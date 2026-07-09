import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/erp_providers.dart';
import '../../domain/entities/chart_data_point.dart';

class ERPHubChartsWidget extends ConsumerWidget {
  const ERPHubChartsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membershipAsync = ref.watch(membershipGrowthProvider);
    final financeAsync = ref.watch(financialTrendProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Tendances & Croissance", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: membershipAsync.when(
            data: (data) => _LineChartWidget(
              title: "Évolution des Membres",
              points: data,
              color: Colors.blue,
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text("Erreur: $e"),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 200,
          child: financeAsync.when(
            data: (data) => _LineChartWidget(
              title: "Collecte Offrandes (FC)",
              points: data,
              color: Colors.green,
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text("Erreur: $e"),
          ),
        ),
      ],
    );
  }
}

class _LineChartWidget extends StatelessWidget {
  final String title;
  final List<ChartDataPoint> points;
  final Color color;

  const _LineChartWidget({required this.title, required this.points, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: points.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value.y);
                      }).toList(),
                      isCurved: true,
                      color: color,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(show: true, color: color.withOpacity(0.2)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
