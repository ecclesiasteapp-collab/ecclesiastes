import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/member_profile.dart';

class MemberRegistrationScreen extends StatefulWidget {
  const MemberRegistrationScreen({super.key});
  @override
  State<MemberRegistrationScreen> createState() => _MemberRegistrationScreenState();
}

class _MemberRegistrationScreenState extends State<MemberRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  final _postNomCtrl = TextEditingController();
  final _prenomCtrl = TextEditingController();
  final _telephoneCtrl = TextEditingController();
  
  final bool _isMale = true;
  final CivilStatus _etatCivil = CivilStatus.celibataire;
  bool _baptise = false;
  bool _scelle = false;
  final MemberStatus _statut = MemberStatus.nouveau;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fiche d\'Enregistrement'), backgroundColor: const Color(0xFF003366)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('I. IDENTITÉ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF003366))),
            const SizedBox(height: 8),
            TextFormField(controller: _nomCtrl, decoration: const InputDecoration(labelText: 'Nom *', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Requis' : null),
            const SizedBox(height: 8),
            TextFormField(controller: _postNomCtrl, decoration: const InputDecoration(labelText: 'Post-nom *', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Requis' : null),
            const SizedBox(height: 8),
            TextFormField(controller: _prenomCtrl, decoration: const InputDecoration(labelText: 'Prénom *', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Requis' : null),
            const SizedBox(height: 16),
            
            const Text('II. FILIATION', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF003366))),
            const SizedBox(height: 8),
            SwitchListTile(title: const Text('Père néo-apostolique'), value: false, onChanged: (v) {}),
            SwitchListTile(title: const Text('Mère née néo-apostolique'), value: false, onChanged: (v) {}),
            SwitchListTile(title: const Text('Membre né néo-apostolique'), value: false, onChanged: (v) {}),
            const SizedBox(height: 16),

            const Text('V. VIE SACRAMENTELLE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF003366))),
            const SizedBox(height: 8),
            CheckboxListTile(title: const Text('Baptisé(e)'), value: _baptise, onChanged: (v) => setState(() => _baptise = v!)),
            CheckboxListTile(title: const Text('Scellé(e)'), value: _scelle, onChanged: (v) => setState(() => _scelle = v!)),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final profile = MemberProfile(
                    id: const Uuid().v4(),
                    nom: _nomCtrl.text, postNom: _postNomCtrl.text, prenom: _prenomCtrl.text,
                    isMale: _isMale, dateNaissance: DateTime(2000, 1, 1), lieuNaissance: 'Kinshasa',
                    nationalite: 'Congolaise', etatCivil: _etatCivil, adresse: 'Non spécifiée',
                    communeQuartier: 'Non spécifié', telephone: _telephoneCtrl.text,
                    egliseTerritorialeId: 'RDC_OUEST', districtId: 'DIST_TSHIKAPA',
                    communauteId: 'CTE_JEREMIE', dateEntreeEglise: DateTime.now(), statutMembre: _statut,
                    baptise: _baptise, prendSainteCene: true, scelle: _scelle,
                    disponibilite: Availability.hebdomadaire, dateInscription: DateTime.now(),
                    inscritParMinistreId: 'ADMIN',
                  );
                  await Hive.box<MemberProfile>('member_profiles').add(profile);
                  if (!mounted) return;
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Membre enregistré avec succès !'), backgroundColor: Colors.green));
                    Navigator.pop(context);
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF003366), minimumSize: const Size.fromHeight(50)),
              child: const Text('ENREGISTRER LE MEMBRE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}
