import '../entities/mandate.dart';
import '../repositories/organization_repository.dart';

class AssignMandateToPerson {
  final OrganizationRepository repository;

  AssignMandateToPerson(this.repository);

  Future<void> execute({
    required String personId,
    required String entityId,
    required MandateType type,
    required String roleName,
    String? appointeeById,
  }) async {
    final mandate = Mandate(
      id: "MND_${DateTime.now().millisecondsSinceEpoch}",
      personId: personId,
      entityId: entityId,
      type: type,
      roleName: roleName,
      startDate: DateTime.now(),
      appointeeById: appointeeById,
    );

    await repository.assignMandate(mandate);
  }
}
