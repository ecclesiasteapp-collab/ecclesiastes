import '../entities/finance/transaction.dart';

abstract class FinanceRepository {
  Future<void> recordTransaction(FinanceTransaction transaction);
  Future<List<FinanceTransaction>> getTransactionsForEntity(String entityId);
  Future<double> getBalance(String entityId, TransactionType type, String currency);
}
