import 'package:ecclesiaste/domain/entities/finance/transaction.dart';
import 'package:ecclesiaste/services/hive_finance_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'dart:io';

void main() {
  group('HiveFinanceRepository Tests', () {
    late HiveFinanceRepository repository;

    setUpAll(() {
      final tempDir = Directory.systemTemp.createTempSync();
      Hive.init(tempDir.path);
    });

    setUp(() {
      repository = HiveFinanceRepository();
    });

    tearDown(() async {
      await Hive.deleteFromDisk();
    });

    test('Enregistrer une transaction et calculer le solde', () async {
      final t1 = FinanceTransaction(
        id: 't1',
        entityId: 'COMM-01',
        personId: 'USER-01',
        amount: 150.0,
        currency: 'USD',
        type: TransactionType.offering,
        method: PaymentMethod.cash,
        date: DateTime.now(),
      );

      final t2 = FinanceTransaction(
        id: 't2',
        entityId: 'COMM-01',
        personId: 'USER-01',
        amount: 50.0,
        currency: 'USD',
        type: TransactionType.offering,
        method: PaymentMethod.cash,
        date: DateTime.now(),
      );

      await repository.recordTransaction(t1);
      await repository.recordTransaction(t2);
      
      final balance = await repository.getBalance('COMM-01', TransactionType.offering, 'USD');
      
      expect(balance, 200.0);
    });

    test('Récupérer les transactions d\'une entité triées par date', () async {
      final now = DateTime.now();
      final tOld = FinanceTransaction(
        id: 'old',
        entityId: 'COMM-01',
        personId: 'U1',
        amount: 10,
        currency: 'FC',
        type: TransactionType.offering,
        method: PaymentMethod.cash,
        date: now.subtract(const Duration(hours: 1)),
      );
      final tNew = FinanceTransaction(
        id: 'new',
        entityId: 'COMM-01',
        personId: 'U1',
        amount: 20,
        currency: 'FC',
        type: TransactionType.offering,
        method: PaymentMethod.cash,
        date: now,
      );

      await repository.recordTransaction(tOld);
      await repository.recordTransaction(tNew);
      
      final list = await repository.getTransactionsForEntity('COMM-01');
      
      expect(list.length, 2);
      expect(list.first.id, 'new');
    });
  });
}
