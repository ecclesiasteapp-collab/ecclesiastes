import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:ecclesiaste/models/hierarchy_models.dart';
import 'package:ecclesiaste/services/report_cascading_service.dart';

/// Widget affichant la progression de validation sur les 5 niveaux hiérarchiques.
class ReportStatusStepper extends StatelessWidget {
  const ReportStatusStepper({
    required this.lastValidatedLevel,
    super.key,
    this.validationHistory,
  });

  final EntityLevel? lastValidatedLevel;
  final Map<EntityLevel, Map<String, dynamic>>? validationHistory;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Text(
            ReportCascadingService.getStatusLabel(lastValidatedLevel),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _getStatusColor(context),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: EntityLevel.values.map((level) {
            return Expanded(
              child: _buildStep(context, level),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStep(BuildContext context, EntityLevel level) {
    final bool isLast = level == EntityLevel.internationale;
    final bool isValidated =
        lastValidatedLevel != null && level.index <= lastValidatedLevel!.index;
    final bool isCurrent = lastValidatedLevel == null
        ? level == EntityLevel.communaute
        : (level.index == lastValidatedLevel!.index + 1);

    Color color;
    if (isValidated) {
      color = Colors.green;
    } else if (isCurrent) {
      color = Theme.of(context).primaryColor;
    } else {
      color = Colors.grey.shade300;
    }

    return InkWell(
      onTap: isValidated ? () => _showValidationDetails(context, level) : null,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        children: [
          Row(
            children: [
              // Ligne de connexion gauche
              Expanded(
                child: Container(
                  height: 2,
                  color: level.index == 0
                      ? Colors.transparent
                      : color.withValues(alpha: 0.5),
                ),
              ),
              // Cercle indicateur
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isValidated ? color : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: isValidated
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : isCurrent
                        ? Center(
                            child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle)))
                        : null,
              ),
              // Ligne de connexion droite
              Expanded(
                child: Container(
                  height: 2,
                  color: isLast
                      ? Colors.transparent
                      : (isValidated ? Colors.green : Colors.grey.shade300),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            level.name.substring(0, 3).toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: isCurrent || isValidated
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: isValidated
                  ? Colors.green
                  : (isCurrent ? Colors.black : Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  void _showValidationDetails(BuildContext context, EntityLevel level) {
    final info = validationHistory?[level];
    if (info == null) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Validation : ${level.name.toUpperCase()}',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.person_outline, 'Validé par',
                info['userName'] ?? 'Inconnu'),
            _buildDetailRow(
                Icons.work_outline, 'Rôle', info['userRole'] ?? 'N/A'),
            _buildDetailRow(
                Icons.access_time,
                'Date & Heure',
                info['date'] != null
                    ? DateFormat('dd/MM/yyyy HH:mm')
                        .format(info['date'] as DateTime)
                    : 'N/A'),
            if (info['comment'] != null &&
                info['comment'].toString().isNotEmpty)
              _buildDetailRow(Icons.chat_bubble_outline, 'Commentaire',
                  info['comment'].toString()),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BuildContext context) {
    if (lastValidatedLevel == EntityLevel.internationale) return Colors.green;
    if (lastValidatedLevel == null) return Colors.orange;
    return Theme.of(context).primaryColor;
  }
}

