import 'package:flutter/material.dart';

class RecommendationsPanel extends StatelessWidget {
  final List<String> items;
  const RecommendationsPanel({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.amber, size: 20),
                SizedBox(width: 8),
                Text('RECOMMANDATIONS ET MAINTENANCE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 12),
            ...items.map((i) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('✅ ', style: TextStyle(fontSize: 12)),
                      Expanded(child: Text(i, style: const TextStyle(fontSize: 12, color: Colors.black87))),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
