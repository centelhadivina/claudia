import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../modules/auth/presentation/bloc/auth_bloc.dart';
import '../../../../modules/auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/consulta.dart';
import '../controllers/consulta_controller.dart';

/// Página para ler consulta por número
/// Disponível para todos os níveis (nível 1 só vê as próprias)
class LerConsultaPage extends StatefulWidget {
  const LerConsultaPage({super.key});

  @override
  State<LerConsultaPage> createState() => _LerConsultaPageState();
}

class _LerConsultaPageState extends State<LerConsultaPage> {
  final consultaController = Get.find<ConsultaController>();
  final numeroController = TextEditingController();
  final nomeController = TextEditingController();

  Consulta? consultaEncontrada;
  List<Consulta> resultadosPorNome = [];
  bool buscaRealizada = false;
  bool buscaPorNome = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ler Consulta',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Buscar Consulta',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Toggle por número / por nome
                    Row(
                      children: [
                        ChoiceChip(
                          label: const Text('Por Número'),
                          selected: !buscaPorNome,
                          onSelected: (_) => setState(() {
                            buscaPorNome = false;
                            _limpar();
                          }),
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Por Nome do Consulente'),
                          selected: buscaPorNome,
                          onSelected: (_) => setState(() {
                            buscaPorNome = true;
                            _limpar();
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: buscaPorNome
                              ? TextFormField(
                                  controller: nomeController,
                                  decoration: const InputDecoration(
                                    labelText: 'Nome do Consulente',
                                    prefixIcon: Icon(Icons.person_search),
                                    border: OutlineInputBorder(),
                                    hintText: 'Digite parte do nome',
                                  ),
                                  onFieldSubmitted: (_) => _buscar(context),
                                )
                              : TextFormField(
                                  controller: numeroController,
                                  decoration: const InputDecoration(
                                    labelText: 'Número da Consulta (5 dígitos)',
                                    prefixIcon: Icon(Icons.numbers),
                                    border: OutlineInputBorder(),
                                    hintText: '00001',
                                  ),
                                  maxLength: 5,
                                  keyboardType: TextInputType.number,
                                  onFieldSubmitted: (_) => _buscar(context),
                                ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: () => _buscar(context),
                          icon: const Icon(Icons.search),
                          label: const Text('Buscar'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: _limpar,
                          icon: const Icon(Icons.clear),
                          label: const Text('Limpar'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Resultado da consulta
            if (consultaEncontrada != null) ...[
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: ListView(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Consulta ${consultaEncontrada!.numeroConsulta}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),

                        const Divider(height: 32),

                        _buildInfoSection('INFORMAÇÕES GERAIS'),
                        _buildInfoRow(
                          'Número da Consulta',
                          consultaEncontrada!.numeroConsulta,
                        ),
                        _buildInfoRow(
                          'Data',
                          _formatarData(consultaEncontrada!.data),
                        ),
                        _buildInfoRow(
                          'Hora de Início',
                          consultaEncontrada!.horaInicio,
                        ),

                        const SizedBox(height: 24),
                        _buildInfoSection('PARTICIPANTES'),
                        _buildInfoRow(
                          'Nome do Consulente',
                          consultaEncontrada!.nomeConsulente,
                        ),
                        _buildInfoRow(
                          'Nome do Médium',
                          consultaEncontrada!.nomeMedium,
                        ),
                        _buildInfoRow(
                          'Nome do Cambono',
                          consultaEncontrada!.nomeCambono,
                        ),
                        _buildInfoRow(
                          'Nome da Entidade',
                          consultaEncontrada!.nomeEntidade,
                        ),

                        const SizedBox(height: 24),
                        _buildInfoSection('DESCRIÇÃO DA CONSULTA'),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            consultaEncontrada!.descricaoConsulta,
                            style: const TextStyle(fontSize: 15, height: 1.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],

            if (buscaRealizada && resultadosPorNome.isNotEmpty) ...
              resultadosPorNome.map((c) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.menu_book, color: Colors.indigo),
                  title: Text(c.nomeConsulente, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Nº ${c.numeroConsulta} • ${_formatarData(c.data)} • ${c.nomeEntidade}'),
                  onTap: () => setState(() {
                    consultaEncontrada = c;
                    resultadosPorNome = [];
                  }),
                ),
              )).toList(),

            if (buscaRealizada && buscaPorNome && resultadosPorNome.isEmpty && consultaEncontrada == null) ...[
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhuma consulta encontrada',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    numeroController.dispose();
    nomeController.dispose();
    super.dispose();
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        titulo,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
        ),
      ),
    );
  }

  Future<void> _buscar(BuildContext context) async {
    if (buscaPorNome) {
      final query = nomeController.text.trim().toLowerCase();
      if (query.isEmpty) return;
      final resultados = consultaController.consultas
          .where((c) => c.nomeConsulente.toLowerCase().contains(query))
          .toList();
      setState(() {
        buscaRealizada = true;
        consultaEncontrada = null;
        resultadosPorNome = resultados;
      });
      if (resultados.isEmpty) {
        Get.snackbar(
          'Não encontrado',
          'Nenhuma consulta com este nome de consulente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
      return;
    }

    final authState = context.read<AuthBloc>().state;

    if (authState is! AuthAuthenticated) {
      Get.snackbar('Erro', 'Usuário não autenticado');
      return;
    }

    final consulta = await consultaController.buscarPorNumero(
      numeroController.text,
    );

    setState(() {
      buscaRealizada = true;
      consultaEncontrada = consulta;
    });

    if (consulta == null) {
      Get.snackbar(
        'Não encontrado',
        'Nenhuma consulta com este número',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // Verifica permissão (nível 1 só vê as próprias)
    final nivelUsuario = authState.usuario.nivelAcesso.index + 1;
    // Para nível 1, usar o ID do usuário como cadastro
    final cadastroUsuario = authState.usuario.id;

    if (!consultaController.podeVerConsulta(
      consulta,
      cadastroUsuario,
      nivelUsuario,
    )) {
      setState(() => consultaEncontrada = null);

      Get.snackbar(
        'Sem Permissão',
        'Você NÃO TEM PERMISSÃO para visualizar esta consulta',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  void _limpar() {
    setState(() {
      numeroController.clear();
      nomeController.clear();
      consultaEncontrada = null;
      resultadosPorNome = [];
      buscaRealizada = false;
    });
  }
}
