import 'package:flutter/material.dart';
import 'package:ecclesiastes/models/report.dart';

class KPICard extends StatelessWidget {
  final KPI kpi;
  
  const KPICard({super.key, required this.kpi});
  
  @override
  Widget build(BuildContext context) {
    final color = kpi.objectifAtteint ? Colors.green : Colors.orange;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(kpi.nom, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${kpi.valeur} ${kpi.unite}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text('${kpi.tauxRealisation.toStringAsFixed(1)}%', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (kpi.tauxRealisation / 100).clamp(0.0, 1.0),
              backgroundColor: Colors.grey[200],
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
