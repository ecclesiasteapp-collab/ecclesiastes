import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ecclesiaste/l10n/app_localizations.dart';
import 'package:ecclesiaste/router/app_router.dart';
import 'package:ecclesiaste/providers/locale_provider.dart';
import 'package:ecclesiaste/providers/theme_provider.dart';
import 'package:ecclesiaste/providers/auth_state_provider.dart';

// Services
import 'package:ecclesiaste/services/auth_service.dart';
import 'package:ecclesiaste/services/database_service.dart';
import 'package:ecclesiaste/services/config_service.dart';
import 'package:ecclesiaste/services/notification_service.dart';
import 'package:ecclesiaste/services/logging_service.dart';
import 'package:ecclesiaste/services/workmanager_setup.dart';
import 'package:ecclesiaste/services/database_initializer.dart';
import 'package:ecclesiaste/services/asset_auto_sync_service.dart';
// import 'package:ecclesiaste/services/sync_service.dart';
import 'package:ecclesiaste/services/library_seed_service.dart';
import 'package:ecclesiaste/core/security/encryption_service.dart';
import 'package:ecclesiaste/theme/app_theme.dart';

void main() async {
  // 1. Initialisation vitale minimale
  // 1. Assurer l'initialisation des bindings Flutter. Indispensable avant tout appel de service.
  WidgetsFlutterBinding.ensureInitialized();

  // Créez un ProviderContainer pour accéder aux providers avant runApp
  final container = ProviderContainer();

  // 2. Initialiser les services critiques de manière séquentielle.
  // Initialise la base de données locale (Hive).
  await DatabaseService.init();

  // Initialise la configuration pilotée par les données (Data Driven)
  await ConfigService().init();

  // Initialisez AuthService avec le container
  AuthService.setProviderContainer(container);

  // 3. Lancer l'application Flutter.
  // La restauration de session est déjà gérée par `authStateProvider`.
  runApp(UncontrolledProviderScope(container: container, child: const EgliseApp()));
}

class EgliseApp extends ConsumerStatefulWidget {
  const EgliseApp({super.key});

  @override
  ConsumerState<EgliseApp> createState() => _EgliseAppState();
}

class _EgliseAppState extends ConsumerState<EgliseApp> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    try {
      await EncryptionService.initializeKey();
      await initializeDateFormatting('fr_FR', null);

      // Initialisations de fond
      _deferredInit();
    } catch (e, stack) {
      LoggingService.error('Erreur démarrage', e, stack);
    }
  }

  Future<void> _deferredInit() async {
    try {
      final auth = AuthService();
      await auth.initializeDefaultAdmin();
      await DatabaseInitializer.seedInitialHierarchy();
      await LibrarySeedService.initialize();
      await AssetAutoSyncService.syncAssetsToHive();

      if (!kIsWeb) {
        await initWorkmanager();
        await NotificationService.init();
      }
    } catch (e) {
      debugPrint('Erreur init différée: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final router = ref.watch(goRouterProvider);
    final currentLocale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider);

    // Affichez un écran de chargement pendant l'initialisation de l'authentification
    if (authState == AuthState.loading) {
      return MaterialApp(
        title: 'Ecclésiaste',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logos/Logo.png', height: 100),
                const SizedBox(height: 32),
                const CircularProgressIndicator(color: Color(0xFF003366), strokeWidth: 3),
                const SizedBox(height: 24),
                const Text('ECCLÉSIASTE',
                  style: TextStyle(color: Color(0xFF003366), fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 2)),
                const SizedBox(height: 8),
                const Text('Chargement de l\'espace sécurisé...',
                  style: TextStyle(color: Colors.blueGrey, fontSize: 12)),

              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp.router(
      title: 'Ecclésiaste',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      locale: currentLocale,
      themeMode: themeMode,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

