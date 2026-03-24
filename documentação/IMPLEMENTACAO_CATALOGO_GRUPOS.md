# Guia de Implementação: Tabelas de Catálogo de Grupos

## 🎯 Problema Resolvido

O sistema estava tentando puxar dados de catálogo da tabela `grupos` centralizada, mas não estava funcionando nos dropdowns. Agora vamos criar tabelas separadas de catálogo:

- `acao_social_grupos` - Lista de grupos de ação social
- `trabalho_espiritual_atividades` - Lista de atividades espirituais
- `trabalho_espiritual_grupos` - Lista de grupos de trabalho espiritual
- `grupos_tarefas_lista` - Lista de grupos de tarefas

## 📋 Passo a Passo

### 1️⃣ Criar as Tabelas de Catálogo

**No Supabase SQL Editor, execute:**

```bash
File: scripts/criar_tabelas_catalogo_grupos.sql
```

Copie todo conteúdo deste script e execute no Supabase SQL Editor.

**O que fará:**
✅ Cria 4 tabelas de catálogo separadas
✅ Configura Row Level Security (RLS) para cada tabela
✅ Adiciona triggers para atualizar `updated_at` automaticamente
✅ Cria índices para melhor performance

---

### 2️⃣ Popular as Tabelas com Dados da Tabela `grupos`

**No Supabase SQL Editor, execute:**

```bash
File: scripts/popular_catalogo_grupos.sql
```

Copie todo conteúdo deste script e execute no Supabase SQL Editor.

**O que fará:**
✅ Copia dados de `grupos` (tipo='acao_social') → `acao_social_grupos`
✅ Copia dados de `grupos` (tipo='atividade_espiritual') → `trabalho_espiritual_atividades`
✅ Copia dados de `grupos` (tipo='grupo_trabalho_espiritual') → `trabalho_espiritual_grupos`
✅ Copia dados de `grupos` (tipo='grupo_tarefa') → `grupos_tarefas_lista`
✅ Mostra relatório de dados inseridos

---

### 3️⃣ Verificar se os Dados Foram Inseridos

Após executar o script de população, você verá um relatório com:

- Contador de registros por tipo
- Lista detalhada de cada grupo/atividade
- Confirmação de sucesso

**Exemplo de saída esperada:**

```
categoria                | total
Ações Sociais           | 12
Atividades Espirituais  | 5
Grupos Espirituais      | 8
Grupos de Tarefas       | N
```

---

### 4️⃣ Código Já Atualizado

Os datasources foram atualizados para usar as novas tabelas:

✅ **grupo_acao_social_supabase_datasource.dart**

- `carregarGruposDisponiveis()` → busca de `acao_social_grupos`

✅ **grupo_trabalho_espiritual_supabase_datasource.dart**

- `carregarAtividadesDisponiveis()` → busca de `trabalho_espiritual_atividades`
- `carregarGruposEspirituaisDisponiveis()` → busca de `trabalho_espiritual_grupos`

---

### 5️⃣ Build e Teste

```bash
flutter clean && flutter pub get && flutter run
```

Verifique se:

1. ✅ Ao clicar em "Atividade Espiritual", a lista popula
2. ✅ Ao clicar em "Grupo de Trabalho", a lista popula
3. ✅ Ao clicar em "Grupo de Ação Social", a lista popula
4. ✅ Os relatórios funcionam corretamente

---

## 🔄 Sincronização Futura

Se adicionar novos grupos na tabela `grupos`, execute novamente:

```sql
-- Para sincronizar grupos de ação social
DELETE FROM acao_social_grupos;
INSERT INTO acao_social_grupos (id, nome, descricao, ativo)
SELECT id, nome, descricao, ativo FROM grupos
WHERE tipo = 'acao_social' AND ativo = true ORDER BY nome;
```

Repita para cada tipo conforme necessário.

---

## 📊 Estrutura das Tabelas

### acao_social_grupos

```sql
id TEXT PRIMARY KEY
nome TEXT NOT NULL UNIQUE
descricao TEXT
ativo BOOLEAN DEFAULT true
created_at TIMESTAMP
updated_at TIMESTAMP
```

### trabalho_espiritual_atividades

```sql
id TEXT PRIMARY KEY
nome TEXT NOT NULL UNIQUE
descricao TEXT
ativo BOOLEAN DEFAULT true
created_at TIMESTAMP
updated_at TIMESTAMP
```

### trabalho_espiritual_grupos

```sql
id TEXT PRIMARY KEY
nome TEXT NOT NULL UNIQUE
descricao TEXT
ativo BOOLEAN DEFAULT true
created_at TIMESTAMP
updated_at TIMESTAMP
```

---

## ❓ FAQ

**P: Por que criar tabelas separadas?**
A: As tabelas separadas são especializadas para cada tipo de dado, facilitam queries mais rápidas e permitem RLS granular.

**P: E se mudar um grupo na tabela `grupos`?**
A: Execute novamente o script `popular_catalogo_grupos.sql` para sincronizar, ou atualize manualmente.

**P: A tabela `grupos` continua sendo usada?**
A: Sim! Serve como "master data". As tabelas de catálogo são cópias especializadas.

---

## 📝 Checklist de Implementação

- [ ] Executar `criar_tabelas_catalogo_grupos.sql` no Supabase
- [ ] Executar `popular_catalogo_grupos.sql` no Supabase
- [ ] Verificar dados nos Supabase Tables
- [ ] `flutter clean && flutter pub get`
- [ ] `flutter run` e testar dropdowns
- [ ] Testar criação/edição de membros em grupos
- [ ] Testar relatórios
- [ ] Commit das mudanças

---

**Status:** ✅ Código atualizado e pronto para usar  
**Próximo passo:** Executar scripts SQL no Supabase
