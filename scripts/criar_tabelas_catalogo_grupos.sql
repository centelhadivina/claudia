-- ============================================================================
-- SCRIPT: CRIAR TABELAS DE CATÁLOGO DE GRUPOS
-- ============================================================================
-- Cria tabelas separadas por tipo para facilitar consultas de dropdowns
-- Estas tabelas armazenam os NOMES DOS GRUPOS disponíveis (não os membros)
-- ============================================================================

-- ============================================================================
-- TABELA: acao_social_grupos
-- ============================================================================
-- Armazena a lista de grupos de ação social disponíveis
CREATE TABLE IF NOT EXISTS acao_social_grupos (
    id TEXT PRIMARY KEY,
    nome TEXT NOT NULL UNIQUE,
    descricao TEXT,
    ativo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TRIGGER atualizar_acao_social_grupos_updated_at
    BEFORE UPDATE ON acao_social_grupos
    FOR EACH ROW
    EXECUTE FUNCTION atualizar_timestamp_updated_at();

CREATE INDEX idx_acao_social_grupos_nome ON acao_social_grupos(nome);
CREATE INDEX idx_acao_social_grupos_ativo ON acao_social_grupos(ativo);

-- ============================================================================
-- TABELA: trabalho_espiritual_atividades
-- ============================================================================
-- Armazena a lista de atividades espirituais disponíveis
CREATE TABLE IF NOT EXISTS trabalho_espiritual_atividades (
    id TEXT PRIMARY KEY,
    nome TEXT NOT NULL UNIQUE,
    descricao TEXT,
    ativo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TRIGGER atualizar_trabalho_espiritual_atividades_updated_at
    BEFORE UPDATE ON trabalho_espiritual_atividades
    FOR EACH ROW
    EXECUTE FUNCTION atualizar_timestamp_updated_at();

CREATE INDEX idx_trabalho_espiritual_atividades_nome ON trabalho_espiritual_atividades(nome);
CREATE INDEX idx_trabalho_espiritual_atividades_ativo ON trabalho_espiritual_atividades(ativo);

-- ============================================================================
-- TABELA: trabalho_espiritual_grupos
-- ============================================================================
-- Armazena a lista de grupos de trabalho espiritual disponíveis
CREATE TABLE IF NOT EXISTS trabalho_espiritual_grupos (
    id TEXT PRIMARY KEY,
    nome TEXT NOT NULL UNIQUE,
    descricao TEXT,
    ativo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TRIGGER atualizar_trabalho_espiritual_grupos_updated_at
    BEFORE UPDATE ON trabalho_espiritual_grupos
    FOR EACH ROW
    EXECUTE FUNCTION atualizar_timestamp_updated_at();

CREATE INDEX idx_trabalho_espiritual_grupos_nome ON trabalho_espiritual_grupos(nome);
CREATE INDEX idx_trabalho_espiritual_grupos_ativo ON trabalho_espiritual_grupos(ativo);

-- ============================================================================
-- TABELA: grupos_tarefas_lista
-- ============================================================================
-- Armazena a lista de grupos de tarefas disponíveis
CREATE TABLE IF NOT EXISTS grupos_tarefas_lista (
    id TEXT PRIMARY KEY,
    nome TEXT NOT NULL UNIQUE,
    descricao TEXT,
    ativo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TRIGGER atualizar_grupos_tarefas_lista_updated_at
    BEFORE UPDATE ON grupos_tarefas_lista
    FOR EACH ROW
    EXECUTE FUNCTION atualizar_timestamp_updated_at();

CREATE INDEX idx_grupos_tarefas_lista_nome ON grupos_tarefas_lista(nome);
CREATE INDEX idx_grupos_tarefas_lista_ativo ON grupos_tarefas_lista(ativo);

-- ============================================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================================

ALTER TABLE acao_social_grupos ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Leitura pública de grupos de ação social"
    ON acao_social_grupos FOR SELECT
    USING (true);
CREATE POLICY "Escrita autenticada de grupos de ação social"
    ON acao_social_grupos FOR ALL
    USING (auth.role() = 'authenticated');

ALTER TABLE trabalho_espiritual_atividades ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Leitura pública de atividades espirituais"
    ON trabalho_espiritual_atividades FOR SELECT
    USING (true);
CREATE POLICY "Escrita autenticada de atividades espirituais"
    ON trabalho_espiritual_atividades FOR ALL
    USING (auth.role() = 'authenticated');

ALTER TABLE trabalho_espiritual_grupos ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Leitura pública de grupos de trabalho espiritual"
    ON trabalho_espiritual_grupos FOR SELECT
    USING (true);
CREATE POLICY "Escrita autenticada de grupos de trabalho espiritual"
    ON trabalho_espiritual_grupos FOR ALL
    USING (auth.role() = 'authenticated');

ALTER TABLE grupos_tarefas_lista ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Leitura pública de grupos de tarefas"
    ON grupos_tarefas_lista FOR SELECT
    USING (true);
CREATE POLICY "Escrita autenticada de grupos de tarefas"
    ON grupos_tarefas_lista FOR ALL
    USING (auth.role() = 'authenticated');

-- ============================================================================
-- VERIFICAÇÃO
-- ============================================================================

COMMIT;
REFRESH MATERIALIZED VIEW IF EXISTS information_schema.tables;

SELECT 
    tablename,
    'Tabela de catálogo criada' as status
FROM pg_tables
WHERE tablename IN (
    'acao_social_grupos',
    'trabalho_espiritual_atividades',
    'trabalho_espiritual_grupos',
    'grupos_tarefas_lista'
)
AND schemaname = 'public';
