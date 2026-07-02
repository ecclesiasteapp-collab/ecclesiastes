import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/hierarchy_models.dart';
import '../models/member_profile.dart';

class MemberEditPage extends StatefulWidget {
  final String memberId;

  const MemberEditPage({super.key, required this.memberId});

  @override
  State<MemberEditPage> createState() => _MemberEditPageState();
}

class _MemberEditPageState extends State<MemberEditPage> {
  final _formKey = GlobalKey<FormState>();

  late MemberProfile _member;
  bool _isLoading = true;

  final _nomController = TextEditingController();
  final _postNomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _adresseController = TextEditingController();
  final _communeController = TextEditingController();
  final _professionController = TextEditingController();
  final _fonctionController = TextEditingController();
  final _donsController = TextEditingController();
  final _observationsController = TextEditingController();

  late bool _isMale;
  late CivilStatus _etatCivil;
  late MemberStatus _statut;
  late Availability _disponibilite;
  late bool _baptise;
  late bool _scelle;
  late bool _prendSainteCene;
  late DateTime _dateNaissance;
  late DateTime _dateEntreeEglise;
  DateTime? _dateBapteme;
  DateTime? _dateScellement;
  List<CommissionType> _commissions = [];

  @override
  void initState() {
    super.initState();
    _loadMember();
  }

  Future<void> _loadMember() async {
    final member = Hive.box<MemberProfile>('member_profiles').get(widget.memberId);

    if (member == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Membre introuvable')),
        );
        context.go('/members');
      }
      return;
    }

    _member = member;
    _nomController.text = member.nom;
    _postNomController.text = member.postNom;
    _prenomController.text = member.prenom;
    _telephoneController.text = member.telephone;
    _emailController.text = member.email ?? '';
    _adresseController.text = member.adresse;
    _communeController.text = member.communeQuartier;
    _professionController.text = member.profession ?? '';
    _fonctionController.text = member.fonctionEglise ?? '';
    _donsController.text = member.donsCompetences ?? '';
    _observationsController.text = member.observations ?? '';

    _isMale = member.isMale;
    _etatCivil = member.etatCivil;
    _statut = member.statutMembre;
    _disponibilite = member.disponibilite;
    _baptise = member.baptise;
    _scelle = member.scelle;
    _prendSainteCene = member.prendSainteCene;
    _dateNaissance = member.dateNaissance;
    _dateEntreeEglise = member.dateEntreeEglise;
    _dateBapteme = member.dateBapteme;
    _dateScellement = member.dateScellement;
    _commissions = List<CommissionType>.from(member.commissions);

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _nomController.dispose();
    _postNomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    _adresseController.dispose();
    _communeController.dispose();
    _professionController.dispose();
    _fonctionController.dispose();
    _donsController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le membre'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _sectionTitle('Identité'),
            _textField(_nomController, 'Nom'),
            _textField(_postNomController, 'Post-nom'),
            _textField(_prenomController, 'Prénom'),
            DropdownButtonFormField<bool>(
              initialValue: _isMale,
              decoration: const InputDecoration(
                labelText: 'Sexe',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: true, child: Text('Masculin')),
                DropdownMenuItem(value: false, child: Text('Féminin')),
              ],
              onChanged: (value) => setState(() => _isMale = value ?? true),
            ),
            const SizedBox(height: 12),
            _dateTile('Date de naissance', _dateNaissance, (date) {
              setState(() => _dateNaissance = date);
            }),
            const SizedBox(height: 12),
            DropdownButtonFormField<CivilStatus>(
              initialValue: _etatCivil,
              decoration: const InputDecoration(
                labelText: 'État civil',
                border: OutlineInputBorder(),
              ),
              items: CivilStatus.values
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status.name),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _etatCivil = value ?? _etatCivil),
            ),
            const SizedBox(height: 20),
            _sectionTitle('Coordonnées'),
            _textField(_telephoneController, 'Téléphone'),
            _textField(_emailController, 'Email'),
            _textField(_adresseController, 'Adresse'),
            _textField(_communeController, 'Commune / Quartier'),
            const SizedBox(height: 20),
            _sectionTitle('Vie ecclésiale'),
            DropdownButtonFormField<MemberStatus>(
              initialValue: _statut,
              decoration: const InputDecoration(
                labelText: 'Statut membre',
                border: OutlineInputBorder(),
              ),
              items: MemberStatus.values
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status.name),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _statut = value ?? _statut),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Availability>(
              initialValue: _disponibilite,
              decoration: const InputDecoration(
                labelText: 'Disponibilité',
                border: OutlineInputBorder(),
              ),
              items: Availability.values
                  .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text(value.name),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _disponibilite = value ?? _disponibilite),
            ),
            const SizedBox(height: 12),
            _dateTile('Date entrée Église', _dateEntreeEglise, (date) {
              setState(() => _dateEntreeEglise = date);
            }),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _baptise,
              title: const Text('Baptisé'),
              onChanged: (value) => setState(() => _baptise = value),
            ),
            if (_baptise)
              _dateTile('Date baptême', _dateBapteme ?? DateTime.now(), (date) {
                setState(() => _dateBapteme = date);
              }),
            SwitchListTile(
              value: _scelle,
              title: const Text('Scellé'),
              onChanged: (value) => setState(() => _scelle = value),
            ),
            if (_scelle)
              _dateTile('Date scellement', _dateScellement ?? DateTime.now(), (date) {
                setState(() => _dateScellement = date);
              }),
            SwitchListTile(
              value: _prendSainteCene,
              title: const Text('Prend la Sainte-Cène'),
              onChanged: (value) => setState(() => _prendSainteCene = value),
            ),
            const SizedBox(height: 20),
            _sectionTitle('Service'),
            _textField(_professionController, 'Profession'),
            _textField(_fonctionController, 'Fonction dans l’Église'),
            _textField(_donsController, 'Dons / compétences'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: CommissionType.values
                  .where((value) => value != CommissionType.none)
                  .map(
                    (commission) => FilterChip(
                      label: Text(commission.name),
                      selected: _commissions.contains(commission),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _commissions = [..._commissions, commission];
                          } else {
                            _commissions =
                                _commissions.where((item) => item != commission).toList();
                          }
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            _sectionTitle('Observations'),
            _textField(_observationsController, 'Observations', maxLines: 4),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveMember,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: const Color(0xFF003366),
                foregroundColor: Colors.white,
              ),
              child: const Text('ENREGISTRER LES MODIFICATIONS'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Color(0xFF003366),
        ),
      ),
    );
  }

  Widget _textField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if ((label == 'Nom' || label == 'Prénom' || label == 'Téléphone') &&
              (value == null || value.trim().isEmpty)) {
            return 'Champ obligatoire';
          }
          return null;
        },
      ),
    );
  }

  Widget _dateTile(
    String label,
    DateTime value,
    ValueChanged<DateTime> onSelected,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text('${value.day}/${value.month}/${value.year}'),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        final selected = await showDatePicker(
          context: context,
          initialDate: value,
          firstDate: DateTime(1900),
          lastDate: DateTime.now().add(const Duration(days: 3650)),
        );
        if (selected != null) {
          onSelected(selected);
        }
      },
    );
  }

  Future<void> _saveMember() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _member.nom = _nomController.text.trim();
    _member.postNom = _postNomController.text.trim();
    _member.prenom = _prenomController.text.trim();
    _member.telephone = _telephoneController.text.trim();
    _member.email = _emailController.text.trim().isEmpty ? null : _emailController.text.trim();
    _member.adresse = _adresseController.text.trim();
    _member.communeQuartier = _communeController.text.trim();
    _member.profession =
        _professionController.text.trim().isEmpty ? null : _professionController.text.trim();
    _member.fonctionEglise =
        _fonctionController.text.trim().isEmpty ? null : _fonctionController.text.trim();
    _member.donsCompetences =
        _donsController.text.trim().isEmpty ? null : _donsController.text.trim();
    _member.observations = _observationsController.text.trim().isEmpty
        ? null
        : _observationsController.text.trim();
    _member.isMale = _isMale;
    _member.etatCivil = _etatCivil;
    _member.statutMembre = _statut;
    _member.disponibilite = _disponibilite;
    _member.baptise = _baptise;
    _member.scelle = _scelle;
    _member.prendSainteCene = _prendSainteCene;
    _member.dateNaissance = _dateNaissance;
    _member.dateEntreeEglise = _dateEntreeEglise;
    _member.dateBapteme = _baptise ? _dateBapteme : null;
    _member.dateScellement = _scelle ? _dateScellement : null;
    _member.commissions = _commissions;

    await _member.save();

    final legacyBox = await Hive.openBox<Map>('membres');
    final legacyMember = legacyBox.get(_member.id);
    if (legacyMember != null) {
      final updated = Map<String, dynamic>.from(legacyMember);
      updated['nom'] = _member.nom;
      updated['postnom'] = _member.postNom;
      updated['prenom'] = _member.prenom;
      updated['telephone'] = _member.telephone;
      updated['email'] = _member.email;
      updated['adresse_avenue'] = _member.adresse;
      updated['adresse_commune'] = _member.communeQuartier;
      updated['profession'] = _member.profession;
      updated['fonction'] = _member.fonctionEglise;
      updated['observations'] = _member.observations;
      updated['date_naissance'] = _member.dateNaissance.toIso8601String();
      updated['date_entree_eglise'] = _member.dateEntreeEglise.toIso8601String();
      updated['statut_membre'] = _member.statutMembre.name;
      updated['baptise'] = _member.baptise ? 'Oui' : 'Non';
      updated['scelle'] = _member.scelle ? 'Oui' : 'Non';
      updated['sainte_cene'] = _member.prendSainteCene ? 'Oui' : 'Non';
      await legacyBox.put(_member.id, updated);
    }

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Membre mis à jour avec succès')),
    );
    context.go('/member/detail/${_member.id}');
  }
}

