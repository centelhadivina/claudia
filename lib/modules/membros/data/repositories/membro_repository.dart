import '../../domain/entities/membro.dart';
import '../datasources/membro_datasource.dart';
import '../models/membro_model.dart';

/// Repository para operações com membros
abstract class MembroRepository {
  Future<void> adicionarMembro(Membro membro);
  Future<void> atualizarMembro(Membro membro);

  /// Garante que dados estão carregados (importante para datasources assíncronos)
  Future<void> garantirDadosCarregados();
  Membro? getMembroPorCpf(String cpf);
  Membro? getMembroPorNumero(String numero);
  List<Membro> getMembros();
  List<Membro> pesquisarPorNome(String nome);

  Future<void> removerMembro(String numero);
}

/// Implementação do repository
class MembroRepositoryImpl implements MembroRepository {
  final MembroDatasource datasource;

  MembroRepositoryImpl(this.datasource);

  @override
  Future<void> adicionarMembro(Membro membro) async {
    final model = MembroModel.fromEntity(membro);
    await datasource.adicionarMembro(model);
  }

  @override
  Future<void> atualizarMembro(Membro membro) async {
    final model = MembroModel.fromEntity(membro);
    await datasource.atualizarMembro(model);
  }

  @override
  Future<void> garantirDadosCarregados() async {
    await datasource.garantirDadosCarregados();
  }

  @override
  Membro? getMembroPorCpf(String cpf) {
    return datasource.getMembroPorCpf(cpf);
  }

  @override
  Membro? getMembroPorNumero(String numero) {
    return datasource.getMembroPorNumero(numero);
  }

  @override
  List<Membro> getMembros() {
    return datasource.getMembros();
  }

  @override
  List<Membro> pesquisarPorNome(String nome) {
    return datasource.pesquisarPorNome(nome);
  }

  @override
  Future<void> removerMembro(String numero) async {
    await datasource.removerMembro(numero);
  }
}
