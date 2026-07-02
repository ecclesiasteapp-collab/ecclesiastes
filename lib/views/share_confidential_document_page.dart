import 'package:flutter/material.dart';
import 'package:ecclesiastes/services/auth_service.dart';
import 'package:ecclesiastes/services/database_helper.dart';
import 'package:ecclesiastes/utils/dashboard_theme.dart';

class ShareConfidentialDocumentPage extends StatefulWidget {
  final String? entiteId;
  final String? entiteNom;

  const ShareConfidentialDocumentPage({
    this.entiteId,
    this.entiteNom,
    super.key,
  });

  @override
  State<ShareConfidentialDocumentPage> createState() => _ShareConfidentialDocumentPageState();
}

class _ShareConfidentialDocumentPageState extends State<ShareConfidentialDocumentPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _selectedDocumentType = 'formulaire';
  final List<String> _selectedMinisters = [];
  final List<String> _selectedCommissions = [];
  List<Map<String, dynamic>> _availableMinisters = [];
  bool _isLoading = false;
  bool _isLoadingMinisters = false;
  DateTime? _expiryDate;

  static const List<String> _documentTypes = [
    'formulaire',
    'protocole',
    'directive_administrative',
    'donnees_financieres',
    'donnees_statistiques',
    'rapport_confidentiel',
    'autre'
  ];

  static const List<String> _commissions = [
    'Jeunesse',
    'Femmes',
    'Hommes',
    'Enfants',
    'Education',
    'Diaconie',
    'Culte',
    'Missions',
  ];

  @override
  void initState() {
    super.initState();
    _loadMinisters();
  }

  Future<void> _loadMinisters() async {
    setState(() => _isLoadingMinisters = true);
    // TODO: Charger les ministres de l'entité depuis la base de données
    setState(() {
      _availableMinisters = [
        {'id': '1', 'nom': 'Apôtre Jean Dupont'},
        {'id': '2', 'nom': 'Apôtre Marie Martin'},
        {'id': '3', 'nom': 'Évêque Pierre Bernard'},
        {'id': '4', 'nom': 'Ancien Paul Lefevre'},
      ];
      _isLoadingMinisters = false;
    });
  }

  Future<void> _selectExpiryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _expiryDate = picked);
    }
  }

  Future<void> _shareDocument() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedMinisters.isEmpty && _selectedCommissions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner au moins un destinataire')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final document = {
        'titre': _titleController.text,
        'description': _descriptionController.text,
        'type': _selectedDocumentType,
        'entite_id': widget.entiteId ?? AuthService.currentEntiteId,
        'auteur_id': AuthService.currentUser?.id,
        'auteur_nom': AuthService.currentUser?.fullName,
        'destinataires_ministres_ids': _selectedMinisters,
        'destinataires_commissions': _selectedCommissions,
        'is_confidential': true,
        'date_creation': DateTime.now().toIso8601String(),
        'date_expiration': _expiryDate?.toIso8601String(),
        'acces_log': [],
      };

      await DatabaseHelper.instance.insertDocument(document);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Document partagé avec succès'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur : $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partager Document Confidentiel'),
        backgroundColor: DashboardTheme.navy,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Entité cible
              if (widget.entiteNom != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: DashboardTheme.navy.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: DashboardTheme.navy),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Entité cible',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Text(
                              widget.entiteNom ?? 'Entité courante',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),

              // Titre
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Titre du document',
                  hintText: 'Ex: Protocole de visite apostolique',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Le titre est requis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Entrez une description détaillée...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'La description est requise';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Type de document
              DropdownButtonFormField<String>(
                initialValue: _selectedDocumentType,
                decoration: InputDecoration(
                  labelText: 'Type de document',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: _documentTypes
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedDocumentType = value);
                },
              ),
              const SizedBox(height: 16),

              // Date d'expiration
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today, color: DashboardTheme.navy),
                title: Text(
                  _expiryDate == null
                      ? "Définir une date d'expiration"
                      : 'Expire le ${_expiryDate!.day}/${_expiryDate!.month}/${_expiryDate!.year}',
                ),
                trailing: _expiryDate != null
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _expiryDate = null),
                      )
                    : null,
                onTap: _selectExpiryDate,
              ),
              const SizedBox(height: 24),

              // Destinataires - Ministres
              const Text(
                'Destinataires - Ministres',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (_isLoadingMinisters)
                const Center(child: CircularProgressIndicator())
              else
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _availableMinisters.length,
                    itemBuilder: (context, index) {
                      final minister = _availableMinisters[index];
                      final isSelected = _selectedMinisters.contains(minister['id']);
                      return CheckboxListTile(
                        value: isSelected,
                        onChanged: (value) {
                          setState(() {
                            if (value ?? false) {
                              _selectedMinisters.add(minister['id']);
                            } else {
                              _selectedMinisters.remove(minister['id']);
                            }
                          });
                        },
                        title: Text(minister['nom']),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 24),

              // Destinataires - Commissions
              const Text(
                'Destinataires - Commissions',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _commissions.length,
                  itemBuilder: (context, index) {
                    final commission = _commissions[index];
                    final isSelected = _selectedCommissions.contains(commission);
                    return CheckboxListTile(
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value ?? false) {
                            _selectedCommissions.add(commission);
                          } else {
                            _selectedCommissions.remove(commission);
                          }
                        });
                      },
                      title: Text(commission),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Boutons d'action
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      child: const Text('Annuler'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _shareDocument,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DashboardTheme.navy,
                        foregroundColor: Colors.white,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Partager'),
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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}


