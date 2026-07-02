import 'package:flutter/material.dart';
import 'package:ecclesiastes/utils/dashboard_theme.dart';

/// Widget pour afficher une directive d'entité avec badge de priorité
class EntityDirectiveCard extends StatelessWidget {
  final String titre;
  final String contenu;
  final String priorite;
  final String type;
  final bool isUnread;
  final DateTime dateCreation;
  final VoidCallback? onTap;
  final VoidCallback? onMarkAsRead;

  const EntityDirectiveCard({
    required this.titre,
    required this.contenu,
    required this.priorite,
    required this.type,
    required this.isUnread,
    required this.dateCreation,
    this.onTap,
    this.onMarkAsRead,
    super.key,
  });

  Color _getPriorityColor() {
    switch (priorite.toLowerCase()) {
      case 'urgente':
        return Colors.red;
      case 'haute':
        return Colors.orange;
      case 'normale':
        return Colors.blue;
      case 'basse':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon() {
    switch (type.toLowerCase()) {
      case 'directive':
        return Icons.gavel;
      case 'message':
        return Icons.mail;
      case 'annonce':
        return Icons.campaign;
      case 'alerte':
        return Icons.warning;
      case 'formulaire':
        return Icons.description;
      case 'document':
        return Icons.folder;
      default:
        return Icons.info;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inHours < 1) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inDays < 1) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays}j';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: isUnread
                ? Border(
                    left: BorderSide(
                      color: _getPriorityColor(),
                      width: 4,
                    ),
                  )
                : null,
            color: isUnread ? _getPriorityColor().withValues(alpha: 0.05) : Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête : icône, titre, badge priorité
              Row(
                children: [
                  Icon(
                    _getTypeIcon(),
                    color: DashboardTheme.blue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      titre,
                      style: TextStyle(
                        fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Badge priorité
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      priorite.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Contenu
              Text(
                contenu,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Pied de page : date et bouton marquer comme lu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(dateCreation),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                  if (isUnread && onMarkAsRead != null)
                    TextButton(
                      onPressed: onMarkAsRead,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                      ),
                      child: const Text(
                        'Marquer comme lu',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget pour afficher la section des directives d'entité dans le dashboard
class EntityDirectivesSection extends StatelessWidget {
  final List<Map<String, dynamic>> directives;
  final int unreadCount;
  final bool isLoading;
  final VoidCallback? onViewAll;
  final Function(String directiveId, String status)? onStatusChanged;

  const EntityDirectivesSection({
    required this.directives,
    required this.unreadCount,
    required this.isLoading,
    this.onViewAll,
    this.onStatusChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête avec badge
        Row(
          children: [
            const Icon(
              Icons.campaign,
              color: Color(0xFF1B6B9E),
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text(
              'Messages & Directives de l\'Entité',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B6B9E),
              ),
            ),
            const Spacer(),
            if (unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        // Contenu
        if (isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          )
        else if (directives.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: DashboardTheme.cardDecoration(),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.inbox,
                    size: 48,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Aucune directive pour le moment',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            children: [
              ...directives.take(3).map((directive) {
                return EntityDirectiveCard(
                  titre: directive['titre'] ?? 'Sans titre',
                  contenu: directive['contenu'] ?? '',
                  priorite: directive['priorite'] ?? 'normale',
                  type: directive['type'] ?? 'message',
                  isUnread: (directive['lecture_status'] as Map?)?['current_user'] == null,
                  dateCreation: DateTime.tryParse(directive['date_creation']?.toString() ?? '') ?? DateTime.now(),
                  onTap: () {
                    // Naviguer vers le détail de la directive
                  },
                  onMarkAsRead: () {
                    onStatusChanged?.call(directive['id'], 'lu');
                  },
                );
              }),
              if (directives.length > 3)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: ElevatedButton(
                    onPressed: onViewAll,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B6B9E),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Voir toutes les directives'),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

