-- ============================================================================
-- SCRIPT: POPULAR TABELAS DE CATÁLOGO DE GRUPOS (NOMES CORRETOS)
-- ============================================================================
-- Execute EXATAMENTE este script no Supabase SQL Editor
-- ============================================================================

-- ============================================================================
-- POPULAR: grupos_acoes_sociais
-- ============================================================================

DELETE FROM grupos_acoes_sociais;

INSERT INTO grupos_acoes_sociais (id, nome, descricao, ativo)
SELECT id, nome, descricao, ativo
FROM grupos
WHERE tipo = 'acao_social' AND ativo = true
ORDER BY nome;

-- Adicionar "Sem grupo" caso não exista
INSERT INTO grupos_acoes_sociais (id, nome, descricao, ativo)
VALUES ('gas_sem_grupo', 'Sem grupo de ação social', NULL, true)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- POPULAR: grupos_trabalhos_espirituais (Atividades)
-- ============================================================================

DELETE FROM grupos_trabalhos_espirituais WHERE id LIKE 'esp_%';

INSERT INTO grupos_trabalhos_espirituais (id, nome, descricao, ativo)
SELECT id, nome, descricao, ativo
FROM grupos
WHERE tipo = 'atividade_espiritual' AND ativo = true
ORDER BY nome;

-- ============================================================================
-- POPULAR: grupos_trabalhos_espirituais (Grupos Espirituais)
-- ============================================================================

INSERT INTO grupos_trabalhos_espirituais (id, nome, descricao, ativo)
SELECT id, nome, descricao, ativo
FROM grupos
WHERE tipo = 'grupo_trabalho_espiritual' AND ativo = true
ORDER BY nome
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- POPULAR: grupos_tarefas
-- ============================================================================

DELETE FROM grupos_tarefas WHERE id LIKE 'gtar_%';

INSERT INTO grupos_tarefas (id, nome, descricao, ativo)
SELECT id, nome, descricao, ativo
FROM grupos
WHERE tipo = 'grupo_tarefa' AND ativo = true
ORDER BY nome
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- VERIFICAÇÃO E REPORTE
-- ============================================================================

SELECT 'Ações Sociais' as categoria, COUNT(*) as total FROM grupos_acoes_sociais WHERE ativo = true
UNION ALL
SELECT 'Atividades Espirituais', COUNT(*) FROM grupos_trabalhos_espirituais WHERE id LIKE 'esp_%' AND ativo = true
UNION ALL
SELECT 'Grupos Espirituais', COUNT(*) FROM grupos_trabalhos_espirituais WHERE id LIKE 'gte_%' AND ativo = true
UNION ALL
SELECT 'Grupos de Tarefas', COUNT(*) FROM grupos_tarefas WHERE ativo = true;

-- Detalhe dos grupos de ação social
SELECT '=== GRUPOS DE AÇÃO SOCIAL ===' as info;
SELECT id, nome FROM grupos_acoes_sociais WHERE ativo = true ORDER BY nome;

-- Detalhe das atividades espirituais
SELECT '';
SELECT '=== ATIVIDADES ESPIRITUAIS ===' as info;
SELECT id, nome FROM grupos_trabalhos_espirituais WHERE id LIKE 'esp_%' AND ativo = true ORDER BY nome;

-- Detalhe dos grupos de trabalho espiritual
SELECT '';
SELECT '=== GRUPOS DE TRABALHO ESPIRITUAL ===' as info;
SELECT id, nome FROM grupos_trabalhos_espirituais WHERE id LIKE 'gte_%' AND ativo = true ORDER BY nome;

-- Detalhe dos grupos de tarefas
SELECT '';
SELECT '=== GRUPOS DE TAREFAS ===' as info;
SELECT id, nome FROM grupos_tarefas WHERE ativo = true ORDER BY nome;
