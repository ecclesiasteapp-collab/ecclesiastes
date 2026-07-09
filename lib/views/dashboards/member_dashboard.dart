import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecclesiaste/services/auth_service.dart';

class MemberDashboard extends StatelessWidget {
  const MemberDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B6B9E),
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/logos/Logo.png', height: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Espace Fidèle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(user?.fullName ?? 'Membre', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7))),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.logout, color: Colors.white, size: 22), onPressed: () => AuthService.logout()),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('MA VIE DE FOI'),
            const SizedBox(height: 12),
            _buildNavigationCompass(context),
            const SizedBox(height: 24),
            _buildSectionTitle('MA BIBLIOTHÈQUE SPIRITUELLE'),
            const SizedBox(height: 12),
            _buildMemberLibrary(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        const Icon(Icons.favorite, color: Color(0xFF1B6B9E), size: 20),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B6B9E))),
      ],
    );
  }

  Widget _buildNavigationCompass(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {'label': 'Ma Bible', 'icon': Icons.book, 'color': Colors.blue, 'route': '/bible'},
      {'label': 'Cantiques', 'icon': Icons.music_note, 'color': Colors.teal, 'route': '/library'},
      {'label': 'Calendrier', 'icon': Icons.calendar_month, 'color': Colors.orange, 'route': '/calendar'},
      {'label': 'Profil', 'icon': Icons.person, 'color': Colors.purple, 'route': '/profile'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 2.3),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => context.push(item['route']),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: (item['color'] as Color).withOpacity(0.3)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
            child: Row(children: [
                Icon(item['icon'] as IconData, color: item['color'] as Color, size: 22),
                const SizedBox(width: 10),
                Text(item['label'] as String, style: const TextStyle(color: Color(0xFF1B6B9E), fontSize: 13, fontWeight: FontWeight.bold)),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildMemberLibrary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        children: [
          _libItem('Recueil de Cantiques', Icons.music_note, Colors.teal),
          const Divider(),
          _libItem('Catéchisme en questions et réponses', Icons.help_outline, Colors.blue),
          const Divider(),
          _libItem('Guide de l\'enfant (Ecodim)', Icons.child_care, Colors.orange),
        ],
      ),
    );
  }

  Widget _libItem(String title, IconData icon, Color color) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 18),
    );
  }
}
