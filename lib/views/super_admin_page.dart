import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecclesiaste/services/auth_service.dart';
import 'package:ecclesiaste/services/database_helper.dart';
import 'package:ecclesiaste/services/attachment_storage_service.dart';
import 'package:ecclesiaste/widgets/custom_drawer.dart';
import 'package:ecclesiaste/widgets/pie_chart_widget.dart';
import 'package:ecclesiaste/views/admin/manage_users_page.dart';
import 'package:ecclesiaste/views/admin/manage_entities_page.dart';
import 'package:ecclesiaste/views/admin/nomination_page.dart';
import 'package:ecclesiaste/views/admin/governance_reports_page.dart';
import 'package:ecclesiaste/models/hierarchy_models.dart';

class SuperAdminPage extends StatefulWidget {
  const SuperAdminPage({super.key});

  @override
  State<SuperAdminPage> createState() => _SuperAdminPageState();
}

class _SuperAdminPageState extends State<SuperAdminPage> {
  bool _isLoading = true;
  int _totalUsers = 0;
  int _totalMembers = 0;
  int _pendingValidations = 0;
  int _totalEntities = 0;
  double _attachmentsSizeMB = 0.0;
  Map<String, double> _storageDistribution = {};
  Map<String, int> _membersByCommission = {};
  Map<String, int> _entitiesByType = {};
  Map<String, int> _governanceStatus = {};
  Map<String, int> _securityStats = {};
  int _activeDelegations = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        DatabaseHelper.instance.getTotalUsers(),
        DatabaseHelper.instance.getTotalMembers(),
        DatabaseHelper.instance.getUnvalidatedCount(),
        DatabaseHelper.instance.getTotalEntities(),
        AttachmentStorageService.getTotalAttachmentSizeInMB(),
        AttachmentStorageService.getStorageDistribution(),
        DatabaseHelper.instance.getMembersByCommission(),
        DatabaseHelper.instance.getEntitiesByTypeDistribution(),
        DatabaseHelper.instance.getGovernanceStatus(),
        DatabaseHelper.instance.getSecurityStats(),
        DatabaseHelper.instance.getActiveDelegationsCount(),
      ]);

      if (!mounted) return;

      setState(() {
        _totalUsers = (results[0] as int?) ?? 0;
        _totalMembers = (results[1] as int?) ?? 0;
        _pendingValidations = (results[2] as int?) ?? 0;
        _totalEntities = (results[3] as int?) ?? 0;
        _attachmentsSizeMB = (results[4] as double?) ?? 0.0;
        _storageDistribution = (results[5] as Map<String, double>?) ?? {};
        _membersByCommission = (results[6] as Map<String, int>?) ?? {};
        _entitiesByType = (results[7] as Map<String, int>?) ?? {};
        _governanceStatus = (results[8] as Map<String, int>?) ?? {};
        _securityStats = (results[9] as Map<String, int>?) ?? {};
        _activeDelegations = (results[10] as int?) ?? 0;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error
      debugPrint('Error loading Super Admin data: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _cleanupOrphanedAttachments() async {
    setState(() => _isLoading = true);
    try {
      await AttachmentStorageService.cleanupOrphanedAttachments();
      await _loadData(); // Refresh data after cleanup
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nettoyage des pièces jointes orphelines terminé.')),
        );
      }
    } catch (e) {
      debugPrint('Error cleaning up attachments: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du nettoyage: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _compactDatabase() async {
    setState(() => _isLoading = true);
    try {
      await DatabaseHelper.instance.compactAll();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Compactage de la base de données terminé.')),
        );
      }
    } catch (e) {
      debugPrint('Error compacting database: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du compactage: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    if (user == null || !user.isSuperAdmin) {
      return const Scaffold(
        body: Center(child: Text('Accès non autorisé. Seul un Super Admin peut accéder à cette page.')),
      );
    }

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Console Super Admin'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final router = GoRouter.of(context);
              await AuthService.logout();
              if (!mounted) return;
              router.go('/login');
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Statistiques Générales', Icons.bar_chart),
                  const SizedBox(height: 16),
                  _buildStatsGrid(),
                  const SizedBox(height: 32),

                  _buildSectionTitle(
                      'Répartition du Stockage', Icons.pie_chart),
                  const SizedBox(height: 16),
                  PieChartWidget(
                    title: 'Répartition des Pièces Jointes',
                    data: _storageDistribution,
                  ),
                  const SizedBox(height: 32),

                  _buildSectionTitle(
                      'Membres par Commission', Icons.group_work),
                  const SizedBox(height: 16),
                  PieChartWidget(
                    title: 'Répartition des Membres par Commission',
                    data: _membersByCommission.map((key, value) => MapEntry(key, value.toDouble())),
                  ),
                  const SizedBox(height: 32),

                  _buildSectionTitle('Santé de la Gouvernance', Icons.admin_panel_settings),
                  const SizedBox(height: 16),
                  _buildGovernanceAnalysis(),
                  const SizedBox(height: 32),

                  _buildSectionTitle('Analyses de Structure', Icons.account_tree),
                  const SizedBox(height: 16),
                  PieChartWidget(
                    title: 'Répartition des Entités par Type',
                    data: _entitiesByType.map((key, value) => MapEntry(key, value.toDouble())),
                  ),
                  const SizedBox(height: 32),

                  _buildSectionTitle('Gestion des Utilisateurs et Entités', Icons.people_alt),
                  const SizedBox(height: 16),
                  _buildUserEntityManagement(),
                  const SizedBox(height: 32),

                  _buildSectionTitle('Maintenance du Système', Icons.build),
                  const SizedBox(height: 16),
                  _buildSystemMaintenance(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple, size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.8,
      children: [
        _buildStatCard('Utilisateurs', _totalUsers.toString(), Icons.person_outline, Colors.blueAccent),
        _buildStatCard('Membres', _totalMembers.toString(), Icons.group_outlined, Colors.green),
        _buildStatCard('Validations en attente', _pendingValidations.toString(), Icons.pending_actions, Colors.orange),
        _buildStatCard('Entités', _totalEntities.toString(), Icons.account_tree_outlined, Colors.redAccent),
        _buildStatCard('Taille des Attachments', '${_attachmentsSizeMB.toStringAsFixed(2)} MB', Icons.attach_file, Colors.teal),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGovernanceAnalysis() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.shade200),
          ),
          child: Row(
            children: [
              const Icon(Icons.security_update_good, color: Colors.amber),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Délégations Actives', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Il y a actuellement $_activeDelegations ministres possédant des droits de nomination délégués.'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: PieChartWidget(
                title: 'État des Responsables',
                data: _governanceStatus.map((key, value) => MapEntry(key, value.toDouble())),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PieChartWidget(
                title: 'Sécurité des Accès',
                data: _securityStats.map((key, value) => MapEntry(key, value.toDouble())),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserEntityManagement() {
    return Column(
      children: [
        _buildAdminActionCard(
          title: 'Gérer les validations',
          subtitle: 'Approuver ou rejeter les demandes d\'inscription des utilisateurs et membres.',
          icon: Icons.how_to_reg,
          color: Colors.orange,
          onTap: () => context.push('/validation_inscription_page', extra: {'isSuperAdmin': true}),
        ),
        const SizedBox(height: 16),
        _buildAdminActionCard(
          title: 'Contrôle Total des Entités',
          subtitle: 'Ajouter, modifier ou supprimer n\'importe quelle entité (Champ, District, Communauté).',
          icon: Icons.account_tree,
          color: Colors.blue,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageEntitiesPage())),
        ),
        const SizedBox(height: 16),
        _buildAdminActionCard(
          title: 'Contrôle Total des Utilisateurs',
          subtitle: 'Modifier les rôles, suspendre des comptes ou gérer les accès.',
          icon: Icons.supervised_user_circle,
          color: Colors.green,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageUsersPage())),
        ),
        const SizedBox(height: 16),
        _buildAdminActionCard(
          title: 'Effectuer une Nomination',
          subtitle: 'Nommer des responsables Territoriaux, de District ou de Communauté.',
          icon: Icons.how_to_reg,
          color: Colors.amber,
          onTap: () => _showNominationLevelDialog(),
        ),
        const SizedBox(height: 16),
        _buildAdminActionCard(
          title: 'Archives des Rapports de Gouvernance',
          subtitle: 'Consulter les synthèses hebdomadaires de sécurité et de nominations.',
          icon: Icons.history_edu,
          color: Colors.indigo,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GovernanceReportsPage())),
        ),
      ],
    );
  }

  void _showNominationLevelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Niveau de Nomination'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Église Territoriale'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const NominationPage(targetLevel: EntityLevel.territoriale)));
              },
            ),
            ListTile(
              title: const Text('District'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const NominationPage(targetLevel: EntityLevel.district)));
              },
            ),
            ListTile(
              title: const Text('Communauté'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const NominationPage(targetLevel: EntityLevel.communaute)));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemMaintenance() {
    return Column(
      children: [
        _buildAdminActionCard(
          title: 'Nettoyer les pièces jointes orphelines',
          subtitle: 'Supprimer les fichiers qui ne sont plus liés à aucune entité (annonces, événements, etc.).',
          icon: Icons.cleaning_services,
          color: Colors.redAccent,
          onTap: _cleanupOrphanedAttachments,
        ),
        const SizedBox(height: 16),
        _buildAdminActionCard(
          title: 'Compacter la base de données',
          subtitle: 'Optimiser l\'espace de stockage de la base de données Hive.',
          icon: Icons.data_usage,
          color: Colors.purpleAccent,
          onTap: _compactDatabase,
        ),
      ],
    );
  }

  Widget _buildAdminActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: color, size: 36),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

