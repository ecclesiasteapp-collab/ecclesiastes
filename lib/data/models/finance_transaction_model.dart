import 'package:hive/hive.dart';
import '../../domain/entities/finance/transaction.dart';

part 'finance_transaction_model.g.dart';

@HiveType(typeId: 256)
class FinanceTransactionModel extends HiveObject {
  @HiveField(0) final String id;
  @HiveField(1) final String entityId;
  @HiveField(2) final String personId;
  @HiveField(3) final double amount;
  @HiveField(4) final String currency;
  @HiveField(5) final int typeIndex;
  @HiveField(6) final int methodIndex;
  @HiveField(7) final DateTime date;
  @HiveField(8) final String? description;

  FinanceTransactionModel({
    required this.id,
    required this.entityId,
    required this.personId,
    required this.amount,
    required this.currency,
    required this.typeIndex,
    required this.methodIndex,
    required this.date,
    this.description,
  });

  factory FinanceTransactionModel.fromEntity(FinanceTransaction entity) {
    return FinanceTransactionModel(
      id: entity.id,
      entityId: entity.entityId,
      personId: entity.personId,
      amount: entity.amount,
      currency: entity.currency,
      typeIndex: entity.type.index,
      methodIndex: entity.method.index,
      date: entity.date,
      description: entity.description,
    );
  }

  FinanceTransaction toEntity() {
    return FinanceTransaction(
      id: id,
      entityId: entityId,
      personId: personId,
      amount: amount,
      currency: currency,
      type: TransactionType.values[typeIndex],
      method: PaymentMethod.values[methodIndex],
      date: date,
      description: description,
    );
  }
}
