import 'package:ecclesiaste/services/logging_service.dart';
import 'package:hive/hive.dart';
import 'package:ecclesiaste/services/hierarchy_seed_service.dart'; 
import 'package:ecclesiaste/config/kso_architecture_config.dart';
import 'package:ecclesiaste/models/church_report.dart';
import 'package:ecclesiaste/models/hierarchy_models.dart';
import 'package:ecclesiaste/models/app_settings.dart';
import 'package:ecclesiaste/models/member_profile.dart';
import 'package:ecclesiaste/models/person_model.dart';
import 'package:ecclesiaste/services/person_service.dart';

class DatabaseInitializer {
  static Future<void> seedInitialHierarchy() async {
    final entitesBox = await Hive.openBox<Map>('entites'); 

    if (entitesBox.isNotEmpty) {
      LoggingService.info('ℹ️ Hiérarchie déjà initialisée.');
      await seedInitialPersons();
      return;
    }

    LoggingService.info('🌱 Initialisation de la hiérarchie Ecclésiaste...');

    await HierarchySeedService.seedHierarchyAndCommissions(); 
    await _seedMockReports();
    await _seedMockEvents();
    await _seedDefaultSettings();
    await seedInitialPersons();
    LoggingService.info('✅ Structure internationale déployée.');
    await KsoArchitectureConfig.initializeCounts(); 
  }

  static Future<void> seedInitialPersons() async {
    final personsBox = await Hive.openBox<Person>('persons');
    if (personsBox.isNotEmpty) return;

    LoggingService.info('👤 Création des Dossiers Ecclésiastiques Uniques (DEU)...');
    
    final membersBox = await Hive.openBox<MemberProfile>('member_profiles');
    if (membersBox.isEmpty) return;

    for (var member in membersBox.values) {
      await PersonService.instance.createPersonFromMember(member);
    }
    
    LoggingService.info('✅ ${personsBox.length} DEU créés.');
  }

  static Future<void> _seedDefaultSettings() async {
    final box = await Hive.openBox<AppSettings>('settings_box');
    if (box.isEmpty) {
      await box.put('current', AppSettings(
        isDarkMode: false,
        language: 'fr',
        notificationsEnabled: true,
      ));
    }
  }

  static Future<void> _seedMockEvents() async {
    final eventsBox = await Hive.openBox<Map>('evenements_map');
    if (eventsBox.isNotEmpty) return;

    final mockEvents = [
      {
        'id': 'evt_001',
        'titre': 'Séminaire des Formateurs Jeunesse',
        'description': 'Séminaire intensif pour tous les moniteurs de la Jeunesse du Champ.',
        'type': 'special',
        'date_evenement': DateTime.now().add(const Duration(days: 10)).toIso8601String(),
        'responsable_type': 'commission',
        'commission_liee': 'Commission de la Jeunesse',
        'niveau': 'champ',
      },
      {
        'id': 'evt_002',
        'titre': 'Culte de la Jeunesse - District KSO 01',
        'description': 'Service Divin spécial pour les jeunes du district.',
        'type': 'mensuel',
        'date_evenement': DateTime.now().add(const Duration(days: 5)).toIso8601String(),
        'responsable_type': 'ministere',
        'commission_liee': 'Commission de la Jeunesse',
        'niveau': 'district',
      },
      {
        'id': 'evt_003',
        'titre': 'Répétition Générale Chorale',
        'description': 'Préparation pour la fête de la Pentecôte.',
        'type': 'special',
        'date_evenement': DateTime.now().add(const Duration(days: 3)).toIso8601String(),
        'responsable_type': 'commission',
        'commission_liee': 'Commission Musique',
        'niveau': 'communaute',
      },
    ];

    for (var e in mockEvents) {
      await eventsBox.put(e['id'], e);
    }
  }

  static Future<void> _seedMockReports() async {
    final reportsBox = await Hive.openBox<ChurchReport>('church_reports');
    if (reportsBox.isNotEmpty) return;

    final mockReports = [
      ChurchReport(
        id: 'rep_001',
        type: ReportTypeExt.serviceDivin,
        niveauEntite: EntityLevel.communaute,
        dateRapport: DateTime.now().subtract(const Duration(days: 1)),
        heureDebut: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        nomEntite: 'Communauté Lemba 01',
        nomDistrict: 'District KSO 01',
        nomChamp: 'Champ KSO',
        offrandeFC: 15000,
        presenceTotale: 120,
        statut: ReportStatus.soumis,
        rapporteur: 'Nestor Mbuyi',
        rapporteurId: 'USR_ROOT',
      ),
      ChurchReport(
        id: 'rep_002',
        type: ReportTypeExt.ecodim,
        niveauEntite: EntityLevel.communaute,
        dateRapport: DateTime.now().subtract(const Duration(days: 2)),
        heureDebut: DateTime.now().subtract(const Duration(days: 2, hours: 2)),
        nomEntite: 'Communauté Limete 02',
        nomDistrict: 'District KSO 02',
        nomChamp: 'Champ KSO',
        statut: ReportStatus.soumis,
        rapporteur: 'Caroline Lusimba',
        rapporteurId: 'USR_ROOT',
      ),
    ];

    for (var r in mockReports) {
      await reportsBox.put(r.id, r);
    }
  }
}
