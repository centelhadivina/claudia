import '../../../../core/constants/grupo_acao_social_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/grupo_acao_social_membro_model.dart';
import 'grupo_acao_social_datasource.dart';

/// Datasource para operações com grupos de ações sociais usando Supabase
class GrupoAcaoSocialSupabaseDatasource implements GrupoAcaoSocialDatasource {
  final SupabaseService _supabaseService;

  // Cache local para operações síncronas
  final List<GrupoAcaoSocialMembroModel> _cache = [];
  bool _cacheCarregado = false;

  GrupoAcaoSocialSupabaseDatasource(this._supabaseService);

  @override
  Future<void> adicionar(GrupoAcaoSocialMembroModel membro) async {
    await _garantirCacheCarregado();

    try {
      final data = _modelToSupabaseJson(membro);
      data.remove('id');
      data.remove('created_at');
      data.remove('updated_at');

      await _supabaseService.client.from('grupos_acoes_sociais').insert(data);
      _cache.add(membro);
    } catch (error) {
      throw ServerException(
        'Erro ao adicionar membro ao grupo ação social: $error',
      );
    }
  }

  @override
  Future<void> atualizar(GrupoAcaoSocialMembroModel membro) async {
    try {
      final data = _modelToSupabaseJson(membro);
      data.remove('created_at');
      data['data_ultima_alteracao'] = DateTime.now().toIso8601String();

      await _supabaseService.client
          .from('grupos_acoes_sociais')
          .update(data)
          .eq('numero_cadastro', membro.numeroCadastro);

      final index = _cache.indexWhere(
        (m) => m.numeroCadastro == membro.numeroCadastro,
      );
      if (index != -1) {
        _cache[index] = membro;
      }
    } catch (error) {
      throw ServerException(
        'Erro ao atualizar membro do grupo ação social: $error',
      );
    }
  }

  /// Busca todas as funções disponíveis (Líder, Membro)
  @override
  Future<List<String>> carregarFuncoesDisponiveis() async {
    // As funções são constantes, mas podemos retornar uma lista
    return ['Líder', 'Membro'];
  }

  /// Busca todos os grupos de ação social disponíveis da tabela grupos
  @override
  Future<List<String>> carregarGruposDisponiveis() async {
    try {
      print('🔍 [GRUPOS AÇÕES SOCIAIS] Carregando grupos disponíveis...');
      final response = await _supabaseService.client
          .from('grupos_acoes_sociais')
          .select('grupo_acao_social')
          .not('grupo_acao_social', 'is', null)
          .order('grupo_acao_social', ascending: true);

      final grupos = (response as List)
          .map((json) => json['grupo_acao_social'] as String)
          .where((nome) => nome.trim().isNotEmpty)
          .toSet()
          .toList();

      print('✅ [GRUPOS AÇÕES SOCIAIS] ${grupos.length} grupos carregados');
      return grupos;
    } catch (e) {
      print(
        '⚠️ [GRUPOS AÇÕES SOCIAIS] Carregando grupos das constantes (fallback): $e',
      );
      // Fallback para constantes se tabela não existir
      return GrupoAcaoSocialConstants.gruposOpcoes;
    }
  }

  @override
  Future<List<GrupoAcaoSocialMembroModel>> filtrar({
    String? grupoAcaoSocial,
    String? funcao,
  }) async {
    await _garantirCacheCarregado();

    var resultado = List<GrupoAcaoSocialMembroModel>.from(_cache);

    if (grupoAcaoSocial != null && grupoAcaoSocial.isNotEmpty) {
      resultado = resultado
          .where((m) => m.grupoAcaoSocial == grupoAcaoSocial)
          .toList();
    }

    if (funcao != null && funcao.isNotEmpty) {
      resultado = resultado.where((m) => m.funcao == funcao).toList();
    }

    return resultado;
  }

  @override
  Future<GrupoAcaoSocialMembroModel?> getPorCadastro(
    String numeroCadastro,
  ) async {
    await _garantirCacheCarregado();

    return _cache.cast<GrupoAcaoSocialMembroModel?>().firstWhere(
      (m) => m?.numeroCadastro == numeroCadastro,
      orElse: () => null,
    );
  }

  @override
  Future<List<GrupoAcaoSocialMembroModel>> getTodos() async {
    await _garantirCacheCarregado();
    return List.from(_cache);
  }

  @override
  Future<void> remover(String numeroCadastro) async {
    try {
      await _supabaseService.client
          .from('grupos_acoes_sociais')
          .delete()
          .eq('numero_cadastro', numeroCadastro);

      _cache.removeWhere((m) => m.numeroCadastro == numeroCadastro);
    } catch (error) {
      throw ServerException(
        'Erro ao remover membro do grupo ação social: $error',
      );
    }
  }

  /// Carrega cache inicial do Supabase
  Future<void> _carregarCache() async {
    if (_cacheCarregado) return;

    try {
      print('🔍 [GRUPOS AÇÕES SOCIAIS] Carregando do Supabase...');
      final response = await _supabaseService.client
          .from('grupos_acoes_sociais')
          .select()
          .order('nome', ascending: true);

      _cache.clear();
      _cache.addAll(
        (response as List).map((json) => _supabaseJsonToModel(json)).toList(),
      );
      _cacheCarregado = true;
      print('✅ [GRUPOS AÇÕES SOCIAIS] ${_cache.length} membros carregados');
    } catch (e) {
      print('❌ [GRUPOS AÇÕES SOCIAIS] Erro ao carregar: $e');
    }
  }

  /// Garante que o cache está carregado
  Future<void> _garantirCacheCarregado() async {
    if (_cacheCarregado) return;
    await _carregarCache();
  }

  /// Converte model para JSON do Supabase (snake_case)
  Map<String, dynamic> _modelToSupabaseJson(GrupoAcaoSocialMembroModel model) {
    return {
      'numero_cadastro': model.numeroCadastro,
      'nome': model.nome,
      'status': model.status,
      'grupo_acao_social': model.grupoAcaoSocial,
      'funcao': model.funcao,
      'data_ultima_alteracao': model.dataUltimaAlteracao?.toIso8601String(),
    };
  }

  /// Converte JSON do Supabase para model
  GrupoAcaoSocialMembroModel _supabaseJsonToModel(Map<String, dynamic> json) {
    return GrupoAcaoSocialMembroModel(
      numeroCadastro: json['numero_cadastro']?.toString() ?? '',
      nome: json['nome']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      grupoAcaoSocial: json['grupo_acao_social']?.toString() ?? '',
      funcao: json['funcao']?.toString() ?? '',
      dataUltimaAlteracao: json['data_ultima_alteracao'] != null
          ? DateTime.parse(json['data_ultima_alteracao'] as String)
          : null,
    );
  }
}
