import '../entities/finance/transaction.dart';
import '../repositories/finance_repository.dart';
import '../usecases/submit_report_workflow.dart';

class RecordFinancialOffering {
  final FinanceRepository financeRepo;
  final SubmitReportWorkflow workflowUseCase;

  RecordFinancialOffering(this.financeRepo, this.workflowUseCase);

  Future<void> execute({
    required String entityId,
    required String personId,
    required double amount,
    required String currency,
  }) async {
    final transactionId = 'FIN_OFF_${DateTime.now().millisecondsSinceEpoch}';
    
    final transaction = FinanceTransaction(
      id: transactionId,
      entityId: entityId,
      personId: personId,
      amount: amount,
      currency: currency,
      type: TransactionType.offering,
      method: PaymentMethod.cash,
      date: DateTime.now(),
    );

    // 1. Enregistrer la transaction brute
    await financeRepo.recordTransaction(transaction);

    // 2. Déclencher un workflow de validation financière
    await workflowUseCase.execute(
      reportType: 'FINANCE_VALIDATION',
      entityId: entityId,
      initiatorId: personId,
      reportData: {
        'transactionId': transactionId,
        'amount': amount,
        'currency': currency,
        'type': 'offering',
      },
    );
  }
}
