import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';

class SuperAdminDashboard extends StatelessWidget {
  final User admin;
  const SuperAdminDashboard({super.key, required this.admin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('🔧 Console Super Admin'),
        backgroundColor: Colors.red.shade900,
        actions: [
          IconButton(icon: const Icon(Icons.history), onPressed: () {}),
          IconButton(icon: const Icon(Icons.logout), onPressed: () => AuthService.logout()),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildAdminCard(context, '⛪ Églises & Entités', Icons.church, Colors.blue, () {}),
            _buildAdminCard(context, '👥 Ministres & Membres', Icons.people, Colors.green, () {}),
            _buildAdminCard(context, '🧩 Commissions', Icons.account_tree, Colors.orange, () {}),
            _buildAdminCard(context, '📢 Annonces Globales', Icons.campaign, Colors.purple, () {}),
            _buildAdminCard(context, '⚙️ Configuration', Icons.settings, Colors.grey, () {}),
            _buildAdminCard(context, '📊 Journaux d\'Audit', Icons.security, Colors.red, () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
