import 'package:hive/hive.dart';
import 'hierarchy_models.dart';
import 'member_profile.dart'; // Pour CivilStatus et MemberStatus

part 'person_model.g.dart';

@HiveType(typeId: 150)
class Person extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String ecclesiasticalId; // Identifiant ecclésiastique unique (DEU)

  @HiveField(2)
  late String lastName; // Nom

  @HiveField(3)
  late String secondName; // Postnom

  @HiveField(4)
  late String firstName; // Prénom

  @HiveField(5)
  late bool isMale;

  @HiveField(6)
  late DateTime birthDate;

  @HiveField(7)
  String? birthPlace;

  @HiveField(8)
  String? nationality;

  @HiveField(9)
  late CivilStatus civilStatus;

  @HiveField(10)
  String? profession;

  @HiveField(11)
  String? educationLevel;

  @HiveField(12)
  String? address;

  @HiveField(13)
  String? phone;

  @HiveField(14)
  String? email;

  @HiveField(15)
  String? photoPath;

  // --- Situation Ecclésiastique Actuelle ---
  @HiveField(16)
  String status; // ex: Visiteur, Catéchumène, Membre, Ministre, Retraité

  @HiveField(17)
  late String currentEntityId; // Communauté de rattachement

  @HiveField(18)
  late EntityLevel currentEntityLevel;

  // --- Liens Familiaux ---
  @HiveField(19)
  String? fatherName;

  @HiveField(20)
  String? motherName;

  @HiveField(21)
  String? spouseName;

  // --- Liens avec les autres entités techniques ---
  @HiveField(22)
  String? userId; // ID du compte utilisateur si la personne peut se connecter

  @HiveField(23)
  late DateTime createdAt;

  @HiveField(24)
  DateTime? updatedAt;

  @HiveField(25)
  bool isDeceased;

  Person({
    required this.id,
    required this.ecclesiasticalId,
    required this.lastName,
    required this.secondName,
    required this.firstName,
    required this.isMale,
    required this.birthDate,
    this.birthPlace,
    this.nationality,
    required this.civilStatus,
    this.profession,
    this.educationLevel,
    this.address,
    this.phone,
    this.email,
    this.photoPath,
    this.status = 'Membre',
    required this.currentEntityId,
    required this.currentEntityLevel,
    this.fatherName,
    this.motherName,
    this.spouseName,
    this.userId,
    DateTime? createdAt,
    this.updatedAt,
    this.isDeceased = false,
  }) : createdAt = createdAt ?? DateTime.now();

  String get fullName => '$firstName $lastName $secondName'.trim();
}
