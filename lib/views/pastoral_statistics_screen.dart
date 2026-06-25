import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/pastoral_analytics_service.dart';

class PastoralStatisticsScreen extends StatefulWidget {
  const PastoralStatisticsScreen({super.key});

  @override
  State<PastoralStatisticsScreen> createState() => _PastoralStatisticsScreenState();
}

class _PastoralStatisticsScreenState extends State<PastoralStatisticsScreen> {
  final PastoralAnalyticsService _analytics = PastoralAnalyticsService();

  @override
  Widget build(BuildContext context) {
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

  Widget _buildPresenceChart() {
    final data = _analytics.getPresenceTrend();
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
              belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.1)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSacramentsChart() {
    final data = _analytics.getYearlySacraments();

    return _buildChartContainer(
      height: 250,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 50, // Ajuster selon les données réelles
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
    final data = _analytics.getOfferingsTrend();
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
              belowBarData: BarAreaData(show: true, color: Colors.green.withOpacity(0.1)),
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
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
