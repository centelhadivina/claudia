# 📋 Instruções: Popular Tabela de Grupos no Supabase

## ⚠️ Problema Encontrado
A tabela `grupos` existe no Supabase, mas não estava populada com os **novos valores corretos** de:
- Atividades Espirituais (5 opções)
- Grupos de Trabalho Espiritual (8 opções)
- Grupos de Ação Social (12 opções)

## ✅ Solução

### 1. Atualizar Constantes (FEITO ✓)
Os arquivos de constantes Dart foram atualizados:
- [lib/core/constants/grupo_acao_social_constants.dart](../../lib/core/constants/grupo_acao_social_constants.dart)
- [lib/core/constants/grupo_trabalho_espiritual_constants.dart](../../lib/core/constants/grupo_trabalho_espiritual_constants.dart)

### 2. Executar Script no Supabase (FAÇA AGORA)

#### Passo 1: Abrir SQL Editor
1. Acesse https://app.supabase.com
2. Selecione seu projeto `centelha_db`
3. Vá em **SQL Editor** (lateral esquerda)
4. Clique em **"New query"**

#### Passo 2: Copiar Script
Abra o arquivo [scripts/popular_grupos_atualizados.sql](./popular_grupos_atualizados.sql) e copie TODO o conteúdo.

#### Passo 3: Executar
1. Cole o script no SQL Editor
2. Clique em **"Run"** (ou CTRL+Enter)
3. Aguarde a conclusão

#### Passo 4: Verificar
O script executará automaticamente 2 SELECT que mostram:
- Quantidade de grupos por tipo
- Lista completa de todos os grupos inseridos

## 📊 Dados que Serão Inseridos

### Atividades Espirituais (5)
```
✓ Encontro dos Amigos de Ramatis
✓ Corrente de Oração e Renovação (COR)
✓ Sessões de Antigoécia
✓ Monitoria Infantil
✓ Sem atividade espiritual
```

### Grupos de Trabalho Espiritual (8)
```
✓ Grupo Paz
✓ Grupo Luz
✓ Grupo Amor
✓ Grupo Fé
✓ Grupo Força
✓ Grupo Esperança
✓ Grupo União
✓ Sem grupo de trabalho espiritual
```

### Grupos de Ação Social (12)
```
✓ Captação de recursos
✓ Projeto Arte Criativa
✓ Projeto Aquecendo Corações
✓ Projeto Banco de Ajuda
✓ Projeto Encaminhamento Profissional
✓ Projeto Farmácia Solidária
✓ Projeto Gestar, Amar e Cuidar
✓ Projeto Pão Nosso
✓ Projeto Simiromba
✓ Projeto Terapias
✓ Projeto Vestibular sem Barreiras
✓ Sem grupo de ação social
```

## 🔄 Alterações de Função
As funções foram atualizadas:
- ❌ "Participante" → **✅ "Membro"** (mas apenas nas constantes)

Se houver registros antigos com "Participante", você pode atualizar com:
```sql
UPDATE usuarios_grupos_acao_social SET funcao = 'Membro' WHERE funcao = 'Participante';
UPDATE usuarios_grupos_trabalho_espiritual SET funcao = 'Membro' WHERE funcao = 'Participante';
```

## ⚙️ Código Dart Atualizado
Os dropdowns na app agora usarão:

```dart
// Grupos de Ação Social
GrupoAcaoSocialConstants.gruposOpcoes  // 12 projetos
GrupoAcaoSocialConstants.funcoesOpcoes // ["Líder", "Membro"]

// Trabalho Espiritual
GrupoTrabalhoEspiritualConstants.atividadesOpcoes      // 5 atividades
GrupoTrabalhoEspiritualConstants.gruposTrabalhoOpcoes  // 8 grupos
GrupoTrabalhoEspiritualConstants.funcoesOpcoes         // ["Líder", "Membro"]
```

## ✨ Próximos Passos
1. Execute o script no Supabase
2. Testar a app vendo se os dropdowns mostram os valores corretos
3. Verificar se alguns dados já existem na tabela com valores diferentes
4. Se necessário, atualizar referências em `usuarios_grupos_*` tables

## 📞 Dúvidas
Se encontrar erro no script, verifique:
- Se a tabela `grupos` existe no Supabase
- Se tem permissão de escrita na tabela
- Se há constraint que impede DELETE (tente desabilitar RLS temporariamente se tiver)
