import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:centelha_claudia/core/services/error_log_service.dart';

class ErrorLogsDashboardController extends GetxController {
  final errorLogService = ErrorLogService.instance;

  final erros = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final filtroModulo = ''.obs;
  final filtroPeriodicidade = 'ultimas24h'.obs;

  @override
  void onInit() {
    super.onInit();
    carregarErros();
  }

  Future<void> carregarErros() async {
    try {
      isLoading.value = true;

      List<Map<String, dynamic>> resultados;

      if (filtroPeriodicidade.value == 'ultimas24h') {
        resultados = await errorLogService.obterErrosRecentes24h();
      } else if (filtroModulo.value.isNotEmpty) {
        resultados = await errorLogService.obterErrosPorModulo(
          filtroModulo.value,
        );
      } else {
        resultados = await errorLogService.obterErrosRecentes(limite: 200);
      }

      erros.value = resultados;
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Falha ao carregar erros: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> limparErrosAntigos() async {
    try {
      await errorLogService.limparErrosAntigos(7); // 7 dias
      Get.snackbar(
        'Sucesso',
        'Erros anteriores a 7 dias removidos',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade400,
        colorText: Colors.white,
      );
      await carregarErros();
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Falha ao limpar erros: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    }
  }
}

class ErrorLogsDashboardPage extends StatelessWidget {
  final controller = Get.put(ErrorLogsDashboardController());

  ErrorLogsDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Erros'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.carregarErros(),
            tooltip: 'Recarregar',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Limpar Erros'),
                  content: const Text('Remover erros anteriores a 7 dias?'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                        controller.limparErrosAntigos();
                      },
                      child: const Text(
                        'Limpar',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
            tooltip: 'Limpar erros antigos',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.erros.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: Colors.green.shade300,
                ),
                const SizedBox(height: 16),
                const Text('Nenhum erro registrado!'),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () => controller.carregarErros(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Recarregar'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // Filtros
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Filtro por periodicidade
                    Obx(
                      () => SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(
                            value: 'ultimas24h',
                            label: Text('Últimas 24h'),
                          ),
                          ButtonSegment(value: 'todos', label: Text('Todos')),
                        ],
                        selected: {controller.filtroPeriodicidade.value},
                        onSelectionChanged: (value) {
                          controller.filtroPeriodicidade.value = value.first;
                          controller.carregarErros();
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Resumo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: ${controller.erros.length}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          'Última atualização: ${DateFormat('HH:mm:ss').format(DateTime.now())}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Lista de erros
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.erros.length,
                separatorBuilder: (_, __) => const Divider(height: 0),
                itemBuilder: (context, index) {
                  final erro = controller.erros[index];
                  final dataErro = DateTime.parse(
                    erro['data_erro'] ?? DateTime.now().toIso8601String(),
                  );
                  final modulo = erro['modulo'] ?? 'N/A';
                  final mensagem = erro['erro_mensagem'] ?? 'Sem mensagem';
                  final tipo = erro['erro_tipo'] ?? 'Unknown';

                  return ListTile(
                    leading: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.shade400,
                      ),
                    ),
                    title: Text(
                      mensagem,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          children: [
                            Chip(
                              label: Text(modulo),
                              labelStyle: const TextStyle(fontSize: 11),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                            Chip(
                              label: Text(tipo),
                              labelStyle: const TextStyle(fontSize: 11),
                              backgroundColor: Colors.orange.shade100,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('dd/MM/yyyy HH:mm:ss').format(dataErro),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      _mostrarDetalhesErro(context, erro);
                    },
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  void _mostrarDetalhesErro(BuildContext context, Map<String, dynamic> erro) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalhes do Erro'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetalheRow('Tipo', erro['erro_tipo']),
              const SizedBox(height: 12),
              _buildDetalheRow('Módulo', erro['modulo']),
              const SizedBox(height: 12),
              _buildDetalheRow('Funcionalidade', erro['funcionalidade']),
              const SizedBox(height: 12),
              Text('Mensagem:', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 4),
              SelectableText(
                erro['erro_mensagem'] ?? 'N/A',
                style: const TextStyle(fontSize: 12),
              ),
              if (erro['erro_stack_trace'] != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Stack Trace:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: SelectableText(
                    erro['erro_stack_trace'],
                    style: const TextStyle(
                      fontSize: 10,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
              if (erro['dados_adicionais'] != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Dados Adicionais:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                SelectableText(
                  erro['dados_adicionais'].toString(),
                  style: const TextStyle(fontSize: 11),
                ),
              ],
              const SizedBox(height: 12),
              _buildDetalheRow(
                'Data/Hora',
                DateFormat('dd/MM/yyyy HH:mm:ss').format(
                  DateTime.parse(
                    erro['data_erro'] ?? DateTime.now().toIso8601String(),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Fechar')),
        ],
      ),
    );
  }

  Widget _buildDetalheRow(String label, dynamic value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(
          child: Text(
            value?.toString() ?? 'N/A',
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
