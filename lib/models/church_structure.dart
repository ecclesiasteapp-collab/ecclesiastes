class MinistryRank {
  final int id;
  final String code;
  final String nom;
  final String role;
  final List<String> taches;

  MinistryRank({
    required this.id,
    required this.code,
    required this.nom,
    required this.role,
    required this.taches,
  });

  factory MinistryRank.fromJson(Map<String, dynamic> json) {
    return MinistryRank(
      id: json['id'],
      code: json['code'],
      nom: json['nom'],
      role: json['role'],
      taches: List<String>.from(json['taches']),
    );
  }
}

class Commission {
  final int id;
  final String nom;
  final String description;
  final List<String>? sousCommissions;

  Commission({
    required this.id,
    required this.nom,
    required this.description,
    this.sousCommissions,
  });

  factory Commission.fromJson(Map<String, dynamic> json) {
    return Commission(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      sousCommissions: json['sous_commissions'] != null
          ? List<String>.from(json['sous_commissions'])
          : null,
    );
  }
}

class KsoYouthData {
  final String champ;
  final List<Map<String, dynamic>> coordinationCentrale;
  final List<Pool> pools;

  KsoYouthData({
    required this.champ,
    required this.coordinationCentrale,
    required this.pools,
  });

  factory KsoYouthData.fromJson(Map<String, dynamic> json) {
    return KsoYouthData(
      champ: json['champ'],
      coordinationCentrale: List<Map<String, dynamic>>.from(json['coordination_centrale']),
      pools: (json['pools'] as List).map((p) => Pool.fromJson(p)).toList(),
    );
  }
}

class Pool {
  final String nom;
  final List<District> districts;

  Pool({required this.nom, required this.districts});

  factory Pool.fromJson(Map<String, dynamic> json) {
    return Pool(
      nom: json['nom'],
      districts: (json['districts'] as List).map((d) => District.fromJson(d)).toList(),
    );
  }
}

class District {
  final String nom;
  final String responsableMixte;
  final String responsableFeminine;
  final List<Communaute> communautes;

  District({
    required this.nom,
    required this.responsableMixte,
    required this.responsableFeminine,
    required this.communautes,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      nom: json['nom'],
      responsableMixte: json['responsable_mixte'] ?? '-',
      responsableFeminine: json['responsable_feminine'] ?? '-',
      communautes: (json['communautes'] as List).map((c) => Communaute.fromJson(c)).toList(),
    );
  }
}

class Communaute {
  final String nom;
  final String resp;
  final String adj;

  Communaute({required this.nom, required this.resp, required this.adj});

  factory Communaute.fromJson(Map<String, dynamic> json) {
    return Communaute(
      nom: json['nom'],
      resp: json['resp'] ?? '-',
      adj: json['adj'] ?? '-',
    );
  }
}
