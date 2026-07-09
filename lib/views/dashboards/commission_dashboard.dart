import 'package:flutter/material.dart';
import '../../widgets/dashboard_modulaire.dart';
import '../../services/auth_service.dart';

class CommissionDashboard extends StatefulWidget {
  final String commissionName;
  const CommissionDashboard({super.key, required this.commissionName});

  @override
  State<CommissionDashboard> createState() => _CommissionDashboardState();
}

class _CommissionDashboardState extends State<CommissionDashboard> {
  int _selectedLevel = 4; // Communauté par défaut
  final List<String> _levels = ['Internationale', 'Territoriale', 'Champ', 'District', 'Communauté'];

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final String userName = user?.fullName ?? 'Utilisateur';
    final String commName = widget.commissionName;

    return DashboardModulaire(
      title: 'Resp. Commission $commName',
      headerSubtitle: '${_levels[_selectedLevel]} • $userName',
      topSection: _buildTopSection(),
      carouselItems: [
        _buildInfoCard(context, 'Séminaire Jeunesse', '15-17 Mars 2026', Icons.school, '/library'),
        _buildInfoCard(context, 'Rapport Trimestriel', '31 Mars 2026', Icons.assignment, '/reports'),
        _buildInfoCard(context, 'Visite Apôtre', '10 Avril 2026', Icons.church, '/calendar'),
      ],
      navigationTabs: [
        {'icon': Icons.assignment, 'label': 'Programmes', 'route': '/programmes'},
        {'icon': Icons.description, 'label': 'Rapports', 'route': '/reports'},
        {'icon': Icons.event, 'label': 'Événements', 'route': '/calendar'},
        {'icon': Icons.calendar_today, 'label': 'Calendrier', 'route': '/calendar'},
      ],
      bottomSection: [
        _buildSectionTitle('ACTIONS RAPIDES', Icons.bolt),
        const SizedBox(height: 12),
        _buildQuickActionsGrid(context),
        const SizedBox(height: 24),

        _buildSectionTitle('RAPPORT FINANCIER', Icons.account_balance_wallet),
        const SizedBox(height: 12),
        _buildFinancialMetrics(),
        const SizedBox(height: 24),

        _buildSectionTitle('ÉQUIPE LOCALE', Icons.groups),
        const SizedBox(height: 12),
        _buildTeamList(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTopSection() {
    return Column(
      children: [
        // Tabs de niveau hiérarchique
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _levels.asMap().entries.map((entry) {
              final isSelected = _selectedLevel == entry.key;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(entry.value, style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF003366), fontSize: 11)),
                  selected: isSelected,
                  selectedColor: const Color(0xFF003366),
                  backgroundColor: Colors.grey.shade100,
                  onSelected: (val) => setState(() => _selectedLevel = entry.key),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        // Carte principale de la commission
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF003366),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.groups, color: Colors.white, size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Commission ${widget.commissionName}', 
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const Text('Gestion unique • Kinshasa Sud-Ouest', 
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 8),
                    const Text('180 communautés • 22 districts • 1 champ', 
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String subtitle, IconData icon, String route) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            decoration: const BoxDecoration(
              color: Color(0xFF003366),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF003366))),
                  Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  const SizedBox(height: 8),
                  const Text('Lire', style: TextStyle(color: Color(0xFF003366), fontWeight: FontWeight.bold, fontSize: 11)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF003366), size: 20),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003366), fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    final actions = [
      {'label': 'Nouveau Rapport', 'color': Colors.blue},
      {'label': 'Créer Événement', 'color': Colors.green},
      {'label': 'Fusionner', 'color': Colors.orange},
      {'label': 'Inviter Membre', 'color': Colors.purple},
      {'label': 'Envoyer Annonce', 'color': Colors.teal},
      {'label': 'Exporter', 'color': Colors.red},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: actions.map((a) => _buildActionButton(a['label'] as String, a['color'] as Color)).toList(),
      ),
    );
  }

  Widget _buildActionButton(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildFinancialMetrics() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildFinancialRow('Cotisations Mensuelles', '1 245 000 CDF', Colors.blue, 0.8),
          const SizedBox(height: 12),
          _buildFinancialRow('Collectes Spéciales', '485 000 CDF', Colors.green, 0.6),
          const SizedBox(height: 12),
          _buildFinancialRow('Dons & Parrainages', '50 000 CDF', Colors.orange, 0.2),
          const Divider(height: 32),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('TOTAL COLLECTÉ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text('1 780 000 CDF', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003366), fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialRow(String label, String value, Color color, double progress) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade100,
          valueColor: AlwaysStoppedAnimation(color),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildTeamList() {
    final team = [
      {'name': 'Sr. Caroline Lusimba', 'role': 'Coordinatrice Adjointe - KSO'},
      {'name': 'P. Christian Kilungi', 'role': 'Chargé de Formation - UPD'},
      {'name': 'P. Christian Nkungi', 'role': 'Chargé de Formation - UPM'},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: team.map((m) => ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(backgroundColor: const Color(0xFF003366), child: Text(m['name']![0], style: const TextStyle(color: Colors.white))),
          title: Text(m['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          subtitle: Text(m['role']!, style: const TextStyle(fontSize: 11)),
          trailing: const Icon(Icons.chat_bubble_outline, size: 20, color: Color(0xFF003366)),
        )).toList(),
      ),
    );
  }
}
