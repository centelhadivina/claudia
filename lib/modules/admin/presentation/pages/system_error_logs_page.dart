import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../core/services/error_log_service.dart';
import '../../../auth/domain/entities/usuario_sistema.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class SystemErrorLogsPage extends StatelessWidget {
  const SystemErrorLogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated || state.usuario.nivelAcesso != NivelAcesso.nivel4) {
          return Scaffold(
            appBar: AppBar(title: const Text('Logs de Erro do Sistema')),
            body: const Center(
              child: Text('Acesso negado. Apenas administradores podem visualizar esta página.'),
            ),
          );
        }

        final entries = ErrorLogService.instance.entries;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Logs de Erro do Sistema'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_forever),
                tooltip: 'Limpar logs',
                onPressed: () {
                  ErrorLogService.instance.clear();
                  Get.snackbar('Sucesso', 'Logs limpos', snackPosition: SnackPosition.BOTTOM);
                },
              ),
            ],
          ),
          body: entries.isEmpty
              ? const Center(
                  child: Text('Nenhum erro registrado ainda.'),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    entry.error,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Tooltip(
                                  message: 'Fonte do erro',
                                  child: Chip(
                                    label: Text(entry.source),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              runSpacing: 8,
                              children: [
                                _InfoLabel(label: 'Data', value: entry.formattedTimestamp),
                                _InfoLabel(label: 'Rota', value: entry.route),
                                if (entry.additionalInfo != null)
                                  _InfoLabel(label: 'Contexto', value: entry.additionalInfo!),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ExpansionTile(
                              title: const Text('Ver StackTrace'),
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SelectableText(
                                    entry.stackTrace ?? 'Sem stacktrace disponível.',
                                    style: const TextStyle(fontSize: 12, height: 1.4),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

class _InfoLabel extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLabel({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
