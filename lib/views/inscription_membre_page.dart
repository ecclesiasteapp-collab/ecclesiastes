import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecclesiaste/services/database_helper.dart';

import 'package:ecclesiaste/models/member_profile.dart';
import 'package:ecclesiaste/utils/constants.dart';
import 'package:ecclesiaste/services/image_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:typed_data';

class InscriptionMembrePage extends StatefulWidget {
  const InscriptionMembrePage({super.key});

  @override
  State<InscriptionMembrePage> createState() => _InscriptionMembrePageState();
}

class _InscriptionMembrePageState extends State<InscriptionMembrePage> {
  final _formKey = GlobalKey<FormState>();

  // I. IDENTITÉ DU MEMBRE
  final _nomController = TextEditingController();
  final _postnomController = TextEditingController();
  final _prenomController = TextEditingController();
  String _sexe = 'Masculin';
  DateTime _dateNaissance = DateTime(2000, 1, 1);
  final _lieuNaisController = TextEditingController();
  final _nationaliteController = TextEditingController(text: 'Congolaise');
  String _etatCivil = 'Célibataire';
  final _professionController = TextEditingController();

  // II. FILIATION
  final _nomPereController = TextEditingController();
  String _pereNeo = 'Inconnu';
  final _nomMereController = TextEditingController();
  String _mereNeo = 'Inconnu';
  String _membreNeoNaissance = 'Oui';

  // III. COORDONNÉES
  final _avenueController = TextEditingController();
  final _numeroController = TextEditingController();
  final _quartierController = TextEditingController();
  final _communeController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _emailController = TextEditingController();

  // IV. INFORMATIONS ECCLÉSIASTIQUES
  String? _selectedEgliseId;
  String? _selectedChampId;
  String? _selectedDistrict;
  String? _selectedCommunaute;
  DateTime _dateEntreeEglise = DateTime.now();
  String _statutMembre = 'Nouveau';
  final _origineTransfertController = TextEditingController();

  // V. VIE SACRAMENTELLE
  String _isBaptise = 'Non';
  DateTime? _dateBapteme;
  String _isScelle = 'Non';
  DateTime? _dateScellement;
  String _sainteCene = 'Non';

  // VI. SERVICE ET ENGAGEMENT
  final _ministereController = TextEditingController();
  final _fonctionController = TextEditingController();
  String? _selectedCommission;
  String _selectedEntityRole = 'Aucun';
  String _selectedCommissionRole = 'Aucun';
  final _donsController = TextEditingController();
  String _disponibilite = 'Hebdomadaire';

  // VII. PERSONNE À CONTACTER EN CAS D'URGENCE
  final _urgenceNomController = TextEditingController();
  final _urgenceLienController = TextEditingController();
  final _urgenceTelController = TextEditingController();

  // VIII. OBSERVATIONS
  final _observationsController = TextEditingController();

  XFile? _imageFile;
  Uint8List? _imageBytes;

  List<Map<String, dynamic>> _eglises = [];
  List<Map<String, dynamic>> _champs = [];
  List<Map<String, dynamic>> _districts = [];
  List<Map<String, dynamic>> _communautes = [];

  @override
  void initState() {
    super.initState();
    _chargerEglises();
  }

  Future<void> _chargerEglises() async {
    final data = await DatabaseHelper.instance.getEglisesTerritoriales();
    if (mounted) setState(() => _eglises = data);
  }

  Future<void> _onEgliseChanged(String? egliseId) async {
    setState(() {
      _selectedEgliseId = egliseId;
      _selectedChampId = null;
      _selectedDistrict = null;
      _selectedCommunaute = null;
      _champs = [];
      _districts = [];
      _communautes = [];
    });
    if (egliseId != null) {
      final data = await DatabaseHelper.instance.getChampsApostoliques(egliseId);
      if (mounted) setState(() => _champs = data);
    }
  }

  Future<void> _onChampChanged(String? champId) async {
    setState(() {
      _selectedChampId = champId;
      _selectedDistrict = null;
      _selectedCommunaute = null;
      _districts = [];
      _communautes = [];
    });
    if (champId != null) {
      final data = await DatabaseHelper.instance.getDistricts(champId: champId);
      if (mounted) setState(() => _districts = data);
    }
  }

  void _onDistrictChanged(String? val) async {
    setState(() {
      _selectedDistrict = val;
      _selectedCommunaute = null;
      _communautes = [];
    });
    if (val != null) {
      final data = await DatabaseHelper.instance.getCommunautesByDistrict(val);
      if (mounted) setState(() => _communautes = data);
    }
  }

  String? _nomEntite(List<Map<String, dynamic>> list, String? id) {
    if (id == null) return null;
    for (final e in list) {
      if (e['id'].toString() == id) return e['nom']?.toString();
    }
    return null;
  }

  Future<void> _selectDate(BuildContext context, Function(DateTime) onSelected, DateTime initial) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => onSelected(picked));
  }

  void _sauvegarder() async {
    if (_formKey.currentState!.validate()) {
      final id = const Uuid().v4();
      final nouveauMembre = {
        'id': id,
        'eglise_id': int.tryParse(_selectedEgliseId ?? '0') ?? 0,
        'communaute_id': int.tryParse(_selectedCommunaute ?? '0') ?? 0,
        'nom': _nomController.text,
        'postnom': _postnomController.text,
        'prenom': _prenomController.text,
        'sexe': _sexe,
        'date_naissance': _dateNaissance.toIso8601String(),
        'lieu_naissance': _lieuNaisController.text,
        'nationalite': _nationaliteController.text,
        'etat_civil': _etatCivil,
        'profession': _professionController.text,
        'nom_pere': _nomPereController.text,
        'pere_neo_apostolique': _pereNeo,
        'nom_mere': _nomMereController.text,
        'mere_neo_apostolique': _mereNeo,
        'membre_neo_apostolique': _membreNeoNaissance,
        'adresse_avenue': _avenueController.text,
        'adresse_numero': _numeroController.text,
        'adresse_quartier': _quartierController.text,
        'adresse_commune': _communeController.text,
        'telephone': _telephoneController.text,
        'email': _emailController.text,
        'eglise_territoriale': _nomEntite(_eglises, _selectedEgliseId),
        'champ_apostolique': _nomEntite(_champs, _selectedChampId),
        'district': _nomEntite(_districts, _selectedDistrict),
        'communaute': _nomEntite(_communautes, _selectedCommunaute),
        'date_entree_eglise': _dateEntreeEglise.toIso8601String(),
        'statut_membre': _statutMembre,
        'origine_transfert': _origineTransfertController.text,
        'baptise': _isBaptise,
        'date_bapteme': _dateBapteme?.toIso8601String(),
        'scelle': _isScelle,
        'date_scellement': _dateScellement?.toIso8601String(),
        'sainte_cene': _sainteCene,
        'ministere': _ministereController.text,
        'fonction': _fonctionController.text,
        'commission': _selectedCommission,
        'role_entite': _selectedEntityRole == 'Aucun' ? null : (_selectedEntityRole == 'Responsable' ? 'responsable' : 'suppleant'),
        'role_commission': _selectedCommissionRole == 'Aucun' ? null : (_selectedCommissionRole == 'Responsable' ? 'responsable' : 'suppleant'),
        'dons_competences': _donsController.text,
        'disponibilite': _disponibilite,
        'urgence_nom': _urgenceNomController.text,
        'urgence_lien': _urgenceLienController.text,
        'urgence_telephone': _urgenceTelController.text,
        'observations': _observationsController.text,
        'date_inscription': DateTime.now().toIso8601String(),
        'statut_validation': 0,
        'photo_path': _imageFile?.path,
      };

      await DatabaseHelper.instance.insertMembre(nouveauMembre);

      // Création du profil Hive pour que l'utilisateur puisse voir sa photo
      final profile = MemberProfile(
        id: id,
        nom: _nomController.text,
        postNom: _postnomController.text,
        prenom: _prenomController.text,
        isMale: _sexe == 'Masculin',
        dateNaissance: _dateNaissance,
        lieuNaissance: _lieuNaisController.text,
        nationalite: _nationaliteController.text,
        etatCivil: _etatCivil == 'Célibataire' ? CivilStatus.celibataire : CivilStatus.marie,
        adresse: _avenueController.text,
        communeQuartier: _communeController.text,
        telephone: _telephoneController.text,
        egliseTerritorialeId: _selectedEgliseId ?? '',
        districtId: _selectedDistrict ?? '',
        communauteId: _selectedCommunaute ?? '',
        dateEntreeEglise: _dateEntreeEglise,
        statutMembre: _statutMembre == 'Nouveau' ? MemberStatus.nouveau : MemberStatus.ancien,
        baptise: _isBaptise == 'Oui',
        prendSainteCene: _sainteCene == 'Oui',
        scelle: _isScelle == 'Oui',
        disponibilite: Availability.hebdomadaire,
        dateInscription: DateTime.now(),
        inscritParMinistreId: 'SELF',
        roleEntite: _selectedEntityRole == 'Aucun' ? null : (_selectedEntityRole == 'Responsable' ? 'responsable' : 'suppleant'),
        roleCommission: _selectedCommissionRole == 'Aucun' ? null : (_selectedCommissionRole == 'Responsable' ? 'responsable' : 'suppleant'),
      );
      
      // La photo est déjà insérée dans le dictionnaire nouveauMembre pour SQLite.

      await Hive.box<MemberProfile>('member_profiles').put(id, profile);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enregistrement effectué et en attente de validation.')));
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fiche d'Inscription")),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo de Profil
              Center(
                child: GestureDetector(
                  onTap: () async {
                    final p = await ImageService.pickImage(context);
                    if (p != null) {
                      final bytes = await p.readAsBytes();
                      setState(() {
                        _imageFile = p;
                        _imageBytes = bytes;
                      });
                    }
                  },
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _imageBytes != null ? MemoryImage(_imageBytes!) : null,
                    child: _imageBytes == null ? const Icon(Icons.camera_alt, size: 35) : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // I. IDENTITÉ DU MEMBRE
              _sectionTitle('I. IDENTITÉ DU MEMBRE'),
              _textField(_nomController, 'Nom'),
              _textField(_postnomController, 'Post-nom'),
              _textField(_prenomController, 'Prénom'),
              _dropdown('Sexe', _sexe, ['Masculin', 'Féminin'], (v) => setState(() => _sexe = v!)),
              _datePicker('Date de naissance', _dateNaissance, (d) => _dateNaissance = d),
              _textField(_lieuNaisController, 'Lieu de naissance'),
              _textField(_nationaliteController, 'Nationalité'),
              _dropdown('État civil', _etatCivil, ['Célibataire', 'Marié(e)', 'Veuf(ve)', 'Divorcé(e)'], (v) => setState(() => _etatCivil = v!)),
              _textField(_professionController, 'Profession'),

              const SizedBox(height: 25),
              // II. FILIATION
              _sectionTitle('II. FILIATION'),
              _textField(_nomPereController, 'Nom du père'),
              _radio('Le père est-il néo-apostolique ?', _pereNeo, ['Oui', 'Non', 'Inconnu'], (v) => setState(() => _pereNeo = v!)),
              _textField(_nomMereController, 'Nom de la mère'),
              _radio('La mère est-elle néo-apostolique ?', _mereNeo, ['Oui', 'Non', 'Inconnu'], (v) => setState(() => _mereNeo = v!)),
              _radio('Le membre est-il néo-apostolique de naissance ?', _membreNeoNaissance, ['Oui', 'Non'], (v) => setState(() => _membreNeoNaissance = v!)),

              const SizedBox(height: 25),
              // III. COORDONNÉES
              _sectionTitle('III. COORDONNÉES'),
              Row(
                children: [
                  Expanded(flex: 3, child: _textField(_avenueController, 'Avenue')),
                  const SizedBox(width: 10),
                  Expanded(flex: 1, child: _textField(_numeroController, 'Numéro')),
                ],
              ),
              _textField(_quartierController, 'Quartier'),
              _textField(_communeController, 'Commune'),
              _textField(_telephoneController, 'Téléphone', keyboardType: TextInputType.phone),
              _textField(_emailController, 'Adresse e-mail', keyboardType: TextInputType.emailAddress),

              const SizedBox(height: 25),
              // IV. INFORMATIONS ECCLÉSIASTIQUES
              _sectionTitle('IV. INFORMATIONS ECCLÉSIASTIQUES'),
              DropdownButtonFormField<String>(
                initialValue: _selectedEgliseId,
                decoration: const InputDecoration(labelText: 'Église territoriale'),
                items: _eglises.map((e) => DropdownMenuItem(value: e['id'].toString(), child: Text(e['nom']?.toString() ?? ''))).toList(),
                onChanged: _onEgliseChanged,
              ),
              DropdownButtonFormField<String>(
                initialValue: _selectedChampId,
                hint: const Text('Champ apostolique'),
                items: _champs.map((c) => DropdownMenuItem(value: c['id'].toString(), child: Text(c['nom']?.toString() ?? ''))).toList(),
                onChanged: _selectedEgliseId == null ? null : _onChampChanged,
              ),
              DropdownButtonFormField<String>(
                initialValue: _selectedDistrict,
                hint: const Text('District'),
                items: _districts.map((d) => DropdownMenuItem(value: d['id'].toString(), child: Text(d['nom']?.toString() ?? ''))).toList(),
                onChanged: _selectedChampId == null ? null : _onDistrictChanged,
              ),
              DropdownButtonFormField<String>(
                initialValue: _selectedCommunaute,
                hint: const Text('Sélectionner la Communauté'),
                items: _communautes.map((c) => DropdownMenuItem(value: c['id'].toString(), child: Text(c['nom']))).toList(),
                onChanged: (v) => setState(() => _selectedCommunaute = v),
              ),
              _datePicker("Date d'entrée dans l'Église", _dateEntreeEglise, (d) => _dateEntreeEglise = d),
              _radio('Statut du membre', _statutMembre, ['Nouveau', 'Ancien', 'Transfert'], (v) => setState(() => _statutMembre = v!)),
              if (_statutMembre == 'Transfert')
                _textField(_origineTransfertController, 'Origine (Eglise, Champ, District, Communaute)'),

              const SizedBox(height: 25),
              // V. VIE SACRAMENTELLE
              _sectionTitle('V. VIE SACRAMENTELLE'),
              _radio('Baptisé(e)', _isBaptise, ['Oui', 'Non'], (v) => setState(() => _isBaptise = v!)),
              if (_isBaptise == 'Oui')
                _datePicker('Date du baptême', _dateBapteme ?? DateTime.now(), (d) => _dateBapteme = d),
              _radio('Scellé(e)', _isScelle, ['Oui', 'Non'], (v) => setState(() => _isScelle = v!)),
              if (_isScelle == 'Oui')
                _datePicker('Date du scellement', _dateScellement ?? DateTime.now(), (d) => _dateScellement = d),
              _radio('Sainte-Cène', _sainteCene, ['Oui', 'Non'], (v) => setState(() => _sainteCene = v!)),

              const SizedBox(height: 25),
              // VI. SERVICE ET ENGAGEMENT
              _sectionTitle('VI. SERVICE ET ENGAGEMENT'),
              _textField(_ministereController, 'Ministère'),
              _textField(_fonctionController, "Fonction dans l'Église"),
              _dropdown('Commission', _selectedCommission, AppConstants.commissions, (v) => setState(() => _selectedCommission = v)),
              _dropdown("Rôle dans l'Entité", _selectedEntityRole, ['Aucun', 'Responsable', 'Suppléant'], (v) => setState(() => _selectedEntityRole = v!)),
              _dropdown('Rôle dans la Commission', _selectedCommissionRole, ['Aucun', 'Responsable', 'Suppléant'], (v) => setState(() => _selectedCommissionRole = v!)),
              _textField(_donsController, 'Dons / compétences'),
              _radio('Disponibilité', _disponibilite, ['Hebdomadaire', 'Mensuelle', 'Occasionnelle'], (v) => setState(() => _disponibilite = v!)),

              const SizedBox(height: 25),
              // VII. PERSONNE À CONTACTER EN CAS D'URGENCE
              _sectionTitle("VII. PERSONNE À CONTACTER EN CAS D'URGENCE"),
              _textField(_urgenceNomController, 'Nom complet'),
              _textField(_urgenceLienController, 'Lien avec le membre'),
              _textField(_urgenceTelController, 'Téléphone', keyboardType: TextInputType.phone),

              const SizedBox(height: 25),
              // VIII. OBSERVATIONS
              _sectionTitle('VIII. OBSERVATIONS'),
              _textField(_observationsController, 'Observations', maxLines: 3),

              const SizedBox(height: 35),
              // IX. DÉCLARATION
              _sectionTitle('IX. DÉCLARATION'),
              const Text('Je certifie que les informations ci-dessus sont exactes.', style: TextStyle(fontStyle: FontStyle.italic)),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(55), backgroundColor: Colors.blue, foregroundColor: Colors.white),
                onPressed: _sauvegarder,
                child: const Text('ENREGISTRER LE MEMBRE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
    );
  }

  Widget _textField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        keyboardType: keyboardType,
        maxLines: maxLines,
      ),
    );
  }

  Widget _dropdown(String label, String? value, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _radio(String label, String groupValue, List<String> options, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        Wrap(
          children: options.map((opt) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<String>(
                value: opt,
                // ignore: deprecated_member_use
                groupValue: groupValue,
                // ignore: deprecated_member_use
                onChanged: (value) => onChanged(value),
              ),
              Text(opt),
              const SizedBox(width: 10),
            ],
          )).toList(),
        ),
      ],
    );
  }

  Widget _datePicker(String label, DateTime date, Function(DateTime) onSelected) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => _selectDate(context, onSelected, date),
        child: InputDecorator(
          decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
          child: Text('${date.day}/${date.month}/${date.year}'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomController.dispose();
    _postnomController.dispose();
    _prenomController.dispose();
    _lieuNaisController.dispose();
    _nationaliteController.dispose();
    _professionController.dispose();
    _nomPereController.dispose();
    _nomMereController.dispose();
    _avenueController.dispose();
    _numeroController.dispose();
    _quartierController.dispose();
    _communeController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    _origineTransfertController.dispose();
    _ministereController.dispose();
    _fonctionController.dispose();
    _donsController.dispose();
    _urgenceNomController.dispose();
    _urgenceLienController.dispose();
    _urgenceTelController.dispose();
    _observationsController.dispose();
    super.dispose();
  }
}

