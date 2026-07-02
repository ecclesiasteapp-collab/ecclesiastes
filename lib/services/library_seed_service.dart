import 'package:hive/hive.dart';
import '../models/library_document.dart';
import '../models/hierarchy_models.dart';

class LibrarySeedService {
  static Future<void> initialize() async {
    final box = Hive.box<LibraryDocument>('library_box');
    if (box.isNotEmpty) return;
    
    final documents = <LibraryDocument>[
      // 1. Documents ministres
      LibraryDocument(
        id: 'directives_ministres_inter',
        title: 'Directives à l\'usage des ministres',
        description: 'Document officiel contenant les directives et instructions pour les ministres de l’Église.',
        type: DocumentType.directives,
        filePath: 'assets/ministre/documents/Directives ministres.pdf',
        fileSize: 4500000,
        allowedCategories: [UserCategory.ministre, UserCategory.responsable],
        allowedLevels: EntityLevel.values.toList(),
        allowedCommissions: [CommissionType.none],
        author: 'Administration Internationale',
        version: '2026',
        isConfidential: true,
      ),
      LibraryDocument(
        id: 'pensees_2026',
        title: 'Pensées Directrices 2026',
        description: 'Recueil annuel destiné aux ministres ordonnés. Édité par l’Apôtre Patriarche.',
        type: DocumentType.penseesDirectrices,
        filePath: 'assets/ministre/documents/Pensées directrices 2026.pdf',
        fileSize: 5242880,
        allowedCategories: [UserCategory.ministre, UserCategory.responsable],
        allowedLevels: EntityLevel.values.toList(),
        allowedCommissions: [CommissionType.none],
        author: 'Apôtre Patriarche',
        version: '2026',
      ),

      // 2. Commissions
      LibraryDocument(
        id: 'programme_ecodim_2025_2026',
        title: 'Programme Unique Ecodim 2025-2026',
        description: 'Programme officiel de l\'École du Dimanche. Commission de l\'Enseignement.',
        type: DocumentType.programmeCommission,
        filePath: 'assets/commissions/documents/programme unique 2025-2026 ECODIM.pdf',
        fileSize: 2097152,
        allowedCategories: [UserCategory.membre, UserCategory.ministre, UserCategory.responsable],
        allowedLevels: EntityLevel.values.toList(),
        allowedCommissions: [CommissionType.ecodim],
        author: 'Commission de l\'Enseignement',
        version: '2025-2026',
      ),

      // 3. Membres
      LibraryDocument(
        id: 'cours_catechisme_prof',
        title: 'Cours de catéchisme',
        description: 'Support de référence pour le catéchisme.',
        type: DocumentType.manuelCommission,
        filePath: 'assets/membre/documents/Cours Catechisme.pdf',
        fileSize: 3000000,
        allowedCategories: [UserCategory.membre, UserCategory.ministre, UserCategory.responsable],
        allowedLevels: EntityLevel.values.toList(),
        allowedCommissions: [CommissionType.ecodim, CommissionType.econfi],
      ),
      LibraryDocument(
        id: 'recueil_cantiques',
        title: 'Recueil de Cantiques',
        description: 'Recueil officiel des cantiques de l\'Église.',
        type: DocumentType.cantiques,
        filePath: 'assets/membre/documents/Recueil de cantiques.pdf',
        fileSize: 10485760,
        allowedCategories: [UserCategory.membre, UserCategory.ministre, UserCategory.responsable],
        allowedLevels: EntityLevel.values.toList(),
        allowedCommissions: [CommissionType.none, CommissionType.musique],
      ),
    ];

    await box.addAll(documents);
  }
}

