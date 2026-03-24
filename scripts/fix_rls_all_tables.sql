-- ================================================
-- CORREÇÃO DE RLS - TODAS AS TABELAS PROBLEMÁTICAS
-- Script para permitir leitura pública das tabelas
-- ================================================

-- ================================================
-- MEMBROS_HISTORICO - Leitura pública
-- ================================================
ALTER TABLE IF EXISTS membros_historico ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "membros_historico_read_public" ON membros_historico;
DROP POLICY IF EXISTS "membros_historico_write_auth" ON membros_historico;
DROP POLICY IF EXISTS "membros_historico_update_auth" ON membros_historico;
DROP POLICY IF EXISTS "membros_historico_delete_auth" ON membros_historico;

CREATE POLICY "membros_historico_read_public" ON membros_historico 
  FOR SELECT USING (true);

CREATE POLICY "membros_historico_write_auth" ON membros_historico 
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "membros_historico_update_auth" ON membros_historico 
  FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "membros_historico_delete_auth" ON membros_historico 
  FOR DELETE TO authenticated USING (true);

-- ================================================
-- CONSULTAS - Leitura pública
-- ================================================
ALTER TABLE IF EXISTS consultas ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "consultas_read_public" ON consultas;
DROP POLICY IF EXISTS "consultas_write_auth" ON consultas;
DROP POLICY IF EXISTS "consultas_update_auth" ON consultas;
DROP POLICY IF EXISTS "consultas_delete_auth" ON consultas;

CREATE POLICY "consultas_read_public" ON consultas 
  FOR SELECT USING (true);

CREATE POLICY "consultas_write_auth" ON consultas 
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "consultas_update_auth" ON consultas 
  FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "consultas_delete_auth" ON consultas 
  FOR DELETE TO authenticated USING (true);

-- ================================================
-- CADASTRO - Leitura pública
-- ================================================
ALTER TABLE IF EXISTS cadastro ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "cadastro_read_public" ON cadastro;
DROP POLICY IF EXISTS "cadastro_write_auth" ON cadastro;
DROP POLICY IF EXISTS "cadastro_update_auth" ON cadastro;
DROP POLICY IF EXISTS "cadastro_delete_auth" ON cadastro;

CREATE POLICY "cadastro_read_public" ON cadastro 
  FOR SELECT USING (true);

CREATE POLICY "cadastro_write_auth" ON cadastro 
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "cadastro_update_auth" ON cadastro 
  FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "cadastro_delete_auth" ON cadastro 
  FOR DELETE TO authenticated USING (true);

-- ================================================
-- USUARIOS_SISTEMA - Leitura pública
-- ================================================
ALTER TABLE IF EXISTS usuarios_sistema ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "usuarios_sistema_read_public" ON usuarios_sistema;
DROP POLICY IF EXISTS "usuarios_sistema_write_auth" ON usuarios_sistema;
DROP POLICY IF EXISTS "usuarios_sistema_update_auth" ON usuarios_sistema;
DROP POLICY IF EXISTS "usuarios_sistema_delete_auth" ON usuarios_sistema;

CREATE POLICY "usuarios_sistema_read_public" ON usuarios_sistema 
  FOR SELECT USING (true);

CREATE POLICY "usuarios_sistema_write_auth" ON usuarios_sistema 
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "usuarios_sistema_update_auth" ON usuarios_sistema 
  FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "usuarios_sistema_delete_auth" ON usuarios_sistema 
  FOR DELETE TO authenticated USING (true);

-- ================================================
-- VERIFICAÇÃO
-- ================================================
SELECT 
  'Políticas RLS aplicadas com sucesso!' as status,
  'Tabelas: membros_historico, consultas, cadastro, usuarios_sistema' as detalhes;

-- Verificar políticas criadas
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies
WHERE tablename IN ('membros_historico', 'consultas', 'cadastro', 'usuarios_sistema')
ORDER BY tablename, policyname;
