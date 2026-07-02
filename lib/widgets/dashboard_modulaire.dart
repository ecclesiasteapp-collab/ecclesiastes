import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../core/theme.dart';
import '../models/hierarchy_models.dart';
import '../models/user.dart';

class DashboardModulaire extends StatelessWidget {
  final String title;
  final List<Widget> carouselItems;
  final List<Map<String, dynamic>> navigationTabs;
  final List<Widget> bottomSection;
  final Widget? topSection;
  final Widget? headerLeading;
  final Widget? headerTrailing;
  final String? headerSubtitle;

  const DashboardModulaire({
    super.key,
    required this.title,
    required this.carouselItems,
    required this.navigationTabs,
    required this.bottomSection,
    this.topSection,
    this.headerLeading,
    this.headerTrailing,
    this.headerSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.primaryDark, // Fond sombre conforme au nouveau style
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(user), // Utiliser le nouveau header
              if (topSection != null) topSection!,
              if (topSection != null) const SizedBox(height: 20),

              _buildSectionTitle('À la Une', Icons.bookmark), // Section À la Une
              const SizedBox(height: 12),
              _buildCarousel(),
              const SizedBox(height: 24),

              _buildNavigationTabs(context), // Navigation Rapide
              const SizedBox(height: 24),

              ...bottomSection,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(User? user) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          headerLeading ?? _buildDefaultAvatar(user), // Avatar ou widget personnalisé
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (headerSubtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    headerSubtitle!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
          headerTrailing ?? _buildDefaultNotification(), // Cloche ou widget personnalisé
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(User? user) {
    IconData icon = Icons.person;
    if (user?.role == UserRole.superAdmin) {
      icon = Icons.security;
    } else if (user?.commissionType != null) {
      icon = _getCommissionIcon(user!.commissionType!); // Assurez-vous que cette fonction existe
    }
    return Hero(
      tag: 'user_icon',
      child: CircleAvatar(
        radius: 24, // Taille augmentée pour correspondre au nouveau style
        backgroundColor: Colors.grey.shade300,
        child: Icon(icon, color: AppTheme.primaryDark, size: 28),
      ),
    );
  }

  IconData _getCommissionIcon(CommissionType type) {
    switch (type) {
      case CommissionType.ecodim:
        return Icons.child_care;
      case CommissionType.jeunesse:
        return Icons.emoji_people;
      case CommissionType.econfi:
        return Icons.account_balance;
      case CommissionType.medicale:
        return Icons.local_hospital;
      case CommissionType.aines:
        return Icons.elderly;
      case CommissionType.construction:
        return Icons.build;
      case CommissionType.securiteProtocole:
        return Icons.security;
      case CommissionType.presseMediasSonorisation:
        return Icons.camera_alt;
      case CommissionType.papas:
        return Icons.man;
      case CommissionType.mamans:
        return Icons.woman;
      case CommissionType.josephArimathee:
        return Icons.volunteer_activism;
      case CommissionType.musique:
        return Icons.music_note;
      default:
        return Icons.group;
    }
  }

  Widget _buildDefaultNotification() {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white, size: 26),
          onPressed: () {},
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            constraints: const BoxConstraints(
              minWidth: 18,
              minHeight: 18,
            ),
            child: const Text(
              '3', // Nombre de notifications
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )
          )
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    return SizedBox(
      height: 180, // Hauteur respectée
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: carouselItems,
      ),
    );
  }

  Widget _buildNavigationTabs(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navigationTabs.map((tab) => _buildTabItem(context, tab)).toList(),
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, Map<String, dynamic> tab) {
    return GestureDetector(
      onTap: () => context.push(tab['route'] as String),
      child: Column(
        children: [
          Icon(tab['icon'] as IconData, color: Colors.white70, size: 24),
          const SizedBox(height: 4),
          Text(
            tab['label'] as String,
            style: const TextStyle(color: Colors.white70, fontSize: 11)
          )
        ],
      ),
    );
  }
}

