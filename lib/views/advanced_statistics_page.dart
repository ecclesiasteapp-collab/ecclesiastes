import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/statistics_aggregation_service.dart';
import '../services/auth_service.dart';
import '../core/theme.dart';

class AdvancedStatisticsPage extends StatefulWidget {
  const AdvancedStatisticsPage({super.key});

  @override
  State<AdvancedStatisticsPage> createState() => _AdvancedStatisticsPageState();
}

class _AdvancedStatisticsPageState extends State<AdvancedStatisticsPage> {
  final _statsService = StatisticsAggregationService.instance;
  bool _isLoading = true;
  Map<String, dynamic> _demographics = {};
  Map<String, dynamic> _attendance = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = AuthService.currentUser;
    if (user == null || user.entityId == null || user.entityLevel == null) return;

    final demo = await _statsService.getDemographicStats(user.entityId!, user.entityLevel!);
    final attend = await _statsService.getAttendanceTrends(user.entityId!, user.entityLevel!);

    setState(() {
      _demographics = demo;
      _attendance = attend;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Statistiques Avancées'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Démographie des Âmes'),
            _buildDemographicsCard(),
            const SizedBox(height: 24),
            _buildSectionTitle('Tendances de Présence (Culte)'),
            _buildAttendanceChart(),
            const SizedBox(height: 24),
            _buildSectionTitle('Santé Spirituelle'),
            _buildSpiritualHealthKPIs(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primary)),
    );
  }

  Widget _buildDemographicsCard() {
    final Map<String, int> ageData = _demographics['age_brackets'];
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ageData.entries.map((e) => _buildDemoItem(e.key, e.value)).toList(),
            ),
            const Divider(height: 32),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: ageData.entries.map((e) {
                    final index = ageData.keys.toList().indexOf(e.key);
                    return PieChartSectionData(
                      value: e.value.toDouble(),
                      title: '${e.value}',
                      color: Colors.blue.withOpacity(1 - (index * 0.2)),
                      radius: 50,
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoItem(String label, int count) {
    return Column(
      children: [
        Text('$count', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _buildAttendanceChart() {
    final Map<String, int> history = _attendance['history'];
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: history.entries.map((e) {
                final index = history.keys.toList().indexOf(e.key);
                return FlSpot(index.toDouble(), e.value.toDouble());
              }).toList(),
              isCurved: true,
              color: AppTheme.primary,
              barWidth: 4,
              belowBarData: BarAreaData(show: true, color: AppTheme.primary.withOpacity(0.1)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpiritualHealthKPIs() {
    return Row(
      children: [
        Expanded(child: _buildKPI('Tx de Scellement', '72%', Colors.green)),
        const SizedBox(width: 12),
        Expanded(child: _buildKPI('Rapport Offrande', '+12%', Colors.blue)),
      ],
    );
  }

  Widget _buildKPI(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
