import '../../../../core/error/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../membros/data/models/membro_model.dart';
import '../models/grupo_tarefa_membro_model.dart';
import 'grupo_tarefa_datasource.dart';

/// Datasource para operações com grupos-tarefas usando Supabase
class GrupoTarefaSupabaseDatasource implements GrupoTarefaDatasource {
  final SupabaseService _supabaseService;

  // Cache local para simular operações síncronas
  final List<GrupoTarefaMembroModel> _cache = [];
  bool _cacheCarregado = false;

  GrupoTarefaSupabaseDatasource(this._supabaseService);

  @override
  Future<void> adicionar(GrupoTarefaMembroModel membro) async {
    // Operação assíncrona
    final data = {
      'cadastro': membro.numeroCadastro,
      'grupo_tarefa': membro.grupoTarefa,
    };

    await _garantirCacheCarregado();
    try {
      await _supabaseService.client
          .from('membros_historico')
          .update(data)
          .eq('cadastro', membro.numeroCadastro);
      
      final index = _cache.indexWhere((m) => m.numeroCadastro == membro.numeroCadastro);
      if (index != -1) {
        _cache[index] = membro;
      } else {
        _cache.add(membro);
      }
    } catch (error) {
      throw ServerException('Erro ao adicionar grupo-tarefa: $error');
    }
  }

  @override
  Future<void> atualizar(GrupoTarefaMembroModel membro) async {
    final data = {
      'grupo_tarefa': membro.grupoTarefa,
    };

    try {
      await _supabaseService.client
          .from('membros_historico')
          .update(data)
          .eq('cadastro', membro.numeroCadastro);
      
      final index = _cache.indexWhere((m) => m.numeroCadastro == membro.numeroCadastro);
      if (index != -1) {
        _cache[index] = membro;
      }
    } catch (error) {
      throw ServerException('Erro ao atualizar grupo-tarefa: $error');
    }
  }

  @override
  Future<List<GrupoTarefaMembroModel>> filtrar({String? grupoTarefa, String? funcao}) async {
    var resultado = List<GrupoTarefaMembroModel>.from(_cache);

    if (grupoTarefa != null && grupoTarefa.isNotEmpty) {
      resultado = resultado.where((m) => m.grupoTarefa == grupoTarefa).toList();
    }

    if (funcao != null && funcao.isNotEmpty) {
      resultado = resultado.where((m) => m.funcao == funcao).toList();
    }

    return resultado;
  }

  @override
  Future<GrupoTarefaMembroModel?> getPorCadastro(String numeroCadastro) async {
    try {
      return _cache.firstWhere((m) => m.numeroCadastro == numeroCadastro);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<GrupoTarefaMembroModel>> getTodos() async => List.from(_cache);

  @override
  Future<void> remover(String numeroCadastro) async {
    final data = {
      'grupo_tarefa': null,
    };

    try {
      await _supabaseService.client
          .from('membros_historico')
          .update(data)
          .eq('cadastro', numeroCadastro);
      
      _cache.removeWhere((m) => m.numeroCadastro == numeroCadastro);
    } catch (error) {
      throw ServerException('Erro ao remover grupo-tarefa: $error');
    }
  }

  /// Carrega cache inicial de membros com grupos-tarefas
  Future<void> _carregarCache() async {
    if (_cacheCarregado) return;

    try {
      print('🔍 [GRUPOS-TAREFAS DS] Consultando membros com grupo_tarefa...');
      final response = await _supabaseService.client
          .from('membros_historico')
          .select()
          .neq('grupo_tarefa', '')
          .order('nome', ascending: true);

      _cache.clear();
      _cache.addAll(
        (response as List)
            .map((json) {
              final membro = MembroModel.fromJson(json);
              if (membro.grupoTarefa != null && membro.grupoTarefa!.isNotEmpty) {
                return GrupoTarefaMembroModel(
                  id: membro.id,
                  numeroCadastro: membro.numeroCadastro,
                  nome: membro.nome,
                  status: membro.status,
                  grupoTarefa: membro.grupoTarefa ?? '',
                  funcao: membro.funcao,
                  dataUltimaAlteracao: membro.dataUltimaAlteracao,
                );
              }
              return null;
            })
            .whereType<GrupoTarefaMembroModel>()
            .toList(),
      );
      _cacheCarregado = true;
      print(
        '✅ [GRUPOS-TAREFAS DS] ${_cache.length} membros com grupo_tarefa carregados',
      );
    } catch (e) {
      print('❌ [GRUPOS-TAREFAS DS] Erro ao carregar: $e');
      // Cache não carregado, retornará lista vazia
    }
  }

  /// Garante que o cache está carregado antes de qualquer operação
  Future<void> _garantirCacheCarregado() async {
    if (_cacheCarregado) return;
    await _carregarCache();
  }
}
