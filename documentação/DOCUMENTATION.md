# Centelha Claudia - Módulo de Cadastro

## 📋 Sobre o Projeto

Aplicação Flutter Web modular com arquitetura limpa (Clean Architecture), preparada para expansão com múltiplos microserviços.

## 🏗️ Arquitetura

O projeto segue os princípios da **Clean Architecture** com a seguinte estrutura:

```
lib/
├── core/                           # Núcleo compartilhado
│   ├── di/                        # Dependency Injection
│   │   └── injection_container.dart
│   ├── error/                     # Gestão de erros
<<<<<<< Updated upstream
│   │   └── failures.dart
│   └── utils/                     # Utilitários
│       └── either.dart
│
└── modules/                       # Módulos da aplicação
    └── cadastro/                  # Módulo de Cadastro
        ├── data/                  # Camada de Dados
        │   ├── datasources/       # Fontes de dados
        │   │   └── usuario_datasource.dart (mockado)
        │   ├── models/            # Models de dados
        │   │   └── usuario_model.dart
        │   └── repositories/      # Implementação dos repositórios
        │       └── usuario_repository_impl.dart
        │
        ├── domain/                # Camada de Domínio
        │   ├── entities/          # Entidades de negócio
        │   │   └── usuario.dart
        │   └── repositories/      # Interfaces dos repositórios
        │       └── usuario_repository.dart
        │
        └── presentation/          # Camada de Apresentação
            ├── bloc/              # Gerenciamento de estado
            │   ├── usuario_bloc.dart
            │   ├── usuario_event.dart
            │   └── usuario_state.dart
            └── pages/             # Telas da aplicação
                ├── usuario_list_page.dart
                └── usuario_form_page.dart
```

## 🎯 Camadas da Arquitetura

### 1. **Domain (Domínio)**

- Contém as regras de negócio puras
- Independente de frameworks e tecnologias
- Define as entidades e interfaces dos repositórios

### 2. **Data (Dados)**

- Implementa os repositórios definidos no domínio
- Gerencia as fontes de dados (datasources)
- Converte models para entidades

### 3. **Presentation (Apresentação)**

- Gerencia a UI e interações do usuário
- Usa BLoC para gerenciamento de estado
- Reage aos estados emitidos pelo BLoC

## 🔧 Tecnologias Utilizadas

- **Flutter** - Framework principal
- **flutter_bloc** - Gerenciamento de estado
- **get_it** - Injeção de dependências
- **equatable** - Comparação de objetos
- **dio** - HTTP client (preparado para futura integração com API)
- **uuid** - Geração de IDs únicos

## 📦 Módulo de Cadastro

### Funcionalidades Implementadas

✅ Listagem de usuários
✅ Cadastro de novos usuários
✅ Edição de usuários existentes
✅ Exclusão de usuários
✅ Validação de formulários
✅ Feedback visual (loading, erros, sucesso)

### Campos do Usuário

- **Nome** (obrigatório)
- **Email** (obrigatório)
- **Telefone** (opcional)
- **CPF** (opcional)
- **Status Ativo** (toggle)
- **Data de Cadastro** (automático)

## 🚀 Como Executar

### Pré-requisitos

- Flutter SDK 3.9.2 ou superior
- Navegador web (Chrome recomendado)

### Instalação

```bash
# Clonar o repositório (se aplicável)
git clone [url-do-repositorio]

# Navegar para o diretório
cd centelha_claudia

# Instalar dependências
flutter pub get

# Executar em modo web
flutter run -d chrome
```

## 🔄 Preparação para API Real

Atualmente, o datasource está **mockado** com dados em memória. Para conectar com uma API real:

### 1. Criar novo datasource remoto

```dart
// lib/modules/cadastro/data/datasources/usuario_datasource_remote.dart

class UsuarioDatasourceRemote implements UsuarioDatasource {
  final Dio dio;

  UsuarioDatasourceRemote({required this.dio});

  @override
  Future<List<UsuarioModel>> getUsuarios() async {
    final response = await dio.get('/api/usuarios');
    return (response.data as List)
        .map((json) => UsuarioModel.fromJson(json))
        .toList();
  }

  // Implementar outros métodos...
}
```

### 2. Atualizar injection_container.dart

```dart
// Trocar de:
sl.registerLazySingleton<UsuarioDatasource>(
  () => UsuarioDatasourceMock(),
);

// Para:
sl.registerLazySingleton<UsuarioDatasource>(
  () => UsuarioDatasourceRemote(dio: sl()),
);
```

### 3. Configurar Dio

```dart
sl.registerLazySingleton(() => Dio(
  BaseOptions(
    baseUrl: 'https://sua-api.com',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ),
));
```

## 🎨 Personalização

### Temas

Edite o tema em `main.dart`:

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple, // Alterar cor principal
    brightness: Brightness.light,
  ),
  useMaterial3: true,
),
```

## 📋 Próximos Passos

### Novos Módulos (Microserviços)

Para adicionar novos módulos, replique a estrutura:

```
lib/modules/
├── cadastro/           # ✅ Implementado
├── vendas/             # 🔜 Próximo módulo
├── estoque/            # 🔜 Próximo módulo
└── relatorios/         # 🔜 Próximo módulo
```

### Melhorias Sugeridas

- [ ] Adicionar testes unitários
- [ ] Adicionar testes de widget
- [ ] Implementar paginação na listagem
- [ ] Adicionar filtros e busca
- [ ] Implementar autenticação
- [ ] Adicionar validação de CPF
- [ ] Implementar máscara nos campos (telefone, CPF)
- [ ] Adicionar logs e analytics
- [ ] Implementar cache local
- [ ] Adicionar internacionalização (i18n)

## 📝 Convenções de Código

- Use nomes descritivos em português para entidades de negócio
- Mantenha classes pequenas e com responsabilidade única
- Sempre valide inputs do usuário
- Trate erros adequadamente em todas as camadas
- Comente código complexo quando necessário

## 🤝 Contribuindo

1. Crie uma branch para sua feature (`git checkout -b feature/NovaFuncionalidade`)
2. Commit suas mudanças (`git commit -m 'Add: Nova funcionalidade'`)
3. Push para a branch (`git push origin feature/NovaFuncionalidade`)
4. Abra um Pull Request

## 📄 Licença

Este projeto é privado e confidencial.

---

**Desenvolvido com ❤️ usando Flutter**
=======
# Documentação Consolidada do Projeto

## Escopo

Este documento centraliza a visão técnica e operacional do Centelha Claudia, substituindo descrições antigas focadas apenas no módulo de cadastro.

## Contexto do sistema

Aplicação Flutter modular para gestão interna, com backend em Supabase e organização por domínios de negócio.

Domínios atualmente presentes:

- auth
- cadastro
- consultas
- cursos
- grupos_acoes_sociais
- grupos_tarefas
- grupos_trabalhos_espirituais
- home
- membros
- organizacao
- sacramentos
- usuarios_sistema

## Arquitetura resumida

Padrão predominante:

- presentation: interface, fluxo de estado e navegação
- domain: regras, contratos e entidades
- data: fontes de dados, mapeamento e integração

Regras gerais:

- domínio não depende de detalhes de infraestrutura
- data implementa contratos de domínio
- UI não deve acessar infraestrutura diretamente

## Setup essencial

1. Instalar dependências:

```bash
flutter pub get
```

2. Configurar Supabase:

- Ajustar credenciais em lib/core/constants/supabase_constants.dart
- Seguir SUPABASE_SETUP.md

3. Executar aplicação:

```bash
flutter run -d chrome
```

## Guias ativos por tema

Arquitetura e expansão:

- ARCHITECTURE.md
- EXPANSION_GUIDE.md
- ARQUITETURA_DADOS_AVALIACOES.md

Supabase e dados:

- SUPABASE_SETUP.md
- GUIA_CRIAR_TABELAS_SUPABASE.md
- GUIA_USO_DATASOURCES.md

Fluxos funcionais:

- SISTEMA_AUTENTICACAO.md
- SISTEMA_IMPORTACAO_PRESENCAS.md
- GUIA_USO_INTERFACES.md
- INTERFACES_LANCAMENTO_NOTAS.md
- GUIA_INTEGRACAO_MENU.md

Importações e manutenção:

- IMPORTAR_CADASTROS_DO_JSON.md
- IMPORTAR_MEMBROS_ANTIGOS.md
- IMPORTAR_CURSOS.md
- GUIA_RAPIDO_IMPORTACAO_PRESENCAS.md
- LIMPAR_E_REIMPORTAR.md

Implantações e referências:

- DEPLOY_GITHUB_PAGES.md
- CAMPOS_USUARIO.md
- RELATORIO_BUGS_MELHORIAS.md

## Decisões de documentação aplicadas

- Removidas duplicatas textuais e arquivos copy.
- Removidas versões duplicadas de setup/arquitetura dentro de documentação.
- Removidos documentos de status concluído e progresso temporal já encerrado.
- Mantidos guias operacionais que ainda agregam execução e manutenção.

## Critérios para novos documentos

Criar novo arquivo somente quando houver:

- novo subsistema com operação independente
- necessidade de runbook recorrente
- decisão arquitetural que não cabe em ARCHITECTURE.md

Caso contrário, atualizar os guias já existentes para evitar fragmentação.

## Melhorias prioritárias

1. Estabelecer padrão mínimo de testes por módulo crítico.
2. Definir política de versionamento para scripts SQL e migrações.
3. Padronizar observabilidade de erros e eventos de negócio.
4. Fechar lacunas de camadas em módulos ainda incompletos.
5. Manter governança documental trimestral para evitar nova obsolescência.
  Future<List<UsuarioModel>> getUsuarios() async {
>>>>>>> Stashed changes
