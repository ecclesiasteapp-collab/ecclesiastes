import '../entities/family.dart';
import '../repositories/organization_repository.dart';

class CreateFamily {
  final OrganizationRepository repository;

  CreateFamily(this.repository);

  Future<void> execute({
    required String name,
    required String entityId,
    required String headOfFamilyId,
    required String address,
    required List<String> memberIds,
  }) async {
    final family = Family(
      id: 'FAM_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      entityId: entityId,
      headOfFamilyId: headOfFamilyId,
      address: address,
      memberIds: memberIds,
    );

    await repository.saveFamily(family);
    
    // Update individual person records to link back to the family
    for (var personId in memberIds) {
      // In a real app, use a dedicated updateUseCase
      // final person = await repository.getPerson(personId);
      // final relation = (personId == headOfFamilyId) ? 'Chef de famille' : 'Membre';
      // await repository.savePerson(...) with new familyId
    }
  }
}
