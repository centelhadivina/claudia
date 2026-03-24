-- SCRIPT: popular catálogo de grupos (compatível com schema atual)
-- Fonte: tabela grupos
-- Observação: tabelas de destino usam id UUID; não inserir id manualmente.

-- POPULAR: grupos_acoes_sociais (coluna catálogo: grupo_acao_social)
INSERT INTO grupos_acoes_sociais (
	numero_cadastro,
	nome,
	grupo_acao_social,
	funcao,
	data_ultima_alteracao
)
SELECT
	NULL,
	g.nome,
	g.nome,
	'Membro',
	NOW()
FROM grupos g
WHERE g.tipo = 'acao_social'
  AND g.ativo = true
  AND NOT EXISTS (
	  SELECT 1
	  FROM grupos_acoes_sociais gas
	  WHERE gas.grupo_acao_social = g.nome
  );

-- POPULAR: grupos_trabalhos_espirituais (Atividades)
INSERT INTO grupos_trabalhos_espirituais (
	numero_cadastro,
	nome,
	atividade_espiritual,
	grupo_trabalho,
	funcao,
	data_ultima_alteracao
)
SELECT
	NULL,
	g.nome,
	g.nome,
	NULL,
	'Membro',
	NOW()
FROM grupos g
WHERE g.tipo = 'atividade_espiritual'
  AND g.ativo = true
  AND NOT EXISTS (
	  SELECT 1
	  FROM grupos_trabalhos_espirituais gte
	  WHERE gte.atividade_espiritual = g.nome
  );

-- POPULAR: grupos_trabalhos_espirituais (Grupos)
INSERT INTO grupos_trabalhos_espirituais (
	numero_cadastro,
	nome,
	atividade_espiritual,
	grupo_trabalho,
	funcao,
	data_ultima_alteracao
)
SELECT
	NULL,
	g.nome,
	NULL,
	g.nome,
	'Membro',
	NOW()
FROM grupos g
WHERE g.tipo = 'grupo_trabalho_espiritual'
  AND g.ativo = true
  AND NOT EXISTS (
	  SELECT 1
	  FROM grupos_trabalhos_espirituais gte
	  WHERE gte.grupo_trabalho = g.nome
  );

-- POPULAR: grupos_tarefas (coluna catálogo: grupo_tarefa)
INSERT INTO grupos_tarefas (
	numero_cadastro,
	nome,
	status,
	grupo_tarefa,
	funcao,
	data_ultima_alteracao
)
SELECT
	NULL,
	g.nome,
	'Membro ativo',
	g.nome,
	'Membro',
	NOW()
FROM grupos g
WHERE g.tipo = 'grupo_tarefa'
  AND g.ativo = true
  AND NOT EXISTS (
	  SELECT 1
	  FROM grupos_tarefas gt
	  WHERE gt.grupo_tarefa = g.nome
  );

-- VERIFICAÇÃO E REPORTE
SELECT 'Ações Sociais' as categoria, COUNT(DISTINCT grupo_acao_social) as total
FROM grupos_acoes_sociais
WHERE grupo_acao_social IS NOT NULL
UNION ALL
SELECT 'Atividades Espirituais', COUNT(DISTINCT atividade_espiritual)
FROM grupos_trabalhos_espirituais
WHERE atividade_espiritual IS NOT NULL
UNION ALL
SELECT 'Grupos Espirituais', COUNT(DISTINCT grupo_trabalho)
FROM grupos_trabalhos_espirituais
WHERE grupo_trabalho IS NOT NULL
UNION ALL
SELECT 'Grupos de Tarefas', COUNT(DISTINCT grupo_tarefa)
FROM grupos_tarefas
WHERE grupo_tarefa IS NOT NULL;

SELECT '=== GRUPOS DE AÇÃO SOCIAL ===' as info;
SELECT DISTINCT grupo_acao_social as nome
FROM grupos_acoes_sociais
WHERE grupo_acao_social IS NOT NULL
ORDER BY nome;

SELECT '=== ATIVIDADES ESPIRITUAIS ===' as info;
SELECT DISTINCT atividade_espiritual as nome
FROM grupos_trabalhos_espirituais
WHERE atividade_espiritual IS NOT NULL
ORDER BY nome;

SELECT '=== GRUPOS DE TRABALHO ESPIRITUAL ===' as info;
SELECT DISTINCT grupo_trabalho as nome
FROM grupos_trabalhos_espirituais
WHERE grupo_trabalho IS NOT NULL
ORDER BY nome;

SELECT '=== GRUPOS DE TAREFAS ===' as info;
SELECT DISTINCT grupo_tarefa as nome
FROM grupos_tarefas
WHERE grupo_tarefa IS NOT NULL
ORDER BY nome;
