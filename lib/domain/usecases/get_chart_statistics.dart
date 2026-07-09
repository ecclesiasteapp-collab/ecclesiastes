import '../entities/chart_data_point.dart';
import '../repositories/organization_repository.dart';
import '../repositories/finance_repository.dart';
import '../usecases/consolidate_finance.dart';
import '../entities/finance/transaction.dart';

class GetChartStatistics {
  final OrganizationRepository orgRepo;
  final FinanceRepository financeRepo;
  final ConsolidateFinance consolidateFinance;

  GetChartStatistics(this.orgRepo, this.financeRepo, this.consolidateFinance);

  Future<List<ChartDataPoint>> getMembershipGrowth(String entityId) async {
    // ... logic for membership growth ...
    // Logic to calculate membership growth over months
    // For now, returning mock data points
    final now = DateTime.now();
    return [
      ChartDataPoint(x: now.subtract(const Duration(days: 120)), y: 100),
      ChartDataPoint(x: now.subtract(const Duration(days: 90)), y: 115),
      ChartDataPoint(x: now.subtract(const Duration(days: 60)), y: 128),
      ChartDataPoint(x: now.subtract(const Duration(days: 30)), y: 145),
      ChartDataPoint(x: now, y: 160),
    ];
  }

  Future<List<ChartDataPoint>> getFinancialTrend(String entityId) async {
    return consolidateFinance.getTrend(
      rootEntityId: entityId,
      type: TransactionType.offering,
      currency: 'FC', // Devise de référence pour le graphique
    );
  }
}
