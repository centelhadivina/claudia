# Interfaces de Lançamento de Notas Manuais

Este documento descreve as 4 páginas criadas para permitir o lançamento manual das notas C, D, F, G, H, I e J do sistema de pontuação.

## 📋 Visão Geral

O sistema de pontuação possui 12 notas (A-L). Algumas são calculadas automaticamente (A, B, E, K, L), mas outras dependem de avaliação humana e precisam ser lançadas manualmente:

- **Notas C e D**: Conceitos dados por líderes de grupo
- **Notas F e G**: Presença em escalas (cambonagem e arrumação)
- **Nota H**: Status de mensalidade
- **Notas I e J**: Conceitos especiais (Pais/Mães e Tata)

## 1️⃣ Lançar Conceitos de Grupo (Notas C e D)

**Arquivo:** `lancar_conceitos_page.dart`

### Funcionalidade

Permite que líderes de Grupo-Tarefa e Ação Social avaliem os membros do seu grupo.

### Recursos

- ✅ Filtros: Mês, Ano e Tipo de Conceito (Grupo-Tarefa ou Ação Social)
- ✅ Lista de membros com slider de 0 a 10
- ✅ Salvamento individual ou em lote
- ✅ Upsert automático (atualiza se já existe, insere se não existe)

### Tabelas Relacionadas

- `conceitos_grupo_tarefa` (Nota C)
- `conceitos_acao_social` (Nota D)

### Como Usar

1. Selecione o mês e ano
2. Escolha o tipo de conceito (Grupo-Tarefa ou Ação Social)
3. Para cada membro, ajuste o slider para a nota desejada (0-10)
4. Clique em "Salvar Conceitos"

### Interface

```
┌──────────────────────────────────────┐
│ Lançar Conceitos                     │
├──────────────────────────────────────┤
│ Mês: [Janeiro ▼]  Ano: [2026 ▼]    │
│ Tipo: [Grupo-Tarefa ▼]              │
├──────────────────────────────────────┤
│ 👤 João Silva                        │
│ ────●─────────────── 7.5             │
│                                      │
│ 👤 Maria Santos                      │
│ ──────────●───────── 9.0             │
├──────────────────────────────────────┤
│         [💾 Salvar Conceitos]        │
└──────────────────────────────────────┘
```

---

## 2️⃣ Gerenciar Escalas (Notas F e G)

**Arquivo:** `gerenciar_escalas_page.dart`

### Funcionalidade

Permite cadastrar escalas de cambonagem e arrumação/desarrumação, e registrar presença.

### Recursos

- ✅ Duas abas: Cambonagem e Arrumação
- ✅ Filtros: Mês e Ano
- ✅ Cadastro de nova escala (data + membro)
- ✅ Registro de comparecimento: Presente ✅, Ausente ❌, Trocou 🔄
- ✅ Exclusão de escala
- ✅ Indicação visual do status de cada escala

### Tabelas Relacionadas

- `escalas_cambonagem` (Nota F)
- `escalas_arrumacao` (Nota G)

### Como Usar

1. Selecione a aba (Cambonagem ou Arrumação)
2. Selecione mês e ano
3. Clique em "➕ Nova Escala"
4. Preencha: Data, Membro, e (se arrumação) Tipo (arrumação/desarrumação)
5. Após a data da escala, registre o comparecimento usando o menu ⋮

### Interface

```
┌──────────────────────────────────────┐
│ Gerenciar Escalas                    │
│ [Cambonagem] [Arrumação]             │
├──────────────────────────────────────┤
│ Mês: [Janeiro ▼]  Ano: [2026 ▼]    │
├──────────────────────────────────────┤
│ ● João Silva                    ⋮ 🗑️ │
│   15/01/2026 - Quinta-feira          │
│   Status: Presente ✅                │
│                                      │
│ ● Maria Santos                  ⋮ 🗑️ │
│   22/01/2026 - Quinta-feira          │
│   Status: Pendente ⏳                │
├──────────────────────────────────────┤
│         [➕ Nova Escala]              │
└──────────────────────────────────────┘
```

---

## 3️⃣ Gerenciar Mensalidades (Nota H)

**Arquivo:** `gerenciar_mensalidades_page.dart`

### Funcionalidade

Permite à tesouraria registrar o status de pagamento de mensalidade de cada membro.

### Recursos

- ✅ Filtros: Mês, Ano e Núcleo
- ✅ Estatísticas: Em dia, Pendente, Sem registro
- ✅ Registro de status: Em dia ✅ ou Pendente ❌
- ✅ Data de pagamento (quando em dia)
- ✅ Campo de observação
- ✅ Indicadores visuais coloridos

### Tabela Relacionada

- `status_mensalidade` (Nota H)

### Como Usar

1. Selecione mês, ano e opcionalmente o núcleo
2. Veja as estatísticas no topo
3. Para cada membro, clique no menu ⋮ → Editar Status
4. Marque como "Em dia" ou "Pendente"
5. Se em dia, informe a data de pagamento
6. Adicione observação se necessário
7. Clique em "Salvar"

### Interface

```
┌──────────────────────────────────────┐
│ Gerenciar Mensalidades               │
├──────────────────────────────────────┤
│ Mês: [Jan ▼]  Ano: [2026 ▼]        │
│ Núcleo: [Todos ▼]                   │
├──────────────────────────────────────┤
│  ✅ Em dia    ❌ Pendente  ❓ S/ reg │
│     15           8            2      │
├──────────────────────────────────────┤
│ ✅ João Silva                   ⋮    │
│    Núcleo: CCU                       │
│    Pago em: 05/01/2026               │
│                                      │
│ ❌ Maria Santos                  ⋮    │
│    Núcleo: CCM                       │
│    Obs: Acordo de parcelamento       │
├──────────────────────────────────────┤
│      [💾 Salvar Alterações]          │
└──────────────────────────────────────┘
```

---

## 4️⃣ Lançar Conceitos Especiais (Notas I e J)

**Arquivo:** `lancar_conceitos_especiais_page.dart`

### Funcionalidade

Permite Pais/Mães de Terreiro (Nota I) e Tata (Nota J) darem conceitos especiais aos membros.

### Recursos

- ✅ Duas abas: Nota I (Pais/Mães) e Nota J (Tata)
- ✅ Filtros: Mês, Ano e Núcleo
- ✅ Slider de 0 a 10 (com incrementos de 0.5)
- ✅ Campo de observações/justificativas
- ✅ Indicador de cor baseado na nota
- ✅ Data da última atualização
- ✅ Salvamento em lote

### Tabelas Relacionadas

- `conceitos_pais_maes` (Nota I)
- `bonus_tata` (Nota J)

### Como Usar

1. Selecione a aba (Nota I ou Nota J)
2. Filtre por mês, ano e opcionalmente núcleo
3. Para cada membro:
   - Ajuste o slider para a nota desejada (0-10)
   - Adicione observações explicando a nota
4. Clique em "💾 Salvar Conceitos"

### Cores das Notas

- 🟢 Verde: 9.0 - 10.0 (Excelente)
- 🟡 Verde-claro: 7.0 - 8.9 (Muito bom)
- 🟠 Laranja: 5.0 - 6.9 (Bom)
- 🔴 Vermelho-claro: 3.0 - 4.9 (Regular)
- ⚫ Vermelho: 0.0 - 2.9 (Precisa melhorar)

### Interface

```
┌──────────────────────────────────────┐
│ Conceitos Especiais                  │
│ [Nota I - Pais/Mães] [Nota J - Tata] │
├──────────────────────────────────────┤
│ Mês: [Jan ▼]  Ano: [2026 ▼]        │
│ Núcleo: [Todos ▼]                   │
├──────────────────────────────────────┤
│ ┌────────────────────────────────┐  │
│ │ 👤 João Silva - CCU            │  │
│ │                                 │  │
│ │ Conceito Pai/Mãe:         [8.5] │  │
│ │ ●────────────────●──────────    │  │
│ │                                 │  │
│ │ Observações:                    │  │
│ │ [Participativo, comprometido]   │  │
│ │                                 │  │
│ │ Última atualização:             │  │
│ │ 10/01/2026 14:30                │  │
│ └────────────────────────────────┘  │
├──────────────────────────────────────┤
│       [💾 Salvar Conceitos]          │
└──────────────────────────────────────┘
```

---

## 🗃️ Estrutura das Tabelas

Todas as tabelas seguem um padrão similar:

```sql
CREATE TABLE nome_tabela (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    mes INTEGER NOT NULL,
    ano INTEGER NOT NULL,
    membro_id TEXT NOT NULL,
    membro_nome TEXT NOT NULL,
    nucleo TEXT NOT NULL,
    [campos específicos],
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE (mes, ano, membro_id)
);
```

### Campos Específicos por Tabela

**conceitos_grupo_tarefa / conceitos_acao_social:**

- `nota` DECIMAL(3,1) - Nota de 0.0 a 10.0

**escalas_cambonagem / escalas_arrumacao:**

- `data` DATE - Data da escala
- `compareceu` BOOLEAN - Se compareceu
- `trocou_escala` BOOLEAN - Se trocou de horário
- `trocou_com_id` TEXT - ID de quem trocou
- `trocou_com_nome` TEXT - Nome de quem trocou
- `tipo` TEXT (só arrumação) - "arrumacao" ou "desarrumacao"

**status_mensalidade:**

- `em_dia` BOOLEAN - Se está em dia
- `data_pagamento` DATE - Quando pagou
- `observacao` TEXT - Observações

**conceitos_pais_maes / bonus_tata:**

- `nota` DECIMAL(3,1) - Nota de 0.0 a 10.0
- `observacao` TEXT - Justificativa

---

## 🔐 Row Level Security (RLS)

Todas as tabelas possuem políticas RLS configuradas:

```sql
-- Leitura: Qualquer usuário autenticado
CREATE POLICY "Leitura pública" ON tabela
    FOR SELECT
    USING (auth.role() = 'authenticated');

-- Escrita: Qualquer usuário autenticado
CREATE POLICY "Escrita autenticada" ON tabela
    FOR ALL
    USING (auth.role() = 'authenticated');
```

---

## 🔄 Triggers

Todas as tabelas possuem trigger para atualizar `updated_at`:

```sql
CREATE TRIGGER atualizar_updated_at
    BEFORE UPDATE ON tabela
    FOR EACH ROW
    EXECUTE FUNCTION atualizar_timestamp_updated_at();
```

---

## 📊 Integração com Ranking

Para integrar essas notas com o cálculo do ranking, será necessário:

1. Buscar os dados das 7 tabelas para o mês/ano selecionado
2. Montar os Maps de dados no `DadosCalculoAvaliacao`:
   - `conceitosGrupoTarefa` (Nota C)
   - `conceitosAcaoSocial` (Nota D)
   - `escalasCambonagem` (Nota F)
   - `escalasArrumacao` (Nota G)
   - `statusMensalidades` (Nota H)
   - `conceitosPaisMaes` (Nota I)
   - `bonusTata` (Nota J)
3. Os calculadores já estão prontos para processar esses dados

---

## 🚀 Próximos Passos

1. ✅ Executar o SQL `criar_tabelas_notas_manuais.sql` no Supabase
2. ✅ Interfaces criadas e exportadas no pacote `sistema_ponto`
3. ⏳ Adicionar as páginas ao menu/navegação do app principal
4. ⏳ Integrar busca de membros reais (atualmente usando dados mock)
5. ⏳ Atualizar `RankingMensalPage` para buscar dados das novas tabelas
6. ⏳ Testar todo o fluxo end-to-end

---

## 💡 Observações Importantes

- **Dados Mock**: As interfaces atualmente usam dados de membros mock (João Silva, Maria Santos, Pedro Oliveira). É necessário integrar com os dados reais de cadastro.

- **Permissões**: No futuro, pode-se implementar controle de permissões mais refinado, limitando:

  - Nota C/D: Apenas líderes de grupo
  - Nota H: Apenas tesouraria
  - Nota I: Apenas Pais/Mães de Terreiro
  - Nota J: Apenas Tata

- **Validações**: As interfaces incluem validações básicas, mas podem ser expandidas conforme necessário.

- **Performance**: Para grandes volumes de dados, considere implementar paginação nas listagens.

---

## 📞 Suporte

Para dúvidas ou problemas com as interfaces de lançamento de notas, consulte:

- `ROADMAP_MELHORIAS.md` - Prioridades e evolução técnica
- `GUIA_INTEGRACAO_MENU.md` - Integração das telas ao fluxo principal
- `/scripts/criar_tabelas_notas_manuais.sql` - Schema das tabelas
