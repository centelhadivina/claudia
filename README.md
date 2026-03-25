# Centelha Claudia

Aplicação Flutter modular para gestão operacional da casa, com foco em cadastros, membros, cursos, grupos, consultas, sacramentos, autenticação e administração de usuários.

## Objetivos do projeto

- Centralizar processos internos em uma única aplicação web/mobile.
- Garantir escalabilidade por módulos com separação de responsabilidades.
- Usar Supabase como backend principal para autenticação e persistência.

## Stack técnica

- Flutter
- flutter_bloc
- get_it
- Supabase Flutter
- Dio (suporte para integrações externas)

## Estrutura principal

- Código-fonte: lib/
- Scripts SQL e migrações: scripts/
- Documentação funcional e técnica: documentação/
- Pacotes locais: packages/

## Como executar

Pré-requisitos:

- Flutter SDK compatível com pubspec.yaml
- Ambiente configurado para plataforma desejada (web, macOS, Android, iOS)

Passos:

1. Instale dependências:

```bash
flutter pub get
```

2. Configure Supabase:

- Ajuste a chave pública em lib/core/constants/supabase_constants.dart
- Revise o guia em SUPABASE_SETUP.md

3. Execute o app:

```bash
flutter run -d chrome
```

## Mapa de documentação

- Arquitetura geral: ARCHITECTURE.md
- Setup de Supabase: SUPABASE_SETUP.md
- Guia consolidado do projeto: documentação/DOCUMENTATION.md
- Roadmap de melhorias: documentação/ROADMAP_MELHORIAS.md
- Bugs e melhorias mapeados por módulo: documentação/RELATORIO_BUGS_MELHORIAS.md

## Estado atual da documentação

A documentação foi consolidada para reduzir redundância e remover arquivos de status já concluídos. Os guias operacionais ativos foram mantidos e os documentos duplicados/obsoletos foram eliminados.

