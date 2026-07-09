import 'package:hive_flutter/hive_flutter.dart';
import '../models/church_report.dart';
import '../models/notification_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  factory DatabaseHelper() => instance;
  DatabaseHelper._internal();

  Future<dynamic> get database async => null;

  // --- MEMBRES ---
  Future<List<Map<String, dynamic>>> getMembresEnAttente({String? communauteId}) async {
    final box = await Hive.openBox<Map>('membres');
    return box.values
        .where((m) => m['statut_validation'] == 0 && (communauteId == null || m['communaute_id'] == communauteId))
        .map((m) => Map<String, dynamic>.from(m))
        .toList();
  }

  Future<void> validerMembre(String id) async {
    final box = await Hive.openBox<Map>('membres');
    final membre = box.get(id);
    if (membre != null) {
      final updated = Map<String, dynamic>.from(membre);
      updated['statut_validation'] = 1;
      await box.put(id, updated);
    }
  }

  Future<void> supprimerMembre(String id) async {
    final box = await Hive.openBox<Map>('membres');
    await box.delete(id);
  }

  Future<void> insertMembre(Map<String, dynamic> data) async {
    final box = await Hive.openBox<Map>('membres');
    await box.put(data['id'], data);
  }

  Future<void> transfererMembre(String membreId, String nouveauDistrictId, String nouvelleCommunauteId, String commOrigine) async {
    final box = await Hive.openBox<Map>('membres');
    final membre = box.get(membreId);
    if (membre != null) {
      final updated = Map<String, dynamic>.from(membre);
      updated['communaute_id'] = nouvelleCommunauteId;
      await box.put(membreId, updated);
    }
  }

  // --- UTILISATEURS ---
  Future<List<Map<String, dynamic>>> getUtilisateursEnAttente({String? entiteId}) async {
    final box = await Hive.openBox<Map>('utilisateurs');
    return box.values
        .where((u) => u['est_valide'] == 0 && (entiteId == null || u['entite_id'] == entiteId))
        .map((u) => Map<String, dynamic>.from(u))
        .toList();
  }

  Future<void> validerUtilisateur(String id) async {
    final box = await Hive.openBox<Map>('utilisateurs');
    final user = box.get(id);
    if (user != null) {
      final updated = Map<String, dynamic>.from(user);
      updated['est_valide'] = 1;
      await box.put(id, updated);
    }
  }

  Future<void> supprimerUtilisateur(String id) async {
    final box = await Hive.openBox<Map>('utilisateurs');
    await box.delete(id);
  }

  Future<Map<String, dynamic>?> getUtilisateurByIdentifiant(String identifiant) async {
    final box = await Hive.openBox<Map>('utilisateurs');
    try {
      final found = box.values.cast<Map>().firstWhere((u) => u['identifiant'] == identifiant, orElse: () => {});
      return found.isEmpty ? null : Map<String, dynamic>.from(found);
    } catch (e) {
      return null;
    }
  }

  Future<void> mettreAJourMotDePasse(String id, String hashed) async {
    final box = await Hive.openBox<Map>('utilisateurs');
    final user = box.get(id);
    if (user != null) {
      final updated = Map<String, dynamic>.from(user);
      updated['mot_de_passe'] = hashed;
      await box.put(id, updated);
    }
  }

  Future<Map<String, dynamic>?> getUserById(String id) async {
    final box = await Hive.openBox<Map>('utilisateurs');
    final data = box.get(id);
    if (data != null) {
      return Map<String, dynamic>.from(data);
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUtilisateur(String id) async {
    // Alias for getUserById for compatibility
    return getUserById(id);
  }

  // --- ANNONCES ---
  Future<List<Map<String, dynamic>>> getAnnoncesRecent() async {
    final box = await Hive.openBox<Map>('annonces');
    final list = box.values.map((a) => Map<String, dynamic>.from(a)).toList();
    list.sort((a, b) => (b['date_publication'] ?? '').compareTo(a['date_publication'] ?? ''));
    return list;
  }

  Future<void> insertAnnonce(Map<String, dynamic> data) async {
    final box = await Hive.openBox<Map>('annonces');
    await box.put(data['id'], data);
  }

  // --- ENTITES ---
  Future<List<Map<String, dynamic>>> getAllEntites() async {
    final box = await Hive.openBox<Map>('entites');
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<Map<String, dynamic>?> getEntiteById(String id) async {
    final box = await Hive.openBox<Map>('entites');
    final data = box.get(id);
    return data == null ? null : Map<String, dynamic>.from(data);
  }

  Future<void> insertEntite({required String id, required String nom, required String type, String? parentId}) async {
    final box = await Hive.openBox<Map>('entites');

    // Vérifier l'unicité de l'Église Internationale
    if (type == 'INTERNATIONALE') { // Utilisation de la chaîne en dur pour éviter les problèmes d'import si EntiteTypes n'est pas dispo
      final existingInternational = box.values.any((e) => e['type'] == 'INTERNATIONALE');
      if (existingInternational) {
        throw Exception("Une seule entité de type 'Internationale' est autorisée.");
      }
    }

    await box.put(id, {
      'id': id,
      'nom': nom,
      'type': type,
      'parent_id': parentId,
    });
  }

  Future<List<Map<String, dynamic>>> getMembresValides({String? commission, String? communauteId}) async {
    final box = await Hive.openBox<Map>('membres');
    return box.values
        .where((m) => m['statut_validation'] == 1 &&
                      (commission == null || m['commission'] == commission) &&
                      (communauteId == null || m['communaute_id'] == communauteId))
        .map((m) => Map<String, dynamic>.from(m))
        .toList();
  }

  // --- COMMISSIONS ---
  Future<List<Map<String, dynamic>>> getCommissionResponsables({
    String? entiteId,
    String? districtId,
    String? commissionType,
  }) async {
    final box = await Hive.openBox<Map>('commissions_map');
    final items = box.values
        .map((item) => Map<String, dynamic>.from(item))
        .where((item) {
      final matchesEntite =
          entiteId == null || item['entite_id']?.toString() == entiteId;
      final matchesDistrict =
          districtId == null || item['district_id']?.toString() == districtId;
      final matchesCommission = commissionType == null ||
          item['commission_type']?.toString() == commissionType;
      return matchesEntite && matchesDistrict && matchesCommission;
    }).toList();

    items.sort((a, b) => (a['commission_nom'] ?? '')
        .toString()
        .compareTo((b['commission_nom'] ?? '').toString()));
    return items;
  }

  Future<void> upsertCommissionResponsable(Map<String, dynamic> data) async {
    final box = await Hive.openBox<Map>('commissions_map');
    final id = data['id']?.toString() ??
        'comm_${DateTime.now().millisecondsSinceEpoch}';
    final payload = Map<String, dynamic>.from(data);
    payload['id'] = id;
    await box.put(id, payload);
  }

  Future<List<Map<String, dynamic>>> getEglisesTerritoriales() async {
    final box = await Hive.openBox<Map>('entites');
    return box.values.where((e) => e['type'] == 'EGLISE_TERRITORIALE').map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<List<Map<String, dynamic>>> getRegionsApostoliques([String? territorialId]) async {
    final box = await Hive.openBox<Map>('entites');
    return box.values
        .where((e) => e['type'] == 'REGION_APOSTOLIQUE' && (territorialId == null || e['parent_id'] == territorialId))
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getChampsApostoliques([String? regionId]) async {
    final box = await Hive.openBox<Map>('entites');
    return box.values
        .where((e) => e['type'] == 'CHAMP_APOSTOLIQUE' && (regionId == null || e['parent_id'] == regionId))
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getDistricts({String? champId}) async {
    final box = await Hive.openBox<Map>('entites');
    return box.values
        .where((e) => e['type'] == 'DISTRICT' && (champId == null || e['parent_id'] == champId))
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getCommunautesByDistrict(String districtId) async {
    final box = await Hive.openBox<Map>('entites');
    return box.values
        .where((e) => e['type'] == 'COMMUNAUTE' && e['parent_id'] == districtId)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getCommissionsByEntity(String entityId) async {
    final box = await Hive.openBox<Map>('commissions_map');
    return box.values
        .where((c) => c['entite_id'] == entityId)
        .map((c) => Map<String, dynamic>.from(c))
        .toList();
  }

  // --- BIBLIOTHEQUE ---
  Future<List<Map<String, dynamic>>> getBibliotheque({String? entiteId, String? commission, String? niveau}) async {
    final box = await Hive.openBox<Map>('bibliotheque');
    return box.values
        .map((d) => Map<String, dynamic>.from(d))
        .where((d) =>
            (entiteId == null || d['entite_id'] == entiteId) &&
            (commission == null || d['commission'] == commission) &&
            (niveau == null || d['niveau'] == niveau))
        .toList();
  }

  Future<void> insertDocument(Map<String, dynamic> data) async {
    final box = await Hive.openBox<Map>('bibliotheque');
    final documentId = data['id']?.toString() ??
        'doc_${DateTime.now().millisecondsSinceEpoch}';
    final payload = Map<String, dynamic>.from(data);
    payload['id'] = documentId;
    await box.put(documentId, payload);
  }

  Future<void> deleteDocument(dynamic id) async {
    final box = await Hive.openBox<Map>('bibliotheque');
    await box.delete(id);
  }

  // --- EVENEMENTS ---
  Future<List<Map<String, dynamic>>> getEvenements() async {
    final box = await Hive.openBox<Map>('evenements_map');
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<List<Map<String, dynamic>>> getProgrammes({
    String? entiteId,
    String? niveau,
    String? responsableType,
    String? commissionLiee,
  }) async {
    final box = await Hive.openBox<Map>('evenements_map');
    final items = box.values
        .map((item) => Map<String, dynamic>.from(item))
        .where((item) {
      final matchesEntite =
          entiteId == null || item['entite_id']?.toString() == entiteId;
      final matchesNiveau =
          niveau == null || item['niveau']?.toString() == niveau;
      final matchesResponsableType = responsableType == null ||
          item['responsable_type']?.toString() == responsableType;
      final matchesCommission = commissionLiee == null ||
          item['commission_liee']?.toString() == commissionLiee;
      return matchesEntite &&
          matchesNiveau &&
          matchesResponsableType &&
          matchesCommission;
    }).toList();

    items.sort((a, b) => (a['date_evenement'] ?? '')
        .toString()
        .compareTo((b['date_evenement'] ?? '').toString()));
    return items;
  }

  Future<void> insertEvenement(Map<String, dynamic> data) async {
    final box = await Hive.openBox<Map>('evenements_map');
    final eventId = data['id']?.toString() ??
        'evt_${DateTime.now().millisecondsSinceEpoch}';
    final payload = Map<String, dynamic>.from(data);
    payload['id'] = eventId;
    await box.put(eventId, payload);
  }

  Future<List<Map<String, dynamic>>> getAnniversairesDuJour([String? dateStr]) async {
    return [];
  }

  Future<List<Map<String, dynamic>>> getSacristyReportsByEvent(String eventId) async {
    final box = await Hive.openBox<Map>('rapports');
    return box.values.where((r) => r['eventId'] == eventId && r['type'] == ReportTypeExt.sacristie.index).map((r) => Map<String, dynamic>.from(r)).toList();
  }

  Future<List<Map<String, dynamic>>> getReportsByAuthor(String authorId) async {
    final box = await Hive.openBox<Map>('rapports');
    return box.values.where((r) => r['rapporteurId'] == authorId).map((r) => Map<String, dynamic>.from(r)).toList();
  }

  Future<Map<String, dynamic>?> getReportById(String reportId) async {
    final box = await Hive.openBox<Map>('rapports');
    final report = box.get(reportId);
    return report != null ? Map<String, dynamic>.from(report) : null;
  }

  Future<List<Map<String, dynamic>>> getReportsByStatus(String status, {String? supervisingEntityId}) async {
    final box = await Hive.openBox<Map>('rapports');
    
    return box.values
        .where((report) {
          final isStatusMatch = report['status'] == status;
          if (!isStatusMatch) return false;

          // Si aucun ID de supervision n'est fourni, on retourne tous les rapports avec le bon statut (comportement admin)
          if (supervisingEntityId == null) return true;

          // Logique de supervision : le rapport doit provenir d'une entité directement supervisée.
          // Exemple : un responsable de district (entityId) voit les rapports de ses communautés (report['parentId']).
          // Cette logique suppose que le rapport contient l'ID de l'entité parente.
          final reportParentId = report['parentEntityId']?.toString();
          return reportParentId == supervisingEntityId;
        })
        .map((r) => Map<String, dynamic>.from(r))
        .toList();
  }

  // --- FINANCES ---
  Future<void> insertFinances(Map<String, dynamic> data) async {
    final box = await Hive.openBox<Map>('finances');
    await box.put(DateTime.now().millisecondsSinceEpoch.toString(), data);
  }

  Future<List<Map<String, dynamic>>> getJournalFinancier({String? entiteId}) async {
    final box = await Hive.openBox<Map>('finances');
    return box.values
        .where((f) => entiteId == null || f['entite_id'] == entiteId)
        .map((f) => Map<String, dynamic>.from(f))
        .toList();
  }

  // --- STATISTIQUES ---
  Future<Map<String, int>> getStatsCommissions({String? communauteId, String? districtId}) async {
    return {};
  }

  Future<Map<String, int>> getStatsSacrements({String? communauteId, String? districtId}) async {
    return {};
  }

  Future<Map<String, int>> getStatsRetraite({String? communauteId, String? entiteId}) async {
    return {};
  }

  Future<int> getUnvalidatedCount({String? communauteId}) async {
    final membres = await getMembresEnAttente(communauteId: communauteId);
    final users = await getUtilisateursEnAttente(entiteId: communauteId);
    return membres.length + users.length;
  }

  // --- KPI / SUPER ADMIN ---
  Future<int> getTotalUsers() async {
    final box = await Hive.openBox<Map>('utilisateurs');
    return box.length;
  }

  Future<int> getTotalMembers() async {
    final box = await Hive.openBox<Map>('membres');
    return box.length;
  }

  Future<int> getTotalEntities() async {
    final box = await Hive.openBox<Map>('entites');
    return box.length;
  }

  Future<Map<String, int>> getMembersByCommission() async {
    final box = await Hive.openBox<Map>('membres');
    final out = <String, int>{};

    for (final raw in box.values) {
      final commission = raw['commission']?.toString().trim();
      if (commission == null || commission.isEmpty) continue;
      out[commission] = (out[commission] ?? 0) + 1;
    }

    return out;
  }

  Future<Map<String, int>> getEntitiesByTypeDistribution() async {
    final box = await Hive.openBox<Map>('entites');
    final out = <String, int>{};

    for (final raw in box.values) {
      final type = raw['type']?.toString().trim();
      if (type == null || type.isEmpty) continue;
      out[type] = (out[type] ?? 0) + 1;
    }

    return out;
  }

  Future<Map<String, int>> getGovernanceStatus() async {
    final entitesBox = await Hive.openBox<Map>('entites');
    final usersBox = await Hive.openBox<Map>('utilisateurs');

    var vacants = 0;
    for (final e in entitesBox.values) {
      final responsableId = e['responsable_id']?.toString();
      if (responsableId == null || responsableId.isEmpty) {
        vacants += 1;
      }
    }

    var interims = 0;
    for (final u in usersBox.values) {
      final isInterim = u['is_interim'] == true;
      final role = u['entity_role']?.toString();
      if (isInterim && role == 'responsable') {
        interims += 1;
      }
    }

    return {
      'Vacants': vacants,
      'Intérims': interims,
    };
  }

  Future<Map<String, int>> getSecurityStats() async {
    final usersBox = await Hive.openBox<Map>('utilisateurs');

    var suspended = 0;
    var pending = 0;
    for (final u in usersBox.values) {
      final status = u['status']?.toString();
      if (status == 'suspended') suspended += 1;
      if (status == 'pending') pending += 1;
    }

    return {
      'Suspendus': suspended,
      'En attente': pending,
    };
  }

  Future<int> getActiveDelegationsCount() async {
    final usersBox = await Hive.openBox<Map>('utilisateurs');

    var count = 0;
    for (final u in usersBox.values) {
      final perms = u['delegated_permissions'];
      if (perms is List && perms.isNotEmpty) {
        count += 1;
      }
    }

    return count;
  }

  Future<void> compactAll() async {
    // Hive compacte par box. On le fait sur les boîtes principales.
    final boxes = await Future.wait([
      Hive.openBox<Map>('membres'),
      Hive.openBox<Map>('utilisateurs'),
      Hive.openBox<Map>('entites'),
      Hive.openBox<Map>('commissions_map'),
      Hive.openBox<Map>('rapports'),
      Hive.openBox<Map>('evenements_map'),
    ]);

    for (final b in boxes) {
      await b.compact();
      await b.flush();
    }
  }

  Future<void> insertDirective(Map<String, dynamic> data) async {
    final box = await Hive.openBox<Map>('directives');
    final id = data['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
    final payload = Map<String, dynamic>.from(data);
    payload['id'] = id;
    await box.put(id, payload);
  }

  Future<Map<String, int>> getEntiteCounts({String? champId}) async {
    final entitesBox = await Hive.openBox<Map>('entites');
    final membresBox = await Hive.openBox<Map>('membres');
    final usersBox = await Hive.openBox<Map>('utilisateurs');

    final allEntites = entitesBox.values.map((e) => Map<String, dynamic>.from(e)).toList();

    final List<String> districtIds;
    final List<String> communauteIds;

    if (champId != null) {
      districtIds = allEntites
          .where((e) => e['type'] == 'DISTRICT' && e['parent_id'] == champId)
          .map((e) => e['id'] as String)
          .toList();
      
      communauteIds = allEntites
          .where((e) => e['type'] == 'COMMUNAUTE' && districtIds.contains(e['parent_id']))
          .map((e) => e['id'] as String)
          .toList();
    } else {
      districtIds = [];
      communauteIds = [];
    }

    final membresCount = membresBox.values.where((m) => communauteIds.contains(m['communaute_id'])).length;
    final ministresCount = usersBox.values.where((u) => communauteIds.contains(u['entite_id'])).length;

    return {
      'districts': districtIds.length,
      'communautes': communauteIds.length,
      'membres': membresCount,
      'ministres': ministresCount,
    };
  }

  // --- ENTITE SCOPE HELPERS ---
  Future<List<Map<String, dynamic>>> getChaineAncestres(String entiteId) async {
    final box = await Hive.openBox<Map>('entites');
    final List<Map<String, dynamic>> chain = [];
    String? currentId = entiteId;

    while (currentId != null) {
      final e = box.get(currentId);
      if (e == null) break;
      final map = Map<String, dynamic>.from(e);
      chain.add(map);
      currentId = map['parent_id']?.toString();
    }
    return chain;
  }

  Future<List<Map<String, dynamic>>> getEntitesByType(String type) async {
    final box = await Hive.openBox<Map>('entites');
    return box.values
        .where((e) => e['type'] == type)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getSubEntites(String? parentId, String type) async {
    final box = await Hive.openBox<Map>('entites');
    return box.values
        .where((e) => (parentId == null || e['parent_id']?.toString() == parentId) && e['type'] == type)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getAllUtilisateurs() async {
    final box = await Hive.openBox<Map>('utilisateurs');
    return box.values
        .map((u) => Map<String, dynamic>.from(u))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getAllEvents() async {
    final box = await Hive.openBox<Map>('evenements_map');
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> updateUtilisateur(String id, Map<String, dynamic> data) async {
    final box = await Hive.openBox<Map>('utilisateurs');
    final payload = Map<String, dynamic>.from(data);
    payload['id'] = id;
    await box.put(id, payload);
  }

  Future<void> updateEntite(String id, Map<String, dynamic> data) async {
    final box = await Hive.openBox<Map>('entites');
    final payload = Map<String, dynamic>.from(data);
    payload['id'] = id;
    await box.put(id, payload);
  }

  Future<void> deleteEntite(String id) async {
    final box = await Hive.openBox<Map>('entites');
    await box.delete(id);
  }

  Future<void> rejectReport(String reportId, String reason) async {
    final box = await Hive.openBox<Map>('rapports');
    final report = box.get(reportId);
    if (report != null) {
      final updatedReport = Map<String, dynamic>.from(report);
      updatedReport['status'] = 'rejete';
      updatedReport['rejectionReason'] = reason;
      updatedReport['rejectionDate'] = DateTime.now().toIso8601String();

      // Créer une notification pour l'auteur du rapport
      final authorId = report['rapporteurId'];
      if (authorId != null) {
        await createNotification(
          userId: authorId,
          title: 'Rapport Rejeté',
          message: 'Votre rapport "${report['type']}" a été rejeté. Motif : $reason',
          relatedObjectId: reportId,
          relatedObjectType: 'report',
        );
      }

      await box.put(reportId, updatedReport);
    }
  }

  Future<void> validateReport(String reportId) async {
    final box = await Hive.openBox<Map>('rapports');
    final report = box.get(reportId);
    if (report != null) {
      final updatedReport = Map<String, dynamic>.from(report);
      updatedReport['status'] = 'valide';
      updatedReport['validationDate'] = DateTime.now().toIso8601String();
      await box.put(reportId, updatedReport);
    }
  }

  Future<void> insertReport(Map<String, dynamic> data) async {
    final box = await Hive.openBox<Map>('rapports');
    final id = data['id'] ?? DateTime.now().millisecondsSinceEpoch.toString();
    final payload = Map<String, dynamic>.from(data);
    payload['id'] = id;
    await box.put(id, payload);
  }

  // --- NOTIFICATIONS ---
  Future<void> createNotification({required String userId, required String title, required String message, String? relatedObjectId, String? relatedObjectType}) async {
    final box = await Hive.openBox<AppNotification>('notifications');
    final notification = AppNotification(
      id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      title: title,
      message: message,
      createdAt: DateTime.now(),
      relatedObjectId: relatedObjectId,
      relatedObjectType: relatedObjectType,
    );
    await box.put(notification.id, notification);
  }

  Future<List<AppNotification>> getNotificationsForUser(String userId) async {
    final box = await Hive.openBox<AppNotification>('notifications');
    return box.values.where((n) => n.userId == userId).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final box = await Hive.openBox<AppNotification>('notifications');
    final notification = box.get(notificationId);
    if (notification != null && !notification.isRead) {
      notification.isRead = true;
      await notification.save();
    }
  }
}

extension ReportActions on DatabaseHelper {
  Future<void> resubmitReport(String reportId, Map<String, dynamic> newPayload) async {
    final box = await Hive.openBox<Map>('rapports');
    final report = box.get(reportId);

    if (report != null) {
      final updatedReport = Map<String, dynamic>.from(report);
      updatedReport['payload'] = newPayload;
      updatedReport['status'] = 'soumis';
      updatedReport['dateSoumission'] = DateTime.now().toIso8601String();
      updatedReport.remove('rejectionReason');
      updatedReport.remove('rejectionDate');
      await box.put(reportId, updatedReport);
    }
  }
}

