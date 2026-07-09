import 'package:hive/hive.dart';
import '../../models/member_model.dart';
import '../../models/entity_model.dart';
import '../../domain/entities/person.dart';
import '../../domain/entities/ecclesiastical_entity.dart';
import '../../domain/entities/mandate.dart';
import '../../data/repositories/hive_organization_repository.dart';

class LegacyToErpMigrationService {
  final HiveOrganizationRepository repository;

  LegacyToErpMigrationService(this.repository);

  Future<void> runMigration() async {
    final membersBox = await Hive.openBox<MemberModel>('membres');
    final entitiesBox = await Hive.openBox<EntityModel>('entites');

    // 1. Migrate Entities
    for (var legacyEntity in entitiesBox.values) {
      final erpEntity = EcclesiasticalEntity(
        id: legacyEntity.id,
        name: legacyEntity.nom,
        level: _mapLevel(legacyEntity.niveau),
        parentId: legacyEntity.entiteParentId,
        metadata: {'code': legacyEntity.code},
      );
      await repository.saveEntity(erpEntity);
    }

    // 2. Migrate Members to Person + Mandates
    for (var legacyMember in membersBox.values) {
      final person = Person(
        id: legacyMember.id,
        lastName: legacyMember.nom,
        firstName: legacyMember.prenom,
        postName: legacyMember.postNom,
        gender: legacyMember.sexe.toLowerCase().startsWith('m') ? Gender.male : Gender.female,
        birthDate: legacyMember.dateNaissance ?? DateTime(1900),
        email: legacyMember.email,
        phone: legacyMember.telephone,
        baptismDate: legacyMember.dateBapteme,
        sealingDate: legacyMember.dateScelle,
        confirmationDate: legacyMember.dateConfirmation,
      );

      await repository.savePerson(person);

      // Create Mandate if applicable
      if (legacyMember.aMinistere) {
        await repository.assignMandate(Mandate(
          id: "MND_MIN_${legacyMember.id}",
          personId: legacyMember.id,
          entityId: legacyMember.communityId,
          type: MandateType.ordination,
          roleName: "Ministre", // Rank info might be missing in legacy model string
          startDate: legacyMember.dateEntreeEglise ?? legacyMember.dateInscription,
        ));
      }

      if (legacyMember.commission.isNotEmpty) {
        await repository.assignMandate(Mandate(
          id: "MND_COM_${legacyMember.id}",
          personId: legacyMember.id,
          entityId: legacyMember.communityId,
          type: MandateType.affectation,
          roleName: "${legacyMember.commission}: ${legacyMember.roleCommission}",
          startDate: legacyMember.dateInscription,
        ));
      }
    }
  }

  EntityLevel _mapLevel(dynamic legacyLevel) {
    // Mapping from your existing EntityLevel enum to the new ERP EntityLevel
    // This depends on the exact order in your legacy hierarchy_models.dart
    switch (legacyLevel.toString()) {
      case 'EntityLevel.internationale': return EntityLevel.internationale;
      case 'EntityLevel.territoriale': return EntityLevel.territoriale;
      case 'EntityLevel.regionale': return EntityLevel.regionale;
      case 'EntityLevel.champ': return EntityLevel.champ;
      case 'EntityLevel.district': return EntityLevel.district;
      case 'EntityLevel.communaute': return EntityLevel.communaute;
      default: return EntityLevel.communaute;
    }
  }
}
