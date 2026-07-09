import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ecclesiaste/services/database_helper.dart';
import '../../models/user.dart';
import '../../widgets/dashboard_modulaire.dart';
import '../../services/auth_service.dart';
import '../../widgets/dashboard/entite_hierarchy_pills.dart';
import '../../models/church_report.dart';
import '../../models/hierarchy_models.dart';
import '../../config/organization_config.dart';

class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final String userName = user?.fullName ?? 'Administrateur';
    
    // Calcul des rapports en attente
    final Box<ChurchReport> reportsBox = Hive.box<ChurchReport>('church_reports');
    final pendingReports = reportsBox.values.where((r) => r.statut == ReportStatus.soumis).toList();
    final int pendingCount = pendingReports.length;

    return DashboardModulaire(
      title: 'Dashboard Global',
      headerSubtitle: 'Bienvenue, $userName',
      topSection: Column(
        children: [
          const EntiteHierarchyPills(),
          const SizedBox(height: 16),
          _buildQuickSearch(context),
        ],
      ),
      carouselItems: [
        if (AuthService.isMinistre())
          _buildInfoCard(
            context,
            'Saisir un rapport',
            '7 modèles officiels',
            Icons.add_chart,
            '/reports/official-list',
          ),
        _buildInfoCard(
          context,
          'Dernières annonces',
          '3 nouvelles publications',
          Icons.campaign,
          '/announcements',
        ),
        if (AuthService.isMinistre())
          _buildInfoCard(
            context,
            'Membres inscrits',
            '16 084 âmes dans le Champ',
            Icons.person_add,
            '/members',
          ),
      ],
      navigationTabs: [
        if (AuthService.isMinistre())
          {'icon': Icons.description, 'label': 'Rapports', 'route': '/reports/official-list'},
        if (AuthService.isMinistre())
          {'icon': Icons.people, 'label': 'Membres', 'route': '/members'},
        {'icon': Icons.assignment_ind, 'label': 'Commissions', 'route': '/commissions'},
        if (AuthService.isMinistre())
          {'icon': Icons.account_balance, 'label': 'Finances', 'route': '/finances/journal'},
      ],
      bottomSection: [
        if (AuthService.isMinistre()) ...[
          _buildSectionTitle('VOTRE CHAMP DE SUPERVISION', Icons.analytics),
          const SizedBox(height: 16),
          _buildStatsGrid(user),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextButton.icon(
              onPressed: () => context.push('/stats/advanced'),
              icon: const Icon(Icons.insights, size: 18),
              label: const Text('VOIR ANALYTIQUES AVANCÉES'),
              style: TextButton.styleFrom(foregroundColor: Color(0xFF003366)),
            ),
          ),
          const SizedBox(height: 30),
        ],

        if (user?.entityLevel == EntityLevel.internationale) ...[
          _buildSectionTitle('ALERTES CRITIQUES', Icons.warning_amber_rounded),
          const SizedBox(height: 12),
          _buildCriticalAlerts(context),
          const SizedBox(height: 30),

          _buildSectionTitle('PERFORMANCE DES TERRITORIALES', Icons.compare_arrows),
          const SizedBox(height: 12),
          _buildTerritorialComparison(context),
          const SizedBox(height: 30),
        ],
        
        _buildSectionTitle('PILOTAGE & ACTIVITÉS', Icons.explore),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSmallAction(context, 'Bibliothèque', Icons.auto_stories, '/library'),
              _buildSmallAction(context, 'Programmes', Icons.event_available, '/programmes'),
              _buildSmallAction(context, 'Événements', Icons.event_note, '/calendar'),
              _buildSmallAction(context, 'Ministres', Icons.groups, '/ministers'),
            ],
          ),
        ),
        const SizedBox(height: 30),

        _buildSectionTitle('COMMISSIONS OFFICIELLES', Icons.groups_outlined),
        const SizedBox(height: 12),
        _buildCommissionsGrid(context),
        const SizedBox(height: 30),

        _buildSectionTitle('SOCIAL HUB & COMMUNICATION', Icons.share),
        const SizedBox(height: 12),
        _buildSocialHub(context),
        const SizedBox(height: 30),

        _buildSectionTitle('GESTION ADMINISTRATIVE', Icons.settings_applications),
        const SizedBox(height: 16),
        _buildManagementActions(context),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildCommissionsGrid(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.2,
        ),
        itemCount: OrganizationConfig.commissions.length,
        itemBuilder: (context, index) {
          final comm = OrganizationConfig.commissions[index];
          return InkWell(
            onTap: () => context.push('/dashboard/commission', extra: {'type': comm.type}),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_getCommIcon(comm.type), color: const Color(0xFF1B6B9E), size: 20),
                  const SizedBox(height: 4),
                  Text(
                    comm.code,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1B6B9E)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickSearch(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              onSubmitted: (query) {
                if (query.isNotEmpty) {
                  context.push('/members', extra: {'search': query});
                }
              },
              decoration: InputDecoration(
                hintText: 'Recherche rapide d\'un membre...',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF003366)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: () => _showScanPlaceholder(context),
          icon: const Icon(Icons.qr_code_scanner, color: Color(0xFF003366)),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            shadowColor: Colors.black.withValues(alpha: 0.2),
            elevation: 4,
          ),
        ),
      ],
    );
  }

  void _showScanPlaceholder(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        height: 300,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.qr_code_scanner, size: 64, color: Color(0xFF003366)),
            const SizedBox(height: 16),
            const Text('Scanner QR Code Officiel', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'Identifiez instantanément un membre via sa carte ministérielle scannable.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003366),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('ACTIVER LE SCANNER', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCommIcon(CommissionType type) {
    switch (type) {
      case CommissionType.ecodim: return Icons.child_care;
      case CommissionType.econfi: return Icons.school;
      case CommissionType.jeunesse: return Icons.emoji_people;
      case CommissionType.papas: return Icons.man;
      case CommissionType.mamans: return Icons.woman;
      case CommissionType.aines: return Icons.elderly;
      case CommissionType.musique: return Icons.music_note;
      case CommissionType.presseMediasSonorisation: return Icons.camera_alt;
      case CommissionType.josephArimathee: return Icons.volunteer_activism;
      case CommissionType.securiteProtocole: return Icons.security;
      case CommissionType.medicale: return Icons.local_hospital;
      case CommissionType.construction: return Icons.build;
      default: return Icons.groups;
    }
  }

  Widget _buildNavChip(BuildContext context, String label, IconData icon, String route) {
    return ActionChip(
      avatar: Icon(icon, size: 14, color: const Color(0xFF003366)),
      label: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
      onPressed: () => context.push(route),
      backgroundColor: Colors.white,
      side: BorderSide(color: Colors.grey.shade300),
    );
  }

  Widget _buildSmallAction(BuildContext context, String label, IconData icon, String route) {
    return InkWell(
      onTap: () => context.push(route),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF003366).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF003366), size: 24),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Color(0xFF003366), fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String subtitle, IconData icon, String route) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF003366).withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF003366).withValues(alpha: 0.1)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF003366), size: 28),
            const Spacer(),
            Text(title, style: const TextStyle(color: Color(0xFF003366), fontWeight: FontWeight.bold, fontSize: 14)),
            Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF003366), size: 20),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(User? user) {
    // Récupération des vrais comptes depuis Hive via DatabaseHelper
    return FutureBuilder<Map<String, int>>(
      future: DatabaseHelper.instance.getEntiteCounts(), // On peut passer champId si besoin
      builder: (context, snapshot) {
        final counts = snapshot.data ?? {'districts': 22, 'communautes': 180, 'membres': 16084, 'ministres': 566};
        
        String label1 = 'Districts';
        String val1 = counts['districts'].toString();
        String label2 = 'Communautés';
        String val2 = counts['communautes'].toString();
        String label3 = 'Membres';
        String val3 = counts['membres'].toString();
        String label4 = 'Ministres';
        String val4 = counts['ministres'].toString();

        if (user?.entityLevel == EntityLevel.internationale) {
          label1 = 'Territoriales';
          val1 = '2'; 
          label2 = 'Champs';
          val2 = '14';
        } else if (user?.entityLevel == EntityLevel.territoriale) {
          label1 = 'Champs';
          val1 = '8'; 
          label2 = 'Districts';
          val2 = '45';
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
            children: [
              _buildStatItem(label1, val1, Icons.account_tree, Colors.blue),
              _buildStatItem(label2, val2, Icons.church, Colors.green),
              _buildStatItem(label3, val3, Icons.people, Colors.purple),
              _buildStatItem(label4, val4, Icons.badge, Colors.orange),
            ],
          ),
        );
      }
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.black87, fontSize: 10)),
              Text(value, style: TextStyle(color: color.withValues(alpha: 0.8), fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildManagementActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _buildQuickActionButton(context, 'Configuration', Icons.account_tree, '/admin/panel'),
          _buildQuickActionButton(context, 'Répertoire', Icons.manage_accounts, '/members'),
          _buildQuickActionButton(context, 'Paramètres', Icons.settings, '/settings'),
          _buildQuickActionButton(context, "Journal d'Audit", Icons.receipt_long, '/audit_log'),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(BuildContext context, String label, IconData icon, String route) {
    return ElevatedButton.icon(
      onPressed: () => context.push(route),
      icon: Icon(icon, color: Colors.white, size: 16),
      label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF003366),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildSocialHub(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Activités Réseaux', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003366))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _socialIcon(Icons.facebook, const Color(0xFF1877F2)),
              _socialIcon(Icons.camera_alt, const Color(0xFFE4405F)),
              _socialIcon(Icons.play_circle_filled, const Color(0xFFFF0000)),
              _socialIcon(Icons.newspaper, Colors.blueGrey),
            ],
          ),
          const Divider(height: 24),
          _socialUpdate(Icons.facebook, 'FB: Photos du culte de l\'Apôtre Patriarche à UPN.'),
          const SizedBox(height: 8),
          _socialUpdate(Icons.play_circle_filled, 'YT: Nouveau chant de la chorale "Jérémie".'),
        ],
      ),
    );
  }

  Widget _socialIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _socialUpdate(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 11, color: Colors.black87), maxLines: 1, overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  Widget _buildTerritorialComparison(BuildContext context) {
    final territoriales = [
      {'nom': 'RDC OUEST', 'membres': '250k', 'rapports': '98%', 'sante': 'A'},
      {'nom': 'RDC EST', 'membres': '180k', 'rapports': '85%', 'sante': 'B+'},
      {'nom': 'CONGO-BRAZZA', 'membres': '45k', 'rapports': '92%', 'sante': 'A-'},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        children: territoriales.map((t) => _buildTerritorialRow(t)).toList(),
      ),
    );
  }

  Widget _buildCriticalAlerts(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Column(
        children: [
          _buildAlertItem(
            'Rapport Financier T2 - RDC EST',
            'En retard de 5 jours',
            Icons.account_balance_wallet_outlined,
            Colors.red,
          ),
          Divider(height: 24, color: Colors.red.withValues(alpha: 0.1)),
          _buildAlertItem(
            'Audit de Sécurité - CONGO BRAZZA',
            'Accès suspects détectés',
            Icons.security,
            Colors.orange,
          ),
          Divider(height: 24, color: Colors.red.withValues(alpha: 0.1)),
          _buildAlertItem(
            'Vérification Mandat - Apôtre Responsable',
            'Renouvellement requis avant 30/07',
            Icons.assignment_ind_outlined,
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItem(String title, String subtitle, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF003366))),
              Text(subtitle, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey.shade400),
      ],
    );
  }

  Widget _buildTerritorialRow(Map<String, String> data) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['nom']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF003366))),
                Text('${data['membres']} membres', style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Text('RAPPORTS', style: TextStyle(fontSize: 9, color: Colors.grey)),
                Text(data['rapports']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.green)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF003366).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(data['sante']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003366))),
          ),
        ],
      ),
    );
  }
}
