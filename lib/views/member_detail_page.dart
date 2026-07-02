import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/member_profile.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MemberDetailPage extends StatelessWidget {
  final String memberId;
  const MemberDetailPage({super.key, required this.memberId});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<MemberProfile>('member_profiles');
    final member = box.get(memberId);

    if (member == null) {
      return const Scaffold(body: Center(child: Text('Membre introuvable')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${member.prenom} ${member.nom}'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(member),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('INFORMATIONS PERSONNELLES'),
                  _buildInfoCard([
                    _buildInfoRow(Icons.cake, 'Naissance', '${DateFormat('dd/MM/yyyy').format(member.dateNaissance)} (${member.lieuNaissance})'),
                    _buildInfoRow(Icons.flag, 'Nationalité', member.nationalite),
                    _buildInfoRow(Icons.favorite, 'État Civil', member.etatCivil.name.toUpperCase()),
                    _buildInfoRow(Icons.work, 'Profession', member.profession ?? 'N/A'),
                  ]),
                  const SizedBox(height: 20),
                  _buildSectionTitle('COORDONNÉES'),
                  _buildInfoCard([
                    _buildInfoRow(Icons.phone, 'Téléphone', member.telephone),
                    _buildInfoRow(Icons.email, 'Email', member.email ?? 'N/A'),
                    _buildInfoRow(Icons.location_on, 'Adresse', '${member.adresse}, ${member.communeQuartier}'),
                  ]),
                  const SizedBox(height: 20),
                  _buildSectionTitle('PARCOURS SPIRITUEL'),
                  _buildInfoCard([
                    _buildInfoRow(Icons.church, 'Date d\'entrée', DateFormat('dd/MM/yyyy').format(member.dateEntreeEglise)),
                    _buildInfoRow(Icons.water_drop, 'Baptême', member.baptise ? (member.dateBapteme != null ? DateFormat('dd/MM/yyyy').format(member.dateBapteme!) : 'OUI') : 'NON'),
                    _buildInfoRow(Icons.verified_user, 'Saint-Scellement', member.scelle ? (member.dateScellement != null ? DateFormat('dd/MM/yyyy').format(member.dateScellement!) : 'OUI') : 'NON'),
                    _buildInfoRow(Icons.restaurant_menu, 'Sainte-Cène', member.prendSainteCene ? 'AUTORISÉ' : 'NON AUTORISÉ'),
                  ]),
                  const SizedBox(height: 20),
                  _buildSectionTitle('ENGAGEMENT & COMMISSIONS'),
                  _buildInfoCard([
                    _buildInfoRow(Icons.badge, 'Fonction', member.fonctionEglise ?? 'Membre'),
                    _buildInfoRow(Icons.groups, 'Commissions', member.commissions.isEmpty ? 'Aucune' : member.commissions.map((e) => e.name.toUpperCase()).join(', ')),
                    _buildInfoRow(Icons.star, 'Dons / Compétences', member.donsCompetences ?? 'N/A'),
                  ]),
                  const SizedBox(height: 30),
                  _buildActionButtons(context, member),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(MemberProfile member) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: const BoxDecoration(
        color: Color(0xFF003366),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white24,
            child: Text(
              member.nom[0].toUpperCase(),
              style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            '${member.prenom} ${member.nom} ${member.postNom}',
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            member.communauteId, // Devrait être le nom de la communauté
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey, letterSpacing: 1.1),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.grey.shade200)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF003366)),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, MemberProfile member) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showTransferDialog(context, member),
            icon: const Icon(Icons.swap_horiz),
            label: const Text('TRANSFÉRER'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF003366),
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: Color(0xFF003366)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {}, // Modifier le profil
            icon: const Icon(Icons.edit),
            label: const Text('MODIFIER'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003366),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  void _showTransferDialog(BuildContext context, MemberProfile member) {
    context.go('/member/transfer/${member.id}');
  }
}

