import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ecclesiastes/l10n/app_localizations.dart';
import 'package:ecclesiastes/router/app_router.dart';
import 'package:ecclesiastes/providers/locale_provider.dart';
import 'package:ecclesiastes/providers/auth_state_provider.dart';

// Services
import 'package:ecclesiastes/services/auth_service.dart';
import 'package:ecclesiastes/services/database_service.dart';
import 'package:ecclesiastes/services/notification_service.dart';
import 'package:ecclesiastes/services/logging_service.dart';
import 'package:ecclesiastes/services/workmanager_setup.dart';
import 'package:ecclesiastes/services/database_initializer.dart';
import 'package:ecclesiastes/services/asset_auto_sync_service.dart';
import 'package:ecclesiastes/services/sync_service.dart';
import 'package:ecclesiastes/services/library_seed_service.dart';
import 'package:ecclesiastes/core/security/encryption_service.dart';
import 'package:ecclesiastes/theme/app_theme.dart';

void main() async {
  // 1. Initialisation vitale minimale
  // 1. Assurer l'initialisation des bindings Flutter. Indispensable avant tout appel de service.
  WidgetsFlutterBinding.ensureInitialized();

  // Créez un ProviderContainer pour accéder aux providers avant runApp
  final container = ProviderContainer();

  // 2. Initialiser les services critiques de manière séquentielle.
  // Initialise la base de données locale (Hive).
  await DatabaseService.init();

  // Initialisez AuthService avec le container
  AuthService.setProviderContainer(container);

  // 3. Restaurer la session utilisateur. C'est l'étape clé.
  // Le service d'authentification va tenter de charger l'utilisateur depuis le stockage sécurisé.
  await AuthService.restoreSession();

  // 4. Lancer l'application Flutter.
  // Ce n'est qu'après la restauration de session que l'UI est construite.
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

    // Affichez un écran de chargement pendant l'initialisation de l'authentification
    if (authState == AuthState.loading) {
      return MaterialApp(
        title: 'Ecclésiaste',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logos/logo_ena.png', height: 80),
                SizedBox(height: 32),
                CircularProgressIndicator(color: Color(0xFF003366), strokeWidth: 3),
                SizedBox(height: 24),
                Text('ECCLÉSIASTE',
                  style: TextStyle(color: Color(0xFF003366), fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 2)),
                SizedBox(height: 8),
                Text('Chargement de l\'espace sécurisé...',
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
      themeMode: ThemeMode.system, // Ou basé sur les paramètres utilisateur
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

