import 'package:flutter/material.dart';
import 'package:ecclesiaste/models/hierarchy_models.dart';
import 'package:ecclesiaste/services/auth_service.dart';
import 'package:ecclesiaste/services/report_cascading_service.dart';

/// Bouton intelligent qui gère la validation d'un rapport selon la hiérarchie.
class ReportValidationButton extends StatefulWidget {
  final EntityLevel? lastValidatedLevel;
  final Function(EntityLevel level, Map<String, dynamic> validationData)
      onValidated;
  final Function(String reason)? onRejected;

  const ReportValidationButton({
    super.key,
    required this.lastValidatedLevel,
    required this.onValidated,
    this.onRejected,
  });

  @override
  State<ReportValidationButton> createState() => _ReportValidationButtonState();
}

class _ReportValidationButtonState extends State<ReportValidationButton> {
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final targetLevel = ReportCascadingService.getNextValidationLevel(
        widget.lastValidatedLevel);

    if (targetLevel == null) return const SizedBox.shrink();

    final user = AuthService.currentUser;
    if (user == null) return const SizedBox.shrink();

    // Vérification des permissions de l'utilisateur actuel
    final bool canValidate = user.role == UserRole.superAdmin ||
        user.role == UserRole.apotrePatriarche ||
        user.role == UserRole.apotreDistrict ||
        user.role == UserRole.apotreResponsable ||
        user.role == UserRole.apotre ||
        user.role == UserRole.eveque ||
        user.role == UserRole.ancien;

    if (!canValidate) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.verified_user),
              label: Text(
                  'VALIDER POUR LE NIVEAU ${targetLevel.name.toUpperCase()}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () => _showValidationDialog(context, targetLevel),
            ),
          ),
          if (widget.lastValidatedLevel != null) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              icon: const Icon(Icons.cancel_outlined, color: Colors.red),
              label: const Text('REJETER AU NIVEAU PRÉCÉDENT',
                  style: TextStyle(color: Colors.red)),
              onPressed: () => _showRejectionDialog(context),
            ),
          ],
        ],
      ),
    );
  }

  void _showRejectionDialog(BuildContext context) {
    _commentController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rejeter le rapport'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'Expliquez pourquoi ce rapport doit être corrigé par le niveau inférieur.'),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Motif du rejet',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ANNULER')),
          ElevatedButton(
            onPressed: () {
              if (_commentController.text.trim().isEmpty) return;
              final reason = _commentController.text.trim();
              Navigator.pop(context);
              if (widget.onRejected != null) widget.onRejected!(reason);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('CONFIRMER LE REJET'),
          ),
        ],
      ),
    );
  }

  void _showValidationDialog(BuildContext context, EntityLevel targetLevel) {
    _commentController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Validation ${targetLevel.name.toUpperCase()}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'En validant, vous attestez de la véracité des informations contenues dans ce rapport.'),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Commentaire pastoral (optionnel)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ANNULER'),
          ),
          ElevatedButton(
            onPressed: () {
              final user = AuthService.currentUser;

              final validationData = {
                'userName': user?.fullName ?? 'Utilisateur',
                'userRole': user?.role.name ?? 'Responsable',
                'date': DateTime.now(),
                'comment': _commentController.text.trim(),
              };

              Navigator.pop(context);
              widget.onValidated(targetLevel, validationData);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Rapport validé au niveau ${targetLevel.name}')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('CONFIRMER LA VALIDATION'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}

