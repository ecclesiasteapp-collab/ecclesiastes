import '../entities/ecclesiastical_entity.dart';
import '../entities/person.dart';
import '../entities/mandate.dart';
import '../entities/family.dart';

abstract class OrganizationRepository {
  // Entités
  Future<EcclesiasticalEntity> getEntity(String id);
  Future<List<EcclesiasticalEntity>> getSubEntities(String parentId);
  
  // Personnes
  Future<Person> getPerson(String id);
  Future<void> savePerson(Person person);
  Future<List<Person>> getPersonsForEntity(String entityId);
  
  // Mandats
  Future<List<Mandate>> getActiveMandatesForPerson(String personId);
  Future<List<Mandate>> getMandatesForEntity(String entityId);
  Future<void> assignMandate(Mandate mandate);

  // Familles
  Future<void> saveFamily(Family family);
  Future<List<Family>> getFamiliesForEntity(String entityId);
  Future<Family> getFamily(String id);
}
