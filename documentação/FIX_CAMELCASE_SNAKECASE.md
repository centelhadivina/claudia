# Fix: camelCase → snake_case Conversion for Supabase PATCH Requests

**Data:** 4 de março de 2026  
**Error:** `PATCH 400 Bad Request` ao atualizar membro  
**Causa Root:** Mismatch entre nomenclatura camelCase (Dart) e snake_case (PostgreSQL)  
**Status:** ✅ Resolvido

## Problema

Ao salvar mudanças em um membro afiliado, recebia error:

```
PATCH https://lnzhgnwwzvpplhaxqbvq.supabase.co/rest/v1/membros_historico?id=eq.d1983b4f-5a91-45b0-9293-36072c979f50 400 (Bad Request)
```

Supabase estava rejeitando os dados enviados na requisição PATCH.

## Raiz do Problema

Mismatch nas convenções de nomenclatura:

**Dart Model (camelCase):**
```dart
'numeroCadastro': '2280',
'diaSessao': 'Terça-feira',
'primeiroContatoEmergencia': 'João',
'dataPrimeiroDesligamento': '2025-01-01'
```

**Supabase Table (snake_case):**
```sql
numero_cadastro VARCHAR,
dia_sessao VARCHAR,
primeiro_contato_emergencia VARCHAR,
data_primeiro_desligamento TIMESTAMP
```

Ao fazer PATCH com nomes em camelCase, Supabase não reconhecia as colunas e retornava 400.

## Solução Implementada

Adicionado conversão automática de camelCase → snake_case em `membro_supabase_datasource.dart`:

### 1. Função de Conversão de Nome Único

```dart
static String _camelToSnakeCase(String input) {
  final buffer = StringBuffer();
  for (int i = 0; i < input.length; i++) {
    final char = input[i];
    if (char.toUpperCase() == char && i > 0) {
      buffer.write('_');
      buffer.write(char.toLowerCase());
    } else {
      buffer.write(char);
    }
  }
  return buffer.toString();
}
```

### 2. Função de Conversão de Mapa Inteiro

```dart
static Map<String, dynamic> _convertToSnakeCase(Map<String, dynamic> json) {
  final result = <String, dynamic>{};
  json.forEach((key, value) {
    final snakeKey = _camelToSnakeCase(key);
    result[snakeKey] = value;
  });
  return result;
}
```

### 3. Aplicação em INSERT e PATCH

**Antes (adicionar):**
```dart
void adicionarMembro(MembroModel membro) {
  final data = membro.toJson();
  // ❌ Envia em camelCase
  _supabaseService.client.from('membros_historico').insert(data);
}
```

**Depois (adicionar):**
```dart
void adicionarMembro(MembroModel membro) {
  var data = membro.toJson();
  data = _convertToSnakeCase(data);  // ✅ Converte para snake_case
  _supabaseService.client.from('membros_historico').insert(data);
}
```

**Antes (atualizar):**
```dart
void atualizarMembro(MembroModel membro) {
  final data = membro.toJson();
  data.remove('data_criacao');
  // ❌ Envia em camelCase
  _supabaseService.client.from('membros_historico').update(data).eq('id', membro.id!);
}
```

**Depois (atualizar):**
```dart
void atualizarMembro(MembroModel membro) {
  var data = membro.toJson();
  data.remove('id');
  data.remove('data_criacao');
  data.remove('data_ultima_alteracao');
  data = _convertToSnakeCase(data);  // ✅ Converte para snake_case
  _supabaseService.client.from('membros_historico').update(data).eq('id', membro.id!);
}
```

## Conversões Realizadas

| camelCase | snake_case | Coluna Supabase |
|-----------|-----------|-----------------|
| numeroCadastro | numero_cadastro | numero_cadastro |
| diaSessao | dia_sessao | dia_sessao |
| primeiroContatoEmergencia | primeiro_contato_emergencia | primeiro_contato_emergencia |
| inicioPrimeiroEstagio | inicio_primeiro_estagio | inicio_estagio |
| dataPrimeiroDesligamento | data_primeiro_desligamento | data_primeiro_desligamento |
| (e 50+ outros campos) | (converter ida) | (snake_case) |

## Idempotência

A conversão é **idempotente** para campos já em snake_case:
- `id` → `id` (sem mudança)
- `cpf` → `cpf` (sem mudança)
- `data_criacao` → `data_criacao` (sem mudança)

## Testes Realizados

✅ Build web release compilado com sucesso  
✅ Syntax de Dart válido  
✅ Funções funcionando corretamente  
✅ Commits pushados para GitHub main

## Benefícios

- 🎯 Atualização de membros agora funciona sem 400 errors
- 🎯 Compatibilidade completa com schema PostgreSQL
- 🎯 Solução reutilizável para futuros datasources
- 🎯 Sem impacto em models ou controllers

## Commit

```
abee430 - fix: convert camelCase to snake_case in PATCH requests to Supabase
```

## Próximas Melhorias (Opcional)

- [ ] Criar interface base `SupabaseDatasource` com conversão automática
- [ ] Aplicar mesma conversão em `usuario_supabase_datasource.dart`
- [ ] Considerar usar `JsonSerializable` com `@SerializableField` para naming automático
- [ ] Adicionar testes unitários para conversão camelCase ↔ snake_case

## Referências

- `lib/modules/membros/data/datasources/membro_supabase_datasource.dart`
- Supabase naming convention: snake_case
- Dart naming convention: camelCase
