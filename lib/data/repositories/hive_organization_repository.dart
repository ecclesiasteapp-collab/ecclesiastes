import 'package:hive/hive.dart';
import '../../domain/entities/ecclesiastical_entity.dart';
import '../../domain/entities/mandate.dart';
import '../../domain/entities/person.dart';
import '../../domain/repositories/organization_repository.dart';
import '../models/ecclesiastical_entity_model.dart';
import '../models/mandate_model.dart';
import '../models/person_model.dart';
import '../models/family_model.dart';
import '../../domain/entities/family.dart';

class HiveOrganizationRepository implements OrganizationRepository {
  static const String entitiesBoxName = 'erp_entities';
  static const String personsBoxName = 'erp_persons';
  static const String mandatesBoxName = 'erp_mandates';
  static const String familiesBoxName = 'erp_families';

  Future<Box<EcclesiasticalEntityModel>> get _entitiesBox =>
      Hive.openBox<EcclesiasticalEntityModel>(entitiesBoxName);

  Future<Box<PersonModel>> get _personsBox =>
      Hive.openBox<PersonModel>(personsBoxName);

  Future<Box<MandateModel>> get _mandatesBox =>
      Hive.openBox<MandateModel>(mandatesBoxName);

  Future<Box<FamilyModel>> get _familiesBox =>
      Hive.openBox<FamilyModel>(familiesBoxName);

  @override
  Future<EcclesiasticalEntity> getEntity(String id) async {
    final box = await _entitiesBox;
    final model = box.get(id);
    if (model == null) throw Exception('Entity not found: $id');
    return model.toEntity();
  }

  @override
  Future<List<EcclesiasticalEntity>> getSubEntities(String parentId) async {
    final box = await _entitiesBox;
    return box.values
        .where((e) => e.parentId == parentId)
        .map((e) => e.toEntity())
        .toList();
  }

  @override
  Future<Person> getPerson(String id) async {
    final box = await _personsBox;
    final model = box.get(id);
    if (model == null) throw Exception('Person not found: $id');
    return model.toEntity();
  }

  @override
  Future<void> savePerson(Person person) async {
    final box = await _personsBox;
    await box.put(person.id, PersonModel.fromEntity(person));
  }

  @override
  Future<List<Person>> getPersonsForEntity(String entityId) async {
    final mandatesBox = await _mandatesBox;
    final personsBox = await _personsBox;

    final personIds = mandatesBox.values
        .where((m) => m.entityId == entityId)
        .map((m) => m.personId)
        .toSet();

    return personsBox.values
        .where((p) => personIds.contains(p.id))
        .map((p) => p.toEntity())
        .toList();
  }

  @override
  Future<List<Mandate>> getActiveMandatesForPerson(String personId) async {
    final box = await _mandatesBox;
    return box.values
        .where((m) => m.personId == personId && m.isActive)
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<List<Mandate>> getMandatesForEntity(String entityId) async {
    final box = await _mandatesBox;
    return box.values
        .where((m) => m.entityId == entityId)
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<void> assignMandate(Mandate mandate) async {
    final box = await _mandatesBox;
    await box.put(mandate.id, MandateModel.fromEntity(mandate));
  }

  @override
  Future<void> saveFamily(Family family) async {
    final box = await _familiesBox;
    await box.put(family.id, FamilyModel.fromEntity(family));
  }

  @override
  Future<List<Family>> getFamiliesForEntity(String entityId) async {
    final box = await _familiesBox;
    return box.values
        .where((f) => f.entityId == entityId)
        .map((f) => f.toEntity())
        .toList();
  }

  @override
  Future<Family> getFamily(String id) async {
    final box = await _familiesBox;
    final model = box.get(id);
    if (model == null) throw Exception('Family not found: $id');
    return model.toEntity();
  }

  Future<void> saveEntity(EcclesiasticalEntity entity) async {
    final box = await _entitiesBox;
    await box.put(entity.id, EcclesiasticalEntityModel.fromEntity(entity));
  }
}
