import 'package:hive/hive.dart';

part 'nomination_model.g.dart';

@HiveType(typeId: 153)
class Nomination extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String personId;

  @HiveField(2)
  late String functionName; // ex: Responsable de communauté, Trésorier

  @HiveField(3)
  late String entityId;

  @HiveField(4)
  late String type; // Titulaire, Adjoint, Intérim

  @HiveField(5)
  late DateTime startDate;

  @HiveField(6)
  DateTime? endDate;

  @HiveField(7)
  String? nominatingAuthorityName;

  @HiveField(8)
  String? nominatingAuthorityId;

  @HiveField(9)
  String? decisionReference;

  @HiveField(10)
  late bool isActive;

  Nomination({
    required this.id,
    required this.personId,
    required this.functionName,
    required this.entityId,
    this.type = 'Titulaire',
    required this.startDate,
    this.endDate,
    this.nominatingAuthorityName,
    this.nominatingAuthorityId,
    this.decisionReference,
    this.isActive = true,
  });
}
