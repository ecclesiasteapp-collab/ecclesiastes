import 'package:flutter/material.dart';
import '../models/person_model.dart';
import '../models/sacrament_model.dart';
import '../models/ordination_model.dart';
import '../models/nomination_model.dart';
import '../services/person_service.dart';
import '../core/theme.dart';
import 'package:intl/intl.dart';
import 'governance_management_page.dart';

class PersonDossierPage extends StatefulWidget {
  final String personId;

  const PersonDossierPage({super.key, required this.personId});

  @override
  State<PersonDossierPage> createState() => _PersonDossierPageState();
}

class _PersonDossierPageState extends State<PersonDossierPage> {
  final PersonService _personService = PersonService.instance;
  Map<String, dynamic>? _dossier;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDossier();
  }

  Future<void> _loadDossier() async {
    setState(() => _isLoading = true);
    final data = await _personService.getFullDossier(widget.personId);
    setState(() {
      _dossier = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_dossier == null || _dossier!.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Dossier Ecclésiastique')),
        body: const Center(child: Text('Personne introuvable')),
      );
    }

    final Person person = _dossier!['person'];
    final List<Sacrament> sacraments = _dossier!['sacraments'];
    final List<Ordination> ordinations = _dossier!['ordinations'];
    final List<Nomination> nominations = _dossier!['nominations'];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Dossier Ecclésiastique Unique'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_suggest_outlined),
            tooltip: 'Gérer les mandats',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => GovernanceManagementPage(personId: widget.personId)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIdentityCard(person),
            const SizedBox(height: 24),
            _buildSectionTitle('Parcours Spirituel (Sacrements)', Icons.auto_awesome),
            _buildSacramentsList(sacraments),
            const SizedBox(height: 24),
            _buildSectionTitle('Parcours Ministériel (Ordinations)', Icons.workspace_premium),
            _buildOrdinationsList(ordinations),
            const SizedBox(height: 24),
            _buildSectionTitle('Mandats & Fonctions (Nominations)', Icons.assignment_ind),
            _buildNominationsList(nominations),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildIdentityCard(Person person) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppTheme.primary.withOpacity(0.1),
                  child: const Icon(Icons.person, size: 50, color: AppTheme.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        person.fullName,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        person.ecclesiasticalId,
                        style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          person.status,
                          style: const TextStyle(fontSize: 12, color: AppTheme.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            _buildInfoRow(Icons.cake, 'Né le', DateFormat('dd/MM/yyyy').format(person.birthDate)),
            _buildInfoRow(Icons.location_on, 'Adresse', person.address ?? 'Non renseignée'),
            _buildInfoRow(Icons.phone, 'Téléphone', person.phone ?? 'Non renseigné'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text('$label : ', style: const TextStyle(color: Colors.grey)),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary, size: 22),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primary, letterSpacing: 1.1),
          ),
        ],
      ),
    );
  }

  Widget _buildSacramentsList(List<Sacrament> list) {
    if (list.isEmpty) return _buildEmptyCard('Aucun sacrement enregistré');
    return Column(
      children: list.map((s) => _buildDossierItem(
        title: s.type,
        subtitle: 'Par ${s.officiantName ?? "Ministre inconnu"}',
        date: s.date,
        icon: Icons.water_drop,
        color: Colors.blue,
      )).toList(),
    );
  }

  Widget _buildOrdinationsList(List<Ordination> list) {
    if (list.isEmpty) return _buildEmptyCard('Aucune ordination enregistrée');
    return Column(
      children: list.map((o) => _buildDossierItem(
        title: o.rank.name,
        subtitle: 'À ${o.entityId}',
        date: o.date,
        icon: Icons.workspace_premium,
        color: Colors.amber.shade700,
      )).toList(),
    );
  }

  Widget _buildNominationsList(List<Nomination> list) {
    if (list.isEmpty) return _buildEmptyCard('Aucun mandat enregistré');
    return Column(
      children: list.map((n) => _buildDossierItem(
        title: n.functionName,
        subtitle: '${n.type} • ${n.entityId}',
        date: n.startDate,
        endDate: n.endDate,
        icon: Icons.assignment_ind,
        color: Colors.teal,
        isCurrent: n.isActive,
      )).toList(),
    );
  }

  Widget _buildDossierItem({
    required String title,
    required String subtitle,
    required DateTime date,
    DateTime? endDate,
    required IconData icon,
    required Color color,
    bool isCurrent = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              DateFormat('dd/MM/yyyy').format(date),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            if (isCurrent)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)),
                child: const Text('ACTIF', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            else if (endDate != null)
              Text(
                'au ${DateFormat('dd/MM/yyyy').format(endDate)}',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCard(String message) {
    return Card(
      color: Colors.white.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(child: Text(message, style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey))),
      ),
    );
  }
}
