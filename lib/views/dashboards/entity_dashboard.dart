import 'package:flutter/material.dart';

class EntityDashboard extends StatelessWidget {
  const EntityDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF003366);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExecutiveSummary(primaryColor),
          const SizedBox(height: 20),
          const Text('Suivi des 12 Commissions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          _buildCommissionGrid(),
          const SizedBox(height: 20),
          _buildValidationQueue(),
        ],
      ),
    );
  }

  Widget _buildExecutiveSummary(Color color) => Card(
    color: color,
    child: const Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SummaryItem('Membres', '450'),
          _SummaryItem('Validations', '3'),
          _SummaryItem('Alertes', '1', isAlert: true),
        ],
      ),
    ),
  );

  Widget _buildCommissionGrid() => GridView.count(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisCount: 3,
    mainAxisSpacing: 8,
    crossAxisSpacing: 8,
    children: [
      _CommBadge('Ecodim', 85, Colors.green),
      _CommBadge('Musique', 90, Colors.green),
      _CommBadge('Econfi', 40, Colors.red),
      _CommBadge('Jeunesse', 60, Colors.orange),
      _CommBadge('Médicale', 10, Colors.red),
      _CommBadge('Aînés', 75, Colors.green),
    ],
  );

  Widget _buildValidationQueue() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('📋 File de Validation', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Card(
        child: ListTile(
          leading: const Icon(Icons.description, color: Colors.blue),
          title: const Text('Rapport Econfi - Mars 2026'),
          subtitle: const Text('Par: Resp. Econfi'),
          trailing: IconButton(icon: const Icon(Icons.check_circle, color: Colors.green), onPressed: () {}),
        ),
      ),
    ],
  );
}

class _SummaryItem extends StatelessWidget {
  final String label, value;
  final bool isAlert;
  const _SummaryItem(this.label, this.value, {this.isAlert = false});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isAlert ? Colors.redAccent : Colors.white)),
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
    ],
  );
}

class _CommBadge extends StatelessWidget {
  final String name; final int pct; final Color color;
  const _CommBadge(this.name, this.pct, this.color);
  @override
  Widget build(BuildContext context) => Card(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.group_work, color: color),
      Text(name, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      Text('$pct%', style: TextStyle(fontSize: 10, color: color)),
    ]),
  );
}

