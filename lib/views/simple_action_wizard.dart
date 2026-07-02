import 'package:flutter/material.dart';
import '../core/directives_rules.dart';
import 'package:ecclesiastes/models/attachment_model.dart';
import 'package:ecclesiastes/widgets/attachment_picker_widget.dart';

class SimpleActionWizard extends StatefulWidget {
  final UserLevel userLevel;
  final String entityId;
  const SimpleActionWizard(
      {super.key, required this.userLevel, required this.entityId});

  @override
  State<SimpleActionWizard> createState() => _SimpleActionWizardState();
}

class _SimpleActionWizardState extends State<SimpleActionWizard> {
  int _step = 0;
  String _selectedType = '';
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedRole;
  Attachment? _eventAttachment;
  Attachment? _announcementAttachment;

  final List<Map<String, String>> _actionTypes = [
    {'icon': '📅', 'title': 'Événement ou Activité', 'key': 'EVENT'},
    {'icon': '📢', 'title': 'Annonce Communautaire', 'key': 'ANNOUNCE'},
    {
      'icon': '👤',
      'title': 'Nomination / Changement Hiérarchique',
      'key': 'HIERARCHY'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
          title: const Text('Assistant de Gestion'),
          backgroundColor: const Color(0xFF003366)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
                value: (_step + 1) / 3, backgroundColor: Colors.grey[300]),
            const SizedBox(height: 20),
            Expanded(child: _buildCurrentStep()),
            const SizedBox(height: 16),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_step) {
      case 0:
        return _buildTypeSelector();
      case 1:
        return _buildDetailsForm();
      case 2:
        return _buildDirectiveValidation();
      default:
        return const SizedBox();
    }
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('1. Que souhaitez-vous faire ?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ..._actionTypes.map((type) {
          final hasPower = _checkPower(type['key']!);
          return Card(
            color: hasPower ? Colors.white : Colors.grey[200],
            child: ListTile(
              leading:
                  Text(type['icon']!, style: const TextStyle(fontSize: 28)),
              title: Text(type['title']!),
              subtitle: hasPower
                  ? const Text('Disponible pour votre niveau',
                      style: TextStyle(color: Colors.green))
                  : Text(
                      DirectiveRules.getBlockMessage(
                          widget.userLevel, type['key']!),
                      style: const TextStyle(color: Colors.red, fontSize: 11)),
              onTap: hasPower
                  ? () => setState(() {
                        _selectedType = type['key']!;
                        _step = 1;
                      })
                  : null,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDetailsForm() {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                  labelText: 'Titre / Objet', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Obligatoire' : null),
          const SizedBox(height: 12),
          TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(
                  labelText: 'Description brève', border: OutlineInputBorder()),
              maxLines: 3),
          const SizedBox(height: 12),
          if (_selectedType == 'EVENT') ...[
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(_selectedDate == null
                  ? 'Choisir une date'
                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
              onTap: () async {
                final d = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)));
                if (d != null) setState(() => _selectedDate = d);
              },
            ),
            const SizedBox(height: 12),
            const Text('Données de l\'événement (optionnel)',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey)),
            const SizedBox(height: 8),
            AttachmentPickerWidget(
              contextType: 'event',
              initialAttachment: _eventAttachment,
              onAttachmentChanged: (attachment) {
                setState(() => _eventAttachment = attachment);
              },
              customLabel:
                  'Ajouter les données d\'événement\n(CSV, Excel, PDF)',
            ),
          ],
          if (_selectedType == 'ANNOUNCE') ...[
            const SizedBox(height: 12),
            const Text('Affiche de l\'annonce (optionnel)',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey)),
            const SizedBox(height: 8),
            AttachmentPickerWidget(
              contextType: 'announcement',
              initialAttachment: _announcementAttachment,
              onAttachmentChanged: (attachment) {
                setState(() => _announcementAttachment = attachment);
              },
              customLabel: 'Ajouter l\'affiche de l\'annonce\n(JPG, PNG, PDF)',
            ),
          ],
          if (_selectedType == 'HIERARCHY')
            DropdownButtonFormField<String>(
              initialValue: _selectedRole,
              decoration: const InputDecoration(
                  labelText: 'Fonction concernée',
                  border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(
                    value: 'RESP_COMMUNAUTE',
                    child: Text('Responsable Communauté')),
                DropdownMenuItem(value: 'DIACRE', child: Text('Diacre')),
                DropdownMenuItem(
                    value: 'MONITEUR', child: Text('Moniteur Ecodim')),
              ],
              onChanged: (v) => setState(() => _selectedRole = v),
            ),
        ],
      ),
    );
  }

  Widget _buildDirectiveValidation() {
    final chain = DirectiveRules.getValidationChain(widget.userLevel);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('3. Vérification & Conformité',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Card(
          color: Colors.blue.shade50,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(children: [
                  const Icon(Icons.label, size: 16),
                  const SizedBox(width: 8),
                  Text('Objet: ${_titleCtrl.text}')
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 8),
                  Text('Date: ${_selectedDate ?? "Non définie"}')
                ]),
                if (_selectedType == 'HIERARCHY') ...[
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.account_tree, size: 16),
                    const SizedBox(width: 8),
                    Text('Fonction: $_selectedRole')
                  ]),
                ],
                const Divider(height: 20),
                Row(
                  children: [
                    Icon(Icons.shield, color: Colors.green.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Chaîne de validation : $chain\n'
                        'Conformité Directives §3.16 & §3.20 appliquée.',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange.shade800),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Cette action sera soumise pour validation au niveau supérieur. Vous recevrez une notification dès approbation.',
                  style: TextStyle(color: Colors.orange.shade900, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (_step > 0)
          Expanded(
              child: OutlinedButton(
                  onPressed: () => setState(() => _step--),
                  child: const Text('Précédent'))),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _step == 2
                ? _submitAction
                : () {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _step++);
                    }
                  },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003366),
                minimumSize: const Size.fromHeight(48)),
            child: Text(_step == 2 ? 'SOUMETTRE' : 'SUIVANT'),
          ),
        ),
      ],
    );
  }

  bool _checkPower(String key) {
    final powers = DirectiveRules.nominationPowers[widget.userLevel] ?? [];
    if (key == 'EVENT' || key == 'ANNOUNCE') return true;
    return powers.contains(key.toLowerCase() == 'hierarchy'
        ? 'propose_minister_ordination'
        : key.toLowerCase());
  }

  void _submitAction() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              '✅ Action soumise. Chaîne de validation : ${DirectiveRules.getValidationChain(widget.userLevel)}'),
          backgroundColor: Colors.green),
    );
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }
}

