import 'package:ecclesiaste/models/hierarchy_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecclesiaste/services/auth_service.dart';

class MinisterDashboard extends StatelessWidget {
  const MinisterDashboard({super.key});

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
                  const Text('Espace Ministre', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(user?.fullName ?? 'Ministre', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7))),
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
            _buildSectionTitle('SERVICES & ACTES PASTORAUX'),
            const SizedBox(height: 12),
            _buildNavigationCompass(context),
            const SizedBox(height: 24),
            _buildSectionTitle('CHARGE PASTORALE DU TRIMESTRE'),
            const SizedBox(height: 12),
            _buildPastoralWorkload(),
            const SizedBox(height: 24),
            _buildSectionTitle('VOTRE BIBLIOTHÈQUE MINISTÉRIELLE'),
            const SizedBox(height: 12),
            _buildMinisterLibrary(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        const Icon(Icons.church, color: Color(0xFF1B6B9E), size: 20),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B6B9E))),
      ],
    );
  }

  Widget _buildNavigationCompass(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {'label': 'Rapports SD', 'icon': Icons.description, 'color': Colors.blue, 'route': '/reports'},
      {'label': 'Visites', 'icon': Icons.home_work, 'color': Colors.green, 'route': '/members'},
      {'label': 'Calendrier', 'icon': Icons.calendar_today, 'color': Colors.orange, 'route': '/calendar'},
      {'label': 'Ministres', 'icon': Icons.groups, 'color': Colors.purple, 'route': '/ministers'},
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

  Widget _buildPastoralWorkload() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suivi des Visites Familles',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1B6B9E)),
                  ),
                  Text(
                    'Objectif Trimestre 1 (Jan-Mar)',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B6B9E).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '12 / 45',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B6B9E), fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: 12 / 45,
              backgroundColor: Colors.grey.shade100,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1B6B9E)),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Icon(Icons.info_outline, size: 14, color: Colors.orange),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Il vous reste 33 familles à visiter pour clore votre objectif trimestriel.',
                  style: TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMinisterLibrary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        children: [
          _libItem('Pensées Directrices 2026', Icons.auto_stories, Colors.purple),
          const Divider(),
          _libItem('Directives à l\'usage des Ministres', Icons.gavel, Colors.brown),
          const Divider(),
          _libItem('Recueil de Cantiques', Icons.music_note, Colors.teal),
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
