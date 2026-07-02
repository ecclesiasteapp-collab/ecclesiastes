import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecclesiastes/services/auth_service.dart';

class DashboardResponsableCommissionModulairePage extends StatefulWidget {
  final bool isSuppleant;

  const DashboardResponsableCommissionModulairePage({
    super.key,
    this.isSuppleant = false,
  });

  @override
  State<DashboardResponsableCommissionModulairePage> createState() => _DashboardResponsableCommissionModulairePageState();
}

class _DashboardResponsableCommissionModulairePageState extends State<DashboardResponsableCommissionModulairePage> {
  int _selectedLevel = 4; // Communauté par défaut
  final List<String> _levels = ['Internationale', 'Territoriale', 'Champ', 'District', 'Communauté'];
  
  // Commission gérée (peut être 1 ou 2 en cas de fusion)
  final String _primaryCommission = 'Jeunesse';
  String? _mergedCommission; // Null si pas de fusion
  
  final List<Map<String, dynamic>> _carouselItems = [
    {
      'number': '1',
      'title': 'Séminaire International des Formateurs Jeunesse 2026',
      'image': 'https://picsum.photos/200/300?random=1',
      'date': '15-17 Mars 2026',
    },
    {
      'number': '2',
      'title': 'Rapport Trimestriel Q1 - Toutes les Territoriales',
      'image': 'https://picsum.photos/200/300?random=2',
      'date': '31 Mars 2026',
    },
    {
      'number': '3',
      'title': 'Visite de l\'Apôtre Patriarche - Programme Jeunesse',
      'image': 'https://picsum.photos/200/300?random=3',
      'date': '10 Avril 2026',
    },
    {
      'number': '4',
      'title': 'Congrès International de la Jeunesse Néo-Apostolique',
      'image': 'https://picsum.photos/200/300?random=4',
      'date': '20-25 Juin 2026',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    return Scaffold(
      backgroundColor: Colors.white, // Fond institutionnel
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B6B9E),
        elevation: 0,
        title: Row(
          children: [
            // Photo de profil du responsable
            Stack(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Icon(Icons.person, color: Color(0xFF1B6B9E), size: 24),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF1B6B9E), width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.isSuppleant ? 'Suppl.' : 'Resp.'} Commission $_primaryCommission',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    'Niveau ${_levels[_selectedLevel]} • ${user?.fullName ?? 'Sr. Caroline Lusimba'}',
                    style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7)),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Badge notifications
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white, size: 24),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: const Text(
                    '5',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 24),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Boussole Hiérarchique (Fil d'Ariane)
            _buildBoussoleHierarchy(),
            const SizedBox(height: 20),

            // Sélecteur de niveau hiérarchique
            _buildLevelSelector(),
            const SizedBox(height: 20),

            // Info commission gérée
            _buildCommissionInfo(),
            const SizedBox(height: 20),

            // Carrousel "À la Une"
            _buildSectionTitle('À la Une - Commission $_primaryCommission'),
            const SizedBox(height: 12),
            _buildCarousel(),
            const SizedBox(height: 24),

            // Boussole de Navigation (4 piliers)
            _buildSectionTitle('Navigation Rapide'),
            const SizedBox(height: 12),
            _buildNavigationCompass(),
            const SizedBox(height: 24),

            // Actions rapides
            _buildQuickActions(),
            const SizedBox(height: 24),

            // Programmes et Activités
            _buildSectionTitle('Programmes & Activités'),
            const SizedBox(height: 12),
            _buildProgramSection(),
            const SizedBox(height: 24),

            // Espace Membres & Parents
            _buildSectionTitle('Espace Membres & Parents'),
            const SizedBox(height: 12),
            _buildMemberManagementSection(),
            const SizedBox(height: 24),

            // Rapports et Statistiques
            _buildSectionTitle('Rapports & Statistiques'),
            const SizedBox(height: 12),
            _buildReportsSection(),
            const SizedBox(height: 24),

            // Rapport Financier
            _buildSectionTitle('Finances & Collectes'),
            const SizedBox(height: 12),
            _buildFinancialReport(),
            const SizedBox(height: 24),

            // Gestion des Commissions (avec option fusion)
            _buildSectionTitle('Gestion des Commissions'),
            const SizedBox(height: 12),
            _buildCommissionManagement(),
            const SizedBox(height: 24),

            // Membres de la commission au niveau international
            _buildSectionTitle('Équipe ${_levels[_selectedLevel]}'),
            const SizedBox(height: 12),
            _buildInternationalTeam(),
            const SizedBox(height: 24),

            // Feuille de Route
            _buildSectionTitle('Feuille de Route'),
            const SizedBox(height: 12),
            _buildFeuilleDeRoute(),
            const SizedBox(height: 24),

            // Hub Réseaux
            _buildSocialHub(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFeuilleDeRoute() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildFeuilleDeRouteItem(
            'Séminaire de Formation',
            'En cours',
            'Prévu pour le 15 Mars',
            Icons.school,
            Colors.blue,
            0.6,
          ),
          const Divider(height: 24),
          _buildFeuilleDeRouteItem(
            'Collecte de Fonds Jeunesse',
            'À venir',
            'Débute le 1er Avril',
            Icons.monetization_on,
            Colors.green,
            0.0,
          ),
          const Divider(height: 24),
          _buildFeuilleDeRouteItem(
            'Rapport Trimestriel',
            'Terminé',
            'Soumis le 20 Février',
            Icons.check_circle,
            Colors.purple,
            1.0,
          ),
        ],
      ),
    );
  }

  Widget _buildFeuilleDeRouteItem(String title, String status, String date, IconData icon, Color color, double progress) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B6B9E))),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(status, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Text('• $date', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                ],
              ),
              if (progress > 0 && progress < 1) ...[
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: color.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(2),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBoussoleHierarchy() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1B6B9E).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_tree_outlined, color: Color(0xFF1B6B9E), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildBreadcrumbItem('ENA', true),
                  _buildBreadcrumbSeparator(),
                  _buildBreadcrumbItem('RDC Ouest', true),
                  _buildBreadcrumbSeparator(),
                  _buildBreadcrumbItem('KSO', true),
                  _buildBreadcrumbSeparator(),
                  _buildBreadcrumbItem(_levels[_selectedLevel], false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreadcrumbItem(String label, bool isLink) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        color: isLink ? const Color(0xFF1B6B9E) : Colors.black54,
        fontSize: 10,
        fontWeight: isLink ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildBreadcrumbSeparator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Icon(Icons.chevron_right, size: 12, color: Colors.black26),
    );
  }

  Widget _buildLevelSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _levels.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          final isSelected = index == _selectedLevel;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedLevel = index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1B6B9E) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF1B6B9E)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? Colors.white : const Color(0xFF1B6B9E),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF1B6B9E),
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCommissionInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B6B9E), Color(0xFF1B6B9E)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.groups, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Commission $_primaryCommission',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _mergedCommission != null
                      ? 'Fusionnée avec : $_mergedCommission'
                      : 'Gestion unique • Niveau ${_levels[_selectedLevel]}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.people, size: 14, color: Colors.white.withValues(alpha: 0.8)),
                    const SizedBox(width: 4),
                    Text(
                      '180 communautés • 22 districts • 2 territoriales',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_mergedCommission != null)
            IconButton(
              icon: const Icon(Icons.merge, color: Colors.white, size: 24),
              onPressed: () => _showMergeDialog(),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        const Icon(Icons.bookmark, color: Color(0xFF1B6B9E), size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B6B9E),
          ),
        ),
      ],
    );
  }

  Widget _buildCarousel() {
    return _CommissionCarousel(items: _carouselItems);
  }

  Widget _buildNavigationCompass() {
    final List<Map<String, dynamic>> items = [
      {'label': 'Programmes', 'count': '12 actifs', 'icon': Icons.assignment, 'color': Colors.blue},
      {'label': 'Rapports', 'count': '8 en attente', 'icon': Icons.description, 'color': Colors.green},
      {'label': 'Événements', 'count': '5 à venir', 'icon': Icons.event, 'color': Colors.orange},
      {'label': 'Calendrier', 'count': 'Année 2026', 'icon': Icons.calendar_today, 'color': Colors.purple},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => _navigateToSection(item['label'] as String),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: (item['color'] as Color).withValues(alpha: 0.3)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 5)],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (item['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item['label'] as String,
                        style: const TextStyle(
                          color: Color(0xFF1B6B9E),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['count'] as String,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.black26, size: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bolt, color: Colors.amber, size: 20),
              SizedBox(width: 8),
              Text(
                'Actions Rapides',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B6B9E)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildQuickActionButton(Icons.add, 'Nouveau Rapport', Colors.blue),
              _buildQuickActionButton(Icons.event, 'Créer Événement', Colors.green),
              _buildQuickActionButton(Icons.merge, 'Fusionner Commission', Colors.orange),
              _buildQuickActionButton(Icons.people, 'Inviter Membre', Colors.purple),
              _buildQuickActionButton(Icons.send, 'Envoyer Annonce', Colors.teal),
              _buildQuickActionButton(Icons.download, 'Exporter Données', Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialReport() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.account_balance_wallet, color: Colors.green, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Finances Commission Jeunesse',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B6B9E)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'T1 2026',
                  style: TextStyle(color: Colors.green, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          _buildFinancialRow('Cotisations Mensuelles', '1,245,000 CDF', Icons.people, Colors.blue, progress: 0.78),
          const SizedBox(height: 12),
          _buildFinancialRow('Collectes Spéciales', '485,000 CDF', Icons.attach_money, Colors.green, progress: 0.65),
          const SizedBox(height: 12),
          _buildFinancialRow('Dons & Parrainages', '320,000 CDF', Icons.favorite, Colors.pink, progress: 0.45),
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1B6B9E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('TOTAL COLLECTÉ', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                Text('2,050,000 CDF', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.visibility, size: 16),
                label: const Text('Détails', style: TextStyle(fontSize: 12)),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download, size: 16),
                label: const Text('Exporter PDF', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMemberManagementSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildActionRow('Annuaire des Membres', '45 membres actifs', Icons.people_outline, Colors.blue),
          const Divider(),
          _buildActionRow('Espace Parents', 'Gestion des mineurs (ECODIM/Jeunesse)', Icons.family_restroom, Colors.orange),
          const Divider(),
          _buildActionRow('Communication Groupée', 'Annonces & SMS aux membres', Icons.campaign_outlined, Colors.green),
          const Divider(),
          _buildActionRow('Ressources & Partage', 'Documents et supports didactiques', Icons.share_outlined, Colors.purple),
        ],
      ),
    );
  }

  Widget _buildProgramSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildActionRow('Calendrier des Activités', 'Voir le programme', Icons.calendar_today, Colors.blue),
          const Divider(),
          _buildActionRow('Saisie Nouveau Programme', 'Ajouter une activité', Icons.add_circle_outline, Colors.green),
          const Divider(),
          _buildActionRow('Annonces Commission', 'Gérer les communiqués', Icons.campaign, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildReportsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transmission Hiérarchique',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          _buildActionRow(
            'Rapport Mensuel d\'Activité', 
            'Transmettre à l\'entité', 
            Icons.description, 
            Colors.indigo,
            onTap: () => context.push('/reports/universal/mensuel_commission'),
          ),
          const Divider(),
          _buildActionRow(
            'Statistiques de Participation', 
            'Transmettre au District', 
            Icons.bar_chart, 
            Colors.teal,
            onTap: () => context.push('/reports/universal/presence_reunion'),
          ),
          const Divider(),
          _buildActionRow('Historique des Rapports', 'Consulter les archives', Icons.history, Colors.blueGrey),
        ],
      ),
    );
  }

  Widget _buildActionRow(String title, String subtitle, IconData icon, Color color, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1B6B9E))),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialRow(String label, String amount, IconData icon, Color color, {required double progress}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 8),
                Text(label, style: const TextStyle(color: Colors.black87, fontSize: 13)),
              ],
            ),
            Text(amount, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildCommissionManagement() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.groups, color: Colors.blue, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Mes Commissions',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B6B9E)),
                  ),
                ],
              ),
              if (_mergedCommission == null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.merge, color: Colors.orange, size: 14),
                      SizedBox(width: 4),
                      Text('Fusion possible', style: TextStyle(color: Colors.orange, fontSize: 11)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          _buildCommissionCard(_primaryCommission, 'Responsable Principal', '180 communautés actives', Colors.green, 0.85, isPrimary: true),
          const SizedBox(height: 12),
          
          if (_mergedCommission != null)
            _buildCommissionCard(_mergedCommission!, 'Fusionnée temporairement', 'Gestion combinée active', Colors.orange, 0.72, isMerged: true),
          
          const SizedBox(height: 16),
          
          if (_mergedCommission == null)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showMergeDialog(),
                icon: const Icon(Icons.merge, size: 18),
                label: const Text('Fusionner avec une autre commission'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.orange,
                  side: const BorderSide(color: Colors.orange),
                ),
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showUnmergeDialog(),
                icon: const Icon(Icons.call_split, size: 18),
                label: const Text('Séparer les commissions'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCommissionCard(String name, String role, String subtitle, Color color, double progress, {bool isPrimary = false, bool isMerged = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPrimary ? const Color(0xFF1B6B9E).withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.group, color: color, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text(name, style: const TextStyle(color: Color(0xFF1B6B9E), fontSize: 14, fontWeight: FontWeight.bold)),
                  if (isMerged)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(4)),
                      child: const Text('FUSION', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
              Icon(isPrimary ? Icons.star : Icons.link, color: isPrimary ? Colors.amber : Colors.orange, size: 18),
            ],
          ),
          const SizedBox(height: 8),
          Text(role, style: const TextStyle(color: Colors.black87, fontSize: 12)),
          Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 11)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text('${(progress * 100).toInt()}%', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInternationalTeam() {
    final members = [
      {'name': 'Sr. Caroline Lusimba', 'role': 'Coordinatrice Adjointe - KSO', 'color': Colors.blue},
      {'name': 'P. Christian Kilungi', 'role': 'Chargé de Formation - UPD', 'color': Colors.green},
      {'name': 'P. Christian Nkungi', 'role': 'Chargé de Formation - UPM', 'color': Colors.green},
      {'name': 'Sr. Carine Kilungi', 'role': 'Chargée de Formation - UPJ', 'color': Colors.pink},
      {'name': 'P. Castalac Dialungi', 'role': 'Chargé de comptes - KSO', 'color': Colors.blue},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: members.map((member) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: (member['color'] as Color).withValues(alpha: 0.1),
                  child: Text(
                    (member['name'] as String).substring(0, 1),
                    style: TextStyle(color: member['color'] as Color, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(member['name'] as String, style: const TextStyle(color: Color(0xFF1B6B9E), fontSize: 13, fontWeight: FontWeight.bold)),
                      Text(member['role'] as String, style: const TextStyle(color: Colors.black54, fontSize: 11)),
                    ],
                  ),
                ),
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSocialHub() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.share, color: Colors.blue, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Hub Réseaux',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B6B9E)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text('nouvelles notifications', style: TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildSocialIcon(Icons.facebook, const Color(0xFF1877F2)),
              const SizedBox(width: 8),
              _buildSocialIcon(Icons.camera_alt, const Color(0xFFE4405F)),
              const SizedBox(width: 8),
              _buildSocialIcon(Icons.play_circle_filled, const Color(0xFFFF0000)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.grey[100]?.withValues(alpha: 0.1) ?? Colors.grey[100], borderRadius: BorderRadius.circular(6)),
                child: const Text('News', style: TextStyle(fontSize: 8, color: Colors.black)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color, {double size = 24}) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      child: Icon(icon, color: Colors.white, size: size),
    );
  }

  void _navigateToSection(String section) {
    switch (section) {
      case 'Programmes':
        context.push('/programmes');
        break;
      case 'Rapports':
        context.push('/reports');
        break;
      case 'Événements':
        context.push('/events');
        break;
      case 'Calendrier':
        context.push('/calendar');
        break;
    }
  }

  void _showMergeDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Fusionner avec une commission'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Sélectionnez une commission à fusionner temporairement :'),
            const SizedBox(height: 16),
            ...['Econfi', 'Papas', 'Mamans', 'Aînés', 'Musique', 'Presse'].map((comm) => 
              ListTile(
                title: Text(comm),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _mergedCommission = comm);
                },
              ),
            ),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler'))],
      ),
    );
  }

  void _showUnmergeDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Séparer les commissions'),
        content: Text('Voulez-vous vraiment séparer la Commission $_primaryCommission de la Commission $_mergedCommission ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _mergedCommission = null);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Séparer'),
          ),
        ],
      ),
    );
  }
}


class _CommissionCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const _CommissionCarousel({required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _CarouselCard(
              number: item['number'] as String,
              title: item['title'] as String,
              imageUrl: item['image'] as String,
              date: item['date'] as String,
            ),
          );
        },
      ),
    );
  }
}

class _CarouselCard extends StatelessWidget {
  final String number;
  final String title;
  final String imageUrl;
  final String date;

  const _CarouselCard({
    required this.number,
    required this.title,
    required this.imageUrl,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
          )
        ],
      ),
      child: Row(
        children: [
          _CarouselImage(imageUrl: imageUrl, number: number),
          Expanded(
            child: _CarouselContent(title: title, date: date),
          ),
        ],
      ),
    );
  }
}

class _CarouselImage extends StatelessWidget {
  final String imageUrl;
  final String number;

  const _CarouselImage({required this.imageUrl, required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
        color: Colors.grey.shade100,
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(8),
        child: Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFF1B6B9E),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CarouselContent extends StatelessWidget {
  final String title;
  final String date;

  const _CarouselContent({required this.title, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF1B6B9E),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 12, color: Colors.black54),
              const SizedBox(width: 4),
              Text(
                date,
                style: const TextStyle(color: Colors.black54, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1B6B9E),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Lire',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

