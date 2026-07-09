import 'dart:convert';
import 'dart:typed_data';
import 'package:ecclesiaste/services/file_storage_service.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../models/church_report.dart';
import '../services/auth_service.dart';


class ChurchReportDetailPage extends StatelessWidget {
  final String reportId;

  const ChurchReportDetailPage({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    final report = Hive.box<ChurchReport>('church_reports').get(reportId);

    if (report == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Rapport introuvable'),
          backgroundColor: const Color(0xFF003366),
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.description_outlined, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Ce rapport n’existe plus ou a été supprimé.'),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => context.go('/reports'),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Retour aux rapports'),
              ),
            ],
          ),
        ),
      );
    }

    final formatter = DateFormat('dd/MM/yyyy');
    final timeFormatter = DateFormat('HH:mm');

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(_reportTypeLabel(report.type)),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
        actions: [
          if (report.rapporteurId == AuthService.currentUserId && report.statut != ReportStatus.valide)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fonctionnalité de modification en cours de déploiement.'))
                );
              },
              tooltip: 'Modifier le rapport',
            ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionCard(
            title: 'Aperçu',
            icon: Icons.summarize,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.nomEntite,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(label: Text(_reportTypeLabel(report.type))),
                    Chip(label: Text('Statut: ${report.statut.name}')),
                    Chip(label: Text('Version ${report.version}')),
                  ],
                ),
                const SizedBox(height: 12),
                _detailRow('Champ', report.nomChamp),
                _detailRow('District', report.nomDistrict),
                _detailRow('Date', formatter.format(report.dateRapport)),
                _detailRow('Heure début', timeFormatter.format(report.heureDebut)),
                if (report.heureFin != null)
                  _detailRow('Heure fin', timeFormatter.format(report.heureFin!)),
                _detailRow('Rapporteur', report.rapporteur),
                _detailRow('Officiant', report.officiant.isEmpty ? 'Non renseigné' : report.officiant),
              ],
            ),
          ),
          _SectionCard(
            title: 'Liturgie',
            icon: Icons.menu_book,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailRow(
                  'Texte biblique',
                  report.texteBiblique.isEmpty ? 'Non renseigné' : report.texteBiblique,
                ),
                _detailRow(
                  'Cantique',
                  report.cantiqueIntroduction.isEmpty ? 'Non renseigné' : report.cantiqueIntroduction,
                ),
                _detailRow(
                  'Assistants',
                  report.assistants.isEmpty ? 'Aucun assistant saisi' : report.assistants.join(', '),
                ),
              ],
            ),
          ),
          _SectionCard(
            title: 'Présence',
            icon: Icons.groups,
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _statTile('Présence totale', '${report.presenceTotale}', Icons.people),
                _statTile('Membres', '${report.nombreMembres}', Icons.person),
                _statTile('Visiteurs', '${report.nombreVisiteurs}', Icons.person_add),
              ],
            ),
          ),
          _SectionCard(
            title: 'Finances',
            icon: Icons.account_balance_wallet,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailRow('Offrande FC', report.offrandeFC.toStringAsFixed(2)),
                _detailRow('Offrande devise', report.offrandeDevise.toStringAsFixed(2)),
                _detailRow(
                  'Numéro reçu',
                  report.numeroRecu.isEmpty ? 'Non renseigné' : report.numeroRecu,
                ),
              ],
            ),
          ),
          _SectionCard(
            title: 'Actes sacramentels',
            icon: Icons.auto_awesome,
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _statTile('Baptêmes', '${report.nombreBaptemes}', Icons.water_drop),
                _statTile('Scellés', '${report.nombreScelles}', Icons.verified),
                _statTile('Confirmations', '${report.nombreConfirmations}', Icons.fact_check),
                _statTile('Ordinations', '${report.nombreOrdinations}', Icons.badge),
                _statTile('Mandatements', '${report.nombreMandatements}', Icons.assignment_ind),
                _statTile('Nominations', '${report.nombreNominations}', Icons.how_to_reg),
                _statTile('Retraites', '${report.nombreRetraites}', Icons.weekend),
              ],
            ),
          ),
          if (report.champsPersonnalises.isNotEmpty)
            _SectionCard(
              title: 'Champs personnalisés',
              icon: Icons.tune,
              child: Column(
                children: report.champsPersonnalises.entries
                    .map((entry) => _detailRow(entry.key, entry.value))
                    .toList(),
              ),
            ),
          _SectionCard(
            title: 'Validation',
            icon: Icons.verified_user,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailRow('Statut', report.statut.name),
                _detailRow('Validateur', report.validateur ?? 'En attente'),
                _detailRow(
                  'Date validation',
                  report.dateValidation == null
                      ? 'Non validé'
                      : formatter.format(report.dateValidation!),
                ),
                _detailRow('Motif rejet', report.motifRejet ?? 'Aucun'),
                _detailRow('Dernière modification', report.updatedAt == null ? 'Aucune' : formatter.format(report.updatedAt!)),
                _detailRow('Modifié par', report.lastModifiedBy ?? 'N/A'),
              ],
            ),
          ),
          if (report.signaturePath != null || report.signatureBase64 != null)
            _SectionCard(
              title: 'Signature',
              icon: Icons.draw,
              child: Container(
                width: double.infinity,
                height: 120,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Builder(
                  builder: (context) {
                    if (report.signaturePath != null) {
                      return FutureBuilder<Uint8List?>(
                        future: FileStorageService.readFile(report.signaturePath!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                            return Image.memory(snapshot.data!, fit: BoxFit.contain);
                          } else if (snapshot.hasError) {
                            return const Icon(Icons.error, size: 50, color: Colors.red);
                          } else {
                            return const Center(child: CircularProgressIndicator());
                          }
                        },
                      );
                    } else if (report.signatureBase64 != null) {
                      return Image.memory(
                        base64Decode(report.signatureBase64!),
                        fit: BoxFit.contain,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  static String _reportTypeLabel(ReportTypeExt type) {
    switch (type) {
      case ReportTypeExt.serviceDivin: return 'Service Divin';
      case ReportTypeExt.visitePastorale: return 'Visite Pastorale';
      case ReportTypeExt.communionFraternelle: return 'Communion Fraternelle';
      case ReportTypeExt.ordinationInstallation: return 'Ordination / Installation';
      case ReportTypeExt.funerailles: return 'Funérailles';
      case ReportTypeExt.mariage: return 'Mariage';
      case ReportTypeExt.bapteme: return 'Baptême';
      case ReportTypeExt.sainteCene: return 'Sainte-Cène';
      case ReportTypeExt.sacristie: return 'Sacristie';
      case ReportTypeExt.ecodim: return 'ECODIM';
      case ReportTypeExt.econfi: return 'ECONFI';
      case ReportTypeExt.jeunesse: return 'Jeunesse';
      case ReportTypeExt.papas: return 'Papas';
      case ReportTypeExt.mamans: return 'Mamans';
      case ReportTypeExt.aines: return 'Aînés';
      case ReportTypeExt.musiqueTechnique: return 'Musique - Direction Technique';
      case ReportTypeExt.musiqueOrchestre: return 'Musique - Orchestre';
      case ReportTypeExt.presseMedias: return 'Presse / Médias';
      case ReportTypeExt.josephArimathee: return 'Joseph d\'Arimathée';
      case ReportTypeExt.securiteProtocole: return 'Sécurité / Protocole';
      case ReportTypeExt.medicale: return 'Médicale';
      case ReportTypeExt.construction: return 'Construction';
      case ReportTypeExt.consolidationCommunaute: return 'Consolidation Communauté';
      case ReportTypeExt.consolidationDistrict: return 'Consolidation District';
      case ReportTypeExt.consolidationChamp: return 'Consolidation Champ';
      case ReportTypeExt.consolidationTerritorial: return 'Consolidation Territorial';
      case ReportTypeExt.consolidationInternational: return 'Consolidation International';
      case ReportTypeExt.collecteFundraising: return 'Collecte / Fundraising';
      case ReportTypeExt.evenementSpecial: return 'Événement';
      case ReportTypeExt.mensuelActivite: return 'Mensuel d\'Activité';
      case ReportTypeExt.trimestrielActivite: return 'Trimestriel d\'Activité';
      case ReportTypeExt.annuelActivite: return 'Annuel d\'Activité';
      case ReportTypeExt.scellement: return 'Saint-Scellement';
      case ReportTypeExt.reunionCommission: return 'Réunion de Commission';
      case ReportTypeExt.seminaire: return 'Séminaire';
      case ReportTypeExt.repetition: return 'Répétition';
      case ReportTypeExt.formation: return 'Formation';
      case ReportTypeExt.activiteSociale: return 'Activité Sociale';
      case ReportTypeExt.inventaire: return 'Rapport d\'Inventaire';
      case ReportTypeExt.gestionDistrict: return 'Rapport de Gestion (District)';
      case ReportTypeExt.gestionCommunaute: return 'Rapport de Gestion (Cté)';
      case ReportTypeExt.autre: return 'Autre Rapport';
    }
  }

  static Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label :',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  static Widget _statTile(String label, String value, IconData icon) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF003366)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF003366)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003366),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            child,
          ],
        ),
      ),
    );
  }
}

