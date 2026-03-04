import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/membro_constants.dart';
import '../../domain/entities/membro.dart';
import '../controllers/membro_controller.dart';
import '../../../organizacao/presentation/controllers/nucleo_controller.dart';

/// Página para editar dados de membro da CLAUDIA
/// Disponível para níveis 2 e 4
class EditarMembroPage extends StatefulWidget {
  const EditarMembroPage({super.key});

  @override
  State<EditarMembroPage> createState() => _EditarMembroPageState();
}

class _EditarMembroPageState extends State<EditarMembroPage> {
  final membroController = Get.find<MembroController>();
  final nucleoController = Get.find<NucleoController>();
  final numeroController = TextEditingController();

  Membro? membroSelecionado;
  bool buscaRealizada = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Dados de Membro'),
        backgroundColor: Colors.purple,
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
                      'Buscar Membro para Editar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: numeroController,
                            decoration: const InputDecoration(
                              labelText: 'Número de Cadastro',
                              prefixIcon: Icon(Icons.numbers),
                              border: OutlineInputBorder(),
                            ),
                            onFieldSubmitted: (_) => _buscar(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: _buscar,
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

            // Resultado da busca
            if (buscaRealizada && membroSelecionado != null) ...[
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 8),
                          const Text(
                            'Membro Encontrado',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      _buildInfoRow(
                        'Número',
                        membroSelecionado!.numeroCadastro,
                      ),
                      _buildInfoRow('Nome', membroSelecionado!.nome),
                      _buildInfoRow('Núcleo', membroSelecionado!.nucleo),
                      _buildInfoRow('Status', membroSelecionado!.status),
                      _buildInfoRow('Função', membroSelecionado!.funcao),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _editarMembro,
                            icon: const Icon(Icons.edit),
                            label: const Text('Editar Dados'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],

            if (buscaRealizada && membroSelecionado == null) ...[
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhum membro encontrado',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
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
    super.dispose();
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _buscar() {
    final membro = membroController.buscarPorNumero(numeroController.text);

    setState(() {
      buscaRealizada = true;
      membroSelecionado = membro;
    });

    if (membro == null) {
      Get.snackbar(
        'Não encontrado',
        'Nenhum membro com este número de cadastro',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  void _editarMembro() {
    if (membroSelecionado == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _FormularioEdicaoPage(membro: membroSelecionado!),
      ),
    ).then((_) {
      // Recarrega após editar
      _limpar();
    });
  }

  void _limpar() {
    setState(() {
      numeroController.clear();
      membroSelecionado = null;
      buscaRealizada = false;
    });
  }
}

class _FormularioEdicaoPage extends StatefulWidget {
  final Membro membro;

  const _FormularioEdicaoPage({required this.membro});

  @override
  State<_FormularioEdicaoPage> createState() => _FormularioEdicaoPageState();
}

class _FormularioEdicaoPageState extends State<_FormularioEdicaoPage> {
  final _formKey = GlobalKey<FormState>();
  final membroController = Get.find<MembroController>();
  final nucleoController = Get.find<NucleoController>();

  late final TextEditingController contato1Controller;
  late final TextEditingController contato2Controller;
  late final TextEditingController observacoesOrixaController;
  late final TextEditingController grupoTarefaController;
  late final TextEditingController acaoSocialController;
  late final TextEditingController cargoLiderancaController;
  late final TextEditingController nomePrController;
  late final TextEditingController nomeBaiController;
  late final TextEditingController nomeCabController;
  late final TextEditingController nomeMarController;
  late final TextEditingController nomeMalController;
  late final TextEditingController nomeCigController;
  late final TextEditingController nomePvController;

  late String nucleoSelecionado;
  late String statusSelecionado;
  late String funcaoSelecionada;
  late String classificacaoSelecionada;
  late String diaSessaoSelecionado;

  // Datas (apenas exemplo, adicionar todas conforme necessário)
  DateTime? primeiraCamarinha;
  DateTime? segundaCamarinha;
  DateTime? terceiraCamarinha;
  DateTime? dataCoroacaoSacerdote;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editando: ${widget.membro.nome}'),
        backgroundColor: Colors.orange,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSecaoTitulo('INFORMAÇÕES ORGANIZACIONAIS'),
            Obx(
              () => _buildDropdown(
                value: nucleoSelecionado,
                label: 'Núcleo *',
                items: nucleoController.nucleos
                    .map((n) => n.nome)
                    .toList(),
                onChanged: (v) => setState(() => nucleoSelecionado = v!),
              ),
            ),
            _buildDropdown(
              value: statusSelecionado,
              label: 'Status *',
              items: MembroConstants.statusOpcoes,
              onChanged: (v) => setState(() => statusSelecionado = v!),
            ),
            _buildDropdown(
              value: funcaoSelecionada,
              label: 'Função *',
              items: MembroConstants.funcaoOpcoes,
              onChanged: (v) => setState(() => funcaoSelecionada = v!),
            ),
            _buildDropdown(
              value: classificacaoSelecionada,
              label: 'Última Classificação *',
              items: MembroConstants.classificacaoOpcoes,
              onChanged: (v) => setState(() => classificacaoSelecionada = v!),
            ),
            _buildDropdown(
              value: diaSessaoSelecionado,
              label: 'Dia de Sessão *',
              items: MembroConstants.diaSessaoOpcoes,
              onChanged: (v) => setState(() => diaSessaoSelecionado = v!),
            ),
            _buildCampoTexto(
              controller: contato1Controller,
              label: '1º Contato para Emergência',
              icon: Icons.phone,
            ),
            _buildCampoTexto(
              controller: contato2Controller,
              label: '2º Contato para Emergência',
              icon: Icons.phone,
            ),

            const SizedBox(height: 24),
            _buildSecaoTitulo('GRUPOS E ATIVIDADES'),
            _buildCampoTexto(
              controller: grupoTarefaController,
              label: 'Grupo-Tarefa (Nota C)',
              icon: Icons.group_work,
            ),
            _buildCampoTexto(
              controller: acaoSocialController,
              label: 'Grupo de Ação Social (Nota D)',
              icon: Icons.volunteer_activism,
            ),
            _buildCampoTexto(
              controller: cargoLiderancaController,
              label: 'Cargo de Liderança (Nota L)',
              icon: Icons.workspace_premium,
            ),

            const SizedBox(height: 24),
            _buildSecaoTitulo('HISTÓRICO ESPIRITUAL'),
            _buildCampoData(
              '1ª camarinha',
              primeiraCamarinha,
              (d) => primeiraCamarinha = d,
            ),
            _buildCampoData(
              '2ª camarinha',
              segundaCamarinha,
              (d) => segundaCamarinha = d,
            ),
            _buildCampoData(
              '3ª camarinha',
              terceiraCamarinha,
              (d) => terceiraCamarinha = d,
            ),
            _buildCampoData(
              'Data da coroação de sacerdote',
              dataCoroacaoSacerdote,
              (d) => dataCoroacaoSacerdote = d,
            ),

            const SizedBox(height: 24),
            _buildSecaoTitulo('OBSERVAÇÕES'),
            TextFormField(
              controller: observacoesOrixaController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Observações sobre Orixás',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),
            _buildSecaoTitulo('NOMES DOS GUIAS ESPIRITUAIS QUE DÃO CONSULTA'),
            _buildCampoTexto(
              controller: nomePrController,
              label: 'Nome do Preto-Velho',
              icon: Icons.elderly,
            ),
            _buildCampoTexto(
              controller: nomeBaiController,
              label: 'Nome do Baiano',
              icon: Icons.person,
            ),
            _buildCampoTexto(
              controller: nomeCabController,
              label: 'Nome do Caboclo',
              icon: Icons.person,
            ),
            _buildCampoTexto(
              controller: nomeMarController,
              label: 'Nome do Marinheiro',
              icon: Icons.sailing,
            ),
            _buildCampoTexto(
              controller: nomeMalController,
              label: 'Nome do Malandro',
              icon: Icons.person,
            ),
            _buildCampoTexto(
              controller: nomeCigController,
              label: 'Nome do Cigano',
              icon: Icons.person,
            ),
            _buildCampoTexto(
              controller: nomePvController,
              label: 'Nome da Pomba-Gira',
              icon: Icons.person,
            ),

            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _salvar,
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar Alterações'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    contato1Controller.dispose();
    contato2Controller.dispose();
    observacoesOrixaController.dispose();
    grupoTarefaController.dispose();
    acaoSocialController.dispose();
    cargoLiderancaController.dispose();
    nomePrController.dispose();
    nomeBaiController.dispose();
    nomeCabController.dispose();
    nomeMarController.dispose();
    nomeMalController.dispose();
    nomeCigController.dispose();
    nomePvController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final m = widget.membro;

    contato1Controller = TextEditingController(
      text: m.primeiroContatoEmergencia,
    );
    contato2Controller = TextEditingController(
      text: m.segundoContatoEmergencia,
    );
    observacoesOrixaController = TextEditingController(
      text: m.observacoesOrixa,
    );
    grupoTarefaController = TextEditingController(text: m.grupoTarefa);
    acaoSocialController = TextEditingController(text: m.acaoSocial);
    cargoLiderancaController = TextEditingController(text: m.cargoLideranca);
    nomePrController = TextEditingController(text: m.nomePr);
    nomeBaiController = TextEditingController(text: m.nomeBai);
    nomeCabController = TextEditingController(text: m.nomeCab);
    nomeMarController = TextEditingController(text: m.nomeMar);
    nomeMalController = TextEditingController(text: m.nomeMal);
    nomeCigController = TextEditingController(text: m.nomeCig);
    nomePvController = TextEditingController(text: m.nomePv);

    nucleoSelecionado = m.nucleo;
    statusSelecionado = m.status;
    funcaoSelecionada = m.funcao;
    classificacaoSelecionada = m.classificacao;
    diaSessaoSelecionado = m.diaSessao;

    primeiraCamarinha = m.primeiraCamarinha;
    segundaCamarinha = m.segundaCamarinha;
    terceiraCamarinha = m.terceiraCamarinha;
    dataCoroacaoSacerdote = m.dataCoroacaoSacerdote;
  }

  Widget _buildCampoData(
    String label,
    DateTime? data,
    Function(DateTime?) onSelected,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        readOnly: true,
        controller: TextEditingController(text: _formatarData(data)),
        onTap: () => _selecionarData(context, onSelected),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today),
          border: const OutlineInputBorder(),
          suffixIcon: data != null
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() => onSelected(null)),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildCampoTexto({
    required TextEditingController controller,
    required String label,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required String label,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    // Normaliza o valor para garantir que existe na lista
    // Remove duplicatas e mantém apenas itens únicos
    final uniqueItems = items.toSet().toList();

    // Função para normalizar texto (remove acentos, pontuação, case-insensitive)
    String normalizar(String texto) {
      return texto
          .toLowerCase()
          .replaceAll(RegExp(r'[àáâãäå]'), 'a')
          .replaceAll(RegExp(r'[èéêë]'), 'e')
          .replaceAll(RegExp(r'[ìíîï]'), 'i')
          .replaceAll(RegExp(r'[òóôõö]'), 'o')
          .replaceAll(RegExp(r'[ùúûü]'), 'u')
          .replaceAll(RegExp(r'[ç]'), 'c')
          .replaceAll(RegExp(r'[–—-]'), '') // Remove travessões e hífens
          .replaceAll(RegExp(r'\s+'), ' ') // Normaliza espaços
          .trim();
    }

    // Verifica se o valor existe na lista (comparação normalizada)
    String validValue = value;
    final valorNormalizado = normalizar(value);

    final itemEncontrado = uniqueItems.firstWhere(
      (item) => normalizar(item) == valorNormalizado,
      orElse: () => '',
    );

    if (itemEncontrado.isEmpty) {
      // Não encontrou correspondência exata, usar primeiro item
      validValue = uniqueItems.first;

      // Debug: mostra quando há inconsistência
      debugPrint('⚠️ Valor do dropdown não encontrado na lista.');
      debugPrint('   Campo: $label');
      debugPrint('   Valor original: "$value"');
      debugPrint('   Valor normalizado: "$valorNormalizado"');
      debugPrint('   Valor usado: "$validValue"');
      debugPrint('   Lista disponível: $uniqueItems');
    } else {
      validValue = itemEncontrado;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        initialValue: validValue,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: uniqueItems.map((item) {
          return DropdownMenuItem(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
        validator: (v) => v == null ? 'Campo obrigatório' : null,
      ),
    );
  }

  Widget _buildSecaoTitulo(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Text(
        titulo,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.purple,
        ),
      ),
    );
  }

  String _formatarData(DateTime? data) {
    if (data == null) return '';
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) {
      Get.snackbar('Atenção', 'Preencha todos os campos obrigatórios');
      return;
    }

    final membroAtualizado = widget.membro.copyWith(
      nucleo: nucleoSelecionado,
      status: statusSelecionado,
      funcao: funcaoSelecionada,
      classificacao: classificacaoSelecionada,
      diaSessao: diaSessaoSelecionado,
      primeiroContatoEmergencia: contato1Controller.text.isNotEmpty
          ? contato1Controller.text
          : null,
      segundoContatoEmergencia: contato2Controller.text.isNotEmpty
          ? contato2Controller.text
          : null,
      primeiraCamarinha: primeiraCamarinha,
      segundaCamarinha: segundaCamarinha,
      terceiraCamarinha: terceiraCamarinha,
      dataCoroacaoSacerdote: dataCoroacaoSacerdote,
      observacoesOrixa: observacoesOrixaController.text.isNotEmpty
          ? observacoesOrixaController.text
          : null,
      grupoTarefa: grupoTarefaController.text.isNotEmpty
          ? grupoTarefaController.text
          : null,
      acaoSocial: acaoSocialController.text.isNotEmpty
          ? acaoSocialController.text
          : null,
      cargoLideranca: cargoLiderancaController.text.isNotEmpty
          ? cargoLiderancaController.text
          : null,
      nomePr: nomePrController.text.isNotEmpty ? nomePrController.text : null,
      nomeBai: nomeBaiController.text.isNotEmpty
          ? nomeBaiController.text
          : null,
      nomeCab: nomeCabController.text.isNotEmpty
          ? nomeCabController.text
          : null,
      nomeMar: nomeMarController.text.isNotEmpty
          ? nomeMarController.text
          : null,
      nomeMal: nomeMalController.text.isNotEmpty
          ? nomeMalController.text
          : null,
      nomeCig: nomeCigController.text.isNotEmpty
          ? nomeCigController.text
          : null,
      nomePv: nomePvController.text.isNotEmpty ? nomePvController.text : null,
    );

    try {
      await membroController.atualizarMembro(membroAtualizado);
      Get.back();
    } catch (e) {
      // Erro já tratado no controller
    }
  }

  Future<void> _selecionarData(
    BuildContext context,
    Function(DateTime?) onSelected,
  ) async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'),
    );
    if (data != null) {
      setState(() => onSelected(data));
    }
  }
}
