import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Aide & Ressources'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Assistant IA Chatbox Header
          _buildIAHeader(),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildResourceCard(
                  context,
                  title: 'Directives Ministres (v3)',
                  subtitle: 'Accès rapide aux 110 pages officielles',
                  icon: Icons.menu_book,
                  color: Colors.brown,
                ),
                _buildResourceCard(
                  context,
                  title: 'Tutoriels Interactifs',
                  subtitle: "Guides vidéo pas-à-pas pour l'app",
                  icon: Icons.play_circle_fill,
                  color: Colors.red,
                ),
                _buildResourceCard(
                  context,
                  title: 'Support Technique',
                  subtitle: "Signaler un bug ou contacter l'admin",
                  icon: Icons.support_agent,
                  color: Colors.blue,
                ),
                
                const SizedBox(height: 20),
                const Text('Glossaire Liturgique', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                _buildGlossaryItem('Épiclèse', 'Prière invoquant le Saint-Esprit sur les espèces de la Sainte-Cène.'),
                _buildGlossaryItem('Mandatement', "Délégation d'une fonction dirigeante par imposition des mains (§3.12)."),
                _buildGlossaryItem('Déliement', 'Acte officiel mettant fin à un mandat ou une nomination (§3.14).'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIAHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF003366),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
      ),
      child: Column(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.amber, size: 40),
          const SizedBox(height: 10),
          const Text(
            'Assistant Ecclésiastes',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          TextField(
            decoration: InputDecoration(
              hintText: 'Posez votre question sur les Directives...',
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search, color: Color(0xFF003366)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required Color color}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }

  Widget _buildGlossaryItem(String term, String definition) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(term, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003366))),
          const SizedBox(height: 4),
          Text(definition, style: const TextStyle(fontSize: 12, color: Colors.black87)),
        ],
      ),
    );
  }
}

