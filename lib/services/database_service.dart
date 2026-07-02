import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../models/app_settings.dart';
import '../models/attachment_model.dart';
import '../models/church_report.dart';
import '../models/ecodim_lesson.dart';
import '../models/event.dart';
import '../models/event_models.dart';
import '../models/fundraising_report.dart';
import '../models/hierarchy_models.dart';
import '../models/library_document.dart';
import '../models/member_profile.dart';
import '../models/news_model.dart';
import '../models/sacristy_report.dart';
import '../models/sync_queue_model.dart';
import '../models/user.dart';
import 'database_helper.dart';

/// Service centralisé pour l'initialisation et la gestion des boîtes Hive.
/// Garantit une initialisation paresseuse (lazy) pour de meilleures performances au démarrage.
class DatabaseService {
  // Noms des boîtes pour éviter les erreurs de frappe
  static const usersBoxName = 'users';
  static const settingsBoxName = 'settings_box';
  static const churchReportsBoxName = 'church_reports';
  static const attachmentsBoxName = 'attachments_box';
  static const newsBoxName = 'news';
  static const eventsBoxName = 'evenements_map';
  static const membersBoxName = 'member_profiles';
  static const lessonsBoxName = 'eco_lessons';
  static const fundraisingBoxName = 'fundraising_reports';
  static const libraryBoxName = 'library_box';
  static const pendingUsersBoxName = 'pending_users';

  /// Initialise Hive et enregistre tous les adaptateurs de type.
  /// C'est la seule méthode à appeler dans `main.dart`.
  static Future<void> init() async {
    // Initialisation de Hive dans un sous-dossier pour une meilleure organisation
    String? path;
    if (!kIsWeb) {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      path = appDocumentDir.path;
    }
    await Hive.initFlutter(path);

    // Enregistrement de tous les TypeAdapters
    _registerAdapters();

    // Ouverture des boîtes critiques pour le démarrage
    await Hive.openBox<User>(usersBoxName);
    await Hive.openBox<AppSettings>(settingsBoxName);
    await Hive.openBox<Map>(eventsBoxName);
    await Hive.openBox<Map>('rapports');
  }

  /// Ouvre une boîte de manière paresseuse. Si elle est déjà ouverte, la retourne simplement.
  /// C'est la méthode à utiliser dans les services ou les vues pour accéder à une boîte.
  static Future<Box<T>> openBox<T>(String name) async {
    if (Hive.isBoxOpen(name)) {
      return Hive.box<T>(name);
    }
    return Hive.openBox<T>(name);
  }

  /// Enregistre tous les adaptateurs de l'application.
  static void _registerAdapters() {
    // N'enregistre que si ce n'est pas déjà fait (utile pour les tests)
    if (!Hive.isAdapterRegistered(UserAdapter().typeId)) {
      Hive.registerAdapter(UserAdapter());
      Hive.registerAdapter(UserRoleAdapter());
      Hive.registerAdapter(EntityLevelAdapter());
      Hive.registerAdapter(CommissionRoleAdapter());
      Hive.registerAdapter(CommissionTypeAdapter());
      Hive.registerAdapter(ProfilDocumentaireAdapter());
      Hive.registerAdapter(AppSettingsAdapter());
      Hive.registerAdapter(ChurchReportAdapter());
      Hive.registerAdapter(ReportTypeExtAdapter());
      Hive.registerAdapter(ReportStatusAdapter());
      Hive.registerAdapter(AttachmentAdapter());
      Hive.registerAdapter(NewsAdapter());
      Hive.registerAdapter(ChurchEventAdapter());
      Hive.registerAdapter(CivilStatusAdapter());
      Hive.registerAdapter(MemberStatusAdapter());
      Hive.registerAdapter(AvailabilityAdapter());
      Hive.registerAdapter(MemberProfileAdapter());
      Hive.registerAdapter(SacristyReportAdapter());
      Hive.registerAdapter(EcodimLessonAdapter());
      Hive.registerAdapter(UserCategoryAdapter());
      Hive.registerAdapter(DocumentTypeAdapter());
      Hive.registerAdapter(LibraryDocumentAdapter());
      Hive.registerAdapter(EntityResponsibleRoleAdapter());
      Hive.registerAdapter(SyncQueueItemAdapter());
      Hive.registerAdapter(FundraisingReportAdapter());
      // ... Ajoutez ici TOUS les autres adaptateurs de votre application
    }
  }

  static Future<User?> getUser(String id) async {
    final box = await openBox<User>(usersBoxName);
    return box.get(id);
  }

  static List<User> getAllUsers() {
    if (!Hive.isBoxOpen(usersBoxName)) {
      return const [];
    }
    return Hive.box<User>(usersBoxName).values.toList();
  }

  static List<Event> getAllEvents() {
    if (!Hive.isBoxOpen(eventsBoxName)) {
      return const [];
    }

    final box = Hive.box<Map>(eventsBoxName);
    return box.values
        .map((data) => _eventFromMap(Map<String, dynamic>.from(data)))
        .toList();
  }

  static Future<void> insertEvent(Event event) async {
    final box = await openBox<Map>(eventsBoxName);
    await box.put(event.id, {
      'id': event.id,
      'title': event.title,
      'description': event.description,
      'type': event.type.name,
      'date_evenement': event.dateTime.toIso8601String(),
      'responsable_type': event.responsiblePerson,
      'attachment_id': null,
    });
  }

  static Future<List<SacristyReport>> getSacristyReportsByEvent(String eventId) async {
    final reports = await DatabaseHelper.instance.getSacristyReportsByEvent(eventId);
    return reports.map(SacristyReport.fromMap).toList();
  }

  static Future<void> insertSacristyReport(SacristyReport report) async {
    final box = await openBox<Map>('rapports');
    await box.put(report.id, report.toMap());
  }

  static Event _eventFromMap(Map<String, dynamic> map) {
    final rawType = (map['type'] ?? map['category'] ?? '').toString();
    final eventType = EventType.values.firstWhere(
      (value) => value.name.toLowerCase() == rawType.toLowerCase(),
      orElse: () => EventType.autre,
    );

    final date = DateTime.tryParse((map['date_evenement'] ?? map['dateTime'] ?? '').toString()) ??
        DateTime.now();

    return Event(
      id: map['id']?.toString() ?? 'evt_${date.millisecondsSinceEpoch}',
      title: map['title']?.toString() ?? map['titre']?.toString() ?? 'Événement',
      description: map['description']?.toString() ?? '',
      type: eventType,
      dateTime: date,
      responsiblePerson: map['responsable_type']?.toString(),
      category: map['niveau']?.toString(),
      location: map['entite_nom']?.toString(),
    );
  }
}
