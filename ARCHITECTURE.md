# Arquitetura do Projeto - Centelha Claudia

## Visão geral

O projeto usa arquitetura modular com separação por camadas (presentation, domain e data) para manter baixo acoplamento e facilitar evolução por contexto de negócio.

## Estrutura atual de código

```text
lib/
├── core/
│   ├── constants/
│   ├── di/
│   ├── error/
│   ├── navigation/
│   ├── services/
│   ├── theme/
│   └── utils/
└── modules/
       ├── auth/
       ├── cadastro/
       ├── consultas/
       ├── cursos/
       ├── grupos_acoes_sociais/
       ├── grupos_tarefas/
       ├── grupos_trabalhos_espirituais/
       ├── home/
       ├── membros/
       ├── organizacao/
       ├── sacramentos/
       └── usuarios_sistema/
```

## Padrão de módulo

Cada módulo evolui no padrão:

- presentation: páginas, bloc/cubit, estados e eventos
- domain: entidades, regras e contratos de repositório
- data: models, datasources e implementação de repositórios

Observação:

Alguns módulos ainda não têm todas as camadas completas, o que é esperado durante evolução incremental.

## Fluxo de dependências

```text
presentation -> domain <- data
```

- Domain não depende de Flutter nem de detalhes de infraestrutura.
- Data implementa contratos definidos em domain.
- Presentation orquestra interação de interface e estado.

## Componentes transversais

- Injeção de dependências centralizada em core/di.
- Serviços compartilhados em core/services (incluindo Supabase).
- Navegação e tema centralizados em core/navigation e core/theme.
- Tratamento de falhas e utilitários comuns em core/error e core/utils.

## Diretrizes de evolução

1. Novas funcionalidades devem nascer dentro de um módulo, evitando espalhar regra de negócio em core.
2. Integrações externas devem entrar por data/datasources com contrato no domain.
3. UI deve consumir casos de uso/serviços de domínio, nunca acessar infraestrutura diretamente.
4. Preferir consistência por módulo antes de expandir novos módulos.

## Riscos técnicos atuais

- Cobertura de testes ainda limitada para módulos críticos.
- Diferença de maturidade entre módulos (alguns com menos camadas implementadas).
- Parte da documentação histórica estava misturada com guias ativos.

## Referências

- Visão operacional consolidada: documentação/DOCUMENTATION.md
- Plano de melhorias: documentação/ROADMAP_MELHORIAS.md
- Setup Supabase: SUPABASE_SETUP.md
