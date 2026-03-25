import '../../../../core/error/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../membros/data/models/membro_model.dart';
import '../models/grupo_acao_social_membro_model.dart';
import 'grupo_acao_social_datasource.dart';

/// Datasource para operações com grupos de ações sociais usando Supabase
class GrupoAcaoSocialSupabaseDatasource implements GrupoAcaoSocialDatasource {
  final SupabaseService _supabaseService;

  // Cache local para simular operações síncronas
  final List<GrupoAcaoSocialMembroModel> _cache = [];
  bool _cacheCarregado = false;

  GrupoAcaoSocialSupabaseDatasource(this._supabaseService);

  @override
  Future<void> adicionar(GrupoAcaoSocialMembroModel membro) async {
    // Operação assíncrona
    final data = {
      'cadastro': membro.numeroCadastro,
      'acao_social': membro.grupoAcaoSocial,
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
      throw ServerException('Erro ao adicionar ação social: $error');
    }
  }

  @override
  Future<void> atualizar(GrupoAcaoSocialMembroModel membro) async {
    final data = {
      'acao_social': membro.grupoAcaoSocial,
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
      throw ServerException('Erro ao atualizar ação social: $error');
    }
  }

  @override
  Future<List<GrupoAcaoSocialMembroModel>> filtrar({
    String? grupoAcaoSocial,
    String? funcao,
  }) async {
    var resultado = List<GrupoAcaoSocialMembroModel>.from(_cache);

    if (grupoAcaoSocial != null && grupoAcaoSocial.isNotEmpty) {
      resultado = resultado.where((m) => m.grupoAcaoSocial == grupoAcaoSocial).toList();
    }

    if (funcao != null && funcao.isNotEmpty) {
      resultado = resultado.where((m) => m.funcao == funcao).toList();
    }

    return resultado;
  }

  @override
  Future<GrupoAcaoSocialMembroModel?> getPorCadastro(String numeroCadastro) async {
    try {
      return _cache.firstWhere((m) => m.numeroCadastro == numeroCadastro);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<GrupoAcaoSocialMembroModel>> getTodos() async {
    await _garantirCacheCarregado();
    return List.from(_cache);
  }

  @override
  Future<void> remover(String numeroCadastro) async {
    final data = {
      'acao_social': null,
    };

    try {
      await _supabaseService.client
          .from('membros_historico')
          .update(data)
          .eq('cadastro', numeroCadastro);
      
      _cache.removeWhere((m) => m.numeroCadastro == numeroCadastro);
    } catch (error) {
      throw ServerException('Erro ao remover ação social: $error');
    }
  }

  /// Carrega cache inicial de membros com ações sociais
  Future<void> _carregarCache() async {
    if (_cacheCarregado) return;

    try {
      print('🔍 [AÇÕES SOCIAIS DS] Consultando membros com acao_social...');
      final response = await _supabaseService.client
          .from('membros_historico')
          .select()
          .neq('acao_social', '')
          .order('nome', ascending: true);

      _cache.clear();
      _cache.addAll(
        (response as List)
            .map((json) {
              final membro = MembroModel.fromJson(json);
              if (membro.acaoSocial != null && membro.acaoSocial!.isNotEmpty) {
                return GrupoAcaoSocialMembroModel(
                  numeroCadastro: membro.numeroCadastro,
                  nome: membro.nome,
                  status: membro.status,
                  grupoAcaoSocial: membro.acaoSocial ?? '',
                  funcao: membro.funcao,
                  dataUltimaAlteracao: membro.dataUltimaAlteracao,
                );
              }
              return null;
            })
            .whereType<GrupoAcaoSocialMembroModel>()
            .toList(),
      );
      _cacheCarregado = true;
      print(
        '✅ [AÇÕES SOCIAIS DS] ${_cache.length} membros com acao_social carregados',
      );
    } catch (e) {
      print('❌ [AÇÕES SOCIAIS DS] Erro ao carregar: $e');
      // Cache não carregado, retornará lista vazia
    }
  }

  /// Garante que o cache está carregado antes de qualquer operação
  Future<void> _garantirCacheCarregado() async {
    if (_cacheCarregado) return;
    await _carregarCache();
  }
}
