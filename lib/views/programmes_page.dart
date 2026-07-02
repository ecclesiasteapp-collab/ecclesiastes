import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/organization_config.dart';
import '../services/database_helper.dart';
import '../utils/entite_types.dart';

class ProgrammesPage extends StatefulWidget {
  const ProgrammesPage({super.key});

  @override
  State<ProgrammesPage> createState() => _ProgrammesPageState();
}

class _ProgrammesPageState extends State<ProgrammesPage> {
  List<Map<String, dynamic>> _programmes = [];
  String? _selectedCadence;
  String? _selectedResponsableType;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProgrammes();
  }

  Future<void> _loadProgrammes() async {
    setState(() => _loading = true);
    final data = await DatabaseHelper.instance.getProgrammes(
      responsableType: _selectedResponsableType,
    );
    if (!mounted) return;
    setState(() {
      _programmes = data;
      _loading = false;
    });
  }

  List<Map<String, dynamic>> get _filteredProgrammes {
    return _programmes.where((programme) {
      if (_selectedCadence == null) return true;
      return programme['type']?.toString() == _selectedCadence;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final programmes = _filteredProgrammes;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programmes'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildFilters(),
          _buildSummary(programmes),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : programmes.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: programmes.length,
                        itemBuilder: (context, index) {
                          return _buildProgrammeCard(programmes[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String?>(
                  initialValue: _selectedCadence,
                  decoration: const InputDecoration(
                    labelText: 'Cadence',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Toutes'),
                    ),
                    DropdownMenuItem(value: 'mensuel', child: Text('Mensuel')),
                    DropdownMenuItem(
                        value: 'trimestriel', child: Text('Trimestriel')),
                    DropdownMenuItem(value: 'annuel', child: Text('Annuel')),
                    DropdownMenuItem(value: 'special', child: Text('Spécial')),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedCadence = value);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String?>(
                  initialValue: _selectedResponsableType,
                  decoration: const InputDecoration(
                    labelText: 'Responsable',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Tous'),
                    ),
                    DropdownMenuItem(
                      value: 'ministere',
                      child: Text('Ministère'),
                    ),
                    DropdownMenuItem(
                      value: 'commission',
                      child: Text('Commission'),
                    ),
                  ],
                  onChanged: (value) async {
                    setState(() => _selectedResponsableType = value);
                    await _loadProgrammes();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _chip('Champ KSO', Icons.church),
              const SizedBox(width: 8),
              _chip('22 districts', Icons.account_tree_outlined),
              const SizedBox(width: 8),
              _chip('180 communautés', Icons.location_city),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF003366)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(List<Map<String, dynamic>> programmes) {
    final byCommission = programmes
        .where((programme) => programme['responsable_type'] == 'commission')
        .length;
    final byMinistry = programmes.length - byCommission;

    return Container(
      width: double.infinity,
      color: Colors.blue.shade50,
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryItem('Total', programmes.length.toString()),
          _summaryItem('Ministères', byMinistry.toString()),
          _summaryItem('Commissions', byCommission.toString()),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF003366),
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_note_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'Aucun programme enregistré',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Publiez d’abord un programme mensuel, trimestriel, annuel ou spécial depuis l’écran de saisie.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgrammeCard(Map<String, dynamic> programme) {
    final commissionType = programme['commission_liee']?.toString();
    String? commissionName;
    if (commissionType != null) {
      for (final item in OrganizationConfig.commissions) {
        if (item.name == commissionType || item.type.name == commissionType) {
          commissionName = item.name;
          break;
        }
      }
    }
    final dateLabel = _formatDate(programme['date_evenement']?.toString());
    final niveau = programme['niveau']?.toString();
    final niveauLabel = niveau == null ? 'Niveau inconnu' : EntiteTypes.label(niveau);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    programme['titre']?.toString() ?? 'Sans titre',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _typeBadge(programme['type']?.toString() ?? 'special'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              programme['description']?.toString().isNotEmpty == true
                  ? programme['description'].toString()
                  : 'Aucune description fournie.',
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _detailChip(Icons.event, dateLabel),
                _detailChip(Icons.visibility_outlined, niveauLabel),
                _detailChip(
                  Icons.person_outline,
                  programme['responsable_type'] == 'commission'
                      ? 'Commission'
                      : 'Ministère',
                ),
                if (commissionName != null)
                  _detailChip(Icons.groups_outlined, commissionName),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeBadge(String type) {
    final label = switch (type) {
      'mensuel' => 'Mensuel',
      'trimestriel' => 'Trimestriel',
      'annuel' => 'Annuel',
      _ => 'Spécial',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _detailChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF003366)),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) {
      return 'Date non définie';
    }
    try {
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(rawDate));
    } catch (_) {
      return rawDate;
    }
  }
}

