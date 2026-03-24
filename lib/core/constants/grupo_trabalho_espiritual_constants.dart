/// Constantes para o módulo de Grupos de Trabalhos Espirituais
class GrupoTrabalhoEspiritualConstants {
  /// 5 atividades espirituais disponíveis
  static const List<String> atividadesOpcoes = [
    'Encontro dos Amigos de Ramatis',
    'Corrente de Oração e Renovação (COR)',
    'Sessões de Antigoécia',
    'Monitoria Infantil',
    'Sem atividade espiritual',
  ];

  /// 8 grupos de trabalho espiritual disponíveis
  static const List<String> gruposTrabalhoOpcoes = [
    'Grupo Paz',
    'Grupo Luz',
    'Grupo Amor',
    'Grupo Fé',
    'Grupo Força',
    'Grupo Esperança',
    'Grupo União',
    'Sem grupo de trabalho espiritual',
  ];

  /// 2 funções disponíveis nos grupos de trabalhos espirituais
  static const List<String> funcoesOpcoes = [
    'Líder',
    'Membro',
  ];

  /// Mapa de grupos de trabalho por atividade espiritual
  /// Cada atividade tem seus grupos específicos
  static const Map<String, List<String>> gruposPorAtividade = {
    'Evangelização': [
      'Evangelização de crianças',
      'Evangelização de jovens',
      'Evangelização de adultos',
    ],
    'Passes': [
      'Sala de passes',
    ],
    'Desobsessão': [
      'Mesa de desobsessão',
      'Equipe de apoio',
    ],
    'Atendimento fraterno': [
      'Equipe de recepção',
      'Equipe de orientação',
    ],
    'Estudos doutrinários': [
      'Grupo de estudos',
    ],
  };

  /// Retorna os grupos disponíveis para uma atividade específica
  static List<String> getGruposPorAtividade(String atividadeEspiritual) {
    return gruposPorAtividade[atividadeEspiritual] ?? [];
  }

  /// Valida se um grupo pertence a uma atividade
  static bool validarGrupoAtividade(String atividadeEspiritual, String grupoTrabalho) {
    final grupos = gruposPorAtividade[atividadeEspiritual] ?? [];
    return grupos.contains(grupoTrabalho);
  }
}
