import '../../../../core/error/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/grupo_tarefa_membro_model.dart';
import 'grupo_tarefa_datasource.dart';

/// Datasource para operações com grupos-tarefas usando Supabase
class GrupoTarefaSupabaseDatasource implements GrupoTarefaDatasource {
  final SupabaseService _supabaseService;

  // Cache local para operações síncronas
  final List<GrupoTarefaMembroModel> _cache = [];
  bool _cacheCarregado = false;

  GrupoTarefaSupabaseDatasource(this._supabaseService);

  @override
  void adicionar(GrupoTarefaMembroModel membro) {
    _garantirCacheCarregado().then((_) {
      final data = _modelToSupabaseJson(membro);
      data.remove('id');
      data.remove('created_at');
      data.remove('updated_at');

      return _supabaseService.client.from('grupos_tarefas').insert(data);
    }).then((_) {
      _cache.add(membro);
    }).catchError((error) {
      throw ServerException('Erro ao adicionar membro ao grupo tarefa: $error');
    });
  }

  @override
  void atualizar(GrupoTarefaMembroModel membro) {
    final data = _modelToSupabaseJson(membro);
    data.remove('created_at');
    data['data_ultima_alteracao'] = DateTime.now().toIso8601String();

    _supabaseService.client
        .from('grupos_tarefas')
        .update(data)
        .eq('numero_cadastro', membro.numeroCadastro)
        .then((_) {
      final index = _cache.indexWhere(
        (m) => m.numeroCadastro == membro.numeroCadastro,
      );
      if (index != -1) {
        _cache[index] = membro;
      }
    }).catchError((error) {
      throw ServerException('Erro ao atualizar membro do grupo tarefa: $error');
    });
  }

  @override
  List<GrupoTarefaMembroModel> filtrar({String? grupoTarefa, String? funcao}) {
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
  GrupoTarefaMembroModel? getPorCadastro(String numeroCadastro) {
    return _cache.cast<GrupoTarefaMembroModel?>().firstWhere(
          (m) => m?.numeroCadastro == numeroCadastro,
          orElse: () => null,
        );
  }

  @override
  List<GrupoTarefaMembroModel> getTodos() {
    return List.from(_cache);
  }

  @override
  void remover(String numeroCadastro) {
    _supabaseService.client
        .from('grupos_tarefas')
        .delete()
        .eq('numero_cadastro', numeroCadastro)
        .then((_) {
      _cache.removeWhere((m) => m.numeroCadastro == numeroCadastro);
    }).catchError((error) {
      throw ServerException('Erro ao remover membro do grupo tarefa: $error');
    });
  }

  /// Carrega cache inicial do Supabase
  Future<void> _carregarCache() async {
    if (_cacheCarregado) return;

    try {
      print('🔍 [GRUPOS TAREFAS] Carregando do Supabase...');
      final response = await _supabaseService.client
          .from('grupos_tarefas')
          .select()
          .order('nome', ascending: true);

      _cache.clear();
      _cache.addAll(
        (response as List)
            .map((json) => _supabaseJsonToModel(json))
            .toList(),
      );
      _cacheCarregado = true;
      print('✅ [GRUPOS TAREFAS] ${_cache.length} membros carregados');
    } catch (e) {
      print('❌ [GRUPOS TAREFAS] Erro ao carregar: $e');
    }
  }

  /// Garante que o cache está carregado
  Future<void> _garantirCacheCarregado() async {
    if (_cacheCarregado) return;
    await _carregarCache();
  }

  /// Converte model para JSON do Supabase (snake_case)
  Map<String, dynamic> _modelToSupabaseJson(GrupoTarefaMembroModel model) {
    return {
      'id': model.id,
      'numero_cadastro': model.numeroCadastro,
      'nome': model.nome,
      'status': model.status,
      'grupo_tarefa': model.grupoTarefa,
      'funcao': model.funcao,
      'data_ultima_alteracao': model.dataUltimaAlteracao?.toIso8601String(),
    };
  }

  /// Converte JSON do Supabase para model
  GrupoTarefaMembroModel _supabaseJsonToModel(Map<String, dynamic> json) {
    return GrupoTarefaMembroModel(
      id: json['id']?.toString(),
      numeroCadastro: json['numero_cadastro']?.toString() ?? '',
      nome: json['nome']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      grupoTarefa: json['grupo_tarefa']?.toString() ?? '',
      funcao: json['funcao']?.toString() ?? '',
      dataUltimaAlteracao: json['data_ultima_alteracao'] != null
          ? DateTime.parse(json['data_ultima_alteracao'] as String)
          : null,
    );
  }
}
