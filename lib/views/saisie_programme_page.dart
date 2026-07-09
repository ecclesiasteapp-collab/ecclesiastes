import 'package:flutter/material.dart';
import 'package:ecclesiaste/config/organization_config.dart';
import 'package:ecclesiaste/services/database_helper.dart';
import 'package:ecclesiaste/services/auth_service.dart';
import 'package:ecclesiaste/utils/entite_types.dart';
import 'package:intl/intl.dart';
import 'package:ecclesiaste/models/attachment_model.dart';
import 'package:ecclesiaste/widgets/attachment_picker_widget.dart';

class SaisieProgrammePage extends StatefulWidget {
  const SaisieProgrammePage({super.key});

  @override
  State<SaisieProgrammePage> createState() => _SaisieProgrammePageState();
}

class _SaisieProgrammePageState extends State<SaisieProgrammePage> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _descController = TextEditingController();

  DateTime _dateDebut = DateTime.now();
  String _selectedType = 'mensuel';
  String _selectedNiveau = EntiteTypes.communaute;
  String _selectedResponsableType = 'ministere';
  String? _selectedCommission;
  String? _selectedEntiteId;
  List<Map<String, dynamic>> _availableEntites = [];
  Attachment? _eventAttachment;

  final List<String> _types = [
    'mensuel',
    'trimestriel',
    'annuel',
    'special',
  ];
  
  final List<String> _niveaux = EntiteTypes.hierarchie.reversed.toList();
  late final List<String> _commissions = OrganizationConfig.commissions
      .map((c) => c.name)
      .toList();

  @override
  void initState() {
    super.initState();
    _loadEntitesForLevel();
  }

  Future<void> _loadEntitesForLevel() async {
    final entites = await DatabaseHelper.instance.getEntitesByType(_selectedNiveau);
    if (!mounted) return;
    setState(() {
      _availableEntites = entites;
      final hasCurrentSelection = entites.any(
        (item) => item['id']?.toString() == _selectedEntiteId,
      );
      if (!hasCurrentSelection) {
        _selectedEntiteId =
            entites.isNotEmpty ? entites.first['id']?.toString() : null;
      }
    });
  }

  Future<void> _choisirDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateDebut,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dateDebut) {
      setState(() {
        _dateDebut = picked;
      });
    }
  }

  void _enregistrerEvenement() async {
    if (_formKey.currentState!.validate()) {
      final user = AuthService.currentUser;
      String? entiteNom;
      for (final entite in _availableEntites) {
        if (entite['id']?.toString() == _selectedEntiteId) {
          entiteNom = entite['nom']?.toString();
          break;
        }
      }
      final eventData = {
        'id': 'programme_${DateTime.now().millisecondsSinceEpoch}',
        'titre': _titreController.text.trim(),
        'description': _descController.text.trim(),
        'date_evenement': DateFormat('yyyy-MM-dd').format(_dateDebut),
        'type': _selectedType,
        'responsable_type': _selectedResponsableType,
        'niveau': _selectedNiveau,
        'commission_liee': _selectedResponsableType == 'commission'
            ? _selectedCommission
            : null,
        'auteur_id': user?.id,
        'entite_id': _selectedEntiteId ?? user?.entityId,
        'entite_nom': entiteNom,
        'attachment_id': _eventAttachment?.id,
        'attachment_filename': _eventAttachment?.fileName,
        'attachment_mimetype': _eventAttachment?.mimeType,
      };

      await DatabaseHelper.instance.insertEvenement(eventData);
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Programme publié avec succès')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau Programme'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Détails de l\'événement',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
              ),
              const SizedBox(height: 20),
              
              TextFormField(
                controller: _titreController,
                decoration: const InputDecoration(
                  labelText: 'Titre de l\'événement',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (v) => v!.isEmpty ? 'Champ obligatoire' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description / Détails',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
              ),
              const SizedBox(height: 15),

              // Sélection du Type
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Cadence du programme',
                  border: OutlineInputBorder(),
                ),
                items: _types
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(_capitalize(t)),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedType = v!),
              ),
              const SizedBox(height: 15),

              // Date
              ListTile(
                tileColor: Colors.grey[100],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                leading: const Icon(Icons.calendar_today, color: Colors.blueAccent),
                title: Text('Date prévue : ${DateFormat('dd/MM/yyyy').format(_dateDebut)}'),
                trailing: const Icon(Icons.edit),
                onTap: () => _choisirDate(context),
              ),
              const SizedBox(height: 25),

              const Divider(),
              const SizedBox(height: 10),
              const Text('Responsable & visibilité', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                initialValue: _selectedResponsableType,
                decoration: const InputDecoration(
                  labelText: 'Type de responsable',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'ministere',
                    child: Text('Ministère'),
                  ),
                  DropdownMenuItem(
                    value: 'commission',
                    child: Text('Commission'),
                  ),
                ],
                onChanged: (v) => setState(() {
                  _selectedResponsableType = v!;
                  if (_selectedResponsableType == 'ministere') {
                    _selectedCommission = null;
                  }
                }),
              ),
              const SizedBox(height: 15),

              // Niveau de visibilité
              DropdownButtonFormField<String>(
                initialValue: _selectedNiveau,
                decoration: const InputDecoration(
                  labelText: 'Niveau de visibilité',
                  border: OutlineInputBorder(),
                  helperText: 'Qui pourra voir cet événement ?',
                ),
                items: _niveaux
                    .map((n) => DropdownMenuItem(value: n, child: Text(EntiteTypes.label(n))))
                    .toList(),
                onChanged: (v) async {
                  setState(() => _selectedNiveau = v!);
                  await _loadEntitesForLevel();
                },
              ),
              const SizedBox(height: 15),

              DropdownButtonFormField<String?>(
                initialValue: _selectedEntiteId,
                decoration: const InputDecoration(
                  labelText: 'Entité concernée',
                  border: OutlineInputBorder(),
                  helperText: 'District, communauté, champ ou territoire visé',
                ),
                items: _availableEntites
                    .map(
                      (entite) => DropdownMenuItem<String?>(
                        value: entite['id']?.toString(),
                        child: Text(entite['nom']?.toString() ?? 'Sans nom'),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _selectedEntiteId = v),
                validator: (v) => v == null ? 'Sélectionnez une entité' : null,
              ),
              const SizedBox(height: 15),

              // Commission spécifique
              DropdownButtonFormField<String?>(
                initialValue: _selectedCommission,
                decoration: const InputDecoration(
                  labelText: 'Commission liée',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('Aucune'),
                  ),
                  ..._commissions.map(
                    (c) => DropdownMenuItem<String?>(
                      value: c,
                      child: Text(c),
                    ),
                  ),
                ],
                onChanged: _selectedResponsableType == 'commission'
                    ? (v) => setState(() => _selectedCommission = v)
                    : null,
              ),

              const SizedBox(height: 25),
              const Divider(),
              const SizedBox(height: 10),
              const Text('Données & Pièces jointes', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),

              // Widget d'attachement pour données d'événement
              AttachmentPickerWidget(
                contextType: 'event',
                initialAttachment: _eventAttachment,
                onAttachmentChanged: (attachment) {
                  setState(() => _eventAttachment = attachment);
                },
                customLabel: 'Ajouter les données d\'événement\n(CSV, Excel, PDF)',
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _enregistrerEvenement,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                  ),
                  child: const Text('PUBLIER LE PROGRAMME', 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titreController.dispose();
    _descController.dispose();
    super.dispose();
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }
}

