import 'package:flutter/material.dart';
import 'package:ecclesiaste/services/auth_service.dart';
import 'package:ecclesiaste/services/database_helper.dart';
import 'package:ecclesiaste/utils/dashboard_theme.dart';

class SendDirectivePage extends StatefulWidget {
  final String? entiteId;
  final String? entiteNom;

  const SendDirectivePage({
    this.entiteId,
    this.entiteNom,
    super.key,
  });

  @override
  State<SendDirectivePage> createState() => _SendDirectivePageState();
}

class _SendDirectivePageState extends State<SendDirectivePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  
  String _selectedType = 'message';
  String _selectedPriority = 'normale';
  bool _isConfidential = false;
  final List<String> _selectedMinisters = [];
  List<Map<String, dynamic>> _availableMinisters = [];
  bool _isLoading = false;
  bool _isLoadingMinisters = false;

  static const List<String> _types = ['message', 'directive', 'annonce', 'alerte', 'formulaire', 'document'];
  static const List<String> _priorities = ['basse', 'normale', 'haute', 'urgente'];

  @override
  void initState() {
    super.initState();
    _loadMinisters();
  }

  Future<void> _loadMinisters() async {
    setState(() => _isLoadingMinisters = true);
    // TODO: Charger les ministres de l'entité depuis la base de données
    // Pour l'instant, on utilise des données de démonstration
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

  Future<void> _sendDirective() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedMinisters.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner au moins un ministre')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final directive = {
        'titre': _titleController.text,
        'contenu': _contentController.text,
        'type': _selectedType,
        'priorite': _selectedPriority,
        'entite_id': widget.entiteId ?? AuthService.currentEntiteId,
        'auteur_id': AuthService.currentUser?.id,
        'auteur_nom': AuthService.currentUser?.fullName,
        'destinataires_ministres_ids': _selectedMinisters,
        'is_confidential': _isConfidential,
        'date_creation': DateTime.now().toIso8601String(),
        'lecture_status': {},
      };

      await DatabaseHelper.instance.insertDirective(directive);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Directive envoyée avec succès'),
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
        title: const Text('Envoyer une Directive'),
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
                  labelText: 'Titre de la directive',
                  hintText: 'Ex: Directives pour la visite apostolique',
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

              // Contenu
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Contenu de la directive',
                  hintText: 'Entrez le contenu détaillé...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.description),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Le contenu est requis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Type et Priorité
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedType,
                      decoration: InputDecoration(
                        labelText: 'Type',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: _types
                          .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _selectedType = value);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedPriority,
                      decoration: InputDecoration(
                        labelText: 'Priorité',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: _priorities
                          .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _selectedPriority = value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Confidentiel
              CheckboxListTile(
                value: _isConfidential,
                onChanged: (value) {
                  setState(() => _isConfidential = value ?? false);
                },
                title: const Text('Marquer comme confidentiel'),
                subtitle: const Text('Seuls les destinataires pourront accéder'),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),

              // Sélection des ministres
              const Text(
                'Destinataires',
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
                      onPressed: _isLoading ? null : _sendDirective,
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
                          : const Text('Envoyer'),
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
    _contentController.dispose();
    super.dispose();
  }
}


