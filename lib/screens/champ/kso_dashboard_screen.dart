// lib/screens/champ/kso_dashboard_screen.dart
import 'package:flutter/material.dart';
import '../../config/kso_districts_data.dart';

class KsoDashboardScreen extends StatelessWidget {
  const KsoDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Champ Apostolique KSO', style: TextStyle(fontSize: 16)),
            Text('Kinshasa Sud-Ouest', style: TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête Apôtre
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF003366), Color(0xFF005B9F)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Responsable du Champ', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 4),
                  const Text(KsoChampData.apotreResponsable, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Tableau synoptique du ${KsoChampData.dateSynoptique}', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Cartes KPI
            const Text('STATISTIQUES GLOBALES', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildKpiCard('Districts', '${KsoChampData.totalDistricts}', Icons.map, Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildKpiCard('Communautés', '${KsoChampData.totalCommunities}', Icons.church, Colors.green)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildKpiCard('Membres', '${KsoChampData.totalMembers}', Icons.people, Colors.orange)),
                const SizedBox(width: 12),
                Expanded(child: _buildKpiCard('Ministres', '${KsoChampData.totalMinisters}', Icons.badge, Colors.purple)),
              ],
            ),
            const SizedBox(height: 24),

            // Liste des Districts
            const Text('LES 22 DISTRICTS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: KsoChampData.districts.length,
              itemBuilder: (context, index) {
                final district = KsoChampData.districts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF003366),
                      child: Text('${district.id}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    title: Text('District de ${district.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${district.communitiesCount} communautés • ${district.membersCount} membres'),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () {
                      // Naviguer vers le détail du district
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
