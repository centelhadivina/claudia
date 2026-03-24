import '../../../../core/error/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/utils/string_utils.dart';
import '../models/membro_model.dart';
import 'membro_datasource.dart';

/// Datasource para operações com membros usando Supabase
/// NOTA: Esta implementação é temporária e usa sincronização forçada.
/// Em uma implementação ideal, toda a arquitetura deveria ser async.
class MembroSupabaseDatasource implements MembroDatasource {
  final SupabaseService _supabaseService;

  // Cache local para simular operações síncronas
  final List<MembroModel> _cache = [];
  bool _cacheCarregado = false;

  MembroSupabaseDatasource(this._supabaseService);

  @override
  void adicionarMembro(MembroModel membro) {
    // Operação assíncrona em background
    var data = membro.toJson();
    data.remove('id');
    data.remove('data_criacao');
    data.remove('data_ultima_alteracao');
    data = _convertToSnakeCase(data);

    _garantirCacheCarregado()
        .then((_) {
          return _supabaseService.client.from('membros_historico').insert(data);
        })
        .then((_) {
          _cache.add(membro);
        })
        .catchError((error) {
          throw ServerException('Erro ao adicionar membro: $error');
        });
  }

  @override
  void atualizarMembro(MembroModel membro) {
    if (membro.id == null) {
      throw ServerException('ID é obrigatório para atualização');
    }

    var data = membro.toJson();
    data.remove('id');
    data.remove('data_criacao');
    data.remove('data_ultima_alteracao');
    data = _convertToSnakeCase(data);

    _supabaseService.client
        .from('membros_historico')
        .update(data)
        .eq('id', membro.id!)
        .then((_) {
          final index = _cache.indexWhere((m) => m.id == membro.id);
          if (index != -1) {
            _cache[index] = membro;
          }
        })
        .catchError((error) {
          throw ServerException('Erro ao atualizar membro: $error');
        });
  }

  @override
  Future<void> garantirDadosCarregados() async {
    await _garantirCacheCarregado();
  }

  @override
  MembroModel? getMembroPorCpf(String cpf) {
    return _cache.cast<MembroModel?>().firstWhere(
      (m) => m?.cpf == cpf,
      orElse: () => null,
    );
  }

  @override
  MembroModel? getMembroPorNumero(String numero) {
    print('🔍 [MEMBROS DATASOURCE] Buscando membro por número: "$numero"');
    print('📊 [MEMBROS DATASOURCE] Cache tem ${_cache.length} membros');

    final resultado = _cache.cast<MembroModel?>().firstWhere(
      (m) {
        final match = m?.numeroCadastro == numero;
        if (match) {
          print(
            '✅ [MEMBROS DATASOURCE] Encontrado: ${m?.nome} (${m?.numeroCadastro})',
          );
        }
        return match;
      },
      orElse: () {
        print('⚠️ [MEMBROS DATASOURCE] Membro não encontrado no cache');
        print('   Exemplos de números no cache:');
        _cache.take(5).forEach((m) {
          print('   - ${m.numeroCadastro} (${m.nome})');
        });
        return null;
      },
    );

    return resultado;
  }

  @override
  List<MembroModel> getMembros() {
    return List.from(_cache);
  }

  @override
  List<MembroModel> pesquisarPorNome(String nome) {
    final nomeNormalizado = normalizarParaBusca(nome);
    return _cache
        .where((m) => normalizarParaBusca(m.nome).contains(nomeNormalizado))
        .toList();
  }

  @override
  void removerMembro(String numero) {
    _supabaseService.client
        .from('membros_historico')
        .delete()
        .eq('cadastro', numero)
        .then((_) {
          _cache.removeWhere((m) => m.numeroCadastro == numero);
        })
        .catchError((error) {
          throw ServerException('Erro ao remover membro: $error');
        });
  }

  /// Carrega cache inicial
  Future<void> _carregarCache() async {
    if (_cacheCarregado) return;

    try {
      print('🔍 [MEMBROS DATASOURCE] Consultando tabela membros_historico...');
      final response = await _supabaseService.client
          .from('membros_historico')
          .select()
          .order('nome', ascending: true);

      _cache.clear();
      _cache.addAll(
        (response as List).map((json) => MembroModel.fromJson(json)).toList(),
      );
      _cacheCarregado = true;
      print(
        '✅ [MEMBROS DATASOURCE] ${_cache.length} membros carregados do Supabase',
      );
    } catch (e) {
      print('❌ [MEMBROS DATASOURCE] Erro ao carregar: $e');
      // Cache não carregado, retornará lista vazia
    }
  }

  /// Garante que o cache está carregado antes de qualquer operação
  Future<void> _garantirCacheCarregado() async {
    if (_cacheCarregado) return;
    await _carregarCache();
  }

  /// Converte camelCase para snake_case
  /// Ex: "numeroCadastro" → "numero_cadastro"
  static String _camelToSnakeCase(String input) {
    final buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      final char = input[i];
      if (char.toUpperCase() == char && i > 0) {
        buffer.write('_');
        buffer.write(char.toLowerCase());
      } else {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }

  /// Converte um mapa inteiro de camelCase para snake_case
  /// Preserva valores null e não reconverte campos já em snake_case
  static Map<String, dynamic> _convertToSnakeCase(Map<String, dynamic> json) {
    final result = <String, dynamic>{};
    json.forEach((key, value) {
      // Alguns campos já estão em snake_case (como id, cpf)
      // Conversão é idempotente: snake_case → snake_case = snake_case
      final snakeKey = _camelToSnakeCase(key);
      result[snakeKey] = value;
    });
    return result;
  }
}
