import 'package:hive/hive.dart';
import '../domain/entities/finance/transaction.dart';
import '../domain/repositories/finance_repository.dart';
import 'database_service.dart';

/// Implémentation de [FinanceRepository] utilisant Hive.
/// Gère la conversion entre les entités du domaine et le stockage local (Map).
class HiveFinanceRepository implements FinanceRepository {
  static const String _boxName = 'finances';

  @override
  Future<void> recordTransaction(FinanceTransaction transaction) async {
    final box = await DatabaseService.openBox<Map>(_boxName);
    await box.put(transaction.id, {
      'id': transaction.id,
      'entite_id': transaction.entityId,
      'person_id': transaction.personId,
      'montant': transaction.amount,
      'devise': transaction.currency,
      'type': transaction.type.name,
      'methode': transaction.method.name,
      'date': transaction.date.toIso8601String(),
      'description': transaction.description,
      'workflow_id': transaction.workflowInstanceId,
    });
  }

  @override
  Future<List<FinanceTransaction>> getTransactionsForEntity(String entityId) async {
    final box = await DatabaseService.openBox<Map>(_boxName);
    return box.values
        .where((m) => m['entite_id'] == entityId)
        .map((m) => _fromMap(Map<String, dynamic>.from(m)))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<double> getBalance(String entityId, TransactionType type, String currency) async {
    final transactions = await getTransactionsForEntity(entityId);
    return transactions
        .where((t) => t.type == type && t.currency == currency)
        .fold<double>(0.0, (prev, t) => prev + t.amount);
  }

  FinanceTransaction _fromMap(Map<String, dynamic> m) {
    return FinanceTransaction(
      id: m['id'] ?? '',
      entityId: m['entite_id'] ?? '',
      personId: m['person_id'] ?? '',
      amount: (m['montant'] as num?)?.toDouble() ?? 0.0,
      currency: m['devise'] ?? 'USD',
      type: TransactionType.values.firstWhere(
        (e) => e.name == m['type'],
        orElse: () => TransactionType.offering,
      ),
      method: PaymentMethod.values.firstWhere(
        (e) => e.name == m['methode'],
        orElse: () => PaymentMethod.cash,
      ),
      date: DateTime.tryParse(m['date'] ?? '') ?? DateTime.now(),
      description: m['description'],
      workflowInstanceId: m['workflow_id'],
    );
  }
}
