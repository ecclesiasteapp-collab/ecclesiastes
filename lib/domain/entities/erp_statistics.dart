class ERPStatistics {
  final int totalMembers;
  final int totalMinisters;
  final int pendingReports;
  final double financialTrend; // Percentage increase/decrease

  ERPStatistics({
    required this.totalMembers,
    required this.totalMinisters,
    required this.pendingReports,
    required this.financialTrend,
  });
}
