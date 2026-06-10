import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:ecclesiastes/utils/password_utils.dart';
import 'package:ecclesiastes/utils/entite_types.dart';

class DatabaseHelper {
  static const int _dbVersion = 7;
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database?> get database async {
    if (kIsWeb) return null;
    if (_database != null) return _database!;
    _database = await _initDB('ecclesiastes_v7.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // --- STRUCTURE MULTI-TENANT (ÉGLISES TERRITORIALES) ---
    await db.execute('''
      CREATE TABLE eglises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom_officiel TEXT NOT NULL,
        pays_siege TEXT NOT NULL,
        date_creation_plateforme TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE communautes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        eglise_id INTEGER NOT NULL,
        nom_communaute TEXT NOT NULL,
        district_nom TEXT NOT NULL,
        champ_apostolique TEXT NOT NULL,
        ville TEXT NOT NULL,
        province TEXT NOT NULL,
        FOREIGN KEY(eglise_id) REFERENCES eglises(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE utilisateurs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        eglise_id INTEGER NOT NULL,
        identifiant_email TEXT NOT NULL UNIQUE,
        mot_de_passe_hash TEXT NOT NULL,
        nom_complet TEXT NOT NULL,
        niveau_geographique TEXT NOT NULL, -- 'Champ', 'District', 'Communauté'
        ministere_ordonne TEXT NOT NULL,    -- 'Berger', 'Prêtre', etc.
        role_applicatif TEXT NOT NULL,      -- 'SUPER_ADMIN', 'RESPONSABLE', etc.
        communaute_id INTEGER,
        statut_validation INTEGER DEFAULT 0,
        FOREIGN KEY(eglise_id) REFERENCES eglises(id) ON DELETE CASCADE,
        FOREIGN KEY(communaute_id) REFERENCES communautes(id)
      )
    ''');

    // --- FINANCES (RÈGLE STRICTE MULTI-DEVISE + REÇU) ---
    await db.execute('''
      CREATE TABLE finances_mouvements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        numero_recu TEXT NOT NULL UNIQUE,
        montant REAL NOT NULL,
        devise TEXT NOT NULL, -- 'FC', 'USD', 'EUR'
        type_mouvement TEXT NOT NULL, -- 'OFFRANDE_CULTURE', 'OFFRANDE_REUNION'
        communaute_id INTEGER NOT NULL,
        enregistre_par INTEGER NOT NULL,
        date_comptable TEXT NOT NULL,
        eglise_id INTEGER NOT NULL,
        FOREIGN KEY(communaute_id) REFERENCES communautes(id) ON DELETE CASCADE
      )
    ''');

    // --- FORMULAIRES DE TERRAIN NUMÉRISÉS ---

    // 1. Rapport de Sacristie
    await db.execute('''
      CREATE TABLE rapports_sacristie (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        communaute_id INTEGER NOT NULL,
        date_rapport TEXT NOT NULL,
        pointage_membres_notes TEXT,
        ordre_eglise_notes TEXT,
        depouillement_offrandes_notes TEXT,
        calice_gauche_ouverture TEXT,
        calice_droite_ouverture TEXT,
        calice_gauche_couverture TEXT,
        calice_droite_couverture TEXT,
        sainte_cene_gauche TEXT,
        sainte_cene_droite TEXT,
        cas_maladie_signales TEXT,
        demandes_prieres_reception TEXT,
        rapporteur_id INTEGER NOT NULL,
        eglise_id INTEGER NOT NULL
      )
    ''');

    // 2. Rapport de Service Divin Néo-Apostolique
    await db.execute('''
      CREATE TABLE rapports_service_divin (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        communaute_id INTEGER NOT NULL,
        date_service TEXT NOT NULL,
        jour_semaine TEXT NOT NULL, -- 'DM', 'JMS'
        type_service TEXT NOT NULL, -- 'SD', 'SE', 'SJ'
        type_categorie TEXT NOT NULL, -- 'CO', 'MA', 'SF'
        heure_debut TEXT NOT NULL,
        heure_fin TEXT NOT NULL,
        cantique_introduction TEXT,
        texte_biblique TEXT NOT NULL,
        officiant_nom TEXT NOT NULL,
        assistants_liste TEXT,
        presences_membres INTEGER DEFAULT 0,
        presences_visiteurs INTEGER DEFAULT 0,
        finance_mouvement_id INTEGER,
        acte_saint_bapteme_total INTEGER DEFAULT 0,
        acte_saint_scelle_total INTEGER DEFAULT 0,
        acte_confirmation_total INTEGER DEFAULT 0, -- Traité comme bénédiction
        acte_ordination_details TEXT,
        acte_retraite_details TEXT,
        signature_rapporteur TEXT NOT NULL,
        eglise_id INTEGER NOT NULL
      )
    ''');

    // 3. Rapport de Répétition (Musique)
    await db.execute('''
      CREATE TABLE rapports_repetition (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        communaute_id INTEGER NOT NULL,
        date_repetition TEXT NOT NULL,
        conducteur TEXT NOT NULL,
        total_choristes_presents INTEGER NOT NULL,
        voix_details_json TEXT, -- Détails Soprano, Alto, etc.
        eglise_id INTEGER NOT NULL
      )
    ''');

    // 4. Feuilles de Route
    await db.execute('''
      CREATE TABLE feuilles_route (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        communaute_id INTEGER NOT NULL,
        voyageur_nom_complet TEXT NOT NULL,
        motif_voyage TEXT NOT NULL,
        date_emission TEXT NOT NULL,
        eglise_id INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE membres (
        id TEXT PRIMARY KEY,
        eglise_id INTEGER NOT NULL,
        communaute_id INTEGER,
        nom TEXT NOT NULL,
        postnom TEXT,
        prenom TEXT,
        sexe TEXT,
        date_naissance TEXT,
        lieu_naissance TEXT,
        nationalite TEXT,
        etat_civil TEXT,
        profession TEXT,
        nom_pere TEXT,
        pere_neo_apostolique TEXT,
        nom_mere TEXT,
        mere_neo_apostolique TEXT,
        membre_neo_apostolique TEXT,
        adresse_avenue TEXT,
        adresse_numero TEXT,
        adresse_quartier TEXT,
        adresse_commune TEXT,
        telephone TEXT,
        email TEXT,
        eglise_territoriale TEXT,
        champ_apostolique TEXT,
        district TEXT,
        communaute TEXT,
        date_entree_eglise TEXT,
        statut_membre TEXT,
        origine_transfert TEXT,
        baptise TEXT,
        date_bapteme TEXT,
        scelle TEXT,
        date_scellement TEXT,
        sainte_cene TEXT,
        ministere TEXT,
        fonction TEXT,
        commission TEXT,
        dons_competences TEXT,
        disponibilite TEXT,
        urgence_nom TEXT,
        urgence_lien TEXT,
        urgence_telephone TEXT,
        observations TEXT,
        date_inscription TEXT,
        statut_validation INTEGER DEFAULT 0,
        photo_path TEXT,
        FOREIGN KEY(eglise_id) REFERENCES eglises(id) ON DELETE CASCADE,
        FOREIGN KEY(communaute_id) REFERENCES communautes(id) ON DELETE SET NULL
      )
    ''');

    // 5. Rapports Génériques (Unifié pour tous les types)
    await db.execute('''
      CREATE TABLE reports (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        data TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        isCompleted INTEGER DEFAULT 0
      )
    ''');

    await _seedInitialDataV7(db);
  }

  Future<void> _seedInitialDataV7(Database db) async {
    // 1. Création de l'Église Territoriale par défaut (Multi-tenancy)
    final egliseId = await db.insert('eglises', {
      'nom_officiel': 'Église Néo-Apostolique RDC Ouest',
      'pays_siege': 'RD Congo',
    });

    // 2. Création du Super Admin
    await db.insert('utilisateurs', {
      'eglise_id': egliseId,
      'identifiant_email': 'admin',
      'mot_de_passe_hash': hashPassword('1234'),
      'nom_complet': 'Nestor Mbuyi Kankolongo',
      'niveau_geographique': 'Territoire',
      'ministere_ordonne': 'Apôtre de District',
      'role_applicatif': 'SUPER_ADMIN',
      'statut_validation': 1,
    });
    
    // 3. Communauté modèle
    await db.insert('communautes', {
      'eglise_id': egliseId,
      'nom_communaute': 'Communauté Centrale',
      'district_nom': 'District de Kinshasa',
      'champ_apostolique': 'Kinshasa Sud-Ouest',
      'ville': 'Kinshasa',
      'province': 'Kinshasa',
    });

    // 4. Données du tableau synoptique
    final synopticDistricts = [
      {'nom': 'BILEKO', 'responsable': 'BANGAWE MBONGO', 'count': 511},
      {'nom': 'BINZA', 'responsable': 'KIBUTILA & BAYOKA NSOBA & MATONDO AKHOKUAMA', 'count': 562},
      {'nom': 'DJELO BINZA', 'responsable': 'ZABUNGANA, MAYITUKA, KANGALA & NANGA', 'count': 760},
      {'nom': 'EBEN EZER', 'responsable': 'NGOIE NZAKIMUENA KABUIKU & TUDIZAYA', 'count': 703},
      {'nom': 'KANGA MOTEMA', 'responsable': 'KASONGO NGWAMA', 'count': 762},
      {'nom': 'KERITH', 'responsable': 'IBANDA & NKUNI', 'count': 381},
      {'nom': 'KIMBWALA', 'responsable': 'KIBAMBE NGANA', 'count': 978},
      {'nom': 'LUTENDELE', 'responsable': 'MUMBAYA MAKENGO', 'count': 1000},
      {'nom': 'MALUEKA', 'responsable': 'KASAMBI MBENKIE GABANGA MUKWEYI & ABATA', 'count': 1416},
      {'nom': 'MANENGA', 'responsable': 'LUKOMBO MUBELA WUTISA', 'count': 584},
      {'nom': 'MBUDI', 'responsable': 'KINAVUIDI NDAMBELE NGBOKOLI & WATA', 'count': 965},
      {'nom': 'MÉTÉO', 'responsable': 'NSIMUNDELE KABONGO & MASAKIDI LUKUSA', 'count': 511},
      {'nom': 'MFINDA', 'responsable': 'KWAPA MULUMBA', 'count': 517},
      {'nom': 'MOBATISI', 'responsable': 'MUKENDI & MANYAYI MAKENGO, LUMUMBA, MAYALA & MANZANZA', 'count': 821},
      {'nom': 'MUNGANGA', 'responsable': 'MAMBOTE KIANGALA BOPE', 'count': 557},
      {'nom': 'NGOMBA KINKUSA', 'responsable': 'BUWEKA KITOKO', 'count': 957},
      {'nom': 'NGOMBI', 'responsable': 'ZIKU', 'count': 405},
      {'nom': 'POMPAGE', 'responsable': 'LUBANA KABAMBA', 'count': 1016},
      {'nom': 'SANGA MAMBA', 'responsable': 'KATUNGA NKISI', 'count': 960},
      {'nom': 'SAREPTA', 'responsable': 'OBOMA KABEMBA', 'count': 1019},
      {'nom': 'TSHIKAPA', 'responsable': 'LANDU POKI & KABASELE', 'count': 761},
      {'nom': 'U.P.N', 'responsable': 'GIMAVU & SINDANI', 'count': 995},
    ];

    for (var d in synopticDistricts) {
      await db.insert('communautes', {
        'eglise_id': egliseId,
        'nom_communaute': 'Centrale ${d['nom']}',
        'district_nom': d['nom'],
        'champ_apostolique': 'Kinshasa Sud-Ouest',
        'ville': 'Kinshasa',
        'province': 'Kinshasa',
      });
    }
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 7) {
      await _createDB(db, newVersion);
    }
  }

  // --- HIÉRARCHIE (4 niveaux) ---
  Future<List<Map<String, dynamic>>> getEglisesTerritoriales() async {
    final db = await database;
    if (db == null) return [];
    return db.query(
      'entites',
      where: 'type = ?',
      whereArgs: [EntiteTypes.egliseTerritoriale],
      orderBy: 'nom ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getChampsApostoliques(String egliseId) async {
    return getSubEntites(egliseId, EntiteTypes.champApostolique);
  }

  Future<List<Map<String, dynamic>>> getDistricts({String? champId}) async {
    final db = await database;
    if (db == null) return [];
    if (champId != null && champId.isNotEmpty) {
      return getSubEntites(champId, EntiteTypes.district);
    }
    return db.query(
      'entites',
      where: 'type = ?',
      whereArgs: [EntiteTypes.district],
      orderBy: 'nom ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getCommunautesByDistrict(String districtId) async {
    return getSubEntites(districtId, EntiteTypes.communaute);
  }

  /// Enfants d'un parent, ou églises territoriales si [parentId] est null et [childType] est EGLISE_TERRITORIALE.
  Future<List<Map<String, dynamic>>> getSubEntites(String? parentId, String childType) async {
    final db = await database;
    if (db == null) return [];
    final type = EntiteTypes.normalize(childType);
    if (parentId == null || parentId.isEmpty) {
      return db.query(
        'entites',
        where: 'parent_id IS NULL AND type = ?',
        whereArgs: [type],
        orderBy: 'nom ASC',
      );
    }
    return db.query(
      'entites',
      where: 'parent_id = ? AND type = ?',
      whereArgs: [parentId, type],
      orderBy: 'nom ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getAllEntites() async {
    final db = await database;
    if (db == null) return [];
    return db.query('entites', orderBy: 'type, nom');
  }

  Future<List<Map<String, dynamic>>> getEntitesByType(String type) async {
    final db = await database;
    if (db == null) return [];
    return db.query(
      'entites',
      where: 'type = ?',
      whereArgs: [EntiteTypes.normalize(type)],
      orderBy: 'nom ASC',
    );
  }

  Future<Map<String, dynamic>?> getEntiteById(String id) async {
    final db = await database;
    if (db == null) return null;
    final rows = await db.query('entites', where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    return rows.first;
  }

  /// Remonte la chaîne parentale jusqu'à la racine.
  Future<List<Map<String, dynamic>>> getChaineAncestres(String entiteId) async {
    final chain = <Map<String, dynamic>>[];
    Map<String, dynamic>? current = await getEntiteById(entiteId);
    while (current != null) {
      chain.insert(0, current);
      final parentId = current['parent_id']?.toString();
      if (parentId == null || parentId.isEmpty) break;
      current = await getEntiteById(parentId);
    }
    return chain;
  }

  /// Comptages districts / communautés (optionnellement sous un champ).
  Future<Map<String, int>> getEntiteCounts({String? champId}) async {
    final db = await database;
    if (db == null) return {'districts': 0, 'communautes': 0, 'champs': 0};
    if (champId != null && champId.isNotEmpty) {
      final districts = await getSubEntites(champId, EntiteTypes.district);
      var commCount = 0;
      for (final d in districts) {
        final comms = await getSubEntites(d['id'].toString(), EntiteTypes.communaute);
        commCount += comms.length;
      }
      return {'districts': districts.length, 'communautes': commCount, 'champs': 1};
    }
    final d = Sqflite.firstIntValue(await db.rawQuery(
          'SELECT COUNT(*) FROM entites WHERE type = ?',
          [EntiteTypes.district],
        )) ??
        0;
    final c = Sqflite.firstIntValue(await db.rawQuery(
          'SELECT COUNT(*) FROM entites WHERE type = ?',
          [EntiteTypes.communaute],
        )) ??
        0;
    final ch = Sqflite.firstIntValue(await db.rawQuery(
          'SELECT COUNT(*) FROM entites WHERE type = ?',
          [EntiteTypes.champApostolique],
        )) ??
        0;
    return {'districts': d, 'communautes': c, 'champs': ch};
  }

  Future<int> insertEntite({
    required String id,
    required String nom,
    required String type,
    String? parentId,
    String responsableNom = 'À définir',
  }) async {
    final db = await database;
    if (db == null) return 0;
    return db.insert('entites', {
      'id': id,
      'nom': nom,
      'type': type,
      'parent_id': parentId,
      'responsable_nom': responsableNom,
    });
  }

  Future<int> insertCommunaute(Map<String, dynamic> row) async {
    final db = await database;
    if (db == null) return 0;
    return db.insert('communautes', row);
  }

  // --- UTILISATEURS ---
  Future<Map<String, dynamic>?> getUtilisateurByIdentifiant(String identifiant) async {
    final db = await database;
    if (db == null) return null;
    final rows = await db.rawQuery(
      'SELECT * FROM utilisateurs WHERE LOWER(identifiant_email) = ? LIMIT 1',
      [identifiant.toLowerCase()],
    );
    if (rows.isEmpty) return null;
    return rows.first;
  }

  Future<bool> identifiantExiste(String identifiant) async {
    final user = await getUtilisateurByIdentifiant(identifiant);
    return user != null;
  }

  Future<int> creerUtilisateur({
    required String identifiant,
    required String motDePasseHash,
    required String nomComplet,
    required String role,
    String? entiteId,
    String? typeEntite,
    String? roleLabel,
    String? ministere,
  }) async {
    final db = await database;
    if (db == null) return 0;
    return db.insert('utilisateurs', {
      'id': 'USR_${DateTime.now().millisecondsSinceEpoch}',
      'identifiant': identifiant.toLowerCase(),
      'mot_de_passe_hash': motDePasseHash,
      'nom_complet': nomComplet,
      'role': role,
      'entite_id': entiteId,
      'type_entite': typeEntite ?? EntiteTypes.communaute,
      'statut_validation': 0, // En attente
      'date_inscription': DateTime.now().toIso8601String(),
      'role_label': roleLabel,
      'ministere': ministere,
    });
  }

  Future<int> validerUtilisateur(String id) async {
    final db = await database;
    if (db == null) return 0;
    return db.update('utilisateurs', {'statut_validation': 1}, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> supprimerUtilisateur(String id) async {
    final db = await database;
    if (db == null) return 0;
    return db.delete('utilisateurs', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getUtilisateursEnAttente({String? entiteId}) async {
    final db = await database;
    if (db == null) return [];
    // Auto-nettoyage des inscriptions de plus de 3 jours expirées
    final now = DateTime.now();
    final users = await db.query('utilisateurs', where: 'statut_validation = ?', whereArgs: [0]);
    for (final u in users) {
      final dateStr = u['date_inscription']?.toString();
      if (dateStr != null && dateStr.isNotEmpty) {
        final d = DateTime.tryParse(dateStr);
        if (d != null && now.difference(d).inDays >= 3) {
          await supprimerUtilisateur(u['id'] as String);
        }
      }
    }

    if (entiteId == null || entiteId == 'TOUS') {
      return db.query('utilisateurs', where: 'statut_validation = ? AND role != ?', whereArgs: [0, 'SUPER_ADMIN'], orderBy: 'nom_complet ASC');
    }
    return db.query(
      'utilisateurs',
      where: 'statut_validation = ? AND entite_id = ? AND role != ?',
      whereArgs: [0, entiteId, 'SUPER_ADMIN'],
      orderBy: 'nom_complet ASC',
    );
  }

  Future<int> mettreAJourMotDePasse(String identifiant, String motDePasseHash) async {
    final db = await database;
    if (db == null) return 0;
    return db.update(
      'utilisateurs',
      {'mot_de_passe_hash': motDePasseHash},
      where: 'LOWER(identifiant) = ?',
      whereArgs: [identifiant.toLowerCase()],
    );
  }

  Future<List<Map<String, dynamic>>> getCommunautesAvecChemin() async {
    final db = await database;
    if (db == null) return [];
    final all = await db.query('entites');
    final byId = {for (final e in all) e['id'].toString(): e};
    final comms = all.where((e) => EntiteTypes.normalize(e['type']?.toString()) == EntiteTypes.communaute);

    String chemin(String id) {
      final parts = <String>[];
      Map<String, dynamic>? current = byId[id];
      while (current != null) {
        parts.insert(0, current['nom']?.toString() ?? '');
        final pid = current['parent_id']?.toString();
        current = pid != null ? byId[pid] : null;
      }
      return parts.join(' › ');
    }

    return comms
        .map((c) => {
              'id': c['id'].toString(),
              'nom': c['nom']?.toString() ?? '',
              'chemin': chemin(c['id'].toString()),
            })
        .toList()
      ..sort((a, b) => (a['chemin'] as String).compareTo(b['chemin'] as String));
  }

  // --- MEMBRES ---
  Future<int> insertMembre(Map<String, dynamic> row) async {
    final db = await database;
    if (db == null) return 0;
    final data = Map<String, dynamic>.from(row);
    data.putIfAbsent('date_inscription', () => DateTime.now().toIso8601String());
    data.putIfAbsent('statut_validation', () => 0);
    return db.insert('membres', data);
  }

  Future<int> updateMembre(String id, Map<String, dynamic> row) async {
    final db = await database;
    if (db == null) return 0;
    return db.update('membres', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> validerMembre(String id) async {
    final db = await database;
    if (db == null) return 0;
    return db.update('membres', {'statut_validation': 1}, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> supprimerMembre(String id) async {
    final db = await database;
    if (db == null) return 0;
    return db.delete('membres', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getMembresEnAttente({String? communauteId}) async {
    final db = await database;
    if (db == null) return [];
    if (communauteId == null || communauteId == 'TOUS') {
      return db.query('membres', where: 'statut_validation = ?', whereArgs: [0], orderBy: 'nom ASC');
    }
    return db.query(
      'membres',
      where: 'statut_validation = ? AND communaute_id = ?',
      whereArgs: [0, communauteId],
      orderBy: 'nom ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getMembresValides({
    String? communauteId,
    String? commission,
  }) async {
    final db = await database;
    if (db == null) return [];
    String where = 'statut_validation = ?';
    final args = <dynamic>[1];
    if (communauteId != null && communauteId.isNotEmpty) {
      where += ' AND communaute_id = ?';
      args.add(communauteId);
    }
    if (commission != null && commission.isNotEmpty) {
      where += ' AND commission = ?';
      args.add(commission);
    }
    return db.query('membres', where: where, whereArgs: args, orderBy: 'nom ASC');
  }

  Future<int> getTotalMembres({String? communauteId}) async {
    final db = await database;
    if (db == null) return 0;
    if (communauteId != null && communauteId.isNotEmpty) {
      return Sqflite.firstIntValue(await db.rawQuery(
            'SELECT COUNT(*) FROM membres WHERE statut_validation = 1 AND communaute_id = ?',
            [communauteId],
          )) ??
          0;
    }
    return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM membres WHERE statut_validation = 1'),
        ) ??
        0;
  }

  Future<int> getUnvalidatedCount({String? communauteId}) async {
    final db = await database;
    if (db == null) return 0;
    if (communauteId != null && communauteId.isNotEmpty) {
      return Sqflite.firstIntValue(await db.rawQuery(
            'SELECT COUNT(*) FROM membres WHERE statut_validation = 0 AND communaute_id = ?',
            [communauteId],
          )) ??
          0;
    }
    return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM membres WHERE statut_validation = 0'),
        ) ??
        0;
  }

  // --- STATISTIQUES ---
  Future<Map<String, int>> getStatsCommissions({String? districtId}) async {
    final db = await database;
    if (db == null) return {};
    String where = 'statut_validation = 1';
    final args = <dynamic>[];
    if (districtId != null && districtId.isNotEmpty) {
      where += ' AND district_id = ?';
      args.add(districtId);
    }
    final res = await db.rawQuery(
      'SELECT commission, COUNT(*) as count FROM membres WHERE $where GROUP BY commission',
      args,
    );
    return {for (var item in res) (item['commission'] ?? 'Autre').toString(): item['count'] as int};
  }

  Future<Map<String, int>> getStatsSacrements({String? districtId}) async {
    final db = await database;
    if (db == null) return {'Baptisés': 0, 'Scellés': 0};
    String filter = '';
    final args = <dynamic>[];
    if (districtId != null && districtId.isNotEmpty) {
      filter = ' AND district_id = ?';
      args.add(districtId);
    }
    final b = Sqflite.firstIntValue(await db.rawQuery(
          'SELECT COUNT(*) FROM membres WHERE baptise = 1$filter',
          args,
        )) ??
        0;
    final s = Sqflite.firstIntValue(await db.rawQuery(
          'SELECT COUNT(*) FROM membres WHERE scelle = 1$filter',
          args,
        )) ??
        0;
    return {'Baptisés': b, 'Scellés': s};
  }

  // --- ÉVÉNEMENTS ---
  Future<List<Map<String, dynamic>>> getEvenements({String? entiteId}) async {
    final db = await database;
    if (db == null) return [];
    if (entiteId != null && entiteId.isNotEmpty) {
      return db.query(
        'evenements',
        where: 'entite_id = ? OR entite_id IS NULL',
        whereArgs: [entiteId],
        orderBy: 'date_evenement ASC',
      );
    }
    return db.query('evenements', orderBy: 'date_evenement ASC');
  }

  Future<int> insertEvenement(Map<String, dynamic> row) async {
    final db = await database;
    if (db == null) return 0;
    final data = Map<String, dynamic>.from(row);
    data.remove('id');
    if (data.containsKey('date_debut')) {
      data['date_evenement'] = data.remove('date_debut');
    }
    return db.insert('evenements', data);
  }

  // --- ANNONCES & FINANCES ---
  Future<List<Map<String, dynamic>>> getAnnoncesRecent() async {
    final db = await database;
    if (db == null) return [];
    return db.query('annonces', orderBy: 'date_publication DESC', limit: 10);
  }

  Future<int> insertAnnonce(Map<String, dynamic> row) async {
    final db = await database;
    if (db == null) return 0;
    return db.insert('annonces', row);
  }

  Future<List<Map<String, dynamic>>> getAnniversairesDuJour() async {
    final db = await database;
    if (db == null) return [];
    final dateDuJour = DateTime.now().toIso8601String().substring(5, 10);
    return db.rawQuery(
      "SELECT nom, prenom, telephone, date_naissance FROM membres WHERE strftime('%m-%d', date_naissance) = ?",
      [dateDuJour],
    );
  }

  Future<List<Map<String, dynamic>>> getJournalFinancier({String? entiteId}) async {
    final db = await database;
    if (db == null) return [];
    if (entiteId != null && entiteId.isNotEmpty) {
      return db.query(
        'finances',
        where: 'entite_id = ?',
        whereArgs: [entiteId],
        orderBy: 'date_saisie DESC',
      );
    }
    return db.query('finances', orderBy: 'date_saisie DESC');
  }

  Future<int> insertFinances(Map<String, dynamic> row) async {
    final db = await database;
    if (db == null) return 0;
    final data = Map<String, dynamic>.from(row);
    data.remove('id');
    if (data.containsKey('date_paiement')) {
      data['date_saisie'] = data.remove('date_paiement');
    }
    data.putIfAbsent('date_saisie', () => DateTime.now().toIso8601String().split('T').first);
    return db.insert('finances', data);
  }

  Future<int> transfererMembre(
    String membreId,
    String nuevoDistrictId,
    String nouvelleCommunauteId,
    String commOrigine,
  ) async {
    final db = await database;
    if (db == null) return 0;
    return db.update(
      'membres',
      {
        'district_id': nuevoDistrictId,
        'communaute_id': nouvelleCommunauteId,
        'communaute_origine': commOrigine,
        'statut_membre': 'Transfert',
      },
      where: 'id = ?',
      whereArgs: [membreId],
    );
  }

  Future<Map<String, int>> getStatsRetraite({String? entiteId}) async {
    final db = await database;
    if (db == null) return {'total': 0, 'proches_retraite': 0, 'deja_retraites': 0};
    final now = DateTime.now();
    final retraiteLimit = DateTime(now.year - 65, now.month, now.day);
    final dateStr = retraiteLimit.toIso8601String().split('T').first;

    String where = 'statut_validation = 1 AND date_naissance IS NOT NULL AND date_naissance != \'\'';
    final args = <dynamic>[];
    if (entiteId != null && entiteId.isNotEmpty) {
      where += ' AND communaute_id = ?';
      args.add(entiteId);
    }

    final proches = await db.rawQuery(
      'SELECT COUNT(*) as cnt FROM membres WHERE $where AND date_naissance >= ?',
      [...args, dateStr],
    );
    final retraites = await db.query('membres',
      where: 'statut_retraite = ?', whereArgs: [1]);

    final total = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM membres WHERE $where', args)) ?? 0;

    return {
      'total': total,
      'proches_retraite': Sqflite.firstIntValue(proches) ?? 0,
      'deja_retraites': retraites.length,
    };
  }

  Future<List<Map<String, dynamic>>> getMembresProchesRetraite({String? entiteId}) async {
    final db = await database;
    if (db == null) return [];
    final now = DateTime.now();
    final retraiteLimit = DateTime(now.year - 65, now.month, now.day);
    final dateStr = retraiteLimit.toIso8601String().split('T').first;

    String where = 'statut_validation = 1 AND date_naissance IS NOT NULL AND date_naissance != \'\' AND date_naissance >= ?';
    final args = <dynamic>[dateStr];
    if (entiteId != null && entiteId.isNotEmpty) {
      where += ' AND communaute_id = ?';
      args.add(entiteId);
    }
    return db.query('membres', where: where, whereArgs: args, orderBy: 'date_naissance ASC');
  }

  Future<List<Map<String, dynamic>>> getBibliotheque({
    String? entiteId,
    String? commission,
    String? niveau,
  }) async {
    final db = await database;
    if (db == null) return [];
    String where = '1=1';
    final args = <dynamic>[];
    if (entiteId != null && entiteId.isNotEmpty) {
      where += ' AND entite_id = ?';
      args.add(entiteId);
    }
    if (commission != null && commission.isNotEmpty) {
      where += ' AND commission = ?';
      args.add(commission);
    }
    if (niveau != null && niveau.isNotEmpty) {
      where += ' AND niveau = ?';
      args.add(niveau);
    }
    return db.query('bibliotheque', where: where, whereArgs: args, orderBy: 'date_ajout DESC');
  }

  Future<int> insertDocument(Map<String, dynamic> row) async {
    final db = await database;
    if (db == null) return 0;
    final data = Map<String, dynamic>.from(row);
    data.putIfAbsent('date_ajout', () => DateTime.now().toIso8601String());
    data.putIfAbsent('type_document', () => 'Document');
    data.putIfAbsent('niveau', () => 'communaute');
    return db.insert('bibliotheque', data);
  }

  Future<int> deleteDocument(int id) async {
    final db = await database;
    if (db == null) return 0;
    return db.delete('bibliotheque', where: 'id = ?', whereArgs: [id]);
  }
}
