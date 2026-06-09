-- ================================================
-- Criar tabela ERROR_LOGS para histórico de erros
-- ================================================
-- Execute este script no SQL Editor do Supabase
-- ================================================

-- Criar tabela error_logs
CREATE TABLE IF NOT EXISTS error_logs (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  
  -- Informações do erro
  erro_tipo VARCHAR(255),
  erro_mensagem TEXT NOT NULL,
  erro_stack_trace TEXT,
  
  -- Contexto
  modulo VARCHAR(255),
  funcionalidade VARCHAR(255),
  usuario_id UUID,
  
  -- Ambiente
  plataforma VARCHAR(50),
  versao_app VARCHAR(50),
  
  -- Metadados
  dados_adicionais JSONB DEFAULT '{}'::jsonb,
  
  -- Timestamps
  data_erro TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Criar índices para melhor performance
CREATE INDEX IF NOT EXISTS idx_error_logs_data_erro ON error_logs(data_erro DESC);
CREATE INDEX IF NOT EXISTS idx_error_logs_modulo ON error_logs(modulo);
CREATE INDEX IF NOT EXISTS idx_error_logs_usuario_id ON error_logs(usuario_id);
CREATE INDEX IF NOT EXISTS idx_error_logs_erro_tipo ON error_logs(erro_tipo);

-- Habilitar RLS (Row Level Security)
ALTER TABLE error_logs ENABLE ROW LEVEL SECURITY;

-- Política: Permitir inserção para usuários autenticados (qualquer um pode registrar erro)
CREATE POLICY "Permitir inserção de logs de erro para usuários autenticados" 
ON error_logs FOR INSERT 
TO authenticated 
WITH CHECK (true);

-- Política: Permitir leitura apenas para usuários de sistema (admin)
CREATE POLICY "Permitir leitura de logs para usuários de sistema" 
ON error_logs FOR SELECT 
TO authenticated 
USING (
  EXISTS (
    SELECT 1 FROM usuarios_sistema 
    WHERE usuarios_sistema.id = auth.uid()
  )
);

-- Política: Permitir deleção apenas para usuários de sistema
CREATE POLICY "Permitir deleção de logs para usuários de sistema" 
ON error_logs FOR DELETE 
TO authenticated 
USING (
  EXISTS (
    SELECT 1 FROM usuarios_sistema 
    WHERE usuarios_sistema.id = auth.uid()
  )
);

-- Trigger para atualizar updated_at automaticamente
CREATE TRIGGER update_error_logs_updated_at 
BEFORE UPDATE ON error_logs 
FOR EACH ROW 
EXECUTE FUNCTION update_updated_at_column();

-- Criar view para erros recentes (últimas 24h)
CREATE OR REPLACE VIEW error_logs_recentes AS
SELECT 
  id,
  erro_tipo,
  erro_mensagem,
  modulo,
  usuario_id,
  data_erro,
  COUNT(*) OVER (PARTITION BY erro_tipo, modulo) as frequencia
FROM error_logs
WHERE data_erro > NOW() - INTERVAL '24 hours'
ORDER BY data_erro DESC;

-- Verificar tabela criada
SELECT 
  table_name, 
  column_name, 
  data_type 
FROM information_schema.columns 
WHERE table_name = 'error_logs'
ORDER BY ordinal_position;
