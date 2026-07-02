// lib/screens/about_screen.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/app_contacts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // Fonction pour ouvrir les liens (Email, YouTube, etc.)
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Impossible d\'ouvrir $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        title: const Text('À Propos & Contact'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. EN-TÊTE AVEC LOGO
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF003366), Color(0xFF005B9F)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.church, color: Colors.white, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'Ecclésiaste',
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Version 1.0.0',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Servir et Diriger avec Excellence',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // 2. SECTION CONTACT
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text('CONTACT & SUPPORT', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
          ),
          
          _buildContactCard(
            icon: Icons.email,
            color: Colors.redAccent,
            title: 'Email Support',
            subtitle: AppContacts.supportEmail,
            onTap: () => _launchUrl(AppContacts.emailLink),
          ),
          
          _buildContactCard(
            icon: Icons.play_circle_fill,
            color: Colors.red,
            title: 'Chaîne YouTube',
            subtitle: 'Tutoriels et formations',
            onTap: () => _launchUrl(AppContacts.youtubeLink),
          ),

          const SizedBox(height: 32),

          // 3. SECTION RESSOURCES
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text('RESSOURCES', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
          ),

          _buildContactCard(
            icon: Icons.menu_book,
            color: Colors.indigo,
            title: 'Manuel d\'Utilisation',
            subtitle: 'Guide complet de l\'application',
            onTap: () {
              // TODO: Ajouter la navigation vers le PDF du manuel plus tard
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Manuel bientôt disponible en téléchargement')));
            },
          ),

          const SizedBox(height: 40),

          // 4. PIED DE PAGE LÉGAL
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                const Text('© 2026 Ecclésiaste', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003366))),
                const SizedBox(height: 6),
                const Text('Conçu pour l\'Église Néo-Apostolique', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  'Conforme aux Directives v3 (Nov. 2023)',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget réutilisable pour les cartes de contact
  Widget _buildContactCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 13)),
        trailing: const Icon(Icons.open_in_new, color: Colors.grey, size: 20),
        onTap: onTap,
      ),
    );
  }
}

