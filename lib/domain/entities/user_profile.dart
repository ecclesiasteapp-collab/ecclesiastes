import 'person.dart';
import 'mandate.dart';
import 'ecclesiastical_entity.dart';

class UserProfile {
  final Person person;
  final List<Mandate> activeMandates;
  final EcclesiasticalEntity? primaryEntity;

  UserProfile({
    required this.person,
    required this.activeMandates,
    this.primaryEntity,
  });

  // Helper to get the highest authority level among mandates
  EntityLevel get maxAuthorityLevel {
    // This is complex because mandates don't have level directly, but entityId does.
    return primaryEntity?.level ?? EntityLevel.communaute;
  }
}
