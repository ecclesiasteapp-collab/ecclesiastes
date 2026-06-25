import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/social_link.dart';

class SocialHubScreen extends StatelessWidget {
  const SocialHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hub Social & Partage'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOfficialSection(),
            const SizedBox(height: 24),
            const Text('PARTAGES DES ENTITÉS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _buildEntitiesFeed(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddLinkDialog(context),
        label: const Text('Partager mon espace'),
        icon: const Icon(Icons.share),
        backgroundColor: const Color(0xFF003366),
      ),
    );
  }

  Widget _buildOfficialSection() {
    return Card(
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.verified, color: Colors.blue),
                SizedBox(width: 8),
                Text('CHAÎNES OFFICIELLES KSO', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _socialButton('YouTube', Icons.play_circle_fill, Colors.red, 'https://youtube.com/@KSO_Official'),
                _socialButton('Facebook', Icons.facebook, Colors.blue.shade800, 'https://facebook.com/KSO_Official'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialButton(String label, IconData icon, Color color, String url) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse(url)),
      child: Column(
        children: [
          Icon(icon, color: color, size: 40),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildEntitiesFeed() {
    return ValueListenableBuilder(
      valueListenable: Hive.box<SocialLink>('social_links').listenable(),
      builder: (context, Box<SocialLink> box, _) {
        final links = box.values.toList();
        if (links.isEmpty) return const Center(child: Text('Aucun espace partagé pour le moment'));

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: links.length,
          itemBuilder: (context, index) {
            final link = links[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: link.platform == 'youtube' ? Colors.red : Colors.blue,
                  child: Icon(link.platform == 'youtube' ? Icons.play_arrow : Icons.facebook, color: Colors.white),
                ),
                title: Text(link.entityName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Espace ${link.platform.toUpperCase()}'),
                trailing: const Icon(Icons.open_in_new),
                onTap: () => launchUrl(Uri.parse(link.url)),
              ),
            );
          },
        );
      },
    );
  }

  void _showAddLinkDialog(BuildContext context) {
    // Logique pour ajouter un lien (YouTube/Facebook de la communauté)
  }
}
