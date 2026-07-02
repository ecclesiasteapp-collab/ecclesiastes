import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/database_helper.dart';

class ReportDetailPage extends StatefulWidget {
  final Map<String, dynamic> report;

  const ReportDetailPage({super.key, required this.report});

  @override
  State<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  void _validateReport() async {
    await DatabaseHelper.instance.validateReport(widget.report['id']);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rapport validé avec succès.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop(true); // Retourne true pour indiquer un changement
    }
  }

  void _showRejectionDialog() {
    final TextEditingController reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Motif du Rejet'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            hintText: 'Expliquez pourquoi le rapport est rejeté...',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              if (reasonController.text.isEmpty) return;
              await DatabaseHelper.instance.rejectReport(widget.report['id'], reasonController.text);
              if (dialogContext.mounted) Navigator.pop(dialogContext);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Rapport rejeté.'),
                    backgroundColor: Colors.red,
                  ),
                );
                Navigator.of(context).pop(true); // Retourne true pour indiquer un changement
              }
            },
            child: const Text('Confirmer le Rejet'),
          ),
        ],
      ),
    );
  }

  Widget _buildPayloadDetails() {
    final payloadString = widget.report['payload'];
    if (payloadString == null || payloadString.isEmpty) {
      return const Text('Aucun contenu détaillé disponible.');
    }

    try {
      final payloadData = jsonDecode(payloadString) as Map<String, dynamic>;
      if (payloadData.isEmpty) {
        return const Text('Le contenu du rapport est vide.');
      }

      final detailWidgets = payloadData.entries.map((entry) {
        return ListTile(
          dense: true,
          title: Text(_formatKey(entry.key), style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(entry.value.toString()),
        );
      }).toList();

      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: detailWidgets);
    } catch (e) {
      // Si le payload n'est pas un JSON valide, on l'affiche tel quel.
      return Text(payloadString);
    }
  }

  String _formatKey(String key) => key.replaceAll('_', ' ').split(' ').map((str) => str.isNotEmpty ? '${str[0].toUpperCase()}${str.substring(1)}' : '').join(' ');

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(widget.report['dateSoumission'] ?? '');
    final formattedDate = date != null ? DateFormat('dd MMMM yyyy HH:mm', 'fr_FR').format(date) : 'Date inconnue';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.report['type'] ?? 'Détail du Rapport'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text('Rapport de ${widget.report['rapporteurNom']}', style: Theme.of(context).textTheme.headlineSmall),
          Text('Entité: ${widget.report['nomEntite']}'),
          const SizedBox(height: 8),
          Text('Soumis le: $formattedDate'),
          const Divider(height: 32),
          _buildPayloadDetails(),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _showRejectionDialog,
                icon: const Icon(Icons.thumb_down),
                label: const Text('Rejeter'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              ),
              ElevatedButton.icon(
                onPressed: _validateReport,
                icon: const Icon(Icons.thumb_up),
                label: const Text('Valider'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
