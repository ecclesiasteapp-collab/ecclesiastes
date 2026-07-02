import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ecclesiastes/models/member_profile.dart';
import 'package:uuid/uuid.dart';

class InscriptionMembreStepper extends StatefulWidget {
  const InscriptionMembreStepper({super.key});

  @override
  State<InscriptionMembreStepper> createState() =>
      _InscriptionMembreStepperState();
}

class _InscriptionMembreStepperState extends State<InscriptionMembreStepper> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _baptemeDateController = TextEditingController();
  final TextEditingController _scellementDateController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _baptemeDateController.dispose();
    _scellementDateController.dispose();
    _phoneController.dispose();
    super.dispose();
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
                controller: _prenomController,
                decoration: const InputDecoration(labelText: 'Prénom')),
          ],
        ),
      ),
      Step(
        isActive: _currentStep >= 1,
        title: const Text('Naissance'),
        content: TextFormField(
            decoration: const InputDecoration(
                labelText: 'Lieu de naissance', hintText: 'Ville / Village')),
      ),
      Step(
        isActive: _currentStep >= 2,
        title: const Text('État Civil'),
        content: DropdownButtonFormField<String>(
          items: ['Célibataire', 'Marié(e)', 'Veuf/Veuve']
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (v) {},
          decoration:
              const InputDecoration(labelText: 'Situation matrimoniale'),
        ),
      ),
      Step(
        isActive: _currentStep >= 3,
        title: const Text('Coordonnées'),
        content: TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
                labelText: 'Téléphone', prefixText: '+243 ')),
      ),
      Step(
        isActive: _currentStep >= 4,
        title: const Text('Baptême'),
        content: Column(
          children: [
            TextFormField(
                controller: _baptemeDateController,
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
                decoration:
                    const InputDecoration(labelText: 'Date du Scellement')),
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
        content: const Column(
          children: [
            Icon(Icons.verified_user, size: 50, color: Colors.green),
            Text(
                'Veuillez vérifier les informations avant de soumettre la fiche au Conducteur.'),
          ],
        ),
      ),
    ];
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
    final box = Hive.box<MemberProfile>('member_profiles');
    final id = const Uuid().v4();

    // Conversion sécurisée des dates
    DateTime? parseDate(String date) =>
        DateTime.tryParse(date.split('/').reversed.join('-'));

    final newMember = MemberProfile(
      id: id,
      nom: _nomController.text,
      prenom: _prenomController.text,
      postNom: '', // À ajouter au formulaire plus tard
      isMale: true,
      dateNaissance: DateTime.now(),
      lieuNaissance: 'Non renseigné',
      nationalite: 'Congolaise',
      etatCivil: CivilStatus.celibataire,
      adresse: 'Non renseignée',
      communeQuartier: 'Non renseigné',
      telephone: _phoneController.text,
      egliseTerritorialeId: 'RDC_OUEST',
      districtId: 'TSHIKAPA',
      communauteId: 'JEREMIE',
      dateEntreeEglise: DateTime.now(),
      statutMembre: MemberStatus.nouveau,
      baptise: _baptemeDateController.text.isNotEmpty,
      dateBapteme: parseDate(_baptemeDateController.text),
      prendSainteCene: true,
      scelle: _scellementDateController.text.isNotEmpty,
      dateScellement: parseDate(_scellementDateController.text),
      disponibilite: Availability.hebdomadaire,
      dateInscription: DateTime.now(),
      inscritParMinistreId: 'ADMIN_01',
    );

    await box.put(id, newMember);
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

