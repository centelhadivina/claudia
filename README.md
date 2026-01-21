# Centelha Claudia

Projeto Flutter para gerenciamento do Centelha.

## 🌐 Demo Online

Este projeto está publicado no GitHub Pages:
**https://centelhadivina.github.io/claudia/**

## 🚀 Deploy Automático

O projeto está configurado com GitHub Actions para deploy automático no GitHub Pages. Cada push na branch `main` gera automaticamente um novo build e deploy.

### Como funciona

1. Push para a branch `main`
2. GitHub Actions executa o workflow de build
3. Flutter compila a versão web
4. Deploy automático para GitHub Pages

### Configuração do GitHub Pages

Para que o deploy funcione, certifique-se de que no repositório do GitHub:

1. Vá em **Settings** > **Pages**
2. Em **Source**, selecione **GitHub Actions**
3. O site estará disponível em `https://centelhadivina.github.io/claudia/`

## 🛠️ Desenvolvimento

### Requisitos

- Flutter SDK ^3.9.2
- Dart SDK

### Instalação

```bash
flutter pub get
```

### Executar localmente

```bash
flutter run
```

### Build para web

```bash
flutter build web --release --base-href /claudia/
```

## 📦 Tecnologias

- **Flutter** - Framework principal
- **BLoC** - Gerenciamento de estado
- **GetIt** - Injeção de dependências
- **Supabase** - Backend e banco de dados
- **Dio** - Cliente HTTP
- **Excel/CSV** - Manipulação de arquivos

## 🗂️ Estrutura do Projeto

Veja [ARCHITECTURE.md](ARCHITECTURE.md) para detalhes sobre a arquitetura Clean Architecture implementada.

