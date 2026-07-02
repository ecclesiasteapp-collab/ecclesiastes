import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, double> data;
  final String title;

  const PieChartWidget({
    super.key,
    required this.data,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty || data.values.every((value) => value == 0)) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Center(child: Text('Aucune donnée disponible pour ce graphique.')),
            ],
          ),
        ),
      );
    }

    final List<PieChartSectionData> sections = [];
    int i = 0;
    final List<Color> colors = [
      Colors.blue, Colors.green, Colors.orange, Colors.red, Colors.purple, Colors.teal,
      Colors.indigo, Colors.amber, Colors.cyan, Colors.deepOrange, Colors.lime, Colors.pink,
    ];

    data.forEach((key, value) {
      final isTouched = i == 0; // Highlight the first section for now
      final double fontSize = isTouched ? 16 : 12;
      final double radius = isTouched ? 60 : 50;
      final Color color = colors[i % colors.length];

      sections.add(
        PieChartSectionData(
          color: color,
          value: value,
          title: '${value.toStringAsFixed(1)}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [Shadow(color: Colors.black, blurRadius: 2)],
          ),
          badgeWidget: _Badge(key, color, isTouched ? 20 : 16),
          badgePositionPercentageOffset: .98,
        ),
      );
      i++;
    });

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  pieTouchData: PieTouchData(enabled: false), // Disable touch for simplicity
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: data.keys.map((key) {
                final color = colors[data.keys.toList().indexOf(key) % colors.length];
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 4),
                    Text(key, style: const TextStyle(fontSize: 12)),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  final double size;

  const _Badge(this.text, this.color, this.size);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.6,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

