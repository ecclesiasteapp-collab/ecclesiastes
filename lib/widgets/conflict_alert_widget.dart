import 'package:flutter/material.dart';
import '../core/services/conflict_detection_service.dart';

class ConflictAlertWidget extends StatelessWidget {
  final ConflictResult result;
  const ConflictAlertWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    if (result.status == 'SAFE') return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: result.status == 'BLOCKED' ? Colors.red.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: result.status == 'BLOCKED' ? Colors.red : Colors.orange),
      ),
      child: Row(
        children: [
          Icon(
            result.status == 'BLOCKED' ? Icons.block : Icons.warning, 
            color: result.status == 'BLOCKED' ? Colors.red : Colors.orange
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              Text(result.message, style: const TextStyle(fontWeight: FontWeight.bold)),
              if (result.suggestedDate != null) 
                Text('Proposition: ${result.suggestedDate!.day}/${result.suggestedDate!.month}/${result.suggestedDate!.year}'),
            ]
          )),
        ],
      ),
    );
  }
}
