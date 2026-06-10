import 'package:flutter/material.dart';

class CommissionDashboard extends StatelessWidget {
  final String commissionName;
  const CommissionDashboard({super.key, required this.commissionName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text("Commission $commissionName", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildConflictAlert(),
          const SizedBox(height: 16),
          _buildActionGrid(),
          const SizedBox(height: 20),
          const Text("Rapports en attente", style: TextStyle(fontWeight: FontWeight.bold)),
          const ListTile(title: Text("Mars 2026"), trailing: Text("⏳ Attente District", style: TextStyle(color: Colors.orange))),
        ],
      ),
    );
  }

  Widget _buildConflictAlert() => Card(
    color: const Color(0xFFFFF3E0),
    child: const ListTile(
      leading: Icon(Icons.warning, color: Colors.orange),
      title: Text("Alerte d'Alignement"),
      subtitle: Text("Une activité de District est planifiée à la même date."),
    ),
  );

  Widget _buildActionGrid() => GridView.count(
    shrinkWrap: true, crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.5,
    children: [
      _actionCard("Saisie Rapport", Icons.add_chart),
      _actionCard("Mon Planning", Icons.calendar_month),
    ],
  );

  Widget _actionCard(String title, IconData icon) => Card(
    child: InkWell(onTap: () {}, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: const Color(0xFF003366)), Text(title)]))
  );
}
