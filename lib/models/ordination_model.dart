import 'package:hive/hive.dart';
import 'hierarchy_models.dart';

part 'ordination_model.g.dart';

@HiveType(typeId: 152)
class Ordination extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String personId;

  @HiveField(2)
  late UserRole rank; // ex: Diacre, Prêtre, Apôtre

  @HiveField(3)
  late DateTime date;

  @HiveField(4)
  late String entityId;

  @HiveField(5)
  String? ordainingMinisterName;

  @HiveField(6)
  String? ordainingMinisterId;

  @HiveField(7)
  String? documentReference;

  Ordination({
    required this.id,
    required this.personId,
    required this.rank,
    required this.date,
    required this.entityId,
    this.ordainingMinisterName,
    this.ordainingMinisterId,
    this.documentReference,
  });
}
