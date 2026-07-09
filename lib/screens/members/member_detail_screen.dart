import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/member_model.dart';
import '../../services/pastoral_encryption_service.dart';

class MemberDetailScreen extends StatefulWidget {
  final MemberModel member;
  const MemberDetailScreen({super.key, required this.member});

  @override
  State<MemberDetailScreen> createState() => _MemberDetailScreenState();
}

class _MemberDetailScreenState extends State<MemberDetailScreen> {
  bool _showPastoralNotes = false;
  String _decryptedNotes = '';

  Future<void> _togglePastoralNotes() async {
    if (!_showPastoralNotes) {
      await PastoralEncryptionService.init();
      setState(() {
        _decryptedNotes = PastoralEncryptionService.decrypt(widget.member.pastoralNotesEncrypted);
        _showPastoralNotes = true;
      });
    } else {
      setState(() {
        _showPastoralNotes = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.member;
    final df = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text('${m.nom} ${m.prenom}'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeaderSection(m),
          const Divider(height: 30),
          _buildInfoSection('Identité', [
            _buildInfoRow('Sexe', m.sexe),
            _buildInfoRow('Né(e) le', m.dateNaissance != null ? df.format(m.dateNaissance!) : 'N/A'),
            _buildInfoRow('Lieu', m.lieuNaissance),
            _buildInfoRow('État Civil', m.etatCivil),
          ]),
          _buildInfoSection('Filiation', [
            _buildInfoRow('Père', '${m.pereNom} ${m.perePrenom} (${m.statutParentPere})'),
            _buildInfoRow('Mère', '${m.mereNom} ${m.merePrenom} (${m.statutParentMere})'),
          ]),
          _buildInfoSection('Coordonnées', [
            _buildInfoRow('Téléphone', m.telephone),
            _buildInfoRow('Email', m.email),
            _buildInfoRow('Adresse', '${m.adresse}, ${m.commune}, ${m.ville}'),
          ]),
          _buildInfoSection('Vie Ecclésiale', [
            _buildInfoRow('Communauté', m.communityName),
            _buildInfoRow('Statut', m.statutMembre),
            _buildInfoRow('Baptisé(e)', m.isBaptise ? 'Oui (le ${m.dateBapteme != null ? df.format(m.dateBapteme!) : "?"})' : 'Non'),
            _buildInfoRow('Scellé(e)', m.isScelle ? 'Oui (le ${m.dateScelle != null ? df.format(m.dateScelle!) : "?"})' : 'Non'),
            _buildInfoRow('Confirmé(e)', m.isConfirme ? 'Oui' : 'Non'),
          ]),
          _buildInfoSection('Engagement', [
            _buildInfoRow('Ministère', m.aMinistere ? 'Oui' : 'Non'),
            _buildInfoRow('Commission', m.commission),
            _buildInfoRow('Rôle', m.roleCommission),
          ]),
          const SizedBox(height: 20),
          _buildPastoralNotesCard(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(MemberModel m) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: const Color(0xFF003366),
            child: Text(m.nom[0], style: const TextStyle(fontSize: 32, color: Colors.white)),
          ),
          const SizedBox(height: 10),
          Text('${m.nom.toUpperCase()} ${m.postNom} ${m.prenom}', 
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(m.statutMembre, style: TextStyle(color: Colors.grey[600], fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
        ),
        ...children,
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text('$label :', style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(child: Text(value.isEmpty ? '-' : value)),
        ],
      ),
    );
  }

  Widget _buildPastoralNotesCard() {
    return Card(
      color: Colors.red.shade50,
      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.red.shade200), borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lock, color: Colors.red),
                const SizedBox(width: 10),
                const Text('Notes Pastorales Confidentielles', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                const Spacer(),
                IconButton(
                  icon: Icon(_showPastoralNotes ? Icons.visibility_off : Icons.visibility, color: Colors.red),
                  onPressed: _togglePastoralNotes,
                )
              ],
            ),
            if (_showPastoralNotes)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(_decryptedNotes, style: const TextStyle(fontStyle: FontStyle.italic)),
              )
            else
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text('Contenu chiffré. Cliquez sur l\'œil pour voir.', style: TextStyle(color: Colors.grey)),
              ),
          ],
        ),
      ),
    );
  }
}
