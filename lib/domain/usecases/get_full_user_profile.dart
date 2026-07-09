import '../entities/user_profile.dart';
import '../repositories/organization_repository.dart';

class GetFullUserProfile {
  final OrganizationRepository repository;

  GetFullUserProfile(this.repository);

  Future<UserProfile> execute(String userId) async {
    final person = await repository.getPerson(userId);
    final mandates = await repository.getActiveMandatesForPerson(userId);
    
    // Attempt to resolve primary entity from first mandate
    dynamic primaryEntity;
    if (mandates.isNotEmpty) {
      try {
        primaryEntity = await repository.getEntity(mandates.first.entityId);
      } catch (_) {
        // Ignore if entity not found
      }
    }

    return UserProfile(
      person: person,
      activeMandates: mandates,
      primaryEntity: primaryEntity,
    );
  }
}
