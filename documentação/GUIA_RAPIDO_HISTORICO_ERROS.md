# Integração Rápida do Sistema de Histórico de Erros

## 1️⃣ Execute o Script SQL (1 minuto)

```
1. Vá em Supabase > SQL Editor
2. Cole o conteúdo de: scripts/criar_tabela_error_logs.sql
3. Execute o script
4. Pronto! Tabela error_logs criada com RLS e índices
```

## 2️⃣ Já Está Automático!

O sistema já está capturando erros automaticamente:

- ✅ ErrorLogService registra erros em memória
- ✅ ErrorLogDatasource salva no Supabase assincronamente
- ✅ Não bloqueia o aplicativo se falhar

## 3️⃣ Visualizar Erros (Optional)

Adicione o dashboard ao seu menu admin:

```dart
// Em main.dart ou routes
GetRoute(
  name: '/admin/error-logs',
  page: () => ErrorLogsDashboardPage(),
),

// Ou acesse diretamente
Get.to(() => ErrorLogsDashboardPage());
```

## 4️⃣ Melhorar Registros (Recomendado)

Adicione contexto ao registrar erros em controllers críticos:

```dart
// usuario_sistema_controller.dart
try {
  await usuarioRepository.salvar(usuario);
} catch (e, st) {
  ErrorLogService.instance.logError(
    e, st,
    source: 'UsuarioSistemaController.salvar',
    modulo: 'usuarios_sistema',
    funcionalidade: 'salvar_usuario',
  );
  Get.snackbar('Erro', 'Falha ao salvar usuário');
}
```

## 📊 Arquivos Criados/Modificados

| Arquivo                                                             | Tipo | Status        |
| ------------------------------------------------------------------- | ---- | ------------- |
| scripts/criar_tabela_error_logs.sql                                 | SQL  | ✅ Novo       |
| lib/core/services/error_log_datasource.dart                         | Dart | ✅ Novo       |
| lib/core/services/error_log_service.dart                            | Dart | ✅ Modificado |
| lib/modules/admin/presentation/pages/error_logs_dashboard_page.dart | Dart | ✅ Novo       |
| documentação/SISTEMA_HISTORICO_ERROS.md                             | Docs | ✅ Novo       |

## 🎯 Próximas Ações

1. Execute o script SQL no Supabase
2. Teste salvando um usuário do sistema (deve registrar no banco)
3. Acesse o dashboard para visualizar erros
4. (Optional) Integre melhor com módulo de usuarios_sistema

## ⏱️ Tempo Total de Setup

- Execute SQL: 30 segundos
- Dashboard já funcional: instantaneamente
- Setup completo: < 2 minutos

---

Tudo pronto para rastrear e analisar erros! 🚀
