-- ============================================================================
-- SCRIPT: CRIAR TABELAS DE CATÁLOGO (SE NÃO EXISTIREM)
-- ============================================================================
-- Execute PRIMEIRO este script para criar as tabelas
-- Depois execute: popular_catalogo_grupos_CORRETO.sql
-- ============================================================================

-- ============================================================================
-- TABELA: grupos_acoes_sociais
-- ============================================================================

CREATE TABLE IF NOT EXISTS grupos_acoes_sociais (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    numero_cadastro VARCHAR(10),
    nome VARCHAR(255),
    grupo_acao_social VARCHAR(100),
    funcao VARCHAR(100),
    data_ultima_alteracao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_grupos_acoes_sociais_nome ON grupos_acoes_sociais(nome);
CREATE INDEX IF NOT EXISTS idx_grupos_acoes_sociais_grupo ON grupos_acoes_sociais(grupo_acao_social);

-- ============================================================================
-- TABELA: grupos_trabalhos_espirituais
-- ============================================================================

CREATE TABLE IF NOT EXISTS grupos_trabalhos_espirituais (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    numero_cadastro VARCHAR(10),
    nome VARCHAR(255),
    atividade_espiritual VARCHAR(100),
    grupo_trabalho VARCHAR(100),
    funcao VARCHAR(100),
    data_ultima_alteracao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_grupos_trabalhos_nome ON grupos_trabalhos_espirituais(nome);
CREATE INDEX IF NOT EXISTS idx_grupos_trabalhos_atividade ON grupos_trabalhos_espirituais(atividade_espiritual);
CREATE INDEX IF NOT EXISTS idx_grupos_trabalhos_grupo ON grupos_trabalhos_espirituais(grupo_trabalho);

-- ============================================================================
-- TABELA: grupos_tarefas
-- ============================================================================

CREATE TABLE IF NOT EXISTS grupos_tarefas (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    numero_cadastro VARCHAR(10),
    nome VARCHAR(255),
    status VARCHAR(50),
    grupo_tarefa VARCHAR(100),
    funcao VARCHAR(100),
    data_ultima_alteracao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_grupos_tarefas_nome ON grupos_tarefas(nome);
CREATE INDEX IF NOT EXISTS idx_grupos_tarefas_grupo ON grupos_tarefas(grupo_tarefa);

-- ============================================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================================

ALTER TABLE grupos_acoes_sociais ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Leitura pública" ON grupos_acoes_sociais;
CREATE POLICY "Leitura pública"
    ON grupos_acoes_sociais FOR SELECT
    USING (true);
DROP POLICY IF EXISTS "Escrita autenticada" ON grupos_acoes_sociais;
CREATE POLICY "Escrita autenticada"
    ON grupos_acoes_sociais FOR ALL
    USING (auth.role() = 'authenticated');

ALTER TABLE grupos_trabalhos_espirituais ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Leitura pública" ON grupos_trabalhos_espirituais;
CREATE POLICY "Leitura pública"
    ON grupos_trabalhos_espirituais FOR SELECT
    USING (true);
DROP POLICY IF EXISTS "Escrita autenticada" ON grupos_trabalhos_espirituais;
CREATE POLICY "Escrita autenticada"
    ON grupos_trabalhos_espirituais FOR ALL
    USING (auth.role() = 'authenticated');

ALTER TABLE grupos_tarefas ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Leitura pública" ON grupos_tarefas;
CREATE POLICY "Leitura pública"
    ON grupos_tarefas FOR SELECT
    USING (true);
DROP POLICY IF EXISTS "Escrita autenticada" ON grupos_tarefas;
CREATE POLICY "Escrita autenticada"
    ON grupos_tarefas FOR ALL
    USING (auth.role() = 'authenticated');

-- ============================================================================
-- VERIFICAÇÃO
-- ============================================================================

SELECT 'Tabelas criadas com sucesso' as status;
SELECT tablename FROM pg_tables WHERE tablename IN ('grupos_acoes_sociais', 'grupos_trabalhos_espirituais', 'grupos_tarefas');
