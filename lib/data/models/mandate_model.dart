import 'package:hive/hive.dart';
import '../../domain/entities/mandate.dart';

part 'mandate_model.g.dart';

@HiveType(typeId: 252)
class MandateModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String personId;
  @HiveField(2)
  final String entityId;
  @HiveField(3)
  final int typeIndex;
  @HiveField(4)
  final String roleName;
  @HiveField(5)
  final DateTime startDate;
  @HiveField(6)
  final DateTime? endDate;
  @HiveField(7)
  final bool isActive;
  @HiveField(8)
  final String? appointeeById;

  MandateModel({
    required this.id,
    required this.personId,
    required this.entityId,
    required this.typeIndex,
    required this.roleName,
    required this.startDate,
    this.endDate,
    this.isActive = true,
    this.appointeeById,
  });

  factory MandateModel.fromEntity(Mandate mandate) {
    return MandateModel(
      id: mandate.id,
      personId: mandate.personId,
      entityId: mandate.entityId,
      typeIndex: mandate.type.index,
      roleName: mandate.roleName,
      startDate: mandate.startDate,
      endDate: mandate.endDate,
      isActive: mandate.isActive,
      appointeeById: mandate.appointeeById,
    );
  }

  Mandate toEntity() {
    return Mandate(
      id: id,
      personId: personId,
      entityId: entityId,
      type: MandateType.values[typeIndex],
      roleName: roleName,
      startDate: startDate,
      endDate: endDate,
      isActive: isActive,
      appointeeById: appointeeById,
    );
  }
}
