import '../../../../core/constants/grupo_trabalho_espiritual_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/grupo_trabalho_espiritual_membro_model.dart';
import 'grupo_trabalho_espiritual_datasource.dart';

/// Datasource para operações com grupos de trabalhos espirituais usando Supabase
class GrupoTrabalhoEspiritualSupabaseDatasource
    implements GrupoTrabalhoEspiritualDatasource {
  final SupabaseService _supabaseService;

  // Cache local para operações síncronas
  final List<GrupoTrabalhoEspiritualMembroModel> _cache = [];
  bool _cacheCarregado = false;

  GrupoTrabalhoEspiritualSupabaseDatasource(this._supabaseService);

  @override
  Future<void> adicionar(GrupoTrabalhoEspiritualMembroModel membro) async {
    await _garantirCacheCarregado();

    try {
      final data = _modelToSupabaseJson(membro);
      data.remove('id');
      data.remove('created_at');
      data.remove('updated_at');

      await _supabaseService.client
          .from('grupos_trabalhos_espirituais')
          .insert(data);
      _cache.add(membro);
    } catch (error) {
      throw ServerException(
        'Erro ao adicionar membro ao grupo trabalho espiritual: $error',
      );
    }
  }

  @override
  Future<void> atualizar(GrupoTrabalhoEspiritualMembroModel membro) async {
    try {
      final data = _modelToSupabaseJson(membro);
      data.remove('created_at');
      data['data_ultima_alteracao'] = DateTime.now().toIso8601String();

      await _supabaseService.client
          .from('grupos_trabalhos_espirituais')
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
        'Erro ao atualizar membro do grupo trabalho espiritual: $error',
      );
    }
  }

  /// Busca todas as atividades espirituais disponíveis da tabela grupos
  @override
  Future<List<String>> carregarAtividadesDisponiveis() async {
    try {
      print('🔍 [GRUPOS TRABALHOS ESPIRITUAIS] Carregando atividades...');
      final response = await _supabaseService.client
          .from('grupos_trabalhos_espirituais')
          .select('atividade_espiritual')
          .not('atividade_espiritual', 'is', null)
          .order('atividade_espiritual', ascending: true);

      final atividades = (response as List)
          .map((json) => json['atividade_espiritual'] as String)
          .where((nome) => nome.trim().isNotEmpty)
          .toSet()
          .toList();

      print(
        '✅ [GRUPOS TRABALHOS ESPIRITUAIS] ${atividades.length} atividades carregadas',
      );
      return atividades;
    } catch (e) {
      print(
        '⚠️ [GRUPOS TRABALHOS ESPIRITUAIS] Carregando atividades das constantes (fallback): $e',
      );
      // Fallback para constantes se tabela não existir
      return GrupoTrabalhoEspiritualConstants.atividadesOpcoes;
    }
  }

  /// Busca todas as funções disponíveis (Líder, Membro)
  @override
  Future<List<String>> carregarFuncoesDisponiveis() async {
    // As funções são constantes, mas podemos retornar uma lista
    return ['Líder', 'Membro'];
  }

  /// Busca todos os grupos de trabalho espiritual disponíveis da tabela grupos_trabalhos_espirituais
  @override
  Future<List<String>> carregarGruposEspirituaisDisponiveis() async {
    try {
      print('🔍 [GRUPOS TRABALHOS ESPIRITUAIS] Carregando grupos...');
      final response = await _supabaseService.client
          .from('grupos_trabalhos_espirituais')
          .select('grupo_trabalho')
          .not('grupo_trabalho', 'is', null)
          .order('grupo_trabalho', ascending: true);

      final grupos = (response as List)
          .map((json) => json['grupo_trabalho'] as String)
          .where((nome) => nome.trim().isNotEmpty)
          .toSet()
          .toList();

      print(
        '✅ [GRUPOS TRABALHOS ESPIRITUAIS] ${grupos.length} grupos carregados',
      );
      return grupos;
    } catch (e) {
      print(
        '⚠️ [GRUPOS TRABALHOS ESPIRITUAIS] Carregando grupos das constantes (fallback): $e',
      );
      // Fallback para constantes se tabela não existir
      return GrupoTrabalhoEspiritualConstants.gruposTrabalhoOpcoes;
    }
  }

  @override
  Future<List<GrupoTrabalhoEspiritualMembroModel>> filtrar({
    String? atividadeEspiritual,
    String? grupoTrabalho,
    String? funcao,
  }) async {
    await _garantirCacheCarregado();

    var resultado = List<GrupoTrabalhoEspiritualMembroModel>.from(_cache);

    if (atividadeEspiritual != null && atividadeEspiritual.isNotEmpty) {
      resultado = resultado
          .where((m) => m.atividadeEspiritual == atividadeEspiritual)
          .toList();
    }

    if (grupoTrabalho != null && grupoTrabalho.isNotEmpty) {
      resultado = resultado
          .where((m) => m.grupoTrabalho == grupoTrabalho)
          .toList();
    }

    if (funcao != null && funcao.isNotEmpty) {
      resultado = resultado.where((m) => m.funcao == funcao).toList();
    }

    return resultado;
  }

  @override
  Future<GrupoTrabalhoEspiritualMembroModel?> getPorCadastro(
    String numeroCadastro,
  ) async {
    await _garantirCacheCarregado();

    return _cache.cast<GrupoTrabalhoEspiritualMembroModel?>().firstWhere(
      (m) => m?.numeroCadastro == numeroCadastro,
      orElse: () => null,
    );
  }

  @override
  Future<List<GrupoTrabalhoEspiritualMembroModel>> getTodos() async {
    await _garantirCacheCarregado();
    return List.from(_cache);
  }

  @override
  Future<void> remover(String numeroCadastro) async {
    try {
      await _supabaseService.client
          .from('grupos_trabalhos_espirituais')
          .delete()
          .eq('numero_cadastro', numeroCadastro);

      _cache.removeWhere((m) => m.numeroCadastro == numeroCadastro);
    } catch (error) {
      throw ServerException(
        'Erro ao remover membro do grupo trabalho espiritual: $error',
      );
    }
  }

  /// Carrega cache inicial do Supabase
  Future<void> _carregarCache() async {
    if (_cacheCarregado) return;

    try {
      print('🔍 [GRUPOS TRABALHOS ESPIRITUAIS] Carregando do Supabase...');
      final response = await _supabaseService.client
          .from('grupos_trabalhos_espirituais')
          .select()
          .order('nome', ascending: true);

      _cache.clear();
      _cache.addAll(
        (response as List).map((json) => _supabaseJsonToModel(json)).toList(),
      );
      _cacheCarregado = true;
      print(
        '✅ [GRUPOS TRABALHOS ESPIRITUAIS] ${_cache.length} membros carregados',
      );
    } catch (e) {
      print('❌ [GRUPOS TRABALHOS ESPIRITUAIS] Erro ao carregar: $e');
    }
  }

  /// Garante que o cache está carregado
  Future<void> _garantirCacheCarregado() async {
    if (_cacheCarregado) return;
    await _carregarCache();
  }

  /// Converte model para JSON do Supabase (snake_case)
  Map<String, dynamic> _modelToSupabaseJson(
    GrupoTrabalhoEspiritualMembroModel model,
  ) {
    return {
      'numero_cadastro': model.numeroCadastro,
      'nome': model.nome,
      'status': model.status,
      'atividade_espiritual': model.atividadeEspiritual,
      'grupo_trabalho': model.grupoTrabalho,
      'funcao': model.funcao,
      'data_ultima_alteracao': model.dataUltimaAlteracao?.toIso8601String(),
    };
  }

  /// Converte JSON do Supabase para model
  GrupoTrabalhoEspiritualMembroModel _supabaseJsonToModel(
    Map<String, dynamic> json,
  ) {
    return GrupoTrabalhoEspiritualMembroModel(
      numeroCadastro: json['numero_cadastro']?.toString() ?? '',
      nome: json['nome']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      atividadeEspiritual: json['atividade_espiritual']?.toString() ?? '',
      grupoTrabalho: json['grupo_trabalho']?.toString() ?? '',
      funcao: json['funcao']?.toString() ?? '',
      dataUltimaAlteracao: json['data_ultima_alteracao'] != null
          ? DateTime.parse(json['data_ultima_alteracao'] as String)
          : null,
    );
  }
}
