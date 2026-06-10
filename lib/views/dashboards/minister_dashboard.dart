import 'package:flutter/material.dart';
import '../../widgets/header_officiel.dart';

class MinisterDashboard extends StatelessWidget {
  const MinisterDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          HeaderOfficiel(champ: 'KSO OUEST', district: 'Ngaliema', communaute: 'Centrale', date: DateTime.now()),
          const SizedBox(height: 16),
          _buildInfoBox("👁️ Mode Observation Pastorale", "Vision complète du District. Fonctions de validation désactivées."),
          const SizedBox(height: 16),
          _buildPastoralNotes(),
          const SizedBox(height: 16),
          _buildStatSummary(),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String title, String text) => Card(
    color: Colors.blue.shade50,
    child: ListTile(title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(text)),
  );

  Widget _buildPastoralNotes() => Card(
    color: Colors.purple.shade50,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("📝 Notes Pastorales Confidentielles (§3.20.6)", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const TextField(decoration: InputDecoration(hintText: "Saisie chiffrée...", border: OutlineInputBorder()), maxLines: 3),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: () {}, child: const Text("Sauvegarder (AES-256)"))
        ],
      ),
    ),
  );

  Widget _buildStatSummary() => const Column(
    children: [
      ListTile(leading: Icon(Icons.people), title: Text("Membres du District"), trailing: Text("1,245")),
      ListTile(leading: Icon(Icons.check_circle), title: Text("Conformité Directives"), trailing: Text("94%")),
    ],
  );
}
