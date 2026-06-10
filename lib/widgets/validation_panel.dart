import 'package:flutter/material.dart';

class DoubleValidationPanel extends StatelessWidget {
  final bool isCommunityValidated;
  final VoidCallback onValidateCommunity;
  final VoidCallback onValidateHierarchical;

  const DoubleValidationPanel({
    super.key,
    required this.isCommunityValidated,
    required this.onValidateCommunity,
    required this.onValidateHierarchical,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.verified_user, color: Color(0xFF003366)),
                SizedBox(width: 8),
                Text('VALIDATION DOUBLE SUBORDINATION',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003366), fontSize: 13)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStep('1. Communauté', isCommunityValidated, Colors.green)),
                const Icon(Icons.arrow_forward, color: Colors.grey, size: 16),
                Expanded(child: _buildStep('2. District/Champ', false, isCommunityValidated ? Colors.orange : Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isCommunityValidated ? onValidateHierarchical : onValidateCommunity,
              style: ElevatedButton.styleFrom(
                backgroundColor: isCommunityValidated ? Colors.green : const Color(0xFF003366),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(isCommunityValidated ? 'Transmettre au District/Champ' : 'Valider Niveau Communauté'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String title, bool isDone, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDone ? color.withValues(alpha: 0.1) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDone ? color : Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Icon(isDone ? Icons.check_circle : Icons.pending_actions, color: color, size: 20),
        ],
      ),
    );
  }
}
