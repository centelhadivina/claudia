# Como Importar os 2.254 Cadastros do Sistema Antigo

## 🔍 Situação Atual

- ✅ **Membros no Supabase**: 428 registros (tabela `membros_historico`)
- ⚠️ **Cadastros no Supabase**: verificar quantos existem na tabela `cadastro`
- 📁 **Arquivo local**: 2.254 cadastros em `assets/CAD_PESSOAS.json`
- 🔧 **Tabela correta**: `cadastro` (não `usuarios`)

## 🎯 Solução: Importar via Interface do Sistema

O sistema já possui uma página pronta para importar os dados do arquivo JSON!

### Passo a Passo:

1. **Acesse o sistema** (certifique-se de estar logado)

2. **Navegue para a página de importação**:

   - Menu → Cadastro → **Importar Pessoas do Sistema Antigo**
   - Ou acesse diretamente pela rota: `/importar-pessoas-antigas`

3. **Execute a importação**:

   - Clique no botão **"Iniciar Importação"**
   - O sistema irá processar os 2.254 registros em lotes de 50
   - Aguarde a conclusão (pode levar alguns minutos)

4. **Verifique o resultado**:
   - O sistema mostrará:
     - Total de registros processados
     - Quantidade importada com sucesso
     - Quantidade de duplicados (ignorados)
     - Erros (se houver)

### Funcionalidades da Importação:

- ✅ **Processamento em lotes**: Para não sobrecarregar o Supabase
- ✅ **Prevenção de duplicatas**: Verifica CPF antes de inserir
- ✅ **Mapeamento automático**: Converte campos do JSON antigo para o novo schema
- ✅ **Tratamento de erros**: Registra e exibe erros sem parar a importação
- ✅ **Progress feedback**: Mostra progresso em tempo real

## 🔧 Campos que serão importados:

```
JSON Antigo              → Tabela Supabase
─────────────────────────────────────────────
CADASTRO                 → numero_cadastro
NOME                     → nome
CPF                      → cpf
NASCIMENTO               → data_nascimento
TELEFONE                 → telefone_fixo
CELULAR                  → telefone_celular
EMAIL                    → email
RUA/AV + NUMERO          → endereco
BAIRRO                   → bairro
CIDADE                   → cidade
ESTADO                   → estado
CEP                      → cep
NUCLEO                   → nucleo_cadastro
DATA DO CADASTRO         → data_cadastro
(e muitos outros...)
```

## ⚠️ Importante

### Antes de importar:

1. **Backup**: Faça backup dos dados atuais do Supabase (se houver dados importantes)
2. **RLS**: Certifique-se de que o RLS está desabilitado ou com políticas corretas (veja [SUPABASE_SETUP.md](../SUPABASE_SETUP.md))

### Após a importação:

1. **Reinicie o app** (Hot Restart)
2. **Verifique os logs**: Deve mostrar `✅ [CADASTRO] 2254 usuários carregados do Supabase`
3. **Teste a busca**: Tente pesquisar por um nome no módulo de cadastro

## 🐛 Solução de Problemas

### "Erro ao carregar arquivo"

- Verifique se o arquivo está em `assets/CAD_PESSOAS.json`
- Confirme que está declarado no `pubspec.yaml`:
  ```yaml
  flutter:
    assets:
      - assets/CAD_PESSOAS.json
  ```

### "Erro ao inserir no Supabase"

- Verifique as políticas RLS (veja documentação acima)
- Confirme que está autenticado no sistema
- Verifique se a tabela `cadastro` existe no Supabase

### "Muitos duplicados"

- Normal se executar a importação múltiplas vezes
- O sistema ignora automaticamente CPFs já cadastrados

## 📊 Verificação Manual no Supabase

Após a importação, você pode verificar diretamente no Supabase:

```sql
-- Contar cadastros importados
SELECT COUNT(*) FROM cadastro;

-- Ver os 10 primeiros
SELECT numero_cadastro, nome, cpf, data_cadastro
FROM cadastro
ORDER BY numero_cadastro
LIMIT 10;

-- Verificar origem dos dados
SELECT nucleo_cadastro, COUNT(*) as total
FROM cadastro
GROUP BY nucleo_cadastro;
```

## 🚀 Resultado Esperado

Após a importação bem-sucedida:

```
🔍 [CADASTRO] Carregando usuários do Supabase...
🔍 [DATASOURCE] Buscando usuários da tabela "cadastro"...
📊 [DATASOURCE] Response length: 2254
✅ [DATASOURCE] 2254 usuários convertidos com sucesso
✅ [CADASTRO] 2254 usuários carregados do Supabase
```

---

**Tempo estimado**: 3-5 minutos para importação completa  
**Arquivo fonte**: `assets/CAD_PESSOAS.json`  
**Página de importação**: [ImportarPessoasAntigasPage](../lib/modules/cadastro/presentation/pages/importar_pessoas_antigas_page.dart)
