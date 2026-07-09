// lib/screens/members/member_registration_wizard.dart
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:hive/hive.dart';
import '../../models/member_model.dart';
import '../../services/pastoral_encryption_service.dart';

class MemberRegistrationWizard extends StatefulWidget {
  final String communityId;
  final String communityName;

  const MemberRegistrationWizard({
    Key? key,
    required this.communityId,
    required this.communityName,
  }) : super(key: key);

  @override
  State<MemberRegistrationWizard> createState() => _MemberRegistrationWizardState();
}

class _MemberRegistrationWizardState extends State<MemberRegistrationWizard> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour chaque section
  final TextEditingController _nomCtrl = TextEditingController();
  final TextEditingController _postNomCtrl = TextEditingController();
  final TextEditingController _prenomCtrl = TextEditingController();
  final TextEditingController _lieuNaissanceCtrl = TextEditingController();
  final TextEditingController _nationaliteCtrl = TextEditingController(text: 'Congolaise');
  final TextEditingController _pieceIdentiteCtrl = TextEditingController();

  final TextEditingController _pereNomCtrl = TextEditingController();
  final TextEditingController _perePrenomCtrl = TextEditingController();
  final TextEditingController _mereNomCtrl = TextEditingController();
  final TextEditingController _merePrenomCtrl = TextEditingController();

  final TextEditingController _adresseCtrl = TextEditingController();
  final TextEditingController _communeCtrl = TextEditingController();
  final TextEditingController _villeCtrl = TextEditingController();
  final TextEditingController _telephoneCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();

  final TextEditingController _urgenceNomCtrl = TextEditingController();
  final TextEditingController _urgenceLienCtrl = TextEditingController();
  final TextEditingController _urgenceTelephoneCtrl = TextEditingController();

  final TextEditingController _pastoralNotesCtrl = TextEditingController();

  DateTime? _dateNaissance;
  DateTime? _dateEntreeEglise;
  DateTime? _dateBapteme;
  DateTime? _dateScelle;
  DateTime? _dateConfirmation;

  String _sexe = 'M';
  String _etatCivil = 'Célibataire';
  String _statutParentPere = 'Membre NAK';
  String _statutParentMere = 'Membre NAK';
  String _statutMembre = 'Nouveau converti';

  String _lieuBapteme = '';
  String _officiantBapteme = '';
  String _lieuScelle = '';
  String _apotreScelle = '';

  String _commission = '';
  String _roleCommission = '';
  String _disponibilite = 'Occasionnelle';

  bool _isBaptise = false;
  bool _isScelle = false;
  bool _isConfirme = false;
  bool _aMinistere = false;

  final SignatureController _signatureMembreCtrl = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  final SignatureController _signatureConducteurCtrl = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void dispose() {
    _signatureMembreCtrl.dispose();
    _signatureConducteurCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        title: const Text('Inscription Membre (9 Sections)'),
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: _onStepContinue,
          onStepCancel: _onStepCancel,
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF003366)),
                    child: Text(_currentStep == 8 ? 'ENREGISTRER' : 'SUIVANT'),
                  ),
                  const SizedBox(width: 10),
                  if (_currentStep > 0)
                    TextButton(onPressed: details.onStepCancel, child: const Text('Retour')),
                ],
              ),
            );
          },
          steps: [
            // SECTION 1: IDENTITÉ
            Step(
              title: const Text('1. Identité'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  TextFormField(controller: _nomCtrl, decoration: const InputDecoration(labelText: 'Nom *'), validator: (v) => v!.isEmpty ? 'Requis' : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: _postNomCtrl, decoration: const InputDecoration(labelText: 'Post-nom')),
                  const SizedBox(height: 12),
                  TextFormField(controller: _prenomCtrl, decoration: const InputDecoration(labelText: 'Prénom *'), validator: (v) => v!.isEmpty ? 'Requis' : null),
                  const SizedBox(height: 12),
                  _buildRadioGroup('Sexe *', _sexe, ['M', 'F'], (val) => setState(() => _sexe = val!)),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(_dateNaissance == null ? 'Date de naissance *' : 'Né(e) le : ${_dateNaissance!.day}/${_dateNaissance!.month}/${_dateNaissance!.year}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(context: context, initialDate: DateTime(2000), firstDate: DateTime(1900), lastDate: DateTime.now());
                      if (date != null) setState(() => _dateNaissance = date);
                    },
                  ),
                  TextFormField(controller: _lieuNaissanceCtrl, decoration: const InputDecoration(labelText: 'Lieu de naissance')),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _etatCivil,
                    decoration: const InputDecoration(labelText: 'État civil'),
                    items: ['Célibataire', 'Marié(e)', 'Divorcé(e)', 'Veuf/Veuve'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) => setState(() => _etatCivil = val!),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(controller: _nationaliteCtrl, decoration: const InputDecoration(labelText: 'Nationalité')),
                  const SizedBox(height: 12),
                  TextFormField(controller: _pieceIdentiteCtrl, decoration: const InputDecoration(labelText: 'N° Pièce d\'identité')),
                ],
              ),
            ),

            // SECTION 2: FILIATION
            Step(
              title: const Text('2. Filiation'),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  const Text('PÈRE', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003366))),
                  TextFormField(controller: _pereNomCtrl, decoration: const InputDecoration(labelText: 'Nom du père')),
                  const SizedBox(height: 12),
                  TextFormField(controller: _perePrenomCtrl, decoration: const InputDecoration(labelText: 'Prénom du père')),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _statutParentPere,
                    decoration: const InputDecoration(labelText: 'Statut ecclésial'),
                    items: ['Membre NAK', 'Autre confession', 'Non-croyant', 'Décédé'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) => setState(() => _statutParentPere = val!),
                  ),
                  const Divider(height: 32),
                  const Text('MÈRE', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003366))),
                  TextFormField(controller: _mereNomCtrl, decoration: const InputDecoration(labelText: 'Nom de la mère')),
                  const SizedBox(height: 12),
                  TextFormField(controller: _merePrenomCtrl, decoration: const InputDecoration(labelText: 'Prénom de la mère')),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _statutParentMere,
                    decoration: const InputDecoration(labelText: 'Statut ecclésial'),
                    items: ['Membre NAK', 'Autre confession', 'Non-croyant', 'Décédée'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) => setState(() => _statutParentMere = val!),
                  ),
                ],
              ),
            ),

            // SECTION 3: COORDONNÉES
            Step(
              title: const Text('3. Coordonnées'),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  TextFormField(controller: _adresseCtrl, decoration: const InputDecoration(labelText: 'Adresse (Numéro, Rue, Quartier)')),
                  const SizedBox(height: 12),
                  TextFormField(controller: _communeCtrl, decoration: const InputDecoration(labelText: 'Commune')),
                  const SizedBox(height: 12),
                  TextFormField(controller: _villeCtrl, decoration: const InputDecoration(labelText: 'Ville / Province')),
                  const SizedBox(height: 12),
                  TextFormField(controller: _telephoneCtrl, decoration: const InputDecoration(labelText: 'Téléphone (WhatsApp)'), keyboardType: TextInputType.phone),
                  const SizedBox(height: 12),
                  TextFormField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email (optionnel)'), keyboardType: TextInputType.emailAddress),
                ],
              ),
            ),

            // SECTION 4: INFORMATIONS ECCLÉSIALES
            Step(
              title: const Text('4. Infos Ecclésiales'),
              isActive: _currentStep >= 3,
              state: _currentStep > 3 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(_dateEntreeEglise == null ? 'Date d\'entrée dans l\'Église' : 'Entré(e) le : ${_dateEntreeEglise!.day}/${_dateEntreeEglise!.month}/${_dateEntreeEglise!.year}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
                      if (date != null) setState(() => _dateEntreeEglise = date);
                    },
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: _statutMembre,
                    decoration: const InputDecoration(labelText: 'Statut'),
                    items: ['Nouveau converti', 'Transfert', 'Ancien membre'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) => setState(() => _statutMembre = val!),
                  ),
                ],
              ),
            ),

            // SECTION 5: VIE SACRAMENTELLE
            Step(
              title: const Text('5. Vie Sacramentelle'),
              isActive: _currentStep >= 4,
              state: _currentStep > 4 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Baptisé(e)'),
                    value: _isBaptise,
                    onChanged: (val) => setState(() => _isBaptise = val),
                  ),
                  if (_isBaptise) ...[
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(_dateBapteme == null ? 'Date du Baptême' : 'Baptisé(e) le : ${_dateBapteme!.day}/${_dateBapteme!.month}/${_dateBapteme!.year}'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
                        if (date != null) setState(() => _dateBapteme = date);
                      },
                    ),
                    TextFormField(decoration: const InputDecoration(labelText: 'Lieu du Baptême'), onChanged: (val) => _lieuBapteme = val),
                    const SizedBox(height: 12),
                    TextFormField(decoration: const InputDecoration(labelText: 'Officiant'), onChanged: (val) => _officiantBapteme = val),
                  ],
                  const Divider(height: 32),
                  SwitchListTile(
                    title: const Text('Scellé(e)'),
                    value: _isScelle,
                    onChanged: (val) => setState(() => _isScelle = val),
                  ),
                  if (_isScelle) ...[
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(_dateScelle == null ? 'Date du Scellé' : 'Scellé(e) le : ${_dateScelle!.day}/${_dateScelle!.month}/${_dateScelle!.year}'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
                        if (date != null) setState(() => _dateScelle = date);
                      },
                    ),
                    TextFormField(decoration: const InputDecoration(labelText: 'Lieu du Scellé'), onChanged: (val) => _lieuScelle = val),
                    const SizedBox(height: 12),
                    TextFormField(decoration: const InputDecoration(labelText: 'Apôtre officiant'), onChanged: (val) => _apotreScelle = val),
                  ],
                  const Divider(height: 32),
                  SwitchListTile(
                    title: const Text('Confirmé(e)'),
                    value: _isConfirme,
                    onChanged: (val) => setState(() => _isConfirme = val),
                  ),
                  if (_isConfirme) ...[
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(_dateConfirmation == null ? 'Date de Confirmation' : 'Confirmé(e) le : ${_dateConfirmation!.day}/${_dateConfirmation!.month}/${_dateConfirmation!.year}'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
                        if (date != null) setState(() => _dateConfirmation = date);
                      },
                    ),
                  ],
                ],
              ),
            ),

            // SECTION 6: SERVICE ET ENGAGEMENT
            Step(
              title: const Text('6. Service et Engagement'),
              isActive: _currentStep >= 5,
              state: _currentStep > 5 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Exerce un ministère'),
                    value: _aMinistere,
                    onChanged: (val) => setState(() => _aMinistere = val),
                  ),
                  const Divider(height: 32),
                  DropdownButtonFormField<String>(
                    initialValue: _commission.isEmpty ? null : _commission,
                    decoration: const InputDecoration(labelText: 'Commission active'),
                    items: ['ECODIM', 'Jeunesse', 'Chorale', 'Econfi', 'Médicale', 'Aînés', 'Construction', 'Sécurité', 'Presse & Média', 'Papas/Mamans', 'Joseph d\'Arimathée', 'Sacristie', 'Aucune']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setState(() => _commission = val ?? ''),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(decoration: const InputDecoration(labelText: 'Rôle dans la commission'), onChanged: (val) => _roleCommission = val),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _disponibilite,
                    decoration: const InputDecoration(labelText: 'Disponibilité'),
                    items: ['Hebdomadaire', 'Mensuelle', 'Occasionnelle'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) => setState(() => _disponibilite = val!),
                  ),
                ],
              ),
            ),

            // SECTION 7: URGENCE
            Step(
              title: const Text('7. Urgence'),
              isActive: _currentStep >= 6,
              state: _currentStep > 6 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  TextFormField(controller: _urgenceNomCtrl, decoration: const InputDecoration(labelText: 'Nom complet du contact d\'urgence')),
                  const SizedBox(height: 12),
                  TextFormField(controller: _urgenceLienCtrl, decoration: const InputDecoration(labelText: 'Lien de parenté')),
                  const SizedBox(height: 12),
                  TextFormField(controller: _urgenceTelephoneCtrl, decoration: const InputDecoration(labelText: 'Numéro de téléphone'), keyboardType: TextInputType.phone),
                ],
              ),
            ),

            // SECTION 8: OBSERVATIONS PASTORALES (CONFIDENTIEL)
            Step(
              title: const Text('8. Notes Pastorales 🔒'),
              isActive: _currentStep >= 7,
              state: _currentStep > 7 ? StepState.complete : StepState.indexed,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.lock, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'CONFIDENTIEL - §3.20.6\nVisible uniquement par les ministres autorisés',
                            style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _pastoralNotesCtrl,
                    maxLines: 8,
                    decoration: const InputDecoration(
                      labelText: 'Observations pastorales (santé, situation familiale, etc.)',
                      border: OutlineInputBorder(),
                      hintText: 'Saisissez les informations confidentielles ici...',
                    ),
                  ),
                ],
              ),
            ),

            // SECTION 9: VALIDATION ET SIGNATURES
            Step(
              title: const Text('9. Validation'),
              isActive: _currentStep >= 8,
              state: _currentStep > 8 ? StepState.complete : StepState.indexed,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Je soussigné(e) certifie l\'exactitude des informations fournies dans cette fiche d\'inscription.',
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 24),
                  const Text('Signature du Membre', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Signature(controller: _signatureMembreCtrl, backgroundColor: Colors.grey[100]!),
                  ),
                  TextButton.icon(
                    onPressed: () => _signatureMembreCtrl.clear(),
                    icon: const Icon(Icons.clear),
                    label: const Text('Effacer'),
                  ),
                  const SizedBox(height: 24),
                  const Text('Signature du Conducteur de Communauté', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Signature(controller: _signatureConducteurCtrl, backgroundColor: Colors.grey[100]!),
                  ),
                  TextButton.icon(
                    onPressed: () => _signatureConducteurCtrl.clear(),
                    icon: const Icon(Icons.clear),
                    label: const Text('Effacer'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioGroup(String label, String groupValue, List<String> options, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: options.map((opt) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioMenuButton<String>(
                value: opt, 
                groupValue: groupValue, 
                onChanged: onChanged,
                child: Text(opt),
              ),
            ],
          )).toList(),
        ),
      ],
    );
  }

  void _onStepContinue() {
    if (_currentStep < 8) {
      setState(() => _currentStep += 1);
    } else {
      _saveMember();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  Future<void> _saveMember() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs obligatoires'), backgroundColor: Colors.red),
      );
      return;
    }

    // Chiffrement des notes pastorales
    await PastoralEncryptionService.init();
    final encryptedNotes = PastoralEncryptionService.encrypt(_pastoralNotesCtrl.text);

    final member = MemberModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nom: _nomCtrl.text,
      postNom: _postNomCtrl.text,
      prenom: _prenomCtrl.text,
      sexe: _sexe,
      dateNaissance: _dateNaissance,
      lieuNaissance: _lieuNaissanceCtrl.text,
      etatCivil: _etatCivil,
      nationalite: _nationaliteCtrl.text,
      pieceIdentite: _pieceIdentiteCtrl.text,
      pereNom: _pereNomCtrl.text,
      perePrenom: _perePrenomCtrl.text,
      statutParentPere: _statutParentPere,
      mereNom: _mereNomCtrl.text,
      merePrenom: _merePrenomCtrl.text,
      statutParentMere: _statutParentMere,
      adresse: _adresseCtrl.text,
      commune: _communeCtrl.text,
      ville: _villeCtrl.text,
      telephone: _telephoneCtrl.text,
      email: _emailCtrl.text,
      communityId: widget.communityId,
      communityName: widget.communityName,
      dateEntreeEglise: _dateEntreeEglise,
      statutMembre: _statutMembre,
      isBaptise: _isBaptise,
      dateBapteme: _dateBapteme,
      lieuBapteme: _lieuBapteme,
      officiantBapteme: _officiantBapteme,
      isScelle: _isScelle,
      dateScelle: _dateScelle,
      lieuScelle: _lieuScelle,
      apotreScelle: _apotreScelle,
      isConfirme: _isConfirme,
      dateConfirmation: _dateConfirmation,
      aMinistere: _aMinistere,
      commission: _commission,
      roleCommission: _roleCommission,
      disponibilite: _disponibilite,
      urgenceNom: _urgenceNomCtrl.text,
      urgenceLien: _urgenceLienCtrl.text,
      urgenceTelephone: _urgenceTelephoneCtrl.text,
      pastoralNotesEncrypted: encryptedNotes,
      dateInscription: DateTime.now(),
    );

    final box = await Hive.openBox<MemberModel>('member_profiles');
    await box.put(member.id, member);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Membre enregistré avec succès !'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }
}
