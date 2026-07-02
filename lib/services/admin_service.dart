import 'package:ecclesiastes/services/database_helper.dart';

class AdminService {
  static Future<List<Map<String, dynamic>>> getAllPending() async {
    return DatabaseHelper.instance.getMembresEnAttente();
  }

  static Future<List<Map<String, dynamic>>> getPendingByEntite(String entiteId) async {
    return DatabaseHelper.instance.getMembresEnAttente(communauteId: entiteId);
  }

  static Future<void> confirmerMembre(String id) async {
    await DatabaseHelper.instance.validerMembre(id);
  }

  static Future<void> rejeterMembre(String id) async {
    await DatabaseHelper.instance.supprimerMembre(id);
  }

  // --- NOUVELLES METHODES DE VALIDATION DES COMPTES UTILISATEURS ---
  static Future<List<Map<String, dynamic>>> getPendingUtilisateurs({String? entiteId}) async {
    return DatabaseHelper.instance.getUtilisateursEnAttente(entiteId: entiteId);
  }

  static Future<void> confirmerUtilisateur(String id) async {
    await DatabaseHelper.instance.validerUtilisateur(id);
  }

  static Future<void> rejeterUtilisateur(String id) async {
    await DatabaseHelper.instance.supprimerUtilisateur(id);
  }

  static Future<List<Map<String, dynamic>>> getMembresByCommission(String commission) async {
    return DatabaseHelper.instance.getMembresValides(commission: commission);
  }

  static Future<void> saveMembre(Map<String, dynamic> data) async {
    final mapped = {
      'id': data['id'],
      'eglise_id': data['eglise_id'] ?? 1, // Par défaut première église
      'communaute_id': data['entite_id'] ?? data['communaute_id'],
      'nom': data['nom'],
      'prenom': data['prenom'],
      'fonction': data['poste'] ?? data['fonction'] ?? 'Membre',
      'telephone': data['telephone'],
      'commission': data['commission'],
      'statut_validation': data['statut'] ?? data['statut_validation'] ?? 1,
      'date_inscription': data['date_inscription'] ?? DateTime.now().toIso8601String(),
      'statut_membre': 'Actif',
    };
    final database = await DatabaseHelper.instance.database;
    if (database == null) return;
    final existing = await database.query(
      'membres',
      where: 'id = ?',
      whereArgs: [mapped['id']],
      limit: 1,
    );
    if (existing.isEmpty) {
      await database.insert('membres', mapped);
    } else {
      await database.update('membres', mapped, where: 'id = ?', whereArgs: [mapped['id']]);
    }
  }

  static Future<void> deleteMembre(String id) async {
    await DatabaseHelper.instance.supprimerMembre(id);
  }
}

