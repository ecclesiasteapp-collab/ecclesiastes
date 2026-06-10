import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecclesiastes/views/login_page.dart';
import 'package:ecclesiastes/views/dashboard_page.dart';
import 'package:ecclesiastes/services/auth_service.dart';
import 'package:ecclesiastes/services/database_helper.dart';
import 'package:ecclesiastes/services/notification_service.dart';
import 'package:ecclesiastes/services/logging_service.dart';
import 'package:ecclesiastes/utils/secure_storage_helper.dart';
import 'package:ecclesiastes/views/report_list_screen.dart';
import 'package:ecclesiastes/views/create_report_screen.dart';
import 'package:ecclesiastes/views/reports/fundraising_report_screen.dart';
import 'package:ecclesiastes/views/legal_disclaimer_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:ecclesiastes/models/isar/sync_queue.dart';
import 'package:ecclesiastes/models/isar/report_local.dart';
import 'package:ecclesiastes/models/isar/event.dart';
import 'package:ecclesiastes/services/workmanager_setup.dart';
import 'package:ecclesiastes/models/catechism_lesson.dart';
import 'package:ecclesiastes/models/confirmation_lesson.dart';
import 'package:ecclesiastes/models/ecodim_lesson.dart';
import 'package:ecclesiastes/models/library_document.dart';
import 'package:ecclesiastes/models/hierarchy_models.dart';
import 'package:ecclesiastes/models/commission_node.dart';
import 'package:ecclesiastes/models/member_profile.dart';
import 'package:ecclesiastes/models/user.dart';
import 'package:ecclesiastes/models/audit_log.dart';
import 'package:ecclesiastes/models/news_model.dart';
import 'package:ecclesiastes/services/seed_data_service.dart';
import 'package:ecclesiastes/services/library_seed_service.dart';
import 'package:ecclesiastes/models/church_report.dart';
import 'package:ecclesiastes/models/fundraising_report.dart';
import 'package:ecclesiastes/models/app_settings.dart';
import 'package:ecclesiastes/models/territory_config.dart';
import 'package:ecclesiastes/models/report_model.dart';
import 'package:ecclesiastes/models/bible_model.dart';
import 'package:ecclesiastes/views/profile_page.dart';
import 'package:ecclesiastes/views/settings_page.dart';
import 'package:ecclesiastes/views/help_page.dart';
import 'package:ecclesiastes/core/security/encryption_service.dart';
import 'package:ecclesiastes/providers/locale_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialisation Hive
  await Hive.initFlutter();
  
  // Registering Adapters with Unique IDs (0-102)
  Hive.registerAdapter(EventTypeAdapter()); // 0
  Hive.registerAdapter(AnnouncementStatusAdapter()); // 1
  Hive.registerAdapter(EventAdapter()); // 2
  Hive.registerAdapter(AnnouncementAdapter()); // 3
  Hive.registerAdapter(CatechismLessonAdapter()); // 4
  Hive.registerAdapter(EcodimLessonAdapter()); // 5
  Hive.registerAdapter(ConfirmationLessonAdapter()); // 6
  Hive.registerAdapter(SyncQueueAdapter()); // 7
  Hive.registerAdapter(ReportLocalAdapter()); // 8
  
  Hive.registerAdapter(UserCategoryAdapter()); // 10
  Hive.registerAdapter(DocumentTypeAdapter()); // 13
  Hive.registerAdapter(LibraryDocumentAdapter()); // 14
  Hive.registerAdapter(CommissionNodeAdapter()); // 15
  
  Hive.registerAdapter(EntityLevelAdapter()); // 20
  Hive.registerAdapter(UserRoleAdapter()); // 21
  Hive.registerAdapter(CommissionTypeAdapter()); // 22
  
  Hive.registerAdapter(CivilStatusAdapter()); // 30
  Hive.registerAdapter(MemberStatusAdapter()); // 31
  Hive.registerAdapter(AvailabilityAdapter()); // 32
  Hive.registerAdapter(MemberProfileAdapter()); // 33
  Hive.registerAdapter(NewsAdapter()); // 40
  
  Hive.registerAdapter(ReportTypeExtAdapter()); // 50
  Hive.registerAdapter(ReportStatusAdapter()); // 51
  Hive.registerAdapter(ChurchReportAdapter()); // 52
  Hive.registerAdapter(FundraisingReportAdapter()); // 53
  
  Hive.registerAdapter(AppSettingsAdapter()); // 60
  Hive.registerAdapter(TerritoryConfigAdapter()); // 61
  Hive.registerAdapter(ReportModelAdapter()); // 70
  
  Hive.registerAdapter(UserAdapter()); // 101
  Hive.registerAdapter(AuditLogAdapter()); // 102
  Hive.registerAdapter(BibleBookAdapter()); // 80
  Hive.registerAdapter(BibleChapterAdapter()); // 81
  Hive.registerAdapter(BibleVerseAdapter()); // 82

  // 📦 Initialisation Hive optimisée (Lazy Loading pour le Web)
  await Future.wait([
    Hive.openBox<User>('users'),
    Hive.openBox<TerritoryConfig>('territory_configs'),
    Hive.openBox<AppSettings>('settings_box'),
  ]);
  debugPrint('✅ Boîtes essentielles ouvertes');

  // Ouvrir les autres boîtes en arrière-plan
  Future.microtask(() async {
    await Future.wait([
      Hive.openBox<Event>('events_box'),
      Hive.openBox<Announcement>('announcements'),
      Hive.openBox<SyncQueue>('syncQueues'),
      Hive.openBox<ReportLocal>('reportLocals'),
      Hive.openBox<AuditLog>('audit_logs'),
      Hive.openBox<LibraryDocument>('library_box'),
      Hive.openBox<CommissionNode>('commissions_box'),
      Hive.openBox<MemberProfile>('member_profiles'),
      Hive.openBox<CatechismLesson>('catechism_lessons'),
      Hive.openBox<ConfirmationLesson>('cat_lessons'),
      Hive.openBox<EcodimLesson>('eco_lessons'),
      Hive.openBox<ChurchReport>('church_reports'),
      Hive.openBox<FundraisingReport>('fundraising_reports'),
      Hive.openBox<ReportModel>('reports_box'),
      Hive.openBox<News>('news'),
      Hive.openBox<BibleBook>('bible_box'),
    ]);
    debugPrint('✅ Boîtes secondaires ouvertes en arrière-plan');
  });
  
  // 2. Initialisation des Services & Sécurité
  await EncryptionService.initializeKey();
  await AuthService().initializeDefaultAdmin();
  await SeedDataService.initialize();
  await LibrarySeedService.initialize();
  
  // ✅ CORRECTION : Ne pas appeler workmanager sur le Web
  if (!kIsWeb) {
    await initWorkmanager();
  } else {
    debugPrint('⚠️ Mode Web détecté - Workmanager ignoré');
  }

  // 3. Initialisation WorkManager (Uniquement sur Mobile)
  if (!kIsWeb) {
    // initSyncWorker est déjà appelé par initWorkmanager() ou peut être supprimé
  }

  await initializeDateFormatting('fr_FR', null);
  try {
    await DatabaseHelper.instance.database;
  } catch (e) {
    debugPrint("Erreur d'initialisation de la base de données : $e");
  }
  await NotificationService.init();

  final hasSession = await SecureStorageHelper.hasSession();
  if (hasSession) {
    final sessionData = await SecureStorageHelper.getSession();
    if (sessionData != null) {
      AuthService.currentUser = sessionData;
      LoggingService.logAuth('main', userId: sessionData['user_id'], message: 'Session restored on app startup');
    }
  }

  LoggingService.info('App started successfully');
  runApp(const ProviderScope(child: EgliseApp()));
}

class EgliseApp extends ConsumerWidget {
  const EgliseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'Ecclesiastes',
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: const [
        Locale('fr'),
        Locale('en'),
        Locale('ln'),
        Locale('ko'),
        Locale('sw'),
        Locale('tl'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF004A99),
          primary: const Color(0xFF004A99),
          secondary: const Color(0xFF1565C0),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/reports': (context) => const ReportListScreen(),
        '/create-report': (context) => const CreateReportScreen(),
        '/fundraising-report': (context) => const FundraisingReportScreen(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
        '/help': (context) => const HelpPage(),
        '/legal': (context) => const LegalDisclaimerPage(),
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _hasAcceptedLegal = false;
  User? _user;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    final prefs = await SharedPreferences.getInstance();
    _hasAcceptedLegal = prefs.getBool('has_accepted_legal_terms') ?? false;
    
    if (_hasAcceptedLegal) {
      await _checkSession();
    }
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkSession() async {
    final user = await AuthService().getCurrentUser();
    if (user != null) {
      AuthService.currentUser = {
        'id': user.id,
        'user_id': user.id,
        'nom_complet': user.fullName,
        'identifiant_email': user.email,
        'role': user.role == UserRole.superAdmin ? 'SUPER_ADMIN' : user.role.name,
        'role_label': user.role.name,
        'entite_id': user.entityId ?? 'ROOT',
        'communaute_id': user.entityId ?? 'ROOT',
      };
    }
    setState(() {
      _user = user;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_hasAcceptedLegal) {
      return const LegalDisclaimerPage();
    }

    if (_user == null && AuthService.currentUser == null) {
      return const LoginPage(); 
    }

    return const DashboardPage();
  }
}
