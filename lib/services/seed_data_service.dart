import 'package:hive/hive.dart';
import '../models/isar/event.dart';
import '../models/catechism_lesson.dart';
import '../models/confirmation_lesson.dart';
import '../models/ecodim_lesson.dart';
import '../models/hierarchy_models.dart';
import '../models/commission_node.dart';
import '../models/user.dart';
import '../models/news_model.dart';
import '../models/library_document.dart';
import '../models/member_profile.dart';
import '../utils/password_utils.dart';

import '../models/meeting_report.dart';
import '../services/report_service.dart';

class SeedDataService {
  static Future<void> initializeSystem() async {
    final userBox = Hive.box<User>('users');
    const adminEmail = 'superadmin@ecclesiastes.rdc';
    const adminId = 'admin_root_001';
    
    if (userBox.get(adminId) == null) {
      final superAdmin = User(
        id: adminId,
        fullName: 'Nestor Mbuyi Kankolongo',
        email: adminEmail,
        passwordHash: hashPassword('Admin@2026!RDC'), 
        role: UserRole.superAdmin,
        isActive: true,
      );
      await userBox.put(superAdmin.id, superAdmin);
    }
  }

  static Future<void> initializeNews() async {
    final box = Hive.box<News>('news');
    if (box.isEmpty) {
      await box.addAll([
        News(id: '1', title: 'Préparation Journée de la Jeunesse KSO', imageUrl: 'https://picsum.photos/400/300?random=1', content: 'Préparez-vous pour le grand événement de la jeunesse.', date: DateTime.now()),
        News(id: '2', title: 'Visite de l\'Apôtre-Patriarche à KSO', imageUrl: 'https://picsum.photos/400/300?random=2', content: 'Une visite historique pour notre champ.', date: DateTime.now()),
        News(id: '3', title: 'Nouveau Programme Ecodim 2026', imageUrl: 'https://picsum.photos/400/300?random=3', content: 'Le nouveau manuel est disponible.', date: DateTime.now()),
      ]);
    }
  }

  static Future<void> initializeHierarchy() async {
    final commissionBox = Hive.box<CommissionNode>('commissions_box');
    if (commissionBox.isNotEmpty) return;

    final comInternationale = CommissionNode(id: 'com_int_01', type: CommissionType.ecodim, level: EntityLevel.internationale, entityId: 'INT_NAC');
    final comTerritoriale = CommissionNode(id: 'com_ter_01', type: CommissionType.ecodim, level: EntityLevel.territoriale, entityId: 'RDC_OUEST', parentId: comInternationale.id);
    final comChamp = CommissionNode(id: 'com_chp_01', type: CommissionType.ecodim, level: EntityLevel.champ, entityId: 'KSO', parentId: comTerritoriale.id);
    final comDistrict = CommissionNode(id: 'com_dis_01', type: CommissionType.ecodim, level: EntityLevel.district, entityId: 'DIST_TSHIKAPA', parentId: comChamp.id);
    final comCommunaute = CommissionNode(id: 'com_com_01', type: CommissionType.ecodim, level: EntityLevel.communaute, entityId: 'CTE_JEREMIE', parentId: comDistrict.id);

    await commissionBox.addAll([comInternationale, comTerritoriale, comChamp, comDistrict, comCommunaute]);
  }

  static Future<void> initialize() async {
    await initializeSystem();
    await initializeHierarchy();
    await initializeNews();
    
    final eventBox = Hive.box<Event>('events_box');
    final catechismBox = Hive.box<CatechismLesson>('catechism_lessons');
    final catLessonBox = Hive.box<ConfirmationLesson>('cat_lessons');
    final ecoLessonBox = Hive.box<EcodimLesson>('eco_lessons');
    final libBox = Hive.box<LibraryDocument>('library_box');
    final memberBox = Hive.box<MemberProfile>('member_profiles');

    if (eventBox.isEmpty) await _boxAddEvents(eventBox);
    if (catechismBox.isEmpty) await _boxAddCatechism(catechismBox);
    if (catLessonBox.isEmpty) await _boxAddConfirmation(catLessonBox);
    if (ecoLessonBox.isEmpty) await _boxAddEcodim(ecoLessonBox);
    if (libBox.isEmpty) await _populateLibrary(libBox);
    if (memberBox.isEmpty) await _populateMembers(memberBox);
    
    // Rapports
    await _populateSampleReports();
  }

  static Future<void> _populateSampleReports() async {
    final service = ReportService();
    final count = await service.getReportCount();
    if (count == 0) {
      final r1 = MeetingReport(
        id: 'rep_001',
        title: 'Rapport mensuel Jeunesse - Mars',
        author: 'Pr. Didier KUYINDAMA',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      );
      r1.meetingObject = 'Planification des activités du 2ème trimestre';
      r1.presentees = ['Membre A', 'Membre B', 'Membre C'];
      r1.isCompleted = true;
      await service.createReport(r1);

      final r2 = MeetingReport(
        id: 'rep_002',
        title: 'Rapport de visite District UPN',
        author: 'Responsable UPN',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      );
      r2.meetingObject = 'Audit administratif annuel';
      r2.isCompleted = false;
      await service.createReport(r2);
    }
  }

  static Future<void> _boxAddEvents(Box<Event> box) async {
    final events = <Event>[
      Event(id: 'eco_01', title: 'Reprise Ecodim (Passation)', description: 'Ouverture de l\'année', dateTime: DateTime(2025, 5, 18), type: EventType.ecodim, category: 'ECODIM'),
      Event(id: 'eco_02', title: 'Dieu crée le monde', description: 'Genèse 1 - Pages 16-20', dateTime: DateTime(2025, 5, 25), type: EventType.ecodim, category: 'ECODIM'),
      Event(id: 'ap_01', title: 'SD Vendredi Saint', description: '6H/17H - Toutes Ctes KSO', dateTime: DateTime(2026, 4, 3), type: EventType.apotre, category: 'APOTRE'),
      Event(id: 'ap_02', title: 'SD Pâques & St-Scellé Tshikapa', description: '10H00', dateTime: DateTime(2026, 4, 5), type: EventType.apotre, category: 'APOTRE'),
    ];
    await box.addAll(events);
  }

  static Future<void> _boxAddCatechism(Box<CatechismLesson> box) async {
    final lessons = [
      CatechismLesson(id: 1, title: 'Le cours de catéchisme', goal: 'Responsabilité de sa foi', moiAussi: 'Vivre sciemment ma foi'),
      CatechismLesson(id: 29, title: 'La Confirmation', goal: 'Prononcer le vœu de fidélité', moiAussi: 'Respecter mon vœu de confirmation', isVow: true),
    ];
    await box.addAll(lessons);
  }

  static Future<void> _boxAddConfirmation(Box<ConfirmationLesson> box) async {
    await box.add(ConfirmationLesson(
      lessonNumber: 1, title: 'Le cours de catéchisme', objective: 'Sens de la confirmation', contentSummary: 'Responsabilité de sa foi',
      resolutionMoiAussi: 'Vivre sciemment ma foi !', bibleVerses: ['Jean 14:6'],
    ));
  }

  static Future<void> _boxAddEcodim(Box<EcodimLesson> box) async {
    await box.add(EcodimLesson(id: 'eco_01', date: DateTime(2025, 5, 25), title: 'Dieu crée le monde', bibleText: 'Genèse 1', pages: '16-20'));
  }

  static Future<void> _populateLibrary(Box<LibraryDocument> box) async {
    final docs = [
      LibraryDocument(
        id: 'pensees_2026', title: 'Pensées Directrices 2026', description: 'Thème: La prière agit!', 
        type: DocumentType.penseesDirectrices, filePath: 'assets/library/pensees_2026.pdf', fileSize: 500000,
        allowedCategories: [UserCategory.ministre], allowedLevels: EntityLevel.values.toList(), allowedCommissions: [CommissionType.none]
      ),
      LibraryDocument(
        id: 'directives_v3', title: 'Directives Ministres v3', description: 'Règles de l\'église', 
        type: DocumentType.directives, filePath: 'assets/library/directives_ministres_v3.pdf', fileSize: 300000,
        allowedCategories: [UserCategory.responsable], allowedLevels: EntityLevel.values.toList(), allowedCommissions: [CommissionType.none]
      ),
    ];
    await box.addAll(docs);
  }

  static Future<void> _populateMembers(Box<MemberProfile> box) async {
    // Membre de test
  }
}
