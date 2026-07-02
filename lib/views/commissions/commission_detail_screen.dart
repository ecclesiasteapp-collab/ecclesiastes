import 'package:flutter/material.dart';
import '../report_list_screen.dart';
import '../gestion_membres_page.dart';
import '../hierarchie_page.dart';

class CommissionDetailScreen extends StatelessWidget {
  final String commissionName;
  final String leaderName;
  final String? leaderPhotoUrl;
  final double progress;
  final String entityId;

  const CommissionDetailScreen({
    super.key,
    required this.commissionName,
    required this.leaderName,
    this.leaderPhotoUrl,
    required this.progress,
    required this.entityId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const Text(
              'ecclesiastes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF003366),
              ),
            ),
            const Spacer(),
            Text(
              'Commission $commissionName',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),

            const Spacer(),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Carte d\'Informations',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _buildInfoCard(context),
            const SizedBox(height: 24),
            _buildActionGrid(context),
            const SizedBox(height: 32),
            const Text('Liste des Rapports Récents',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _buildReportItem(context, 'District Tshikapa - Rapport Mars',
                'validé', Icons.check_circle, Colors.green),
            _buildReportItem(context, 'District UPN - Rapport Mars',
                'en attente', Icons.access_time, Colors.orange),
            _buildReportItem(context, 'District Kanga-M - Rapport Mars',
                'validé', Icons.check_circle, Colors.green),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOptions(context),
        backgroundColor: const Color(0xFF990000),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: leaderPhotoUrl != null
                      ? NetworkImage(leaderPhotoUrl!)
                      : null,
                  child: leaderPhotoUrl == null
                      ? const Icon(Icons.person, size: 30)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(leaderName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      Text('Responsable: $leaderName',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildClickableStat(context, '22', 'Districts actifs', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const HierarchiePage()));
                }),
                _buildClickableStat(context, '156', 'Rapports ce mois', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ReportListScreen()));
                }),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              color: Colors.orange,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('${(progress * 100).toInt()}% complété',
                  style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClickableStat(
      BuildContext context, String value, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 2.2,
      children: [
        _buildActionBtn(
            context, '📋 Voir Rapports', Colors.green, '12 nouveaux', () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ReportListScreen()));
        }),
        _buildActionBtn(context, '👥 Membres (847)', Colors.blue, null, () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => GestionMembresPage()));
        }),
        _buildActionBtn(context, '📅 Programme 2026', Colors.orange, null, () {
          _showProgramme(context);
        }),
        _buildActionBtn(context, '✏️ Modifier', Colors.deepPurpleAccent, null,
            () {
          _showEditDialog(context);
        }),
      ],
    );
  }

  Widget _buildActionBtn(BuildContext context, String label, Color color,
      String? badge, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (badge != null)
            Positioned(
              top: -8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF990000),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(badge,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReportItem(BuildContext context, String title, String status,
      IconData icon, Color iconColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 14),
            children: [
              TextSpan(text: '$title '),
              TextSpan(
                  text: '($status)',
                  style:
                      TextStyle(color: iconColor, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_right, size: 16),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ReportListScreen()));
        },
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
              title: Text('Filtrer par district',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          const Divider(),
          ListTile(
              title: const Text('District Tshikapa'),
              onTap: () => Navigator.pop(ctx)),
          ListTile(
              title: const Text('District UPN'),
              onTap: () => Navigator.pop(ctx)),
          ListTile(
              title: const Text('District Kanga-M'),
              onTap: () => Navigator.pop(ctx)),
        ],
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Créer un nouveau rapport'),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/create-report')),
          ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Ajouter un membre'),
              onTap: () {}),
          ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Envoyer un rappel'),
              onTap: () {}),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Modifier la Commission'),
        content:
            const Text('Formulaire d\'édition en cours de construction...'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Fermer'))
        ],
      ),
    );
  }

  void _showProgramme(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Programme $commissionName 2026',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildProgramItem(
                      '17 Janvier',
                      '1ère Rencontre Trimestrielle Encadreurs',
                      'D/ Kanga-M, C/Kanga-M'),
                  _buildProgramItem(
                      '7 Mars',
                      'Conférence Jeunesse Féminine (JIF)',
                      'D/ Mbudi, C/Mbudi'),
                  _buildProgramItem('14 Août',
                      'Voyage d’excursion toute la jeunesse', 'Kongo Central'),
                  _buildProgramItem(
                      '30 Août',
                      'SD de la rentrée scolaire avec tous les élèves',
                      'D/ UPN, C/Naomi'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramItem(String date, String title, String loc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8)),
          child: Text(date,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange)),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text(loc, style: const TextStyle(fontSize: 11)),
      ),
    );
  }
}

