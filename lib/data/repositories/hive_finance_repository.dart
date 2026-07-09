import 'package:hive/hive.dart';
import '../../domain/entities/finance/transaction.dart';
import '../../domain/repositories/finance_repository.dart';
import '../models/finance_transaction_model.dart';

class HiveFinanceRepository implements FinanceRepository {
  static const String financeBoxName = 'erp_finance';

  Future<Box<FinanceTransactionModel>> get _financeBox =>
      Hive.openBox<FinanceTransactionModel>(financeBoxName);

  @override
  Future<void> recordTransaction(FinanceTransaction transaction) async {
    final box = await _financeBox;
    await box.put(transaction.id, FinanceTransactionModel.fromEntity(transaction));
  }

  @override
  Future<List<FinanceTransaction>> getTransactionsForEntity(String entityId) async {
    final box = await _financeBox;
    return box.values
        .where((t) => t.entityId == entityId)
        .map((t) => t.toEntity())
        .toList();
  }

  @override
  Future<double> getBalance(String entityId, TransactionType type, String currency) async {
    final box = await _financeBox;
    return box.values
        .where((t) => t.entityId == entityId && t.typeIndex == type.index && t.currency == currency)
        .fold<double>(0.0, (sum, t) => sum + t.amount);
  }
}
