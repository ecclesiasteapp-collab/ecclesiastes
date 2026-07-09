import 'package:flutter/material.dart';
import '../../core/rbac/admin_roles.dart';

class AdminDashboard extends StatelessWidget {
  final AdminLevel adminLevel;
  final String entityId; // ID de l'entité de référence

  const AdminDashboard({super.key, required this.adminLevel, required this.entityId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administration - ${_levelLabel(adminLevel)}'),
        actions: [
          if (AdminPermissions.can(adminLevel, 'export:reports'))
            IconButton(icon: const Icon(Icons.download), onPressed: _exportReports),
        ],
      ),
      body: Row(
        children: [
          // Sidebar de navigation hiérarchique
          if (adminLevel.index > AdminLevel.community.index)
            _buildHierarchySidebar(),
          
          // Contenu principal
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildHierarchySidebar() {
    return NavigationRail(
      destinations: [
        if (adminLevel.index >= AdminLevel.district.index)
          const NavigationRailDestination(icon: Icon(Icons.home), label: Text('Communautés')),
        if (adminLevel.index >= AdminLevel.champ.index)
          const NavigationRailDestination(icon: Icon(Icons.map), label: Text('Districts')),
        if (adminLevel.index >= AdminLevel.apostolicRegion.index)
          const NavigationRailDestination(icon: Icon(Icons.explore), label: Text('Champs')),
        if (adminLevel.index >= AdminLevel.territorial.index)
          const NavigationRailDestination(icon: Icon(Icons.public), label: Text('Régions')),
      ],
      selectedIndex: 0,
      onDestinationSelected: (index) {
        // Navigation vers le niveau sélectionné
      },
    );
  }

  Widget _buildMainContent() {
    switch (adminLevel) {
      case AdminLevel.community:
        return _CommunityView(entityId: entityId);
      case AdminLevel.district:
        return _DistrictView(districtId: entityId);
      case AdminLevel.champ:
        return _ChampView(champId: entityId);
      case AdminLevel.apostolicRegion:
        return _RegionView(regionId: entityId);
      case AdminLevel.territorial:
        return const _TerritorialView();
      case AdminLevel.superAdmin:
        return const _SuperAdminView();
    }
  }

  String _levelLabel(AdminLevel level) => switch (level) {
    AdminLevel.community => 'Communauté',
    AdminLevel.district => 'District',
    AdminLevel.champ => 'Champ',
    AdminLevel.apostolicRegion => 'Région Apostolique',
    AdminLevel.territorial => 'Territorial',
    AdminLevel.superAdmin => 'Super Admin',
  };

  void _exportReports() {
    // Logique d'export PDF/Excel des rapports validés
  }
}

class _CommunityView extends StatelessWidget {
  final String entityId;
  const _CommunityView({required this.entityId});
  @override
  Widget build(BuildContext context) => Center(child: Text('Vue Communauté: $entityId'));
}

class _DistrictView extends StatelessWidget {
  final String districtId;
  const _DistrictView({required this.districtId});
  @override
  Widget build(BuildContext context) => Center(child: Text('Vue District: $districtId'));
}

class _ChampView extends StatelessWidget {
  final String champId;
  const _ChampView({required this.champId});
  @override
  Widget build(BuildContext context) => Center(child: Text('Vue Champ: $champId'));
}

class _RegionView extends StatelessWidget {
  final String regionId;
  const _RegionView({required this.regionId});
  @override
  Widget build(BuildContext context) => Center(child: Text('Vue Région Apostolique: $regionId'));
}

class _TerritorialView extends StatelessWidget {
  const _TerritorialView();
  @override
  Widget build(BuildContext context) => const Center(child: Text('Vue Territoriale'));
}

class _SuperAdminView extends StatelessWidget {
  const _SuperAdminView();
  @override
  Widget build(BuildContext context) => const Center(child: Text('Vue Super Admin'));
}

