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
      backgroundColor: Colors.white, // Fond blanc demandé
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, user),
              if (topSection != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: topSection!,
                ),
                const SizedBox(height: 20),
              ],

              _buildSectionTitle('À la Une', Icons.bookmark), 
              const SizedBox(height: 12),
              _buildCarousel(),
              const SizedBox(height: 24),

              _buildNavigationTabs(context), 
              const SizedBox(height: 24),

              ...bottomSection,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, User? user) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFF003366), // En-tête garde le bleu institutionnel
      child: Row(
        children: [
          headerLeading ?? _buildDefaultAvatar(user), 
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset('assets/logos/Logo.png', height: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
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
          headerTrailing ?? _buildDefaultActions(context), 
        ],
      ),
    );
  }

  Widget _buildDefaultActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDefaultNotification(),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white, size: 22),
          tooltip: 'Déconnexion',
          onPressed: () => _handleLogout(context),
        ),
      ],
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await AuthService.logout();
              if (context.mounted) context.go('/login');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Déconnecter', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(User? user) {
    IconData icon = Icons.person;
    if (user?.role == UserRole.superAdmin) {
      icon = Icons.security;
    } else if (user?.commissionType != null) {
      icon = _getCommissionIcon(user!.commissionType!);
    }
    return Hero(
      tag: 'user_icon',
      child: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.white24,
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }

  IconData _getCommissionIcon(CommissionType type) {
    switch (type) {
      case CommissionType.ecodim: return Icons.child_care;
      case CommissionType.jeunesse: return Icons.emoji_people;
      case CommissionType.econfi: return Icons.account_balance;
      case CommissionType.medicale: return Icons.local_hospital;
      case CommissionType.aines: return Icons.elderly;
      case CommissionType.construction: return Icons.build;
      case CommissionType.securiteProtocole: return Icons.security;
      case CommissionType.presseMediasSonorisation: return Icons.camera_alt;
      case CommissionType.papas: return Icons.man;
      case CommissionType.mamans: return Icons.woman;
      case CommissionType.josephArimathee: return Icons.volunteer_activism;
      case CommissionType.musique: return Icons.music_note;
      default: return Icons.group;
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
          right: 5,
          top: 5,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF003366), width: 1.5),
            ),
            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
            child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
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
          Icon(icon, color: const Color(0xFF003366), size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003366),
            )
          )
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    return SizedBox(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: carouselItems,
      ),
    );
  }

  Widget _buildNavigationTabs(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navigationTabs.map((tab) => _buildTabItem(context, tab)).toList(),
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, Map<String, dynamic> tab) {
    return InkWell(
      onTap: () => context.push(tab['route'] as String),
      child: Column(
        children: [
          Icon(tab['icon'] as IconData, color: const Color(0xFF003366), size: 28),
          const SizedBox(height: 6),
          Text(
            tab['label'] as String,
            style: const TextStyle(color: Color(0xFF003366), fontSize: 11, fontWeight: FontWeight.w500)
          )
        ],
      ),
    );
  }
}
