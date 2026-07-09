import 'package:hive/hive.dart';

part 'member_model.g.dart';

@HiveType(typeId: 0)
class MemberModel extends HiveObject {
  @HiveField(0) final String id;
  @HiveField(1) final String nom;
  @HiveField(2) final String postNom;
  @HiveField(3) final String prenom;
  @HiveField(4) final String sexe;
  @HiveField(5) final DateTime? dateNaissance;
  @HiveField(6) final String lieuNaissance;
  @HiveField(7) final String etatCivil;
  @HiveField(8) final String nationalite;
  @HiveField(9) final String pieceIdentite;
  @HiveField(10) final String pereNom;
  @HiveField(11) final String perePrenom;
  @HiveField(12) final String statutParentPere;
  @HiveField(13) final String mereNom;
  @HiveField(14) final String merePrenom;
  @HiveField(15) final String statutParentMere;
  @HiveField(16) final String adresse;
  @HiveField(17) final String commune;
  @HiveField(18) final String ville;
  @HiveField(19) final String telephone;
  @HiveField(20) final String email;
  @HiveField(21) final String communityId;
  @HiveField(22) final String communityName;
  @HiveField(23) final DateTime? dateEntreeEglise;
  @HiveField(24) final String statutMembre;
  @HiveField(25) final bool isBaptise;
  @HiveField(26) final DateTime? dateBapteme;
  @HiveField(27) final String lieuBapteme;
  @HiveField(28) final String officiantBapteme;
  @HiveField(29) final bool isScelle;
  @HiveField(30) final DateTime? dateScelle;
  @HiveField(31) final String lieuScelle;
  @HiveField(32) final String apotreScelle;
  @HiveField(33) final bool isConfirme;
  @HiveField(34) final DateTime? dateConfirmation;
  @HiveField(35) final bool aMinistere;
  @HiveField(36) final String commission;
  @HiveField(37) final String roleCommission;
  @HiveField(38) final String disponibilite;
  @HiveField(39) final String urgenceNom;
  @HiveField(40) final String urgenceLien;
  @HiveField(41) final String urgenceTelephone;
  @HiveField(42) final String pastoralNotesEncrypted;
  @HiveField(43) final DateTime dateInscription;

  MemberModel({
    required this.id,
    required this.nom,
    required this.postNom,
    required this.prenom,
    required this.sexe,
    this.dateNaissance,
    required this.lieuNaissance,
    required this.etatCivil,
    required this.nationalite,
    required this.pieceIdentite,
    required this.pereNom,
    required this.perePrenom,
    required this.statutParentPere,
    required this.mereNom,
    required this.merePrenom,
    required this.statutParentMere,
    required this.adresse,
    required this.commune,
    required this.ville,
    required this.telephone,
    required this.email,
    required this.communityId,
    required this.communityName,
    this.dateEntreeEglise,
    required this.statutMembre,
    required this.isBaptise,
    this.dateBapteme,
    required this.lieuBapteme,
    required this.officiantBapteme,
    required this.isScelle,
    this.dateScelle,
    required this.lieuScelle,
    required this.apotreScelle,
    required this.isConfirme,
    this.dateConfirmation,
    required this.aMinistere,
    required this.commission,
    required this.roleCommission,
    required this.disponibilite,
    required this.urgenceNom,
    required this.urgenceLien,
    required this.urgenceTelephone,
    required this.pastoralNotesEncrypted,
    required this.dateInscription,
  });
}
