import 'package:hive/hive.dart';
import '../models/library_document.dart';
import '../models/hierarchy_models.dart';

class LibrarySeedService {
  static Future<void> initialize() async {
    final box = Hive.box<LibraryDocument>('library_box');
    if (box.isNotEmpty) return;
    
    final documents = <LibraryDocument>[
      // 1. PENSÉES DIRECTRICES 2026
      LibraryDocument(
        id: 'pensees_2026',
        title: 'Pensées Directrices 2026 - "La prière agit!"',
        description: 'Recueil annuel destiné aux ministres ordonnés. Thème 2026: La prière agit! Édité par Jean-Luc Schneider.',
        type: DocumentType.penseesDirectrices,
        filePath: 'assets/library/pensees_2026.pdf',
        fileSize: 5242880,
        allowedCategories: [UserCategory.ministre, UserCategory.responsable],
        allowedLevels: EntityLevel.values.toList(),
        allowedCommissions: [CommissionType.none],
        author: 'Jean-Luc Schneider',
        version: '2026',
      ),
      
      // 2. MANUELS ECODIM
      LibraryDocument(
        id: 'programme_ecodim_2025_2026',
        title: 'Programme Unique Ecodim 2025-2026',
        description: 'Programme officiel de l\'École du Dimanche - 40 leçons. Commission Territoriale de l\'Enseignement.',
        type: DocumentType.programmeCommission,
        filePath: 'assets/library/programme_ecodim_2025_2026.pdf',
        fileSize: 2097152,
        allowedCategories: [UserCategory.membre, UserCategory.ministre, UserCategory.responsable],
        allowedLevels: EntityLevel.values.toList(),
        allowedCommissions: [CommissionType.ecodim],
        author: 'Commission Territoriale de l\'Enseignement',
        version: '2025-2026',
      ),
      
      LibraryDocument(
        id: 'cahier_moi_aussi',
        title: 'Cahier de l\'élève "Moi aussi..."',
        description: 'Cahier de travail pour les enfants de l\'École du Dimanche.',
        type: DocumentType.manuelCommission,
        filePath: 'assets/library/cahier_moi_aussi.pdf',
        fileSize: 1048576,
        allowedCategories: [UserCategory.membre, UserCategory.ministre, UserCategory.responsable],
        allowedLevels: EntityLevel.values.toList(),
        allowedCommissions: [CommissionType.ecodim],
      ),
      
      // 3. MANUELS CONFIRMATION
      LibraryDocument(
        id: 'cours_catechisme_maitre',
        title: 'Cours de Catéchisme - Livre du Maître',
        description: 'Manuel officiel du catéchiste - 29 leçons. 3e édition 2013.',
        type: DocumentType.manuelCommission,
        filePath: 'assets/library/cours_catechisme_prof.pdf',
        fileSize: 8388608,
        allowedCategories: [UserCategory.membre, UserCategory.ministre, UserCategory.responsable],
        allowedLevels: EntityLevel.values.toList(),
        allowedCommissions: [CommissionType.confirmation],
        author: 'Église néo-apostolique internationale',
        version: '3e édition 2013',
      ),
      
      LibraryDocument(
        id: 'cahier_confirmand',
        title: 'Cahier du Confirmand "Moi aussi..."',
        description: 'Cahier de travail pour les confirmands.',
        type: DocumentType.manuelCommission,
        filePath: 'assets/library/cahier_confirmand.pdf',
        fileSize: 1572864,
        allowedCategories: [UserCategory.membre, UserCategory.ministre, UserCategory.responsable],
        allowedLevels: EntityLevel.values.toList(),
        allowedCommissions: [CommissionType.confirmation],
      ),
      
      // 4. PROGRAMMES APOSTOLIQUES
      LibraryDocument(
        id: 'programme_ap_ngolo_avril_2026',
        title: 'Programme Apôtre NGOLO - Avril 2026',
        description: 'Programme officiel des activités de l\'Apôtre Emmanuel NGOLO WOTO.',
        type: DocumentType.programmeApostolique,
        filePath: 'assets/library/programme_ap_ngolo_avril_2026.pdf',
        fileSize: 524288,
        allowedCategories: [UserCategory.membre, UserCategory.ministre, UserCategory.responsable],
        allowedLevels: [EntityLevel.champ, EntityLevel.district, EntityLevel.communaute],
        allowedCommissions: [CommissionType.none],
        author: 'Apôtre Emmanuel NGOLO WOTO',
        version: 'Avril 2026',
      ),
      
      // 5. PROGRAMME JEUNESSE
      LibraryDocument(
        id: 'programme_jeunesse_2026',
        title: 'Programme de la Jeunesse KSO 2026',
        description: 'Programme annuel des activités de la Commission Locale de la Jeunesse KSO.',
        type: DocumentType.programmeCommission,
        filePath: 'assets/library/programme_jeunesse_2026.pdf',
        fileSize: 786432,
        allowedCategories: [UserCategory.membre, UserCategory.ministre, UserCategory.responsable],
        allowedLevels: [EntityLevel.champ, EntityLevel.district, EntityLevel.communaute],
        allowedCommissions: [CommissionType.jeunesse],
        author: 'Commission Locale de la Jeunesse KSO',
        version: '2026',
      ),
      
      // 6. DIRECTIVES OFFICIELLES
      LibraryDocument(
        id: 'directives_ministres_v3',
        title: 'Directives à l\'usage des ministres (v3)',
        description: 'Directives officielles régissant la vie de l\'Église.',
        type: DocumentType.directives,
        filePath: 'assets/library/directives_ministres_v3.pdf',
        fileSize: 3145728,
        allowedCategories: [UserCategory.ministre, UserCategory.responsable],
        allowedLevels: EntityLevel.values.toList(),
        allowedCommissions: [CommissionType.none],
        version: 'v3',
      ),
      
      // 7. CANTIQUES
      LibraryDocument(
        id: 'recueil_cantiques',
        title: 'Recueil de Cantiques',
        description: 'Recueil officiel des cantiques de l\'Église Néo-Apostolique.',
        type: DocumentType.cantiques,
        filePath: 'assets/library/recueil_cantiques.pdf',
        fileSize: 10485760,
        allowedCategories: [UserCategory.membre, UserCategory.ministre, UserCategory.responsable],
        allowedLevels: EntityLevel.values.toList(),
        allowedCommissions: [CommissionType.none, CommissionType.musique],
      ),
      
      // 8. FORMULAIRES DE RAPPORTS
      LibraryDocument(
        id: 'formulaire_rapport_ecodim',
        title: 'Formulaire de Rapport Ecodim',
        description: 'Formulaire officiel pour le rapport mensuel de l\'École du Dimanche.',
        type: DocumentType.formulaire,
        filePath: 'assets/library/formulaire_rapport_ecodim.pdf',
        fileSize: 262144,
        allowedCategories: [UserCategory.responsable],
        allowedLevels: [EntityLevel.communaute, EntityLevel.district],
        allowedCommissions: [CommissionType.ecodim],
      ),
      
      LibraryDocument(
        id: 'formulaire_rapport_confirmation',
        title: 'Formulaire de Rapport Confirmation',
        description: 'Formulaire officiel pour le rapport de catéchèse.',
        type: DocumentType.formulaire,
        filePath: 'assets/library/formulaire_rapport_confirmation.pdf',
        fileSize: 262144,
        allowedCategories: [UserCategory.responsable],
        allowedLevels: [EntityLevel.communaute, EntityLevel.district],
        allowedCommissions: [CommissionType.confirmation],
      ),
      
      // 9. DOCUMENTS DE FORMATION
      LibraryDocument(
        id: 'formation_moniteurs_ecodim',
        title: 'Guide de Formation des Moniteurs Ecodim',
        description: 'Manuel de formation pour les moniteurs de l\'École du Dimanche.',
        type: DocumentType.formation,
        filePath: 'assets/library/formation_moniteurs_ecodim.pdf',
        fileSize: 2097152,
        allowedCategories: [UserCategory.ministre, UserCategory.responsable],
        allowedLevels: EntityLevel.values.toList(),
        allowedCommissions: [CommissionType.ecodim],
      ),
      
      LibraryDocument(
        id: 'formation_catechistes',
        title: 'Guide de Formation des Catéchistes',
        description: 'Manuel de formation pour les catéchistes.',
        type: DocumentType.formation,
        filePath: 'assets/library/formation_catechistes.pdf',
        fileSize: 2621440,
        allowedCategories: [UserCategory.ministre, UserCategory.responsable],
        allowedLevels: EntityLevel.values.toList(),
        allowedCommissions: [CommissionType.confirmation],
      ),
    ];

    await box.addAll(documents);
  }
}
