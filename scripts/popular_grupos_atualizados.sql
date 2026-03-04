-- ============================================================================
-- SCRIPT PARA POPULAR DADOS ATUALIZADOS DE GRUPOS NO SUPABASE
-- ============================================================================
-- EXECUTE ESTE SCRIPT NO SQL EDITOR DO SUPABASE PARA ATUALIZAR OS DADOS
-- ============================================================================

-- ============================================================================
-- LIMPAR DADOS ANTIGOS (OPCIONAL - DESCOMENTE SE QUISER RESETAR)
-- ============================================================================

-- DELETE FROM grupos WHERE tipo IN ('atividade_espiritual', 'grupo_trabalho_espiritual', 'acao_social');

-- ============================================================================
-- ATUALIZAR ATIVIDADES ESPIRITUAIS EXISTENTES
-- ============================================================================

-- Deletar e reinserir as atividades espirituais
DELETE FROM grupos WHERE tipo = 'atividade_espiritual';

INSERT INTO grupos (id, nome, tipo, descricao, ativo) VALUES
('esp_encontro_ramatis', 'Encontro dos Amigos de Ramatis', 'atividade_espiritual', 'Encontro mensal dos amigos de Ramatis', true),
('esp_corrente_oracao', 'Corrente de Oração e Renovação (COR)', 'atividade_espiritual', 'Corrente de oração e renovação espiritual', true),
('esp_antigoeicia', 'Sessões de Antigoécia', 'atividade_espiritual', 'Sessão de Antigoécia', true),
('esp_monitoria_infantil', 'Monitoria Infantil', 'atividade_espiritual', 'Monitoria das crianças', true),
('esp_sem_atividade', 'Sem atividade espiritual', 'atividade_espiritual', 'Sem atividade espiritual', true);

-- ============================================================================
-- ATUALIZAR GRUPOS DE TRABALHO ESPIRITUAL
-- ============================================================================

DELETE FROM grupos WHERE tipo = 'grupo_trabalho_espiritual';

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
-- ATUALIZAR GRUPOS DE AÇÃO SOCIAL
-- ============================================================================

DELETE FROM grupos WHERE tipo = 'acao_social' AND nome != 'Coordenação';

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
-- VERIFICAR INSERÇÕES
-- ============================================================================

-- Ver totais por tipo
SELECT tipo, COUNT(*) as total
FROM grupos
GROUP BY tipo
ORDER BY tipo;

-- Ver todos os grupos atualizados
SELECT id, nome, tipo, ativo
FROM grupos
WHERE tipo IN ('atividade_espiritual', 'grupo_trabalho_espiritual', 'acao_social')
ORDER BY tipo, nome;

-- ============================================================================
-- INSTRUÇÕES DE USO
-- ============================================================================

/*
1. Abra o Supabase Console (https://app.supabase.com)
2. Vá em SQL Editor
3. Cole o conteúdo deste script
4. Clique em "Run" (ou CTRL+Enter)
5. Verifique que os dados foram inseridos com os SELECT abaixo

OBSERVAÇÕES:
- O script deleta os grupos antigos e insere os novos
- Os cargos de liderança (cargo_lideranca) não foram modificados
- No campo função, os valores serão atualizados em separate statement

PRÓXIMOS PASSOS:
- Se precisar atualizar as funções de "Participante" para "Membro",
  use este script adicional:

  UPDATE usuarios_grupos_acao_social SET funcao = 'Membro' WHERE funcao = 'Participante';
  UPDATE usuarios_grupos_trabalho_espiritual SET funcao = 'Membro' WHERE funcao = 'Participante';
*/
