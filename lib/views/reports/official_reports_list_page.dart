import 'package:flutter/material.dart';
import '../../models/official_report.dart';
import '../../core/theme.dart';
import 'package:go_router/go_router.dart';

class OfficialReportsListPage extends StatelessWidget {
  const OfficialReportsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Rapports Officiels'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoBanner(),
          const SizedBox(height: 24),
          const Text(
            'MODÈLES DE RAPPORTS',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey, letterSpacing: 1.1),
          ),
          const SizedBox(height: 12),
          _buildReportItem(context, OfficialReportTemplates.all[0], Icons.history_edu, Colors.blue),
          _buildReportItem(context, OfficialReportTemplates.all[1], Icons.church, Colors.amber.shade800),
          _buildComingSoonItem('Communiqué Officiel', Icons.campaign, Colors.teal),
          _buildComingSoonItem('Liste de Présence', Icons.people_alt, Colors.green),
          _buildComingSoonItem('Rapport Funéraille', Icons.person_off, Colors.blueGrey),
          _buildComingSoonItem('Feuille de Route', Icons.map, Colors.indigo),
          _buildComingSoonItem('Saints-Scellés', Icons.verified, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: AppTheme.primary),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Ces formulaires sont conformes aux modèles officiels de l\'Église Néo-Apostolique RDC Ouest.',
              style: TextStyle(fontSize: 13, color: AppTheme.primary, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportItem(BuildContext context, OfficialReportTemplate template, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () {
          // Naviguer vers le formulaire dynamique du rapport
          context.push('/reports/create/${template.type.name}');
        },
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color),
        ),
        title: Text(template.titre, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(template.description, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.add_circle_outline, color: AppTheme.primary),
      ),
    );
  }

  Widget _buildComingSoonItem(String title, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        enabled: false,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: Colors.grey),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        subtitle: const Text('Bientôt disponible', style: TextStyle(fontSize: 11)),
        trailing: const Icon(Icons.lock_outline, size: 18),
      ),
    );
  }
}
