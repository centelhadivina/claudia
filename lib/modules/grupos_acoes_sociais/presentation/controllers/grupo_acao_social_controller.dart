import 'package:get/get.dart';

import '../../data/repositories/grupo_acao_social_repository.dart';
import '../../domain/entities/grupo_acao_social_membro.dart';

/// Controller para gerenciar grupos de ações sociais
class GrupoAcaoSocialController extends GetxController {
  final GrupoAcaoSocialRepository repository;

  final RxList<GrupoAcaoSocialMembro> membros = <GrupoAcaoSocialMembro>[].obs;
  final RxList<String> gruposDisponiveis = <String>[].obs;
  final RxList<String> funcoesDisponiveis = <String>[].obs;

  final RxBool isLoading = false.obs;
  GrupoAcaoSocialController(this.repository);

  Future<GrupoAcaoSocialMembro?> buscarPorCadastro(
    String numeroCadastro,
  ) async {
    return await repository.getPorCadastro(numeroCadastro);
  }

  Future<void> carregarTodos() async {
    try {
      isLoading.value = true;
      membros.value = await repository.getTodos();
    } finally {
      isLoading.value = false;
    }
  }

  List<GrupoAcaoSocialMembro> filtrar({
    String? grupoAcaoSocial,
    String? funcao,
  }) {
    var resultado = List<GrupoAcaoSocialMembro>.from(membros);

    if (grupoAcaoSocial != null) {
      resultado = resultado
          .where((m) => m.grupoAcaoSocial == grupoAcaoSocial)
          .toList();
    }

    if (funcao != null) {
      resultado = resultado.where((m) => m.funcao == funcao).toList();
    }

    return resultado;
  }

  @override
  void onInit() {
    super.onInit();
    carregarTodos();
    _carregarDadosDinamicos();
  }

  Future<void> remover(String numeroCadastro) async {
    try {
      isLoading.value = true;
      await repository.remover(numeroCadastro);
      await carregarTodos();
      Get.snackbar(
        'Sucesso',
        'Membro removido do grupo de ação social com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao remover membro: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> salvar(GrupoAcaoSocialMembro membro) async {
    try {
      isLoading.value = true;
      await repository.salvar(membro);
      await carregarTodos();
      Get.snackbar(
        'Sucesso',
        'Membro salvo no grupo de ação social com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao salvar membro: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _carregarDadosDinamicos() async {
    try {
      gruposDisponiveis.value = await repository.carregarGruposDisponiveis();
      funcoesDisponiveis.value = await repository.carregarFuncoesDisponiveis();
    } catch (e) {
      print('Erro ao carregar dados dinâmicos: $e');
      // Fallback to empty lists
      gruposDisponiveis.value = [];
      funcoesDisponiveis.value = [];
    }
  }
}
