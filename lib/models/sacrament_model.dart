import 'package:hive/hive.dart';

part 'sacrament_model.g.dart';

@HiveType(typeId: 151)
class Sacrament extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String personId; // Lien vers Person

  @HiveField(2)
  late String type; // Baptême, Scellement, Confirmation, Mariage

  @HiveField(3)
  late DateTime date;

  @HiveField(4)
  late String entityId; // Lieu de l'acte

  @HiveField(5)
  String? officiantName;

  @HiveField(6)
  String? officiantId;

  @HiveField(7)
  String? documentReference;

  Sacrament({
    required this.id,
    required this.personId,
    required this.type,
    required this.date,
    required this.entityId,
    this.officiantName,
    this.officiantId,
    this.documentReference,
  });
}
