import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EspaceFamillePage extends StatelessWidget {
  const EspaceFamillePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Espace Famille & Parents'),
        backgroundColor: const Color(0xFF1B6B9E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIntroduction(),
            const SizedBox(height: 24),
            _buildSectionTitle('GESTION DES ENFANTS (ECODIM)'),
            const SizedBox(height: 12),
            _buildChildrenList(),
            const SizedBox(height: 30),
            _buildSectionTitle('COMMUNICATION PARENTS'),
            const SizedBox(height: 12),
            _buildParentActions(context),
            const SizedBox(height: 30),
            _buildSectionTitle('DOCUMENTS & RESSOURCES'),
            const SizedBox(height: 12),
            _buildFamilyResources(),
            const SizedBox(height: 40),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF1B6B9E),
        icon: const Icon(Icons.group_add, color: Colors.white),
        label: const Text('RATTACHER UN MEMBRE', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildIntroduction() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B6B9E).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1B6B9E).withValues(alpha: 0.1)),
      ),
      child: const Row(
        children: [
          Icon(Icons.family_restroom, color: Color(0xFF1B6B9E), size: 32),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              'Gérez les liens familiaux, suivez les progrès des enfants à l\'Ecodim et communiquez efficacement avec les parents.',
              style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1B6B9E),
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildChildrenList() {
    final children = [
      {'nom': 'Marc Lelo', 'age': '8 ans', 'classe': 'Ecodim Niveau 2', 'presence': '90%'},
      {'nom': 'Sarah Lusimba', 'age': '12 ans', 'classe': 'Ecodim Niveau 4', 'presence': '85%'},
    ];

    return Column(
      children: children.map((c) => _buildChildCard(c)).toList(),
    );
  }

  Widget _buildChildCard(Map<String, String> child) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFE3F2FD),
          child: Icon(Icons.child_care, color: Color(0xFF1B6B9E)),
        ),
        title: Text(child['nom']!, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${child['age']} • ${child['classe']}'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            child['presence']!,
            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11),
          ),
        ),
      ),
    );
  }

  Widget _buildParentActions(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.5,
      children: [
        _buildActionBtn('Réunions Parents', Icons.groups, Colors.blue),
        _buildActionBtn('SMS Groupés', Icons.sms, Colors.green),
        _buildActionBtn('Visites Familles', Icons.home, Colors.orange),
        _buildActionBtn('Suivi Spirituel', Icons.auto_awesome, Colors.purple),
      ],
    );
  }

  Widget _buildActionBtn(String label, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFamilyResources() {
    final resources = [
      {'titre': 'Guide des parents - ENA', 'type': 'PDF', 'icon': Icons.picture_as_pdf},
      {'titre': 'Programme Ecodim 2026', 'type': 'DOC', 'icon': Icons.description},
      {'titre': 'Fiche d\'autorisation parentale', 'type': 'PDF', 'icon': Icons.verified},
    ];

    return Column(
      children: resources.map((r) => _buildResourceItem(r)).toList(),
    );
  }

  Widget _buildResourceItem(Map<String, dynamic> res) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(res['icon'] as IconData, color: Colors.grey),
      title: Text(res['titre'] as String, style: const TextStyle(fontSize: 13)),
      trailing: const Icon(Icons.download, size: 18, color: Color(0xFF1B6B9E)),
      onTap: () {},
    );
  }
}
