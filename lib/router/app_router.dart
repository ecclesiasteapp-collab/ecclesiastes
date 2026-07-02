import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Models
import '../models/news_model.dart';
import '../models/hierarchy_models.dart';
import '../models/library_document.dart';

// Services
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../providers/auth_state_provider.dart';
import '../config/report_registry.dart';

// Views
import 'welcome_page.dart';
import '../views/login_page.dart';
import '../views/register_page.dart';
import '../views/pending_confirmation_page.dart';
import '../views/forgot_password_page.dart';
import '../views/legal_disclaimer_page.dart';
import '../views/dashboard_page.dart';
import '../views/bible_page.dart';
import '../views/gestion_membres_page.dart';
import '../views/hierarchie_page.dart';
import '../views/calendrier_page.dart';
import '../views/saisie_programme_page.dart';
import '../views/programmes_page.dart';
import '../views/event_dashboard_page.dart';
import '../views/import_events_page.dart';
import '../views/commissions/commission_detail_screen.dart';
import '../views/report_list_screen.dart';
import '../views/library_screen.dart';
import '../views/reports/universal_report_screen.dart';
import '../views/organization/organization_overview_page.dart';
import '../screens/about_screen.dart';
import '../views/annonces_page.dart';
import '../views/create_announcement_page.dart';
import '../views/announcement_detail_screen.dart';
import '../views/commissions_page.dart';
import '../views/settings_page_enhanced.dart';
import '../views/profile_page.dart';
import '../views/member_detail_page.dart';
import '../views/member_transfer_page.dart';
import '../views/inscription_membre_page.dart';
import '../views/social_hub_screen.dart';
import '../views/pastoral_statistics_screen.dart';
import '../views/church_report_detail_page.dart';
import '../views/admin_entites_page.dart';
import '../views/structure_test_page.dart';
import '../views/dashboards/main_dashboard.dart';
import '../views/dashboards/member_dashboard.dart';
import '../views/dashboards/minister_dashboard.dart';
import '../views/dashboards/commission_dashboard.dart';
import '../views/dashboards/dashboard_responsable_entite_page.dart';
import '../views/admin/super_admin_dashboard.dart';

import '../views/reports/rapport_ecodim.dart';
import '../views/reports/fundraising_report_screen.dart';
import '../views/reports/universal_monthly_report_screen.dart';
import '../views/reports/report_inbox_page.dart';
import '../views/inscription_membre_stepper.dart';
import '../views/ecodim_assistant_screen.dart';
import '../views/planning_sd_page.dart';
import '../views/signature_screen.dart';
import '../views/help_page.dart';
import '../views/journal_finances_page.dart';
import '../views/saisie_finances_page.dart';

// Page de secours
class _ComingSoonPage extends StatelessWidget {
  final String title;
  const _ComingSoonPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        title: Text(title),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 80, color: Colors.orange),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Bientôt disponible', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.go('/dashboard'),
              icon: const Icon(Icons.home),
              label: const Text('Retour au Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}

UserCategory _resolveLibraryCategory() {
  final user = AuthService.currentUser;
  if (user == null) return UserCategory.membre;
  switch (user.role) {
    case UserRole.superAdmin:
    case UserRole.apotrePatriarche:
    case UserRole.apotreDistrict:
    case UserRole.apotreResponsable:
    case UserRole.apotre:
    case UserRole.eveque:
    case UserRole.ancien:
    case UserRole.lead:
      return UserCategory.responsable;
    case UserRole.membre:
      return UserCategory.membre;
    default:
      return UserCategory.ministre;
  }
}

EntityLevel _resolveLibraryLevel() {
  final user = AuthService.currentUser;
  return user?.entityLevel ?? EntityLevel.communaute;
}

CommissionType _resolveLibraryCommission() {
  final user = AuthService.currentUser;
  return user?.commissionType ?? CommissionType.none;
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authStateProvider.notifier);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(authNotifier.stream),
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final isLoggedIn = authState == AuthState.authenticated;
      final isInitializing = authState == AuthState.loading;

      final path = state.matchedLocation;
      final isGoingToLogin = path == '/login';
      final isWelcome = path == '/';

      // Si l'authentification est en cours d'initialisation, ne redirigez pas encore
      if (isInitializing) return null;

      // Si pas connecté et essaie d'accéder à une page protégée, redirige vers le login
      if (!isLoggedIn && !isGoingToLogin && !isWelcome &&
          path != '/register' && path != '/forgot-password' && path != '/legal' && path != '/pending-confirmation') {
        return '/login';
      }
      // Si connecté et essaie d'accéder à la page de login ou welcome, redirige vers le dashboard
      if (isLoggedIn && (isGoingToLogin || isWelcome)) {
        return '/dashboard';
      }
      return null;
    },
    routes: _routes,
    errorBuilder: _errorBuilder,
  );
});

final appRouter = GoRouter(
  initialLocation: '/',
  routes: _routes,
  errorBuilder: _errorBuilder,
  // La logique de redirection sera gérée par le nouveau goRouterProvider
);

final List<RouteBase> _routes = [
    GoRoute(path: '/', builder: (context, state) => const WelcomePage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterPage()),
    GoRoute(path: '/pending-confirmation', builder: (context, state) => const PendingConfirmationPage()),
    GoRoute(path: '/forgot-password', builder: (context, state) => const ForgotPasswordPage()),
    GoRoute(path: '/legal', builder: (context, state) => const LegalDisclaimerPage()),

    GoRoute(path: '/dashboard', builder: (context, state) => const DashboardPage()),

    GoRoute(path: '/organization', builder: (context, state) => const OrganizationOverviewPage()),
    GoRoute(path: '/hierarchie', builder: (context, state) => const HierarchiePage()),
    GoRoute(path: '/organigramme', builder: (context, state) => const HierarchiePage(title: 'Organigramme KSO', typeEntite: 'EGLISE_INTERNATIONALE')),

    GoRoute(path: '/admin/super-admin', builder: (context, state) => SuperAdminDashboard(admin: AuthService.currentUser!)),
    GoRoute(path: '/admin/panel', builder: (context, state) => const AdminEntitesPage()),
    GoRoute(path: '/admin/users', builder: (context, state) => const _ComingSoonPage(title: 'Gestion Utilisateurs')),

    GoRoute(path: '/bible', builder: (context, state) => const BiblePage()),

    GoRoute(
        path: '/members',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>?;
          return GestionMembresPage(
            entiteId: extras?['communauteId'],
            commissionName: extras?['commission'],
          );
        }),
    GoRoute(path: '/member/detail/:id', builder: (context, state) => MemberDetailPage(memberId: state.pathParameters['id']!)),
    GoRoute(path: '/member/register', builder: (context, state) => const InscriptionMembrePage()),
    GoRoute(path: '/member/register-stepper', builder: (context, state) => const InscriptionMembreStepper()),
    GoRoute(path: '/member/transfer/:id', builder: (context, state) => MemberTransferPage(memberId: state.pathParameters['id']!)),

    GoRoute(path: '/reports', builder: (context, state) => const ReportListScreen()),
    GoRoute(path: '/reports/inbox', builder: (context, state) => const ReportInboxPage()),

    GoRoute(path: '/reports/detail/:id', builder: (context, state) => ChurchReportDetailPage(reportId: state.pathParameters['id']!)),
    GoRoute(
        path: '/reports/universal/:type',
        builder: (context, state) {
          final type = state.pathParameters['type']!;
          final config = ReportRegistry.all[type] ?? ReportRegistry.all['service_divin']!;
          if (type.endsWith('_mensuel')) {
            // Pour les rapports mensuels, utiliser UniversalMonthlyReportScreen
            // Il faudra passer la config et des données réelles ici
            return UniversalMonthlyReportScreen(reportConfig: config, reportData: {}); // Placeholder pour reportData
          }
          return UniversalReportScreen(config: config);
        }),

    GoRoute(path: 
'/reports/ecodim', builder: (context, state) => const ReportEcodimPage()),
    GoRoute(path: '/fundraising-report', builder: (context, state) => const FundraisingReportScreen()),

    GoRoute(path: '/announcements', builder: (context, state) => const AnnoncesPage()),
    GoRoute(path: '/announcements/create', builder: (context, state) => const CreateAnnouncementPage()),
    GoRoute(path: '/announcements/detail/:id', builder: (context, state) => AnnouncementDetailScreen(announcement: state.extra as News)),

    GoRoute(path: '/library', builder: (context, state) => LibraryScreen(
            userCategory: _resolveLibraryCategory(),
            userLevel: _resolveLibraryLevel(),
            userCommission: _resolveLibraryCommission(),
            isSuperAdmin: AuthService.isSuperAdmin())),

    GoRoute(path: '/calendar', builder: (context, state) => const CalendrierPage()),
    GoRoute(
      path: '/events',
      builder: (context, state) => EventDashboardPage(
        events: DatabaseService.getAllEvents(),
      ),
    ),
    GoRoute(path: '/events/import', builder: (context, state) => const ImportEventsPage()),
    GoRoute(path: '/events/program', builder: (context, state) => const SaisieProgrammePage()),
    GoRoute(path: '/programmes', builder: (context, state) => const ProgrammesPage()),

    GoRoute(path: '/commissions', builder: (context, state) => const CommissionsPage()),
    GoRoute(
        path: '/commissions/detail/:id',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          return CommissionDetailScreen(
            commissionName: extras['commissionName'] as String,
            leaderName: extras['leaderName'] as String,
            leaderPhotoUrl: extras['leaderPhotoUrl'] as String?,
            progress: extras['progress'] as double,
            entityId: extras['entityId'] as String,
          );
        }),

    GoRoute(path: '/settings', builder: (context, state) => const SettingsPageEnhanced()),
    GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
    GoRoute(path: '/stats', builder: (context, state) => const PastoralStatisticsScreen()),
    GoRoute(path: '/social-hub', builder: (context, state) => const SocialHubScreen()),
    GoRoute(path: '/about', builder: (context, state) => const AboutScreen()),

    GoRoute(path: '/test-structure', builder: (context, state) => const StructureTestPage()),
    GoRoute(path: '/ecodim/assistant', builder: (context, state) => const EcodimAssistantScreen()),
    GoRoute(path: '/planning/sd', builder: (context, state) => const PlanningSDPage()),
    GoRoute(path: '/finances/journal', builder: (context, state) => const JournalFinancesPage()),
    GoRoute(path: '/finances/saisie', builder: (context, state) => const SaisieFinancesPage()),
    GoRoute(path: '/help', builder: (context, state) => const HelpPage()),
    GoRoute(path: '/signature', builder: (context, state) => SignatureScreen(onSignatureSaved: (bytes) {})),

    GoRoute(
        path: '/dashboard/main',
        builder: (context, state) => const MainDashboard()),
    GoRoute(
        path: '/dashboard/entity',
        builder: (context, state) => const DashboardResponsableEntitePage()),
    GoRoute(
        path: '/dashboard/commission',
        builder: (context, state) => CommissionDashboard(
              commissionName:
                  AuthService.currentUser?.commissionType?.name ?? 'Commission',
            )),
    GoRoute(
        path: '/dashboard/minister',
        builder: (context, state) => const MinisterDashboard()),
    GoRoute(
        path: '/dashboard/member',
        builder: (context, state) => const MemberDashboard()),
];

Widget _errorBuilder(BuildContext context, GoRouterState state) => Scaffold(
  appBar: AppBar(backgroundColor: const Color(0xFF003366), title: const Text('Erreur 404'), foregroundColor: Colors.white),
  body: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 64),
        const SizedBox(height: 16),
        const Text('Page introuvable', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        ElevatedButton.icon(onPressed: () => context.go('/'), icon: const Icon(Icons.home), label: const Text('Retour à l\'accueil')),
      ],
    ),
  ),
);

