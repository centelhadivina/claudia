-- ============================================================================
-- INSERIR GRUPOS E ATIVIDADES
-- ============================================================================
-- Este script insere todos os grupos, grupo-tarefas, ações sociais e 
-- atividades espirituais no sistema
-- ============================================================================

-- Limpar dados anteriores (opcional - descomente se quiser resetar)
-- DELETE FROM grupos WHERE tipo IN ('atividade_espiritual', 'grupo_trabalho_espiritual', 'grupo_tarefa', 'acao_social', 'cargo_lideranca');

-- ============================================================================
-- ATIVIDADES ESPIRITUAIS
-- ============================================================================

INSERT INTO grupos (id, nome, tipo, descricao, ativo) VALUES
('esp_encontro_ramatis', 'Encontro dos Amigos de Ramatis', 'atividade_espiritual', 'Encontro mensal dos amigos de Ramatis', true),
('esp_corrente_oracao', 'Corrente de Oração e Renovação (COR)', 'atividade_espiritual', 'Corrente de oração e renovação espiritual', true),
('esp_antigoeicia', 'Sessões de Antigoécia', 'atividade_espiritual', 'Sessão de Antigoécia', true),
('esp_monitoria_infantil', 'Monitoria Infantil', 'atividade_espiritual', 'Monitoria das crianças', true),
('esp_sem_atividade', 'Sem atividade espiritual', 'atividade_espiritual', 'Sem atividade espiritual', true);

-- ============================================================================
-- GRUPOS DE TRABALHO ESPIRITUAL
-- ============================================================================

INSERT INTO grupos (id, nome, tipo, descricao, ativo) VALUES
('gte_paz', 'Grupo Paz', 'grupo_trabalho_espiritual', 'Grupo de Trabalho Espiritual - Paz', true),
('gte_luz', 'Grupo Luz', 'grupo_trabalho_espiritual', 'Grupo de Trabalho Espiritual - Luz', true),
('gte_amor', 'Grupo Amor', 'grupo_trabalho_espiritual', 'Grupo de Trabalho Espiritual - Amor', true),
('gte_fe', 'Grupo Fé', 'grupo_trabalho_espiritual', 'Grupo de Trabalho Espiritual - Fé', true),
('gte_forca', 'Grupo Força', 'grupo_trabalho_espiritual', 'Grupo de Trabalho Espiritual - Força', true),
('gte_esperanca', 'Grupo Esperança', 'grupo_trabalho_espiritual', 'Grupo de Trabalho Espiritual - Esperança', true),
('gte_uniao', 'Grupo União', 'grupo_trabalho_espiritual', 'Grupo de Trabalho Espiritual - União', true),
('gte_sem_grupo', 'Sem grupo de trabalho espiritual', 'grupo_trabalho_espiritual', 'Sem grupo de trabalho espiritual', true);

-- ============================================================================
-- GRUPO-TAREFA (Nota C)
-- ============================================================================

INSERT INTO grupos (id, nome, tipo, descricao, ativo) VALUES
('gt_patrimonio', 'Controle de Patrimônio e Estoque', 'grupo_tarefa', 'Gestão de patrimônio e controle de estoque', true),
('gt_secretaria', 'Auxílio à Secretaria', 'grupo_tarefa', 'Auxílio às atividades da secretaria', true),
('gt_vendas', 'Vendas', 'grupo_tarefa', 'Gestão de vendas e produtos', true),
('gt_comunicacao', 'Comunicação & Marketing', 'grupo_tarefa', 'Comunicação, marketing e divulgação', true);

-- ============================================================================
-- GRUPO DE AÇÃO SOCIAL (Nota D)
-- ============================================================================

INSERT INTO grupos (id, nome, tipo, descricao, ativo) VALUES
('gas_captacao', 'Captação de recursos', 'acao_social', 'Captação de recursos', true),
('gas_arte', 'Projeto Arte Criativa', 'acao_social', 'Projeto Arte Criativa', true),
('gas_aquecendo', 'Projeto Aquecendo Corações', 'acao_social', 'Projeto Aquecendo Corações', true),
('gas_banco_ajuda', 'Projeto Banco de Ajuda', 'acao_social', 'Projeto Banco de Ajuda', true),
('gas_encaminhamento', 'Projeto Encaminhamento Profissional', 'acao_social', 'Projeto Encaminhamento Profissional', true),
('gas_farmacia', 'Projeto Farmácia Solidária', 'acao_social', 'Projeto Farmácia Solidária', true),
('gas_gestar', 'Projeto Gestar, Amar e Cuidar', 'acao_social', 'Projeto Gestar, Amar e Cuidar', true),
('gas_pao_nosso', 'Projeto Pão Nosso', 'acao_social', 'Projeto Pão Nosso', true),
('gas_simiromba', 'Projeto Simiromba', 'acao_social', 'Projeto Simiromba', true),
('gas_terapias', 'Projeto Terapias', 'acao_social', 'Projeto Terapias', true),
('gas_vestibular', 'Projeto Vestibular sem Barreiras', 'acao_social', 'Projeto Vestibular sem Barreiras', true),
('gas_sem_grupo', 'Sem grupo de ação social', 'acao_social', 'Sem grupo de ação social', true);

-- ============================================================================
-- CARGOS DE LIDERANÇA (Nota L)
-- ============================================================================

INSERT INTO grupos (id, nome, tipo, descricao, ativo) VALUES
('lid_diretoria', 'Diretoria', 'cargo_lideranca', 'Membro da Diretoria', true),
('lid_gt', 'Líder de grupo-tarefa', 'cargo_lideranca', 'Líder de Grupo-Tarefa', true),
('lid_gas', 'Líder de grupo de ação social', 'cargo_lideranca', 'Líder de Grupo de Ação Social', true),
('lid_coordenador', 'Coordenador de departamento', 'cargo_lideranca', 'Coordenador de departamento (DIJ, DIM, DAS)', true),
('lid_pai_mae', 'Pai/mãe de terreiro', 'cargo_lideranca', 'Pai ou Mãe de Terreiro', true);

-- ============================================================================
-- VERIFICAR INSERÇÕES
-- ============================================================================

-- Contar grupos por tipo
SELECT tipo, COUNT(*) as total
FROM grupos
GROUP BY tipo
ORDER BY tipo;

-- Mostrar todos os grupos
SELECT id, nome, tipo, ativo
FROM grupos
ORDER BY tipo, nome;

-- ============================================================================
-- COMENTÁRIOS
-- ============================================================================

COMMENT ON COLUMN grupos.tipo IS 'Tipo do grupo: atividade_espiritual, grupo_trabalho_espiritual, grupo_tarefa, acao_social, cargo_lideranca';
