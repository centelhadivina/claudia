import '../../domain/entities/grupo_tarefa_membro.dart';
import '../datasources/grupo_tarefa_datasource.dart';
import '../models/grupo_tarefa_membro_model.dart';

/// Repository para operações com grupos-tarefas
abstract class GrupoTarefaRepository {
  Future<void> adicionar(GrupoTarefaMembro membro);
  Future<void> atualizar(GrupoTarefaMembro membro);
  Future<List<GrupoTarefaMembro>> filtrar({String? grupoTarefa, String? funcao});
  Future<GrupoTarefaMembro?> getPorCadastro(String numeroCadastro);
  Future<List<GrupoTarefaMembro>> getTodos();
  Future<void> remover(String numeroCadastro);
}

/// Implementação do repository
class GrupoTarefaRepositoryImpl implements GrupoTarefaRepository {
  final GrupoTarefaDatasource datasource;

  GrupoTarefaRepositoryImpl(this.datasource);

  @override
  Future<void> adicionar(GrupoTarefaMembro membro) async {
    final model = GrupoTarefaMembroModel.fromEntity(membro);
    await datasource.adicionar(model);
  }

  @override
  Future<void> atualizar(GrupoTarefaMembro membro) async {
    final model = GrupoTarefaMembroModel.fromEntity(membro);
    await datasource.atualizar(model);
  }

  @override
  Future<List<GrupoTarefaMembro>> filtrar({String? grupoTarefa, String? funcao}) async {
    return await datasource.filtrar(grupoTarefa: grupoTarefa, funcao: funcao);
  }

  @override
  Future<GrupoTarefaMembro?> getPorCadastro(String numeroCadastro) async {
    return await datasource.getPorCadastro(numeroCadastro);
  }

  @override
  Future<List<GrupoTarefaMembro>> getTodos() async {
    return await datasource.getTodos();
  }

  @override
  Future<void> remover(String numeroCadastro) async {
    await datasource.remover(numeroCadastro);
  }
}
