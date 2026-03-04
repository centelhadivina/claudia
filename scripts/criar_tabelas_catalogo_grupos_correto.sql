-- ============================================================================
-- SCRIPT: CRIAR TABELAS DE CATÁLOGO DE GRUPOS (NOMES CORRETOS)
-- ============================================================================
-- Se as tabelas NÃO existem, execute este script primeiro
-- Se as tabelas JÁ existem, pule para popular_catalogo_grupos.sql
-- ============================================================================

-- Verifica se as tabelas já existem (para Supabase)
-- Se existirem, o script de população funcionará normalmente

-- ============================================================================
-- TABELA: grupos_acoes_sociais (CATÁLOGO)
-- ============================================================================
-- Se já existe, você pode ignorar este bloco
-- Armazena a lista de grupos de ação social disponíveis

-- Verifique se a tabela já existe antes de criar
-- Supabase já pode ter uma tabela com este nome para MEMBROS
-- Caso tenha, você pode usar a mesma ou criar uma coluna 'tipo' para separar

-- ============================================================================
-- TABELA: grupos_trabalhos_espirituais (CATÁLOGO - Atividades + Grupos)
-- ============================================================================
-- Armazena TANTO atividades QUANTO grupos de trabalho espiritual
-- Use o prefixo do 'id' para diferenciar:
-- - esp_* = Atividade Espiritual
-- - gte_* = Grupo de Trabalho Espiritual

-- ============================================================================
-- TABELA: grupos_tarefas (CATÁLOGO)
-- ============================================================================
-- Armazena a lista de grupos de tarefas disponíveis

-- ============================================================================
-- IMPORTANTE: ESTRUTURA DAS TABELAS
-- ============================================================================
-- As seguintes colunas são ESPERADAS em cada tabela:
-- - id TEXT PRIMARY KEY
-- - nome TEXT NOT NULL
-- - descricao TEXT (opcional)
-- - ativo BOOLEAN DEFAULT true

-- Se suas tabelas tiverem uma estrutura diferente, 
-- ajuste o script popular_catalogo_grupos.sql para corresponder

-- ============================================================================
-- EXECUÇÃO
-- ============================================================================
-- Se as tabelas já existem no Supabase com os nomes:
-- - grupos_acoes_sociais
-- - grupos_trabalhos_espirituais
-- - grupos_tarefas
-- 
-- Pule direto para: scripts/popular_catalogo_grupos.sql
