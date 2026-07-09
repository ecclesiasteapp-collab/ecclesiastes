enum TransactionType { offering, tithe, donation, expense }
enum PaymentMethod { cash, mobileMoney, bankTransfer }

class FinanceTransaction {
  final String id;
  final String entityId;
  final String personId; // Donateur ou payeur
  final double amount;
  final String currency;
  final TransactionType type;
  final PaymentMethod method;
  final DateTime date;
  final String? description;
  final String? workflowInstanceId; // Lien vers le circuit de validation

  FinanceTransaction({
    required this.id,
    required this.entityId,
    required this.personId,
    required this.amount,
    required this.currency,
    required this.type,
    required this.method,
    required this.date,
    this.description,
    this.workflowInstanceId,
  });
}
