import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ecclesiaste/models/member_profile.dart';
import 'package:ecclesiaste/services/auth_service.dart';
import 'package:ecclesiaste/services/entite_scope_service.dart';
import 'package:ecclesiaste/services/database_service.dart';
import 'package:ecclesiaste/services/repository_providers.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class InscriptionMembreStepper extends ConsumerStatefulWidget {
  const InscriptionMembreStepper({super.key});

  @override
  ConsumerState<InscriptionMembreStepper> createState() =>
      _InscriptionMembreStepperState();
}

class _InscriptionMembreStepperState extends ConsumerState<InscriptionMembreStepper> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _postNomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _lieuNaissanceController = TextEditingController();
  final TextEditingController _nationaliteController = TextEditingController(text: 'Congolaise');
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _communeQuartierController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _baptemeDateController = TextEditingController();
  final TextEditingController _scellementDateController = TextEditingController();

  bool _isMale = true;
  CivilStatus _selectedCivilStatus = CivilStatus.celibataire;
  DateTime? _selectedBirthDate;

  @override
  void dispose() {
    _nomController.dispose();
    _postNomController.dispose();
    _prenomController.dispose();
    _birthDateController.dispose();
    _lieuNaissanceController.dispose();
    _nationaliteController.dispose();
    _adresseController.dispose();
    _communeQuartierController.dispose();
    _phoneController.dispose();
    _baptemeDateController.dispose();
    _scellementDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller, Function(DateTime) onSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF003366),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
        onSelected(picked);
      });
    }
  }

  List<Step> _getSteps() {
    return [
      Step(
        isActive: _currentStep >= 0,
        title: const Text('Identité'),
        content: Column(
          children: [
            TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom')),
            TextFormField(
                controller: _postNomController,
                decoration: const InputDecoration(labelText: 'Post-Nom')),
            TextFormField(
                controller: _prenomController,
                decoration: const InputDecoration(labelText: 'Prénom')),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Sexe : '),
                Radio<bool>(
                  value: true,
                  groupValue: _isMale,
                  onChanged: (v) => setState(() => _isMale = v!),
                ),
                const Text('M'),
                Radio<bool>(
                  value: false,
                  groupValue: _isMale,
                  onChanged: (v) => setState(() => _isMale = v!),
                ),
                const Text('F'),
              ],
            ),
          ],
        ),
      ),
      Step(
        isActive: _currentStep >= 1,
        title: const Text('Naissance'),
        content: Column(
          children: [
            TextFormField(
                controller: _birthDateController,
                readOnly: true,
                onTap: () => _selectDate(context, _birthDateController, (d) => _selectedBirthDate = d),
                decoration: const InputDecoration(
                    labelText: 'Date de naissance',
                    suffixIcon: Icon(Icons.calendar_today))),
            TextFormField(
                controller: _lieuNaissanceController,
                decoration: const InputDecoration(
                    labelText: 'Lieu de naissance', hintText: 'Ville / Village')),
            TextFormField(
                controller: _nationaliteController,
                decoration: const InputDecoration(labelText: 'Nationalité')),
          ],
        ),
      ),
      Step(
        isActive: _currentStep >= 2,
        title: const Text('État Civil'),
        content: DropdownButtonFormField<CivilStatus>(
          value: _selectedCivilStatus,
          items: CivilStatus.values
              .map((s) => DropdownMenuItem(
                  value: s,
                  child: Text(s.name[0].toUpperCase() + s.name.substring(1))))
              .toList(),
          onChanged: (v) => setState(() => _selectedCivilStatus = v!),
          decoration:
              const InputDecoration(labelText: 'Situation matrimoniale'),
        ),
      ),
      Step(
        isActive: _currentStep >= 3,
        title: const Text('Coordonnées'),
        content: Column(
          children: [
            TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                    labelText: 'Téléphone', prefixText: '+243 ')),
            TextFormField(
                controller: _adresseController,
                decoration: const InputDecoration(labelText: 'Adresse domicile')),
            TextFormField(
                controller: _communeQuartierController,
                decoration: const InputDecoration(labelText: 'Commune / Quartier')),
          ],
        ),
      ),
      Step(
        isActive: _currentStep >= 4,
        title: const Text('Baptême'),
        content: Column(
          children: [
            TextFormField(
                controller: _baptemeDateController,
                readOnly: true,
                onTap: () => _selectDate(context, _baptemeDateController, (d) {}),
                decoration: const InputDecoration(
                    labelText: 'Date du Baptême',
                    suffixIcon: Icon(Icons.calendar_today))),
            TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Ministre ayant officié')),
          ],
        ),
      ),
      Step(
        isActive: _currentStep >= 5,
        title: const Text('Saint-Scellement'),
        content: Column(
          children: [
            TextFormField(
                controller: _scellementDateController,
                readOnly: true,
                onTap: () => _selectDate(context, _scellementDateController, (d) {}),
                decoration:
                    const InputDecoration(
                        labelText: 'Date du Scellement',
                        suffixIcon: Icon(Icons.calendar_today))),
            TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Apôtre ayant officié')),
          ],
        ),
      ),
      Step(
        isActive: _currentStep >= 6,
        title: const Text('Formation'),
        content: CheckboxListTile(
            title: const Text('A terminé son Catéchisme'),
            value: false,
            onChanged: (v) {}),
      ),
      Step(
        isActive: _currentStep >= 7,
        title: const Text('Engagement'),
        content: TextFormField(
            decoration: const InputDecoration(
                labelText: 'Commission suggérée',
                hintText: 'ex: Musique, ECODIM')),
      ),
      Step(
        isActive: _currentStep >= 8,
        title: const Text('Validation'),
        content: Column(
          children: [
            const Icon(Icons.verified_user, size: 50, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
                'Veuillez vérifier les informations avant de soumettre la fiche au Conducteur.'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF003366).withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Scope de destination :', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003366))),
                  const SizedBox(height: 8),
                  _buildScopeDetail('Territoriale', EntiteScopeService.territorialeId),
                  _buildScopeDetail('Région', EntiteScopeService.regionApostoliqueId),
                  _buildScopeDetail('Champ', EntiteScopeService.champId),
                  _buildScopeDetail('District', EntiteScopeService.districtId),
                  _buildScopeDetail('Communauté', EntiteScopeService.communauteId, isLast: true),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Widget _buildScopeDetail(String label, String? value, {bool isLast = false}) {
    if (value == null) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 4),
      child: Row(
        children: [
          Text('$label : ', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fiche d\'Inscription Membre'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < _getSteps().length - 1) {
              setState(() => _currentStep += 1);
            } else {
              _saveMember();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) setState(() => _currentStep -= 1);
          },
          steps: _getSteps(),
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003366),
                        foregroundColor: Colors.white),
                    child: Text(_currentStep == 8 ? 'SOUMETTRE' : 'SUIVANT'),
                  ),
                  const SizedBox(width: 12),
                  if (_currentStep > 0)
                    TextButton(
                        onPressed: details.onStepCancel,
                        child: const Text('RETOUR')),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _saveMember() async {
    final id = const Uuid().v4();
    final currentUser = AuthService.currentUser;
    final repo = ref.read(memberRepositoryProvider);

    // Conversion sécurisée des dates
    DateTime? parseDate(String date) {
      if (date.isEmpty) return null;
      try {
        final parts = date.split('/');
        if (parts.length != 3) return null;
        return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
      } catch (e) {
        return null;
      }
    }

    final newMember = MemberProfile(
      id: id,
      nom: _nomController.text,
      prenom: _prenomController.text,
      postNom: _postNomController.text,
      isMale: _isMale,
      dateNaissance: _selectedBirthDate ?? DateTime.now(),
      lieuNaissance: _lieuNaissanceController.text.isEmpty ? 'Non renseigné' : _lieuNaissanceController.text,
      nationalite: _nationaliteController.text.isEmpty ? 'Congolaise' : _nationaliteController.text,
      etatCivil: _selectedCivilStatus,
      adresse: _adresseController.text.isEmpty ? 'Non renseignée' : _adresseController.text,
      communeQuartier: _communeQuartierController.text.isEmpty ? 'Non renseigné' : _communeQuartierController.text,
      telephone: _phoneController.text,
      internationaleId: EntiteScopeService.internationaleId,
      egliseTerritorialeId: EntiteScopeService.territorialeId ?? 'RDC_OUEST',
      regionApostoliqueId: EntiteScopeService.regionApostoliqueId,
      champApostoliqueId: EntiteScopeService.champId,
      districtId: EntiteScopeService.districtId ?? 'TSHIKAPA',
      communauteId: EntiteScopeService.communauteId ?? 'JEREMIE',
      dateEntreeEglise: DateTime.now(),
      statutMembre: MemberStatus.nouveau,
      baptise: _baptemeDateController.text.isNotEmpty,
      dateBapteme: parseDate(_baptemeDateController.text),
      prendSainteCene: true,
      scelle: _scellementDateController.text.isNotEmpty,
      dateScellement: parseDate(_scellementDateController.text),
      disponibilite: Availability.hebdomadaire,
      dateInscription: DateTime.now(),
      inscritParMinistreId: currentUser?.id ?? 'ADMIN_01',
    );

    await repo.addMember(newMember);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Fiche soumise pour validation'),
            backgroundColor: Colors.green),
      );
      context.pop();
    }
  }
}

