// lib/models/validation_model.dart
import 'package:hive/hive.dart';

part 'validation_model.g.dart';

@HiveType(typeId: 117)
class ValidationModel extends HiveObject {
  @HiveField(0) final String id;
  @HiveField(1) final String reportId;       // ID du rapport à valider
  @HiveField(2) final String validatorRole;  // 'Chef de District', 'Apôtre'
  @HiveField(3) final String validatorName;  // Nom de celui qui valide
  @HiveField(4) final String decision;       // 'Approuvé', 'Rejeté'
  @HiveField(5) final String? comments;      // Commentaires optionnels
  @HiveField(6) final DateTime validatedAt;

  ValidationModel({
    required this.id,
    required this.reportId,
    required this.validatorRole,
    required this.validatorName,
    required this.decision,
    this.comments,
    required this.validatedAt,
  });
}

