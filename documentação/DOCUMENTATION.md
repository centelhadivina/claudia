# Documentacao Consolidada do Projeto

## Escopo

Este documento centraliza a visao tecnica e operacional do Centelha Claudia, reduzindo duplicidade e organizando o uso da documentacao ativa.

## Visao do sistema

Aplicacao Flutter modular para gestao interna, com backend em Supabase e organizacao por dominios de negocio.

Dominios ativos em codigo:

- auth
- cadastro
- consultas
- cursos
- grupos_acoes_sociais
- grupos_tarefas
- grupos_trabalhos_espirituais
- home
- membros
- organizacao
- sacramentos
- usuarios_sistema

## Setup rapido

1. Instalar dependencias:

```bash
flutter pub get
```

2. Configurar Supabase:

- Ajustar credenciais em lib/core/constants/supabase_constants.dart
- Seguir SUPABASE_SETUP.md

3. Executar aplicacao:

```bash
flutter run -d chrome
```

## Estrutura recomendada de leitura

1. Comecar por ARCHITECTURE.md.
2. Seguir para SUPABASE_SETUP.md e GUIA_USO_DATASOURCES.md.
3. Consultar guias funcionais por modulo.
4. Usar ROADMAP_MELHORIAS.md e RELATORIO_BUGS_MELHORIAS.md para planejamento.

## Guias ativos por tema

Arquitetura e evolucao:

- ARCHITECTURE.md
- EXPANSION_GUIDE.md
- ARQUITETURA_DADOS_AVALIACOES.md

Supabase, dados e operacao de banco:

- SUPABASE_SETUP.md
- GUIA_CRIAR_TABELAS_SUPABASE.md
- GUIA_USO_DATASOURCES.md

Fluxos funcionais:

- SISTEMA_AUTENTICACAO.md
- SISTEMA_IMPORTACAO_PRESENCAS.md
- GUIA_USO_INTERFACES.md
- INTERFACES_LANCAMENTO_NOTAS.md
- GUIA_INTEGRACAO_MENU.md

Importacao e manutencao:

- IMPORTAR_CADASTROS_DO_JSON.md
- IMPORTAR_MEMBROS_ANTIGOS.md
- IMPORTAR_CURSOS.md
- GUIA_RAPIDO_IMPORTACAO_PRESENCAS.md
- LIMPAR_E_REIMPORTAR.md

Qualidade e planejamento:

- ROADMAP_MELHORIAS.md
- RELATORIO_BUGS_MELHORIAS.md

Implantacao e referencia:

- DEPLOY_GITHUB_PAGES.md
- CAMPOS_USUARIO.md
- MELHORIAS_BUSCA.md
- PREVENCAO_DUPLICATAS.md
- IMPLEMENTACAO_CATALOGO_GRUPOS.md

## Politica de obsolescencia

Documentos de correcao pontual, migracoes concluidas e arquivos duplicados foram removidos para reduzir ruido.
Quando um ajuste estiver estavel no produto, o conteudo deve ser incorporado no guia operacional principal em vez de manter arquivos de "fix" separados.

## Criterios para criar novos documentos

Criar novo arquivo somente quando houver:

- novo subsistema com operacao independente
- runbook recorrente de incidente ou operacao
- decisao arquitetural que nao cabe em ARCHITECTURE.md

Nos demais casos, atualizar documento existente para evitar fragmentacao.

## Pontos de melhoria tecnica

1. Definir baseline de testes para fluxos criticos por modulo.
2. Consolidar versionamento de scripts SQL por ambiente.
3. Padronizar observabilidade de erros e eventos de negocio.
4. Fechar lacunas de consistencia entre modulos (camadas e contratos).
5. Revisar documentacao trimestralmente para evitar nova obsolescencia.
