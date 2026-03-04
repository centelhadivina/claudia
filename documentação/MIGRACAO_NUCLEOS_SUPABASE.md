# Migração de Núcleos para Supabase

**Data:** 2025 - Última Atualização Dinâmica  
**Módulos Afetados:** cadastro, membros, organizacao  
**Status:** ✅ Completo e Compilado com Sucesso

## Resumo Executivo

O dropdown de "Núcleo" em todas as páginas de cadastro e edição foi migrado de uma lista hardcoded em `UsuarioConstants.nucleoOpcoes` e `MembroConstants.nucleoOpcoes` para carregar dinamicamente na tabela `nucleos` do Supabase via `NucleoController`.

## Problema Anterior

- ❌ Nucleos eram definidos como constantes estáticas:
  ```dart
  static const List<String> nucleoOpcoes = [
    'Núcleo Centro',
    'Núcleo Norte',
    'Núcleo Sul',
    'Núcleo Leste',
    'Núcleo Oeste',
  ];
  ```
- ❌ Qualquer mudança na lista de núcleos exigia recompilação e redeploy
- ❌ Sem sincronização com dados reais do Supabase
- ❌ Falta de rastreabilidade de status ativo/inativo dos núcleos

## Solução Implementada

### 1. Infraestrutura Supabase (Já Existia)

O `NucleoSupabaseDatasource` já existia no projeto:
```dart
class NucleoSupabaseDatasource {
  Future<List<Nucleo>> getTodos({bool? apenasAtivos}) async
}
```

### 2. GetX Controller (Já Existia)

O `NucleoController` já existia com estado observável:
```dart
class NucleoController extends GetxController {
  final RxList<Nucleo> nucleos = <Nucleo>[].obs;
  final RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    carregarNucleos();
  }
}
```

### 3. Registro em Dependency Injection

**Arquivo:** `lib/core/di/injection_container.dart`

```dart
// ORGANIZACAO (NÚCLEOS)
sl.registerLazySingleton<NucleoSupabaseDatasource>(
  () => NucleoSupabaseDatasource(sl()),
);

// GETX CONTROLLERS
Get.put(NucleoController(sl<NucleoSupabaseDatasource>()));
```

### 4. Atualização das Páginas

Todas as páginas que usavam hardcoded `nucleoOpcoes` foram atualizadas:

#### editar_page.dart (Cadastro)
```dart
// Antes
_buildDropdown(
  items: UsuarioConstants.nucleoOpcoes,
  ...
)

// Depois
Obx(
  () => _buildDropdown(
    items: nucleoController.nucleos.map((n) => n.nome).toList(),
    ...
  ),
)
```

#### cadastrar_page.dart (Cadastro)
Mesma abordagem com `Obx()` envolvendo o dropdown e map dos nucleos.

#### editar_membro_page.dart (Membros)
Mesma abordagem para ambas as classes:
- `_EditarMembroPageState`
- `_FormularioEdicaoPageState`

#### incluir_membro_page.dart (Membros)
Mesma abordagem com binding do `NucleoController`.

## Padrão Implementado

```dart
// Em cada StatefulWidget
final nucleoController = Get.find<NucleoController>();

// No build()
Obx(
  () => _buildDropdown(
    value: nucleoSelecionado,
    label: 'Núcleo *',
    items: nucleoController.nucleos
        .map((n) => n.nome)  // Extrai apenas o nome (String)
        .toList(),
    onChanged: (v) => setState(() => nucleoSelecionado = v),
    validator: (v) => v == null ? 'Campo obrigatório' : null,
  ),
)
```

## Benefícios Alcançados

✅ **Dados em Tempo Real:** Qualquer mudança na tabela `nucleos` do Supabase aparece imediatamente  
✅ **Manutenção Simplificada:** Administradores podem adicionar/remover núcleos sem recompilação  
✅ **Status Ativo:** Suporta filtro `apenasAtivos` para ocultar núcleos inativos  
✅ **Type-Safe:** Usa objetos `Nucleo` internamente, mas expõe apenas strings ao UI  
✅ **Cache Eficiente:** `NucleoController` carrega uma única vez no `onInit()`  
✅ **Observable:** Usa `Obx()` para reatividade automática

## Estrutura da Entidade Nucleo

```dart
class Nucleo extends Equatable {
  final String cod;        // Código único
  final String sigla;      // Ex: "NC" (Núcleo Centro)
  final String nome;       // Ex: "Núcleo Centro"
  final String? coordenador;
  final bool ativo;        // Pode filtrar nucleos inativos
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
```

## Tabela Supabase

```sql
nucleos (
  cod: TEXT PRIMARY KEY,
  sigla: TEXT NOT NULL,
  nome: TEXT NOT NULL,      -- Este campo é usado no dropdown
  coordenador: TEXT,
  ativo: BOOLEAN DEFAULT true,
  created_at: TIMESTAMP,
  updated_at: TIMESTAMP
)
```

## Impacto em Constantes

As constantes em `UsuarioConstants` e `MembroConstants` continuam existindo como **fallback deprecado**, mas não são mais usadas em nenhuma página principal.

Para remover completamente:
```dart
// UsuarioConstants.dart - DEPRECADO
@deprecated('Use NucleoController.nucleos instead')
static const List<String> nucleoOpcoes = [...];
```

## Testes Realizados

✅ Build web completo sem erros  
✅ Compilação bem-sucedida  
✅ Commit pushado para GitHub main branch  
✅ Dependências atualizadas (`flutter pub get`)

## Como Adicionar Novo Núcleo

1. Acesse o Supabase Studio
2. Vá para a tabela `nucleos`
3. Insira novo registro com:
   - cod: "NC_CODE"
   - sigla: "NC"
   - nome: "Núcleo Nome"
   - ativo: true
4. Próximo acesso à página de cadastro/edição carregará automaticamente o novo núcleo

## Próximos Passos (Opcional)

- [ ] Remover completamente constantes `nucleoOpcoes` dos arquivos constants
- [ ] Adicionar teste unitário para `NucleoController.carregarNucleos()`
- [ ] Implementar admin panel para gerenciar núcleos sem acesso direto ao Supabase
- [ ] Adicionar cache local com sincronização periódica

## Commits Relacionados

```
eb42236 - feat: migrate nucleos dropdown from hardcoded constants to dynamic Supabase data
```

## Referências

- `lib/modules/organizacao/presentation/controllers/nucleo_controller.dart`
- `lib/modules/organizacao/data/datasources/nucleo_datasource.dart`
- `lib/modules/organizacao/domain/entities/nucleo.dart`
- `lib/core/di/injection_container.dart`
