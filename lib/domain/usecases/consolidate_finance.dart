import '../entities/finance/transaction.dart';
import '../repositories/finance_repository.dart';
import '../repositories/organization_repository.dart';
import '../entities/chart_data_point.dart';

class ConsolidateFinance {
  final FinanceRepository financeRepo;
  final OrganizationRepository orgRepo;

  ConsolidateFinance(this.financeRepo, this.orgRepo);

  /// Calcule le total des transactions pour une entité et toutes ses sous-entités récursivement.
  Future<Map<String, double>> execute({
    required String rootEntityId,
    required TransactionType type,
  }) async {
    final Map<String, double> totals = {};
    
    final allEntityIds = await _getAllSubEntityIds(rootEntityId);
    allEntityIds.add(rootEntityId);

    for (final entityId in allEntityIds) {
      final transactions = await financeRepo.getTransactionsForEntity(entityId);
      
      for (final t in transactions) {
        if (t.type == type) {
          totals[t.currency] = (totals[t.currency] ?? 0.0) + t.amount;
        }
      }
    }

    return totals;
  }

  /// Récupère la tendance financière (ex: offrandes) sur les 6 derniers mois pour toute la branche.
  Future<List<ChartDataPoint>> getTrend({
    required String rootEntityId,
    required TransactionType type,
    required String currency,
  }) async {
    final List<ChartDataPoint> trend = [];
    final now = DateTime.now();
    
    final allEntityIds = await _getAllSubEntityIds(rootEntityId);
    allEntityIds.add(rootEntityId);

    // Initialisation des 6 derniers mois
    for (int i = 5; i >= 0; i--) {
      final monthDate = DateTime(now.year, now.month - i, 1);
      double monthlyTotal = 0.0;

      for (final entityId in allEntityIds) {
        final transactions = await financeRepo.getTransactionsForEntity(entityId);
        final filtered = transactions.where((t) => 
          t.type == type && 
          t.currency == currency &&
          t.date.year == monthDate.year &&
          t.date.month == monthDate.month
        );
        
        monthlyTotal += filtered.fold(0.0, (sum, t) => sum + t.amount);
      }

      trend.add(ChartDataPoint(x: monthDate, y: monthlyTotal));
    }

    return trend;
  }

  Future<List<String>> _getAllSubEntityIds(String parentId) async {
    final List<String> ids = [];
    final subEntities = await orgRepo.getSubEntities(parentId);
    
    for (final sub in subEntities) {
      ids.add(sub.id);
      ids.addAll(await _getAllSubEntityIds(sub.id));
    }
    
    return ids;
  }
}
