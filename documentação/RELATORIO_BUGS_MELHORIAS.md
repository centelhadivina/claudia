# Relatorio de Bugs e Melhorias

## Objetivo

Consolidar os pontos identificados no sistema para planejamento, execucao e validacao de correcoes por modulo.

## Convencoes

- Status inicial: Aberto
- Tipos: Bug ou Melhoria
- Prioridade: Alta, Media, Baixa

## Modulo Cadastro

### Bugs

- [ ] Prioridade Alta | Bug | Pesquisar nao funciona no modulo cadastro.
  Impacto: bloqueia localizacao de membros para fluxo de manutencao.
  Criterio de aceite: pesquisa deve retornar resultados por criterio valido sem erro.

- [ ] Prioridade Alta | Bug | Data de nascimento gera erro; ao clicar em atualizar a tela recarrega e o cadastro crasha.
  Impacto: impede atualizacao de dados cadastrais.
  Criterio de aceite: atualizar com data valida sem crash e persistir o registro.

- [ ] Prioridade Alta | Bug | Nome dos guias nao esta sendo salvo apos preenchimento.
  Impacto: perda de informacao funcional relevante no cadastro.
  Criterio de aceite: nome dos guias deve persistir e reaparecer na edicao/consulta.

### Melhorias

- [ ] Prioridade Media | Melhoria | Mover funcao de editar para dentro do fluxo de pesquisar.
  Impacto: simplifica jornada e reduz duplicidade de tela/acao.
  Criterio de aceite: ao pesquisar membro, card de resultado exibe acao Editar funcional.

## Modulo Membros

### Bugs

- [ ] Prioridade Alta | Bug | Texto do AppBar com baixa visibilidade (roxo e preto).
  Impacto: compromete legibilidade e acessibilidade.
  Criterio de aceite: contraste de texto no AppBar dentro de padrao de leitura adequado.

- [ ] Prioridade Alta | Bug | No editar membros, campos Grupo Tarefa e Grupo de Acao Social devem vir como dropdown com opcoes reais dos grupos.
  Impacto: risco de inconsistencia e erro de digitacao.
  Criterio de aceite: dropdown carregado com opcoes da base, com selecao e salvamento corretos.

- [ ] Prioridade Media | Bug | Falta opcao de dia de sessao sexta-feira.
  Impacto: incompletude de configuracao operacional.
  Criterio de aceite: sexta-feira disponivel em opcoes de dia de sessao e salva corretamente.

### Melhorias

- [ ] Prioridade Alta | Melhoria | Retirar item Editar Membros do menu e centralizar edicao via resultado da pesquisa.
  Impacto: simplifica navegacao e reduz pontos redundantes de entrada.
  Criterio de aceite: menu sem item Editar Membros e fluxo de edicao mantido via pesquisa.

- [ ] Prioridade Alta | Melhoria | Incluir pesquisa de membros por parte do nome e por numero de cadastro, alem do CPF.
  Impacto: melhora encontrabilidade e produtividade.
  Criterio de aceite: pesquisa aceita termo parcial de nome, numero de cadastro e CPF.

- [ ] Prioridade Alta | Melhoria | Incluir acao Editar no card de pesquisa de usuario, abrindo dados para edicao.
  Impacto: reduz cliques e melhora fluxo operacional.
  Criterio de aceite: card pesquisado possui botao Editar que abre formulario preenchido.

- [ ] Prioridade Media | Melhoria | Criar tabela de opcoes de cargo de lideranca.
  Impacto: padroniza cadastro e evita variacoes de texto.
  Criterio de aceite: cargos carregados de tabela dedicada e selecionaveis no cadastro/edicao.

## Modulo Grupo Tarefa / Grupo de Acao Social

### Bugs

- [ ] Prioridade Alta | Bug | Trabalho espiritual nao esta condizente entre nome do grupo de trabalho e atividade.
  Impacto: incoerencia funcional e possivel erro de classificacao.
  Criterio de aceite: nomes e atividades devem refletir relacionamento correto conforme regra de negocio.

## Modulo Consulta

### Bugs

- [ ] Prioridade Alta | Bug | Campo Data com erro (abre cinza e nao funciona).
  Impacto: bloqueia preenchimento correto da consulta.
  Criterio de aceite: seletor de data funcional, com escolha e persistencia sem falha.

- [ ] Prioridade Alta | Bug | Texto da consulta vem cortado do Supabase.
  Impacto: perda de informacao e rastreabilidade da consulta.
  Criterio de aceite: campos textuais exibidos e salvos integralmente, respeitando limite definido.

### Melhorias

- [ ] Prioridade Alta | Melhoria | Permitir pesquisa por nome do consulente.
  Impacto: melhora acesso ao historico de consultas.
  Criterio de aceite: busca retorna consultas por nome completo e parcial.

- [ ] Prioridade Alta | Melhoria | Nome do guia deve ser campo digitado (nao dropdown).
  Impacto: maior flexibilidade para variacao de nomes nao catalogados.
  Criterio de aceite: campo de texto livre para nome do guia com salvamento correto.

- [ ] Prioridade Alta | Melhoria | Abrir pesquisa por numero de cadastro ou nome.
  Impacto: acelera localizacao do consulente.
  Criterio de aceite: busca aceita numero de cadastro e nome, com retorno consistente.

## Ordem sugerida de execucao

1. Corrigir bugs bloqueantes de cadastro e consulta (crash, data, pesquisa, persistencia de campos).
2. Ajustar fluxo de pesquisa e edicao em cadastro e membros.
3. Padronizar listas de opcoes (grupos, cargos, dias de sessao).
4. Refinar acessibilidade visual (AppBar) e consistencia semantica dos grupos.

## Checklist de validacao final

- [ ] Sem crash em atualizar cadastro com data de nascimento.
- [ ] Pesquisa funcional em Cadastro, Membros e Consulta.
- [ ] Edicao centralizada via card de pesquisa nos modulos aplicaveis.
- [ ] Campos de guias e textos longos persistindo sem truncamento.
- [ ] Dropdowns e tabelas de dominio sincronizados com dados oficiais.
- [ ] Contraste visual revisado no AppBar.
