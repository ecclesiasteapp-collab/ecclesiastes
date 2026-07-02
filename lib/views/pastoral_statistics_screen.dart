import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/pastoral_analytics_service.dart';
import '../services/entite_scope_service.dart';
import '../widgets/dashboard/entite_hierarchy_pills.dart';

class PastoralStatisticsScreen extends StatefulWidget {
  const PastoralStatisticsScreen({super.key});

  @override
  State<PastoralStatisticsScreen> createState() => _PastoralStatisticsScreenState();
}

class _PastoralStatisticsScreenState extends State<PastoralStatisticsScreen> {
  final PastoralAnalyticsService _analytics = PastoralAnalyticsService();

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final scope = EntiteScopeService.getActiveScope();
    final overviewStats = _analytics.getGlobalOverview(
      entityId: scope['id'],
      level: scope['level'],
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Analyse Pastorale'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EntiteHierarchyPills(onScopeChanged: _refresh),
            const SizedBox(height: 20),
            _buildGlobalOverview(overviewStats),
// ... rest same

            const SizedBox(height: 24),
            _buildSectionTitle('TENDANCE DE PRÉSENCE (Moyenne/Service)'),
            const SizedBox(height: 12),
            _buildPresenceChart(),
            const SizedBox(height: 30),
            _buildSectionTitle('ACTES SACRAMENTELS (Année en cours)'),
            const SizedBox(height: 12),
            _buildSacramentsChart(),
            const SizedBox(height: 30),
            _buildSectionTitle('ÉVOLUTION DES OFFRANDES (FC)'),
            const SizedBox(height: 12),
            _buildOfferingsChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 12, letterSpacing: 1.1),
    );
  }

  Widget _buildGlobalOverview(Map<String, dynamic> stats) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF003366),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10)],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ECCLÉSIASTE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  Text('Statistiques Globales', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
              Icon(Icons.public, color: Colors.white30, size: 40),
            ],
          ),
          const Divider(color: Colors.white24, height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statMini('Champs', '${stats['champs']}'),
              _statMini('Districts', '${stats['districts']}'),
              _statMini('Membres', '${stats['membres']}'),
            ],
          ),
          const SizedBox(height: 15),
          const Row(
            children: [
              Icon(Icons.verified_user, color: Colors.orange, size: 16),
              SizedBox(width: 8),
              Text(
                'Direction Mondiale Active',
                style: TextStyle(color: Colors.white, fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _statMini(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
      ],
    );
  }

  Widget _buildPresenceChart() {
    final scope = EntiteScopeService.getActiveScope();
    final data = _analytics.getPresenceTrend(
      entityId: scope['id'],
      level: scope['level'],
    );
    final spots = <FlSpot>[];
    final labels = data.keys.toList();

    for (int i = 0; i < labels.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[labels[i]]!));
    }

    return _buildChartContainer(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: _buildTitlesData(labels),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.blue,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: true, color: Colors.blue.withValues(alpha: 0.1)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSacramentsChart() {
    final scope = EntiteScopeService.getActiveScope();
    final data = _analytics.getYearlySacraments(
      entityId: scope['id'],
      level: scope['level'],
    );

    return _buildChartContainer(
      height: 250,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 1000, // Ajusté pour le volume global

          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final keys = data.keys.toList();
                  if (value.toInt() >= 0 && value.toInt() < keys.length) {
                    return Text(keys[value.toInt()], style: const TextStyle(fontSize: 10));
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            for (int i = 0; i < data.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: data.values.toList()[i].toDouble(),
                    color: Colors.orange,
                    width: 25,
                    borderRadius: BorderRadius.circular(4),
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferingsChart() {
    final scope = EntiteScopeService.getActiveScope();
    final data = _analytics.getOfferingsTrend(
      entityId: scope['id'],
      level: scope['level'],
    );
    final spots = <FlSpot>[];
    final labels = data.keys.toList();

    for (int i = 0; i < labels.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[labels[i]]!));
    }

    return _buildChartContainer(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          titlesData: _buildTitlesData(labels),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: false,
              color: Colors.green,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: true, color: Colors.green.withValues(alpha: 0.1)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartContainer({required double height, required Widget child}) {
    return Container(
      height: height,
      padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: child,
    );
  }

  FlTitlesData _buildTitlesData(List<String> labels) {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            if (value.toInt() >= 0 && value.toInt() < labels.length) {
              return Text(labels[value.toInt()], style: const TextStyle(fontSize: 10));
            }
            return const Text('');
          },
        ),
      ),
      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
}

