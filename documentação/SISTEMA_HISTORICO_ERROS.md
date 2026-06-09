# Sistema de Histórico de Erros - Documentação

## Visão Geral

Este sistema captura e registra todos os erros que ocorrem no aplicativo, armazenando-os em uma tabela no Supabase para análise posterior.

## Componentes

### 1. Tabela no Supabase: `error_logs`

Arquivo SQL: `scripts/criar_tabela_error_logs.sql`

**Colunas:**

- `id` - UUID único (chave primária)
- `erro_tipo` - Tipo de erro (ServerException, TimeoutException, etc)
- `erro_mensagem` - Mensagem de erro completa
- `erro_stack_trace` - Stack trace do erro
- `modulo` - Módulo onde ocorreu (usuarios_sistema, cadastro, etc)
- `funcionalidade` - Funcionalidade específica
- `usuario_id` - UUID do usuário autenticado
- `plataforma` - Plataforma (flutter)
- `versao_app` - Versão do aplicativo
- `dados_adicionais` - JSON com dados extras
- `data_erro` - Timestamp do erro
- `created_at` / `updated_at` - Timestamps de controle

**Índices:**

- data_erro (descendente) - para queries rápidas
- modulo - para filtrar por módulo
- usuario_id - para rastrear erros por usuário
- erro_tipo - para análise de tipos de erro

**Segurança (RLS):**

- Todos autenticados podem inserir logs
- Apenas usuários de sistema (admin) podem ler/deletar logs

### 2. Datasource: `error_log_datasource.dart`

Responsável por salvar e consultar erros no Supabase.

```dart
// Registrar um erro
await errorLogDatasource.registrarErro(
  erroTipo: 'TimeoutException',
  erroMensagem: 'Timeout ao salvar usuário',
  erroStackTrace: stackTrace.toString(),
  modulo: 'usuarios_sistema',
  funcionalidade: 'salvar',
);

// Obter erros recentes
final erros = await errorLogDatasource.obterErrosRecentes(limite: 100);

// Obter erros de um módulo específico
final erros = await errorLogDatasource.obterErrosPorModulo('usuarios_sistema');

// Obter erros das últimas 24h
final erros = await errorLogDatasource.obterErrosRecentes24h();

// Limpar erros antigos
await errorLogDatasource.limparErrosAntigos(7); // Remove erros >7 dias
```

### 3. Serviço: `error_log_service.dart`

Centraliza logging local e integração com Supabase.

**Features:**

- Mantém histórico local em memória
- Salva erros no Supabase automaticamente (assincronamente)
- Previne loops infinitos de erro ao falhar salvamento
- Integrado com FlutterError

```dart
// Usar em qualquer lugar do app
final errorLogService = ErrorLogService.instance;

// Log automático (salva localmente + envia para Supabase)
errorLogService.logError(
  exception,
  stackTrace,
  source: 'UsuarioSistemaController',
  modulo: 'usuarios_sistema',
  funcionalidade: 'salvar',
);

// Consultar erros
final errosRecentes = await errorLogService.obterErrosRecentes24h();
```

### 4. Dashboard: `error_logs_dashboard_page.dart`

Página de administração para visualizar histórico de erros.

**Features:**

- Filtro por periodicidade (últimas 24h / todos)
- Exibição com chips de módulo e tipo
- Modal com detalhes completos (mensagem, stack trace, dados adicionais)
- Botão para limpar erros antigos (>7 dias)
- Atualização manual com refresh

## Setup

### Passo 1: Executar Script SQL

1. Vá para Supabase > SQL Editor
2. Copie o conteúdo de `scripts/criar_tabela_error_logs.sql`
3. Execute o script
4. Verifique se a tabela foi criada com `SELECT * FROM error_logs LIMIT 1;`

### Passo 2: Integração Automática

O sistema já está integrado! Erros serão capturados automaticamente quando:

- Uma exceção é lançada em um catch block
- Uma operação com timeout falha
- Uma operação no banco de dados falha

### Passo 3: Adicionar Dashboard ao Menu

Integre o `ErrorLogsDashboardPage` no seu menu de administração:

```dart
// No seu arquivo de rotas ou menu
GetRoute(
  name: '/admin/error-logs',
  page: () => ErrorLogsDashboardPage(),
),

// Ou como botão no menu
ElevatedButton(
  onPressed: () => Get.to(() => ErrorLogsDashboardPage()),
  child: const Text('Ver Histórico de Erros'),
),
```

## Uso Prático

### Quando o Erro Ocorre

```dart
// Em usuario_sistema_controller.dart - exemplo atual
try {
  await repository.salvar(usuario);
  Get.snackbar('Sucesso', 'Usuário salvo');
} on ServerException catch (e) {
  errorLogService.logError(
    e,
    StackTrace.current,
    source: 'UsuarioSistemaController.salvar',
    modulo: 'usuarios_sistema',
    funcionalidade: 'salvar_usuario',
  );
  Get.snackbar('Erro', e.message);
}
```

### Consultando Erros

```dart
// No dashboard ou página de análise
final controller = Get.put(ErrorLogsDashboardController());

// Automaticamente carrega erros das últimas 24h
// Usuário pode filtrar e ver detalhes em modal
```

## Boas Práticas

1. **Sempre especifique módulo e funcionalidade**

   ```dart
   errorLogService.logError(
     error,
     stackTrace,
     source: 'Exception',
     modulo: 'usuarios_sistema',  // IMPORTANTE
     funcionalidade: 'atualizar',   // IMPORTANTE
   );
   ```

2. **Use dados_adicionais para contexto**

   ```dart
   // No datasource.registrarErro()
   dadosAdicionais: {
     'numero_cadastro': usuario.numeroCadastro,
     'email': usuario.email,
     'operacao': 'criar',
   }
   ```

3. **Limpe dados antigos regularmente**

   ```dart
   // Em um initializer ou app startup
   await errorLogService.limparErrosAntigos(30); // Manter 30 dias
   ```

4. **Monitore padrões de erro**
   - Acesse o dashboard regularmente
   - Procure por módulos com muitos erros
   - Identifique funcionalidades problemáticas

## Troubleshooting

### Erros não aparecem no dashboard

1. Verifique se a tabela `error_logs` existe: `SELECT COUNT(*) FROM error_logs;`
2. Verifique RLS policies: role deve ser `authenticated`
3. Verifique se usuário está autenticado (RLS nega leitura para anônimos)

### Timeout ao salvar logs

- Esperado! O sistema silencia timeouts no log para não criar loop infinito
- Isso é proposital - logs são not-critical e não devem bloquear o app

### Stack trace não aparece

- Verifique se `StackTrace.current` foi passado no `logError()`
- Stack trace é opcional, aplicativo não falha sem ele

## Performance

- **Logs locais**: Mantém ~1000 entradas em memória (descarta antigas)
- **Supabase**: Consultas com índices são rápidas (<100ms)
- **Limpeza**: Execute `limparErrosAntigos()` regularmente (pode ser async)
- **RLS**: Apenas usuários autenticados podem inserir logs

## Segurança

- ✅ Erros são salvos apenas para usuários autenticados
- ✅ Apenas admins (usuarios_sistema) podem ler logs
- ✅ Stack traces sensíveis são visíveis apenas em dev mode
- ✅ Dados adicionais são JSON validado
- ✅ Nenhuma senha ou token é registrado automaticamente

## Próximos Passos

1. Criar dashboard analítico (gráficos, tendências)
2. Alertas automáticos para erros críticos
3. Integração com Discord/Slack para notificações
4. Análise de padrões com IA
5. Exportação de relatórios

---

Documentação criada em: 9 de junho de 2026
