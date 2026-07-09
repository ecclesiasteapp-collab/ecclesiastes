import '../../models/ordination_model.dart';
import '../../models/nomination_model.dart';
import '../../models/person_model.dart';

abstract class GovernanceRepository {
  Future<List<Ordination>> getOrdinationsForPerson(String personId);
  Future<List<Nomination>> getNominationsForPerson(String personId);
  Future<List<Nomination>> getNominationsForEntity(String entityId);
  Future<void> saveOrdination(Ordination ordination);
  Future<void> saveNomination(Nomination nomination);
  Future<void> deleteOrdination(String id);
  Future<void> deleteNomination(String id);
}
