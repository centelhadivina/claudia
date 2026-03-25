import '../models/grupo_tarefa_membro_model.dart';

/// Datasource para operações com grupos-tarefas
abstract class GrupoTarefaDatasource {
  Future<void> adicionar(GrupoTarefaMembroModel membro);
  Future<void> atualizar(GrupoTarefaMembroModel membro);
  Future<List<GrupoTarefaMembroModel>> filtrar({String? grupoTarefa, String? funcao});
  Future<GrupoTarefaMembroModel?> getPorCadastro(String numeroCadastro);
  Future<List<GrupoTarefaMembroModel>> getTodos();
  Future<void> remover(String numeroCadastro);
}

/// Implementação mock do datasource
class GrupoTarefaDatasourceImpl implements GrupoTarefaDatasource {
  final List<GrupoTarefaMembroModel> _membros = [
    GrupoTarefaMembroModel(
      id: '1',
      numeroCadastro: 'M001',
      nome: 'Maria Silva Santos',
      status: 'Membro ativo',
      grupoTarefa: 'Auxílio à Secretaria',
      funcao: 'Líder',
      dataUltimaAlteracao: DateTime(2024, 11, 15),
    ),
    GrupoTarefaMembroModel(
      id: '2',
      numeroCadastro: 'M002',
      nome: 'José Oliveira',
      status: 'Membro ativo',
      grupoTarefa: 'Comunicação & Marketing',
      funcao: 'Membro',
      dataUltimaAlteracao: DateTime(2024, 10, 20),
    ),
  ];

  @override
  Future<void> adicionar(GrupoTarefaMembroModel membro) async {
    _membros.add(membro);
  }

  @override
  Future<void> atualizar(GrupoTarefaMembroModel membro) async {
    final index = _membros.indexWhere(
      (m) => m.numeroCadastro == membro.numeroCadastro,
    );
    if (index != -1) {
      _membros[index] = membro;
    }
  }

  @override
  Future<List<GrupoTarefaMembroModel>> filtrar({String? grupoTarefa, String? funcao}) async {
    var resultado = List<GrupoTarefaMembroModel>.from(_membros);

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
      return _membros.firstWhere((m) => m.numeroCadastro == numeroCadastro);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<GrupoTarefaMembroModel>> getTodos() async => List.from(_membros);

  @override
  Future<void> remover(String numeroCadastro) async {
    _membros.removeWhere((m) => m.numeroCadastro == numeroCadastro);
  }
}
