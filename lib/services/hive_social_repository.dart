import 'package:hive/hive.dart';
import '../domain/repositories/social_repository.dart';
import '../domain/entities/social_action.dart';
import 'database_service.dart';

class HiveSocialRepository implements SocialRepository {
  static const String _boxName = 'social_actions';

  @override
  Future<List<SocialAction>> getActionsForEntity(String entityId) async {
    final box = await DatabaseService.openBox<Map>(_boxName);
    return box.values
        .where((m) => m['entite_id'] == entityId)
        .map((m) => _fromMap(Map<String, dynamic>.from(m)))
        .toList();
  }

  @override
  Future<void> saveAction(SocialAction action) async {
    final box = await DatabaseService.openBox<Map>(_boxName);
    await box.put(action.id, {
      'id': action.id,
      'beneficiary_id': action.beneficiaryId,
      'type': action.type.name,
      'entite_id': action.entityId,
      'amount': action.amount,
      'currency': action.currency,
      'date': action.date.toIso8601String(),
      'description': action.description,
    });
  }

  @override
  Future<void> deleteAction(String id) async {
    final box = await DatabaseService.openBox<Map>(_boxName);
    await box.delete(id);
  }

  SocialAction _fromMap(Map<String, dynamic> m) {
    return SocialAction(
      id: m['id'] ?? '',
      beneficiaryId: m['beneficiary_id'] ?? '',
      type: SocialActionType.values.firstWhere(
        (e) => e.name == m['type'],
        orElse: () => SocialActionType.other,
      ),
      entityId: m['entite_id'] ?? '',
      amount: m['amount'] ?? 0.0,
      currency: m['currency'] ?? 'USD',
      date: DateTime.tryParse(m['date'] ?? '') ?? DateTime.now(),
      description: m['description'],
    );
  }
}
