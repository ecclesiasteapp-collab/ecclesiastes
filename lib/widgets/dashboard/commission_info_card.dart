import 'package:flutter/material.dart';
import 'package:ecclesiaste/models/hierarchy_models.dart';

/// Widget pour afficher les informations d'une commission
/// adapté selon le niveau d'entité (Internationale, Territoriale, etc.)
class CommissionInfoCard extends StatelessWidget {
  final String commissionName;
  final String? responsableName;
  final String? suppleantName;
  final int membersCount;
  final int districtsCount;
  final int communitiesCount;
  final EntityLevel entityLevel;
  final bool isSuppleant;

  const CommissionInfoCard({
    super.key,
    required this.commissionName,
    this.responsableName,
    this.suppleantName,
    this.membersCount = 0,
    this.districtsCount = 0,
    this.communitiesCount = 0,
    required this.entityLevel,
    this.isSuppleant = false,
  });

  static const _bg = Color(0xFF1E3C72);
  static const _accent = Color(0xFF2A5298);

  String _getEntityLabel(EntityLevel level) {
    switch (level) {
      case EntityLevel.internationale:
        return 'Église Internationale';
      case EntityLevel.territoriale:
        return 'Église Territoriale';
      case EntityLevel.champ:
        return 'Champ Apostolique';
      case EntityLevel.regionApostolique:
        return 'Région Apostolique';
      case EntityLevel.district:
        return 'District';
      case EntityLevel.communaute:
        return 'Communauté';
    }
  }

  String _getStatisticsText() {
    switch (entityLevel) {
      case EntityLevel.internationale:
        return '$membersCount membres • $districtsCount territoires • $communitiesCount champs';
      case EntityLevel.territoriale:
        return '$membersCount membres • $districtsCount champs • $communitiesCount districts';
      case EntityLevel.regionApostolique:
        return '$membersCount membres • $districtsCount districts • $communitiesCount communautés';
      case EntityLevel.champ:
        return '$membersCount membres • $districtsCount districts • $communitiesCount communautés';
      case EntityLevel.district:
        return '$membersCount membres • $communitiesCount communautés';
      case EntityLevel.communaute:
        return '$membersCount membres actifs';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_bg, _accent],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec icône et titre
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.groups, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Commission $commissionName',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _getEntityLabel(entityLevel),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Responsabilités
          if (responsableName != null || suppleantName != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (responsableName != null)
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.white70, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Responsable Principal',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                responsableName!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  if (suppleantName != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.person_outline, color: Colors.white70, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Suppléant',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                suppleantName!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Statistiques
          Text(
            _getStatisticsText(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),

          // Badge suppléant si applicable
          if (isSuppleant) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info, color: Colors.white, size: 14),
                  SizedBox(width: 6),
                  Text(
                    'Mode Suppléant Actif',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

