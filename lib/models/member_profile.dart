import 'package:hive/hive.dart';
import 'hierarchy_models.dart';

part 'member_profile.g.dart';

@HiveType(typeId: 30)
enum CivilStatus {
  @HiveField(0)
  celibataire,
  @HiveField(1)
  marie,
  @HiveField(2)
  veuf,
  @HiveField(3)
  divorce
}

@HiveType(typeId: 31)
enum MemberStatus {
  @HiveField(0)
  nouveau,
  @HiveField(1)
  ancien,
  @HiveField(2)
  transfert
}

@HiveType(typeId: 32)
enum Availability {
  @HiveField(0)
  hebdomadaire,
  @HiveField(1)
  mensuelle,
  @HiveField(2)
  occasionnelle
}

@HiveType(typeId: 33)
class MemberProfile extends HiveObject {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String nom;
  @HiveField(2)
  late String postNom;
  @HiveField(3)
  late String prenom;
  @HiveField(4)
  late bool isMale;
  @HiveField(5)
  late DateTime dateNaissance;
  @HiveField(6)
  late String lieuNaissance;
  @HiveField(7)
  late String nationalite;
  @HiveField(8)
  late CivilStatus etatCivil;
  @HiveField(9)
  String? profession;

  @HiveField(10)
  String? nomPere;
  @HiveField(11)
  bool? pereNeApostolique;
  @HiveField(12)
  String? nomMere;
  @HiveField(13)
  bool? mereNeeApostolique;
  @HiveField(14)
  bool membreNeApostolique;

  @HiveField(15)
  late String adresse;
  @HiveField(16)
  late String communeQuartier;
  @HiveField(17)
  late String telephone;
  @HiveField(18)
  String? email;

  @HiveField(19)
  late String egliseTerritorialeId;
  @HiveField(20)
  String? champApostoliqueId;
  @HiveField(21)
  late String districtId;
  @HiveField(22)
  late String communauteId;
  @HiveField(23)
  late DateTime dateEntreeEglise;
  @HiveField(24)
  late MemberStatus statutMembre;
  @HiveField(25)
  String? communauteOrigine;

  @HiveField(26)
  late bool baptise;
  @HiveField(27)
  DateTime? dateBapteme;
  @HiveField(28)
  late bool prendSainteCene;
  @HiveField(29)
  late bool scelle;
  @HiveField(30)
  DateTime? dateScellement;

  @HiveField(31)
  String? fonctionEglise;
  @HiveField(32)
  late List<CommissionType> commissions;
  @HiveField(33)
  String? donsCompetences;
  @HiveField(34)
  late Availability disponibilite;

  @HiveField(35)
  String? contactUrgenceNom;
  @HiveField(36)
  String? contactUrgenceLien;
  @HiveField(37)
  String? contactUrgenceTel;
  @HiveField(38)
  String? observations;

  @HiveField(39)
  late DateTime dateInscription;
  @HiveField(40)
  late String inscritParMinistreId;

  @HiveField(41)
  String? roleEntite; // "responsable", "suppleant" or null
  @HiveField(42)
  String? roleCommission; // "responsable", "suppleant" or null
  @HiveField(43)
  String? personId; // Lien vers le Dossier Ecclésiastique Unique
  @HiveField(44)
  String? internationaleId;
  @HiveField(45)
  String? regionApostoliqueId;

  MemberProfile({
    required this.id,
    required this.nom,
    required this.postNom,
    required this.prenom,
    required this.isMale,
    required this.dateNaissance,
    required this.lieuNaissance,
    required this.nationalite,
    required this.etatCivil,
    required this.adresse,
    required this.communeQuartier,
    required this.telephone,
    required this.egliseTerritorialeId,
    required this.districtId,
    required this.communauteId,
    required this.dateEntreeEglise,
    required this.statutMembre,
    required this.baptise,
    required this.prendSainteCene,
    required this.scelle,
    required this.disponibilite,
    required this.dateInscription,
    required this.inscritParMinistreId,
    this.profession,
    this.nomPere,
    this.pereNeApostolique,
    this.nomMere,
    this.mereNeeApostolique,
    this.membreNeApostolique = false,
    this.email,
    this.champApostoliqueId,
    this.communauteOrigine,
    this.dateBapteme,
    this.dateScellement,
    this.fonctionEglise,
    this.commissions = const [],
    this.donsCompetences,
    this.contactUrgenceNom,
    this.contactUrgenceLien,
    this.contactUrgenceTel,
    this.observations,
    this.roleEntite,
    this.roleCommission,
    this.internationaleId,
    this.regionApostoliqueId,
  });

  String get fullName => '$prenom $nom $postNom'.trim();

  bool get isReadyForConfirmation =>
      baptise &&
      !scelle &&
      DateTime.now().difference(dateNaissance).inDays >= (14 * 365);
  bool get hasSacramentalInconsistency => scelle && !prendSainteCene;
  bool get isNewMemberNeedingFollowUp =>
      statutMembre == MemberStatus.nouveau &&
      DateTime.now().difference(dateInscription).inDays <= 60;
}

