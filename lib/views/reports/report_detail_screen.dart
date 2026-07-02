import 'package:flutter/material.dart';
import '../../models/report_base.dart';
import '../../models/meeting_report.dart';
import '../../models/visit_report.dart';
import '../../models/divine_service_report.dart';
import 'package:intl/intl.dart';

class ReportDetailScreen extends StatelessWidget {
  final ReportBase report;

  const ReportDetailScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(report.title),
        backgroundColor: const Color(0xFF003366),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildContent(),
            if (report.audioSegments.isNotEmpty) _buildAudioSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(report.type.label, style: const TextStyle(color: Colors.white)),
                  backgroundColor: const Color(0xFF003366),
                ),
                Text(
                  DateFormat('dd/MM/yyyy').format(report.createdAt),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(report.author),
              subtitle: const Text('Auteur du rapport'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (report is MeetingReport) return _buildMeetingContent(report as MeetingReport);
    if (report is VisitReport) return _buildVisitContent(report as VisitReport);
    if (report is DivineServiceReport) return _buildDivineServiceContent(report as DivineServiceReport);
    return const Text('Contenu non disponible pour ce type de rapport');
  }

  Widget _buildMeetingContent(MeetingReport m) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Détails de la Réunion'),
        _infoRow('Objet', m.meetingObject ?? 'N/A'),
        _infoRow('Président', m.president ?? 'N/A'),
        _infoRow('Secrétaire', m.secretary ?? 'N/A'),
        const SizedBox(height: 16),
        _sectionTitle('Participants (${m.presentees.length})'),
        ...m.presentees.map((p) => ListTile(leading: const Icon(Icons.check, color: Colors.green), title: Text(p))),
      ],
    );
  }

  Widget _buildVisitContent(VisitReport v) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Détails de la Visite'),
        _infoRow('Lieu', v.location ?? 'N/A'),
        _infoRow('Raison', v.visitReason ?? 'N/A'),
        const SizedBox(height: 16),
        _sectionTitle('Observations'),
        Text(v.observations ?? 'Aucune observation', style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildDivineServiceContent(DivineServiceReport s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Détails du Service Divin'),
        _infoRow('Thème', s.theme ?? 'N/A'),
        _infoRow('Participants', '${s.attendance}'),
        const SizedBox(height: 16),
        _sectionTitle('Résumé'),
        Text(s.summary ?? 'Aucun résumé', style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
  );

  Widget _infoRow(String label, String val) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Text('$label : ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(val),
      ],
    ),
  );

  Widget _buildAudioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        _sectionTitle('Enregistrements Audio'),
        ...report.audioSegments.map((a) => ListTile(
          leading: const Icon(Icons.play_circle_fill, color: Colors.orange),
          title: Text(a.section),
          subtitle: Text('${a.duration.inMinutes}:${a.duration.inSeconds.remainder(60).toString().padLeft(2, '0')}'),
          trailing: const Icon(Icons.download),
        )),
      ],
    );
  }
}

