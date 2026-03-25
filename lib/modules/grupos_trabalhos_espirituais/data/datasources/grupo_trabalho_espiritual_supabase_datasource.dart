import '../../../../core/error/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../membros/data/models/membro_model.dart';
import '../models/grupo_trabalho_espiritual_membro_model.dart';
import 'grupo_trabalho_espiritual_datasource.dart';

/// Datasource para operações com grupos de trabalhos espirituais usando Supabase
class GrupoTrabalhoEspiritualSupabaseDatasource implements GrupoTrabalhoEspiritualDatasource {
  final SupabaseService _supabaseService;

  // Cache local para simular operações síncronas
  final List<GrupoTrabalhoEspiritualMembroModel> _cache = [];
  bool _cacheCarregado = false;

  GrupoTrabalhoEspiritualSupabaseDatasource(this._supabaseService);

  @override
  Future<void> adicionar(GrupoTrabalhoEspiritualMembroModel membro) async {
    // Operação assíncrona
    final data = {
      'cadastro': membro.numeroCadastro,
      'grupo_trabalho_espiritual': membro.grupoTrabalho,
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
      throw ServerException('Erro ao adicionar grupo trabalho espiritual: $error');
    }
  }

  @override
  Future<void> atualizar(GrupoTrabalhoEspiritualMembroModel membro) async {
    final data = {
      'grupo_trabalho_espiritual': membro.grupoTrabalho,
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
      throw ServerException('Erro ao atualizar grupo trabalho espiritual: $error');
    }
  }

  @override
  Future<List<GrupoTrabalhoEspiritualMembroModel>> filtrar({
    String? atividadeEspiritual,
    String? grupoTrabalho,
    String? funcao,
  }) async {
    var resultado = List<GrupoTrabalhoEspiritualMembroModel>.from(_cache);

    if (atividadeEspiritual != null && atividadeEspiritual.isNotEmpty) {
      resultado = resultado.where((m) => m.atividadeEspiritual == atividadeEspiritual).toList();
    }

    if (grupoTrabalho != null && grupoTrabalho.isNotEmpty) {
      resultado = resultado.where((m) => m.grupoTrabalho == grupoTrabalho).toList();
    }

    if (funcao != null && funcao.isNotEmpty) {
      resultado = resultado.where((m) => m.funcao == funcao).toList();
    }

    return resultado;
  }

  @override
  Future<GrupoTrabalhoEspiritualMembroModel?> getPorCadastro(String numeroCadastro) async {
    try {
      return _cache.firstWhere((m) => m.numeroCadastro == numeroCadastro);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<GrupoTrabalhoEspiritualMembroModel>> getTodos() async {
    await _garantirCacheCarregado();
    return List.from(_cache);
  }

  @override
  Future<void> remover(String numeroCadastro) async {
    final data = {
      'grupo_trabalho_espiritual': null,
    };

    try {
      await _supabaseService.client
          .from('membros_historico')
          .update(data)
          .eq('cadastro', numeroCadastro);
      
      _cache.removeWhere((m) => m.numeroCadastro == numeroCadastro);
    } catch (error) {
      throw ServerException('Erro ao remover grupo trabalho espiritual: $error');
    }
  }

  /// Carrega cache inicial de membros com grupos de trabalhos espirituais
  Future<void> _carregarCache() async {
    if (_cacheCarregado) return;

    try {
      print('🔍 [TRABALHOS ESPIRITUAIS DS] Consultando membros com grupo_trabalho_espiritual...');
      final response = await _supabaseService.client
          .from('membros_historico')
          .select()
          .neq('grupo_trabalho_espiritual', '')
          .order('nome', ascending: true);

      _cache.clear();
      _cache.addAll(
        (response as List)
            .map((json) {
              final membro = MembroModel.fromJson(json);
              if (membro.grupoTrabalhoEspiritual != null && membro.grupoTrabalhoEspiritual!.isNotEmpty) {
                return GrupoTrabalhoEspiritualMembroModel(
                  numeroCadastro: membro.numeroCadastro,
                  nome: membro.nome,
                  status: membro.status,
                  atividadeEspiritual: membro.atividadeEspiritual ?? '',
                  grupoTrabalho: membro.grupoTrabalhoEspiritual ?? '',
                  funcao: membro.funcao,
                  dataUltimaAlteracao: membro.dataUltimaAlteracao,
                );
              }
              return null;
            })
            .whereType<GrupoTrabalhoEspiritualMembroModel>()
            .toList(),
      );
      _cacheCarregado = true;
      print(
        '✅ [TRABALHOS ESPIRITUAIS DS] ${_cache.length} membros com grupo_trabalho_espiritual carregados',
      );
    } catch (e) {
      print('❌ [TRABALHOS ESPIRITUAIS DS] Erro ao carregar: $e');
      // Cache não carregado, retornará lista vazia
    }
  }

  /// Garante que o cache está carregado antes de qualquer operação
  Future<void> _garantirCacheCarregado() async {
    if (_cacheCarregado) return;
    await _carregarCache();
  }
}
