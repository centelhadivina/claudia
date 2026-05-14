import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sistema_ponto/sistema_ponto.dart';

import 'core/di/auth_bloc_binding.dart';
import 'core/di/injection_container.dart' as di;
import 'core/navigation/placeholder_page.dart';
import 'core/services/supabase_service.dart';
import 'core/theme/app_theme.dart';
import 'modules/auth/presentation/bloc/auth_bloc.dart';
import 'modules/auth/presentation/bloc/auth_event.dart';
import 'modules/auth/presentation/bloc/auth_state.dart';
import 'modules/auth/presentation/pages/login_page.dart';
import 'modules/cadastro/presentation/pages/cadastrar_page.dart';
import 'modules/cadastro/presentation/pages/editar_page.dart';
import 'modules/cadastro/presentation/pages/excluir_page.dart';
import 'modules/cadastro/presentation/pages/importar_excel_page.dart';
import 'modules/cadastro/presentation/pages/importar_pessoas_antigas_page.dart';
import 'modules/cadastro/presentation/pages/pesquisar_page.dart';
import 'modules/consultas/presentation/pages/ler_consulta_page.dart';
import 'modules/consultas/presentation/pages/nova_consulta_page.dart';
import 'modules/consultas/presentation/pages/pesquisar_consulta_page.dart';
import 'modules/grupos_acoes_sociais/presentation/pages/gerenciar_grupo_acao_social_page.dart';
import 'modules/grupos_acoes_sociais/presentation/pages/relatorios_grupo_acao_social_page.dart';
import 'modules/grupos_tarefas/presentation/pages/gerenciar_grupo_tarefa_page.dart';
import 'modules/grupos_tarefas/presentation/pages/relatorios_grupo_tarefa_page.dart';
import 'modules/grupos_trabalhos_espirituais/presentation/pages/gerenciar_grupo_trabalho_espiritual_page.dart';
import 'modules/grupos_trabalhos_espirituais/presentation/pages/relatorios_grupo_trabalho_espiritual_page.dart';
import 'modules/home/presentation/pages/home_page.dart';
import 'modules/membros/presentation/pages/editar_membro_page.dart';
import 'modules/membros/presentation/pages/importar_membros_antigos_page.dart';
import 'modules/membros/presentation/pages/incluir_membro_page.dart';
import 'modules/membros/presentation/pages/pesquisar_membro_page.dart';
import 'modules/membros/presentation/pages/relatorios_membro_page.dart';
import 'modules/organizacao/presentation/pages/gerenciar_classificacoes_mediunicas_page.dart';
import 'modules/organizacao/presentation/pages/gerenciar_dias_sessao_page.dart';
import 'modules/organizacao/presentation/pages/gerenciar_grupos_page.dart';
import 'modules/organizacao/presentation/pages/gerenciar_nucleos_page.dart';
import 'modules/organizacao/presentation/pages/gerenciar_organizacao_page.dart';
import 'modules/organizacao/presentation/pages/organizacao_centelha_page.dart';
import 'modules/usuarios_sistema/presentation/pages/gerenciar_usuario_sistema_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Supabase
  await SupabaseService.initialize();

  await di.init();
  AuthBlocBinding.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<AuthBloc>()..add(CheckAuthEvent()),
      child: GetMaterialApp(
        title: 'CLAUDIA',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return const HomePage();
            }
            return const LoginPage();
          },
        ),
        // Rotas GetX
        getPages: [
          GetPage(name: '/cadastrar', page: () => const CadastrarPage()),
          GetPage(
            name: '/cadastros/cadastrar',
            page: () => const CadastrarPage(),
          ),
          GetPage(name: '/pesquisar', page: () => const PesquisarPage()),
          GetPage(
            name: '/cadastros/pesquisar',
            page: () => const PesquisarPage(),
          ),
          GetPage(name: '/editar', page: () => const EditarPage()),
          GetPage(name: '/cadastros/editar', page: () => const EditarPage()),
          GetPage(name: '/excluir', page: () => const ExcluirPage()),
          GetPage(name: '/cadastros/excluir', page: () => const ExcluirPage()),
          GetPage(
            name: '/importar-excel',
            page: () => const ImportarExcelPage(),
          ),
          GetPage(
            name: '/importar-pessoas-antigas',
            page: () => const ImportarPessoasAntigasPage(),
          ),

          // Membros
          GetPage(
            name: '/membros/importar-antigos',
            page: () => const ImportarMembrosAntigosPage(),
          ),
          GetPage(
            name: '/membros/incluir',
            page: () => const IncluirMembroPage(),
          ),
          GetPage(
            name: '/membros/pesquisar',
            page: () => const PesquisarMembroPage(),
          ),
          GetPage(
            name: '/membros/editar',
            page: () => const EditarMembroPage(),
          ),
          GetPage(
            name: '/membros/relatorios',
            page: () => const RelatoriosMembroPage(),
          ),

          // Consultas
          GetPage(
            name: '/consultas/nova',
            page: () => const NovaConsultaPage(),
          ),
          GetPage(
            name: '/consultas/pesquisar',
            page: () => const PesquisarConsultaPage(),
          ),
          GetPage(name: '/consultas/ler', page: () => const LerConsultaPage()),

          // Grupos Tarefas
          GetPage(
            name: '/grupos-tarefas/gerenciar',
            page: () => const GerenciarGrupoTarefaPage(),
          ),
          GetPage(
            name: '/grupos-tarefas/relatorios',
            page: () => const RelatoriosGrupoTarefaPage(),
          ),

          // Grupos Ações Sociais
          GetPage(
            name: '/grupos-acoes-sociais/gerenciar',
            page: () => const GerenciarGrupoAcaoSocialPage(),
          ),
          GetPage(
            name: '/grupos-acoes-sociais/relatorios',
            page: () => const RelatoriosGrupoAcaoSocialPage(),
          ),

          // Grupos Trabalhos Espirituais
          GetPage(
            name: '/grupos-trabalhos-espirituais/gerenciar',
            page: () => const GerenciarGrupoTrabalhoEspiritualPage(),
          ),
          GetPage(
            name: '/grupos-trabalhos-espirituais/relatorios',
            page: () => const RelatoriosGrupoTrabalhoEspiritualPage(),
          ),

          // Sacramentos
          GetPage(
            name: '/sacramentos/batismo',
            page: () => const PlaceholderPage(title: 'Batismo'),
          ),
          GetPage(
            name: '/sacramentos/casamento',
            page: () => const PlaceholderPage(title: 'Casamento'),
          ),
          GetPage(
            name: '/sacramentos/jogo-orixa',
            page: () => const PlaceholderPage(title: 'Jogo de Orixá'),
          ),
          GetPage(
            name: '/sacramentos/camarinhas',
            page: () => const PlaceholderPage(title: 'Camarinhas'),
          ),
          GetPage(
            name: '/sacramentos/coroacao',
            page: () => const PlaceholderPage(title: 'Coroação Sacerdotal'),
          ),
          GetPage(
            name: '/sacramentos/relatorios',
            page: () =>
                const PlaceholderPage(title: 'Relatórios de Sacramentos'),
          ),

          // Cursos e Treinamentos
          GetPage(
            name: '/cursos/criar',
            page: () => const PlaceholderPage(title: 'Criar Novo Curso'),
          ),
          GetPage(
            name: '/cursos/nova-turma',
            page: () => const PlaceholderPage(title: 'Abrir Nova Turma'),
          ),
          GetPage(
            name: '/cursos/inscricao',
            page: () => const PlaceholderPage(title: 'Inscrição em Curso'),
          ),
          GetPage(
            name: '/cursos/lancar-notas',
            page: () => const PlaceholderPage(title: 'Lançar Notas'),
          ),
          GetPage(
            name: '/cursos/relatorios',
            page: () => const PlaceholderPage(title: 'Relatórios de Cursos'),
          ),

          // Sistema de Ponto
          GetPage(
            name: '/sistema-ponto/importar-calendario',
            page: () => const ImportarCalendarioPage(),
          ),
          GetPage(
            name: '/sistema-ponto/importar-presencas',
            page: () => const ImportarPresencaPage(),
          ),
          GetPage(
            name: '/sistema-ponto/avaliacoes',
            page: () => const LancarConceitosPage(),
          ),
          GetPage(
            name: '/sistema-ponto/rankings',
            page: () => const RankingMensalPage(),
          ),
          GetPage(
            name: '/sistema-ponto/relatorios',
            page: () =>
                const PlaceholderPage(title: 'Relatórios do Sistema de Ponto'),
          ),

          // Usuários Sistema
          GetPage(
            name: '/usuarios-sistema/cadastrar',
            page: () => const GerenciarUsuarioSistemaPage(),
          ),
          GetPage(
            name: '/usuarios-sistema/listar',
            page: () => const GerenciarUsuarioSistemaPage(),
          ),
          GetPage(
            name: '/usuarios-sistema/excluir',
            page: () => const GerenciarUsuarioSistemaPage(),
          ),
          GetPage(
            name: '/usuarios-sistema/acessos',
            page: () => const PlaceholderPage(title: 'Acessos de Usuários'),
          ),

          // Organização
          GetPage(
            name: '/organizacao/gerenciar',
            page: () => const GerenciarOrganizacaoPage(),
          ),
          GetPage(
            name: '/organizacao',
            page: () => const OrganizacaoCentelhaPage(),
          ),
          GetPage(
            name: '/organizacao/nucleos',
            page: () => const GerenciarNucleosPage(),
          ),
          GetPage(
            name: '/organizacao/dias-sessao',
            page: () => const GerenciarDiasSessaoPage(),
          ),
          GetPage(
            name: '/organizacao/grupos-tarefa',
            page: () => const GerenciarGruposPage(tipo: 'grupo_tarefa'),
          ),
          GetPage(
            name: '/organizacao/grupos-acao-social',
            page: () => const GerenciarGruposPage(tipo: 'acao_social'),
          ),
          GetPage(
            name: '/organizacao/grupos-trabalho-espiritual',
            page: () => const GerenciarGruposPage(tipo: 'trabalho_espiritual'),
          ),
          GetPage(
            name: '/organizacao/classificacoes-mediunicas',
            page: () => const GerenciarClassificacoesMediunicasPage(),
          ),
        ],
      ),
    );
  }
}
