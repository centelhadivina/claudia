# Roadmap de Melhorias

## Objetivo

Priorizar evolução técnica com foco em confiabilidade, manutenção e previsibilidade de entrega.

## Curto prazo (0-30 dias)

1. Cobertura de testes mínima para fluxos críticos:
- autenticação
- cadastro/membros
- importações

2. Auditoria de integração Supabase:
- validar políticas RLS por tabela ativa
- mapear queries sem índice
- revisar tratamento de erros em operações críticas

3. Padronização de documentação operacional:
- runbooks de importação e correção de dados
- checklist de deploy web

## Médio prazo (31-90 dias)

1. Padronização de módulo:
- todos os módulos com camadas explícitas (presentation/domain/data)
- contratos de domínio documentados

2. Observabilidade:
- trilha de erros por módulo
- eventos de negócio para auditoria
- métricas de importação (volume, rejeição, duplicidade)

3. Governança de banco:
- versionamento de scripts SQL
- processo de migração repetível por ambiente

## Longo prazo (90+ dias)

1. Otimização de performance e experiência:
- paginação em listas volumosas
- cache para consultas recorrentes
- redução de latência em fluxos críticos

2. Hardening de segurança:
- revisão periódica de permissões por perfil
- trilha de auditoria para operações sensíveis

3. Maturidade de entrega:
- pipeline de validação automatizada
- critérios de release por módulo

## Indicadores de sucesso

- aumento de cobertura de testes dos fluxos críticos
- redução de erros em importação e autenticação
- menor tempo de diagnóstico de incidentes
- documentação operacional atualizada em ciclo trimestral

## Riscos e mitigação

1. Risco: expansão funcional sem padronização técnica.
Mitigação: gate arquitetural para novos módulos.

2. Risco: regressão por ausência de testes.
Mitigação: baseline obrigatório de testes antes de release.

3. Risco: divergência entre SQL e aplicação.
Mitigação: processo formal de migração e revisão técnica.
