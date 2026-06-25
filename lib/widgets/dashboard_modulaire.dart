import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../models/hierarchy_models.dart';
import '../models/user.dart';

class DashboardModulaire extends StatelessWidget {
  final String title;
  final List<Widget> carouselItems;
  final List<Map<String, dynamic>> navigationTabs;
  final List<Widget> bottomSection;
  final Widget? levelSelector;

  const DashboardModulaire({
    super.key,
    required this.title,
    required this.carouselItems,
    required this.navigationTabs,
    required this.bottomSection,
    this.levelSelector,
  });

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF1a2a4a),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0d1b3e),
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(_getRoleIcon(user?.role), color: const Color(0xFF003366), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.white), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => AuthService.logout().then((_) => context.go('/login')),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (levelSelector != null) levelSelector!,
            if (levelSelector != null) const SizedBox(height: 20),

            _buildSectionTitle('À la Une / Annonces', Icons.campaign),
            const SizedBox(height: 12),
            _buildCarousel(),
            const SizedBox(height: 24),

            _buildNavigationTabs(context),
            const SizedBox(height: 24),

            ...bottomSection,
          ],
        ),
      ),
    );
  }

  IconData _getRoleIcon(UserRole? role) {
    if (role == UserRole.superAdmin) return Icons.security;
    if (role == UserRole.apotrePatriarche || role == UserRole.apotreDistrict || role == UserRole.apotre) return Icons.account_balance;
    if (role == UserRole.respCommission) return Icons.assignment_ind;
    return Icons.person;
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  Widget _buildCarousel() {
    return SizedBox(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: carouselItems,
      ),
    );
  }

  Widget _buildNavigationTabs(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: navigationTabs.map((tab) => _buildTabItem(context, tab)).toList(),
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, Map<String, dynamic> tab) {
    return GestureDetector(
      onTap: () => context.push(tab['route'] as String),
      child: Container(
        margin: const EdgeInsets.only(right: 24),
        child: Column(
          children: [
            Icon(tab['icon'] as IconData, color: Colors.white70, size: 24),
            const SizedBox(height: 6),
            Text(tab['label'] as String, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
