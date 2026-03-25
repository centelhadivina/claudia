import '../../../../core/utils/string_utils.dart';
import '../../domain/entities/usuario.dart';

/// Model de dados do Usuário
class UsuarioModel extends Usuario {
  const UsuarioModel({
    super.id,
    required super.nome,
    required super.cpf,
    super.numeroCadastro,
    super.dataNascimento,
    super.telefoneFixo,
    super.telefoneCelular,
    super.email,
    super.nomeResponsavel,
    super.telefoneResponsavel,
    super.emailResponsavel,
    super.endereco,
    super.bairro,
    super.cidade,
    super.estado,
    super.cep,
    super.sexo,
    super.estadoCivil,
    super.tipoSanguineo,
    super.apelido1,
    super.apelido2,
    super.nucleoCadastro,
    super.dataCadastro,
    super.nucleoPertence,
    super.statusAtual,
    super.classificacao,
    super.diaSessao,
    super.dataBatismo,
    super.mediumCelebranteBatismo,
    super.guiaCelebranteBatismo,
    super.padrinhoBatismo,
    super.madrinhaBatismo,
    super.dataPrimeiroCasamento,
    super.nomePrimeiroConjuge,
    super.mediumCelebrantePrimeiroCasamento,
    super.padrinhoPrimeiroCasamento,
    super.madrinhaPrimeiroCasamento,
    super.dataSegundoCasamento,
    super.nomeSegundoConjuge,
    super.mediumCelebranteSegundoCasamento,
    super.padrinhoSegundoCasamento,
    super.madrinhaSegundoCasamento,
    super.primeiroContatoEmergencia,
    super.segundoContatoEmergencia,
    super.inicioPrimeiroEstagio,
    super.desistenciaPrimeiroEstagio,
    super.primeiroRitoPassagem,
    super.dataPrimeiroDesligamento,
    super.justificativaPrimeiroDesligamento,
    super.inicioSegundoEstagio,
    super.desistenciaSegundoEstagio,
    super.segundoRitoPassagem,
    super.dataSegundoDesligamento,
    super.justificativaSegundoDesligamento,
    super.inicioTerceiroEstagio,
    super.desistenciaTerceiroEstagio,
    super.terceiroRitoPassagem,
    super.dataTerceiroDesligamento,
    super.justificativaTerceiroDesligamento,
    super.inicioQuartoEstagio,
    super.desistenciaQuartoEstagio,
    super.quartoRitoPassagem,
    super.dataQuartoDesligamento,
    super.justificativaQuartoDesligamento,
    super.dataJogoOrixa,
    super.primeiroOrixa,
    super.adjuntoPrimeiroOrixa,
    super.segundoOrixa,
    super.adjuntoSegundoOrixa,
    super.terceiroOrixa,
    super.quartoOrixa,
    super.coroacaoSacerdote,
    super.primeiraCamarinha,
    super.segundaCamarinha,
    super.terceiraCamarinha,
    super.atividadeEspiritual,
    super.grupoAtividadeEspiritual,
    super.grupoTarefa,
    super.grupoAcaoSocial,
    super.cargoLideranca,
  });

  factory UsuarioModel.fromEntity(Usuario usuario) {
    return UsuarioModel(
      id: usuario.id,
      nome: usuario.nome,
      cpf: usuario.cpf,
      numeroCadastro: usuario.numeroCadastro,
      dataNascimento: usuario.dataNascimento,
      telefoneFixo: usuario.telefoneFixo,
      telefoneCelular: usuario.telefoneCelular,
      email: usuario.email,
      nomeResponsavel: usuario.nomeResponsavel,
      endereco: usuario.endereco,
      nucleoCadastro: usuario.nucleoCadastro,
      dataCadastro: usuario.dataCadastro,
      nucleoPertence: usuario.nucleoPertence,
      statusAtual: usuario.statusAtual,
      classificacao: usuario.classificacao,
      diaSessao: usuario.diaSessao,
      dataBatismo: usuario.dataBatismo,
      mediumCelebranteBatismo: usuario.mediumCelebranteBatismo,
      guiaCelebranteBatismo: usuario.guiaCelebranteBatismo,
      padrinhoBatismo: usuario.padrinhoBatismo,
      madrinhaBatismo: usuario.madrinhaBatismo,
      dataPrimeiroCasamento: usuario.dataPrimeiroCasamento,
      nomePrimeiroConjuge: usuario.nomePrimeiroConjuge,
      mediumCelebrantePrimeiroCasamento:
          usuario.mediumCelebrantePrimeiroCasamento,
      padrinhoPrimeiroCasamento: usuario.padrinhoPrimeiroCasamento,
      madrinhaPrimeiroCasamento: usuario.madrinhaPrimeiroCasamento,
      dataSegundoCasamento: usuario.dataSegundoCasamento,
      nomeSegundoConjuge: usuario.nomeSegundoConjuge,
      mediumCelebranteSegundoCasamento:
          usuario.mediumCelebranteSegundoCasamento,
      padrinhoSegundoCasamento: usuario.padrinhoSegundoCasamento,
      madrinhaSegundoCasamento: usuario.madrinhaSegundoCasamento,
      primeiroContatoEmergencia: usuario.primeiroContatoEmergencia,
      segundoContatoEmergencia: usuario.segundoContatoEmergencia,
      inicioPrimeiroEstagio: usuario.inicioPrimeiroEstagio,
      desistenciaPrimeiroEstagio: usuario.desistenciaPrimeiroEstagio,
      primeiroRitoPassagem: usuario.primeiroRitoPassagem,
      dataPrimeiroDesligamento: usuario.dataPrimeiroDesligamento,
      justificativaPrimeiroDesligamento:
          usuario.justificativaPrimeiroDesligamento,
      inicioSegundoEstagio: usuario.inicioSegundoEstagio,
      desistenciaSegundoEstagio: usuario.desistenciaSegundoEstagio,
      segundoRitoPassagem: usuario.segundoRitoPassagem,
      dataSegundoDesligamento: usuario.dataSegundoDesligamento,
      justificativaSegundoDesligamento:
          usuario.justificativaSegundoDesligamento,
      inicioTerceiroEstagio: usuario.inicioTerceiroEstagio,
      desistenciaTerceiroEstagio: usuario.desistenciaTerceiroEstagio,
      terceiroRitoPassagem: usuario.terceiroRitoPassagem,
      dataTerceiroDesligamento: usuario.dataTerceiroDesligamento,
      justificativaTerceiroDesligamento:
          usuario.justificativaTerceiroDesligamento,
      inicioQuartoEstagio: usuario.inicioQuartoEstagio,
      desistenciaQuartoEstagio: usuario.desistenciaQuartoEstagio,
      quartoRitoPassagem: usuario.quartoRitoPassagem,
      dataQuartoDesligamento: usuario.dataQuartoDesligamento,
      justificativaQuartoDesligamento: usuario.justificativaQuartoDesligamento,
      dataJogoOrixa: usuario.dataJogoOrixa,
      primeiroOrixa: usuario.primeiroOrixa,
      adjuntoPrimeiroOrixa: usuario.adjuntoPrimeiroOrixa,
      segundoOrixa: usuario.segundoOrixa,
      adjuntoSegundoOrixa: usuario.adjuntoSegundoOrixa,
      terceiroOrixa: usuario.terceiroOrixa,
      quartoOrixa: usuario.quartoOrixa,
      coroacaoSacerdote: usuario.coroacaoSacerdote,
      primeiraCamarinha: usuario.primeiraCamarinha,
      segundaCamarinha: usuario.segundaCamarinha,
      terceiraCamarinha: usuario.terceiraCamarinha,
      atividadeEspiritual: usuario.atividadeEspiritual,
      grupoAtividadeEspiritual: usuario.grupoAtividadeEspiritual,
      grupoTarefa: usuario.grupoTarefa,
      grupoAcaoSocial: usuario.grupoAcaoSocial,
      cargoLideranca: usuario.cargoLideranca,
    );
  }

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    // Helper para tentar múltiplos nomes de campo (case-insensitive)
    dynamic getField(List<String> possibleNames) {
      for (var name in possibleNames) {
        if (json.containsKey(name)) return json[name];
      }
      return null;
    }

    // Parse de data segura (aceita Date ou String)
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      if (value is String && value.isNotEmpty) {
        try {
          return DateTime.parse(value);
        } catch (e) {
          return null;
        }
      }
      return null;
    }

    // Monta endereço completo a partir dos campos separados
    String? montarEndereco() {
      final rua = getField(['RUA', 'rua', 'endereco', 'logradouro']);
      final numero = getField(['NUMERO', 'numero']);
      final complemento = getField(['COMPLEMENTO', 'complemento']);

      if (rua == null) return null;

      final partes = <String>[rua];
      if (numero != null) partes.add(numero.toString());
      if (complemento != null && complemento.toString().isNotEmpty) {
        partes.add('- $complemento');
      }

      return partes.join(', ');
    }

    return UsuarioModel(
      id: json['id'],
      // Tenta NOME (maiúscula) e nome (minúscula)
      nome: getField(['NOME', 'nome']) ?? '',
      // Tenta CPF (maiúscula) e cpf (minúscula)
      cpf: getField(['CPF', 'cpf']) ?? '',
      // numero_cadastro ou CADASTRO
      numeroCadastro: getField([
        'numero_cadastro',
        'numeroCadastro',
        'CADASTRO',
        'cadastro',
      ]),
      // NASCIMENTO (text) ou nascimento (date)
      dataNascimento: parseDate(getField(['nascimento', 'NASCIMENTO'])),
      // TELEFONE
      telefoneFixo: getField(['TELEFONE', 'telefoneFixo', 'telefone_fixo']),
      // CELULAR
      telefoneCelular: getField(['CELULAR', 'telefoneCelular', 'celular']),
      // E-MAIL (note o hífen!)
      email: getField(['E-MAIL', 'email', 'EMAIL']),
      // Campos de responsável (não existem na tabela atual)
      nomeResponsavel: getField(['nomeResponsavel', 'NOME_RESPONSAVEL']),
      telefoneResponsavel: getField([
        'telefoneResponsavel',
        'TELEFONE_RESPONSAVEL',
      ]),
      emailResponsavel: getField(['emailResponsavel', 'EMAIL_RESPONSAVEL']),
      // Endereço - monta a partir dos campos separados
      endereco: getField(['endereco']) ?? montarEndereco(),
      bairro: getField(['BAIRRO', 'bairro']),
      cidade: getField(['CIDADE', 'cidade']),
      estado: getField(['UF', 'estado', 'uf']),
      cep: getField(['CEP', 'cep']),
      // Campos que não existem na tabela atual
      sexo: getField(['sexo', 'SEXO']),
      estadoCivil: getField(['estadoCivil', 'ESTADO_CIVIL']),
      tipoSanguineo: getField(['tipoSanguineo', 'TIPO_SANGUINEO']),
      apelido1: getField(['apelido1', 'APELIDO1']),
      apelido2: getField(['apelido2', 'APELIDO2']),
      // NUCLEO
      nucleoCadastro: getField(['NUCLEO', 'nucleoCadastro', 'nucleo_cadastro']),
      // data_cadastro (date) ou DATA_CADASTRO (text)
      dataCadastro: parseDate(getField(['data_cadastro', 'DATA_CADASTRO'])),
      nucleoPertence: getField(['nucleoPertence', 'nucleo_pertence', 'NUCLEO']),
      statusAtual: getField(['statusAtual', 'status_atual', 'STATUS']),
      classificacao: getField(['classificacao', 'CLASSIFICACAO']),
      diaSessao: getField(['diaSessao', 'dia_sessao', 'DIA_SESSAO']),
      // data_batismo (date) ou DATA_BATISMO (text)
      dataBatismo: parseDate(getField(['data_batismo', 'DATA_BATISMO'])),
      mediumCelebranteBatismo: getField([
        'mediumCelebranteBatismo',
        'MEDIUM_CELEBRANTE_BATISMO',
      ]),
      guiaCelebranteBatismo: getField([
        'guiaCelebranteBatismo',
        'GUIA_CELEBRANTE_BATISMO',
      ]),
      // PADRINHO
      padrinhoBatismo: getField(['PADRINHO', 'padrinhoBatismo', 'padrinho']),
      // MADRINHA
      madrinhaBatismo: getField(['MADRINHA', 'madrinhaBatismo', 'madrinha']),
      dataPrimeiroCasamento: parseDate(
        getField(['dataPrimeiroCasamento', 'data_primeiro_casamento']),
      ),
      nomePrimeiroConjuge: getField([
        'nomePrimeiroConjuge',
        'nome_primeiro_conjuge',
      ]),
      mediumCelebrantePrimeiroCasamento: getField([
        'mediumCelebrantePrimeiroCasamento',
        'medium_celebrante_primeiro_casamento',
      ]),
      padrinhoPrimeiroCasamento: getField([
        'padrinhoPrimeiroCasamento',
        'padrinho_primeiro_casamento',
      ]),
      madrinhaPrimeiroCasamento: getField([
        'madrinhaPrimeiroCasamento',
        'madrinha_primeiro_casamento',
      ]),
      dataSegundoCasamento: parseDate(
        getField(['dataSegundoCasamento', 'data_segundo_casamento']),
      ),
      nomeSegundoConjuge: getField([
        'nomeSegundoConjuge',
        'nome_segundo_conjuge',
      ]),
      mediumCelebranteSegundoCasamento: getField([
        'mediumCelebranteSegundoCasamento',
        'medium_celebrante_segundo_casamento',
      ]),
      padrinhoSegundoCasamento: getField([
        'padrinhoSegundoCasamento',
        'padrinho_segundo_casamento',
      ]),
      madrinhaSegundoCasamento: getField([
        'madrinhaSegundoCasamento',
        'madrinha_segundo_casamento',
      ]),
      primeiroContatoEmergencia: getField([
        'primeiroContatoEmergencia',
        'primeiro_contato_emergencia',
      ]),
      segundoContatoEmergencia: getField([
        'segundoContatoEmergencia',
        'segundo_contato_emergencia',
      ]),
      inicioPrimeiroEstagio: parseDate(
        getField(['inicioPrimeiroEstagio', 'inicio_primeiro_estagio']),
      ),
      desistenciaPrimeiroEstagio: parseDate(
        getField([
          'desistenciaPrimeiroEstagio',
          'desistencia_primeiro_estagio',
        ]),
      ),
      primeiroRitoPassagem: parseDate(
        getField(['primeiroRitoPassagem', 'primeiro_rito_passagem']),
      ),
      dataPrimeiroDesligamento: parseDate(
        getField(['dataPrimeiroDesligamento', 'data_primeiro_desligamento']),
      ),
      justificativaPrimeiroDesligamento: getField([
        'justificativaPrimeiroDesligamento',
        'justificativa_primeiro_desligamento',
      ]),
      inicioSegundoEstagio: parseDate(
        getField(['inicioSegundoEstagio', 'inicio_segundo_estagio']),
      ),
      desistenciaSegundoEstagio: parseDate(
        getField(['desistenciaSegundoEstagio', 'desistencia_segundo_estagio']),
      ),
      segundoRitoPassagem: parseDate(
        getField(['segundoRitoPassagem', 'segundo_rito_passagem']),
      ),
      dataSegundoDesligamento: parseDate(
        getField(['dataSegundoDesligamento', 'data_segundo_desligamento']),
      ),
      justificativaSegundoDesligamento: getField([
        'justificativaSegundoDesligamento',
        'justificativa_segundo_desligamento',
      ]),
      inicioTerceiroEstagio: parseDate(
        getField(['inicioTerceiroEstagio', 'inicio_terceiro_estagio']),
      ),
      desistenciaTerceiroEstagio: parseDate(
        getField([
          'desistenciaTerceiroEstagio',
          'desistencia_terceiro_estagio',
        ]),
      ),
      terceiroRitoPassagem: parseDate(
        getField(['terceiroRitoPassagem', 'terceiro_rito_passagem']),
      ),
      dataTerceiroDesligamento: parseDate(
        getField(['dataTerceiroDesligamento', 'data_terceiro_desligamento']),
      ),
      justificativaTerceiroDesligamento: getField([
        'justificativaTerceiroDesligamento',
        'justificativa_terceiro_desligamento',
      ]),
      inicioQuartoEstagio: parseDate(
        getField(['inicioQuartoEstagio', 'inicio_quarto_estagio']),
      ),
      desistenciaQuartoEstagio: parseDate(
        getField(['desistenciaQuartoEstagio', 'desistencia_quarto_estagio']),
      ),
      quartoRitoPassagem: parseDate(
        getField(['quartoRitoPassagem', 'quarto_rito_passagem']),
      ),
      dataQuartoDesligamento: parseDate(
        getField(['dataQuartoDesligamento', 'data_quarto_desligamento']),
      ),
      justificativaQuartoDesligamento: getField([
        'justificativaQuartoDesligamento',
        'justificativa_quarto_desligamento',
      ]),
      dataJogoOrixa: parseDate(getField(['dataJogoOrixa', 'data_jogo_orixa'])),
      primeiroOrixa: getField(['primeiroOrixa', 'primeiro_orixa']),
      adjuntoPrimeiroOrixa: getField([
        'adjuntoPrimeiroOrixa',
        'adjunto_primeiro_orixa',
      ]),
      segundoOrixa: getField(['segundoOrixa', 'segundo_orixa']),
      adjuntoSegundoOrixa: getField([
        'adjuntoSegundoOrixa',
        'adjunto_segundo_orixa',
      ]),
      terceiroOrixa: getField(['terceiroOrixa', 'terceiro_orixa']),
      quartoOrixa: getField(['quartoOrixa', 'quarto_orixa']),
      coroacaoSacerdote: parseDate(
        getField(['coroacaoSacerdote', 'coroacao_sacerdote']),
      ),
      primeiraCamarinha: parseDate(
        getField(['primeiraCamarinha', 'primeira_camarinha']),
      ),
      segundaCamarinha: parseDate(
        getField(['segundaCamarinha', 'segunda_camarinha']),
      ),
      terceiraCamarinha: parseDate(
        getField(['terceiraCamarinha', 'terceira_camarinha']),
      ),
      atividadeEspiritual: getField([
        'atividadeEspiritual',
        'atividade_espiritual',
      ]),
      grupoAtividadeEspiritual: getField([
        'grupoAtividadeEspiritual',
        'grupo_atividade_espiritual',
      ]),
      grupoTarefa: getField(['grupoTarefa', 'grupo_tarefa']),
      grupoAcaoSocial: getField(['grupoAcaoSocial', 'grupo_acao_social']),
      cargoLideranca: getField(['cargoLideranca', 'cargo_lideranca']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'NOME': toUpperCaseOrNull(nome),
      'CPF': cpf,
      'numero_cadastro': numeroCadastro,
      'nascimento': dataNascimento?.toIso8601String(),
      'TELEFONE': telefoneFixo,
      'CELULAR': telefoneCelular,
      'E-MAIL': email?.toLowerCase(),
      'nome_responsavel': toUpperCaseOrNull(nomeResponsavel),
      'telefone_responsavel': telefoneResponsavel,
      'email_responsavel': emailResponsavel?.toLowerCase(),
      'endereco': toUpperCaseOrNull(endereco),
      'BAIRRO': toUpperCaseOrNull(bairro),
      'CIDADE': toUpperCaseOrNull(cidade),
      'UF': toUpperCaseOrNull(estado),
      'CEP': cep,
      'sexo': toUpperCaseOrNull(sexo),
      'estado_civil': toUpperCaseOrNull(estadoCivil),
      'tipo_sanguineo': toUpperCaseOrNull(tipoSanguineo),
      'apelido1': toUpperCaseOrNull(apelido1),
      'apelido2': toUpperCaseOrNull(apelido2),
      'NUCLEO': toUpperCaseOrNull(nucleoCadastro),
      'data_cadastro': dataCadastro?.toIso8601String(),
      'nucleo_pertence': toUpperCaseOrNull(nucleoPertence),
      'status_atual': toUpperCaseOrNull(statusAtual),
      'classificacao': toUpperCaseOrNull(classificacao),
      'dia_sessao': toUpperCaseOrNull(diaSessao),
      'data_batismo': dataBatismo?.toIso8601String(),
      'medium_celebrante_batismo': toUpperCaseOrNull(mediumCelebranteBatismo),
      'guia_celebrante_batismo': toUpperCaseOrNull(guiaCelebranteBatismo),
      'PADRINHO': toUpperCaseOrNull(padrinhoBatismo),
      'MADRINHA': toUpperCaseOrNull(madrinhaBatismo),
      'data_primeiro_casamento': dataPrimeiroCasamento?.toIso8601String(),
      'nome_primeiro_conjuge': toUpperCaseOrNull(nomePrimeiroConjuge),
      'medium_celebrante_primeiro_casamento': toUpperCaseOrNull(
        mediumCelebrantePrimeiroCasamento,
      ),
      'padrinho_primeiro_casamento': toUpperCaseOrNull(padrinhoPrimeiroCasamento),
      'madrinha_primeiro_casamento': toUpperCaseOrNull(madrinhaPrimeiroCasamento),
      'data_segundo_casamento': dataSegundoCasamento?.toIso8601String(),
      'nome_segundo_conjuge': toUpperCaseOrNull(nomeSegundoConjuge),
      'medium_celebrante_segundo_casamento': toUpperCaseOrNull(
        mediumCelebranteSegundoCasamento,
      ),
      'padrinho_segundo_casamento': toUpperCaseOrNull(padrinhoSegundoCasamento),
      'madrinha_segundo_casamento': toUpperCaseOrNull(madrinhaSegundoCasamento),
      'primeiro_contato_emergencia': toUpperCaseOrNull(primeiroContatoEmergencia),
      'segundo_contato_emergencia': toUpperCaseOrNull(segundoContatoEmergencia),
      'inicio_primeiro_estagio': inicioPrimeiroEstagio?.toIso8601String(),
      'desistencia_primeiro_estagio': desistenciaPrimeiroEstagio
          ?.toIso8601String(),
      'primeiro_rito_passagem': primeiroRitoPassagem?.toIso8601String(),
      'data_primeiro_desligamento': dataPrimeiroDesligamento?.toIso8601String(),
      'justificativa_primeiro_desligamento': toUpperCaseOrNull(
        justificativaPrimeiroDesligamento,
      ),
      'inicio_segundo_estagio': inicioSegundoEstagio?.toIso8601String(),
      'desistencia_segundo_estagio': desistenciaSegundoEstagio?.toIso8601String(),
      'segundo_rito_passagem': segundoRitoPassagem?.toIso8601String(),
      'data_segundo_desligamento': dataSegundoDesligamento?.toIso8601String(),
      'justificativa_segundo_desligamento': toUpperCaseOrNull(
        justificativaSegundoDesligamento,
      ),
      'inicio_terceiro_estagio': inicioTerceiroEstagio?.toIso8601String(),
      'desistencia_terceiro_estagio': desistenciaTerceiroEstagio
          ?.toIso8601String(),
      'terceiro_rito_passagem': terceiroRitoPassagem?.toIso8601String(),
      'data_terceiro_desligamento': dataTerceiroDesligamento?.toIso8601String(),
      'justificativa_terceiro_desligamento': toUpperCaseOrNull(
        justificativaTerceiroDesligamento,
      ),
      'inicio_quarto_estagio': inicioQuartoEstagio?.toIso8601String(),
      'desistencia_quarto_estagio': desistenciaQuartoEstagio?.toIso8601String(),
      'quarto_rito_passagem': quartoRitoPassagem?.toIso8601String(),
      'data_quarto_desligamento': dataQuartoDesligamento?.toIso8601String(),
      'justificativa_quarto_desligamento': toUpperCaseOrNull(
        justificativaQuartoDesligamento,
      ),
      'data_jogo_orixa': dataJogoOrixa?.toIso8601String(),
      'primeiro_orixa': toUpperCaseOrNull(primeiroOrixa),
      'adjunto_primeiro_orixa': toUpperCaseOrNull(adjuntoPrimeiroOrixa),
      'segundo_orixa': toUpperCaseOrNull(segundoOrixa),
      'adjunto_segundo_orixa': toUpperCaseOrNull(adjuntoSegundoOrixa),
      'terceiro_orixa': toUpperCaseOrNull(terceiroOrixa),
      'quarto_orixa': toUpperCaseOrNull(quartoOrixa),
      'coroacao_sacerdote': coroacaoSacerdote?.toIso8601String(),
      'primeira_camarinha': primeiraCamarinha?.toIso8601String(),
      'segunda_camarinha': segundaCamarinha?.toIso8601String(),
      'terceira_camarinha': terceiraCamarinha?.toIso8601String(),
      'atividade_espiritual': toUpperCaseOrNull(atividadeEspiritual),
      'grupo_atividade_espiritual': toUpperCaseOrNull(grupoAtividadeEspiritual),
      'grupo_tarefa': toUpperCaseOrNull(grupoTarefa),
      'grupo_acao_social': toUpperCaseOrNull(grupoAcaoSocial),
      'cargo_lideranca': toUpperCaseOrNull(cargoLideranca),
    };
  }
}
