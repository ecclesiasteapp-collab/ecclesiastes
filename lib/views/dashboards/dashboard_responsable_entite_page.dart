import 'package:ecclesiaste/models/hierarchy_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecclesiaste/services/auth_service.dart';
import 'package:ecclesiaste/widgets/dashboard/entite_hierarchy_pills.dart';

import 'package:ecclesiaste/services/database_helper.dart';
import 'package:ecclesiaste/config/organization_config.dart';
import 'package:ecclesiaste/providers/scope_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

import 'package:ecclesiaste/widgets/dashboard/dashboard_shared.dart';

class DashboardResponsableEntitePage extends ConsumerStatefulWidget {
  const DashboardResponsableEntitePage({super.key});

  @override
  ConsumerState<DashboardResponsableEntitePage> createState() => _DashboardResponsableEntitePageState();
}

class _DashboardResponsableEntitePageState extends ConsumerState<DashboardResponsableEntitePage> {
  List<Map<String, dynamic>> _commissions = [];
  bool _loadingCommissions = true;

  @override
  void initState() {
    super.initState();
    _loadCommissions();
  }

  Future<void> _loadCommissions() async {
    setState(() => _loadingCommissions = true);
    final entityId = ref.read(activeEntityIdProvider);
    if (entityId.isEmpty) {
       setState(() => _loadingCommissions = false);
       return;
    }
    final list = await DatabaseHelper.instance.getCommissionsByEntity(entityId);
    if (mounted) {
      setState(() {
        _commissions = list;
        _loadingCommissions = false;
      });
    }
  }

  Future<void> _activateCommissions() async {
    setState(() => _loadingCommissions = true);
    final user = AuthService.currentUser;
    final entityId = ref.read(activeEntityIdProvider);
    
    if (entityId.isEmpty) return;

    final commissionsBox = await Hive.openBox<Map>('commissions_map');
    
    for (final config in OrganizationConfig.commissions) {
      final commissionId = const Uuid().v4();
      await commissionsBox.put(commissionId, {
        'id': commissionId,
        'entite_id': entityId,
        'entite_type': user?.entityLevel?.name.toUpperCase(),
        'commission_code': config.code,
        'commission_type': config.type.name,
        'commission_nom': config.name,
        'responsable_id': null,
        'responsable_nom': 'À désigner',
        'statut': 'active',
        'date_activation': DateTime.now().toIso8601String(),
      });
    }
    
    await _loadCommissions();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Commissions activées avec succès')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... reste du build existant
    final user = AuthService.currentUser;
    final String entityLevelName = user?.entityLevel?.name.toUpperCase() ?? 'ENTITÉ';

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
                  Text('Administration $entityLevelName', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(user?.fullName ?? 'Responsable', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7))),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.logout, color: Colors.white, size: 22), onPressed: () => _handleLogout(context)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EntiteHierarchyPills(onScopeChanged: () => _loadCommissions()),
            const SizedBox(height: 20),
            _buildQuickSearch(context),
            const SizedBox(height: 20),
            _buildSectionTitle('PILOTAGE STRATÉGIQUE'),
            const SizedBox(height: 12),
            _buildNavigationCompass(context),
            const SizedBox(height: 24),
            if (user?.entityLevel != null && user!.entityLevel!.index >= EntityLevel.district.index) ...[
              _buildSectionTitle('CONSOLIDATION FINANCIÈRE', Icons.account_balance),
              const SizedBox(height: 12),
              _buildFinanceConsolidationCard(context),
              const SizedBox(height: 24),
            ],
            if (user?.entityLevel == EntityLevel.communaute) ...[
              _buildSectionTitle('SANTÉ CHRÉTIENNE & SPIRITUELLE'),
              const SizedBox(height: 12),
              _buildSpiritualHealthMonitor(),
              const SizedBox(height: 24),
            ],
            _buildSectionTitle('COMMISSIONS DE L\'ENTITÉ'),
            const SizedBox(height: 12),
            _buildCommissionsDynamicGrid(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, [IconData icon = Icons.bookmark]) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1B6B9E), size: 20),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B6B9E))),
      ],
    );
  }

  Widget _buildFinanceConsolidationCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF003366),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Column(
        children: [
          const Text('Total Offrandes sous votre juridiction', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _financeItem('CDF', '1.250.000'),
              Container(width: 1, height: 40, color: Colors.white24),
              _financeItem('USD', '450'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _financeItem(String unit, String val) {
    return Column(
      children: [
        Text(unit, style: const TextStyle(color: Colors.white60, fontSize: 10)),
        Text(val, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildNavigationCompass(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {'label': 'Rapports', 'count': 'Officiels', 'icon': Icons.description, 'color': Colors.blue, 'route': '/reports/official-list'},
      {'label': 'Membres', 'count': 'Annuaire', 'icon': Icons.people, 'color': Colors.green, 'route': '/members'},
      {'label': 'Finances', 'count': 'Journal', 'icon': Icons.account_balance_wallet, 'color': Colors.orange, 'route': '/finances/journal'},
      {'label': 'Bibliothèque', 'count': 'Directives', 'icon': Icons.auto_stories, 'color': Colors.purple, 'route': '/library'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.3, // MÉTRIQUE RESPECTÉE
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => context.push(item['route']),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: (item['color'] as Color).withOpacity(0.3)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
            ),
            child: Row(
              children: [
                Icon(item['icon'] as IconData, color: item['color'] as Color, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item['label'] as String, style: const TextStyle(color: Color(0xFF1B6B9E), fontSize: 13, fontWeight: FontWeight.bold)),
                      Text(item['count'] as String, style: const TextStyle(color: Colors.black54, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpiritualHealthMonitor() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
      child: Column(
        children: [
          _healthRow('Membres Actifs', '85%', Colors.green),
          const Divider(height: 24),
          _healthRow('Visites Pastorales', '12/45', Colors.orange),
        ],
      ),
    );
  }

  Widget _healthRow(String label, String val, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: Text(val, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12))),
      ],
    );
  }

  Widget _buildCommissionsDynamicGrid(BuildContext context) {
    if (_loadingCommissions) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_commissions.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            const Icon(Icons.group_work_outlined, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Aucune commission activée pour cette entité.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _activateCommissions,
              icon: const Icon(Icons.bolt),
              label: const Text('ACTIVER MES COMMISSIONS'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B6B9E),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.2,
      ),
      itemCount: _commissions.length,
      itemBuilder: (context, index) {
        final comm = _commissions[index];
        return _miniComm(context, comm['commission_code'] ?? 'N/A', commissionIcon(comm['commission_nom'] ?? ''));
      },
    );
  }

  Widget _miniComm(BuildContext context, String code, IconData icon) {
    return InkWell(
      onTap: () => context.push('/dashboard/commission', extra: {'type': code}),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF1B6B9E), size: 20),
            const SizedBox(height: 4),
            Text(
              code,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1B6B9E)),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommissionsGrid(BuildContext context) {
    // Méthode devenue obsolète au profit de _buildCommissionsDynamicGrid
    return const SizedBox.shrink();
  }

  Widget _buildQuickSearch(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
      child: TextField(
        decoration: InputDecoration(hintText: 'Recherche rapide...', prefixIcon: const Icon(Icons.search, color: Color(0xFF1B6B9E)), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.symmetric(vertical: 15)),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    AuthService.logout();
    context.go('/login');
  }
}
