import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/auth_service.dart';
import '../services/social_share_service.dart';
import '../models/hierarchy_models.dart';

class SocialHubScreen extends StatefulWidget {
  const SocialHubScreen({super.key});

  @override
  State<SocialHubScreen> createState() => _SocialHubScreenState();
}

class _SocialHubScreenState extends State<SocialHubScreen> {
  final SocialShareService _shareService = SocialShareService();
  final TextEditingController _activityController = TextEditingController();

  late String _entityName;
  late EntityLevel _level;
  late CommissionType _commission;

  @override
  void initState() {
    super.initState();
    final user = AuthService.currentUser;
    _entityName = 'Ma Communauté';
    _level = EntityLevel.communaute;
    _commission = CommissionType.none;

    if (user != null) {
      _level = user.entityLevel ?? EntityLevel.communaute;
      _commission = user.commissionType ?? CommissionType.none;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hub Social & Rayonnement'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildOfficialHeader(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBrandingTool(),
                  const SizedBox(height: 24),
                  _buildLeaderboard(),
                  const SizedBox(height: 24),
                  _buildMonthlyChallenges(),
                  const SizedBox(height: 24),
                  const Text('CONTRIBUTIONS DES ENTITÉS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                  const SizedBox(height: 12),
                  _buildLiveFeed(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfficialHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF003366),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Column(
        children: [
          const Text('CANAUX OFFICIELS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _officialAction('YouTube', Icons.play_circle_fill, Colors.red, 'https://youtube.com/@ecclesiaste.app'),
              const SizedBox(width: 30),
              _officialAction('Facebook', Icons.facebook, Colors.blue, 'https://facebook.com/ecclesiaste.app'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _officialAction(String label, IconData icon, Color color, String url) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse(url)),
      child: Column(
        children: [
          Icon(icon, color: color, size: 45),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildBrandingTool() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.orange),
                SizedBox(width: 10),
                Text('GÉNÉRATEUR DE RAYONNEMENT', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(),
            const Text(
              'Créez un visuel pour vos réseaux sociaux qui pointe vers nos pages officielles.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _activityController,
              decoration: InputDecoration(
                hintText: 'Titre de l\'activité (ex: Culte de Jeunesse)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                _buildTag(_commission.name.toUpperCase(), Colors.blue),
                const SizedBox(width: 8),
                _buildTag(_level.name.toUpperCase(), Colors.orange),
                const SizedBox(width: 8),
                Expanded(child: Text(_entityName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _generateAndShare,
                icon: const Icon(Icons.share),
                label: const Text('GÉNÉRER ET PARTAGER'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003366),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(5), border: Border.all(color: color)),
      child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildLeaderboard() {
    final List<Map<String, dynamic>> rankings = [
      {'name': 'District de Binza', 'points': 1250, 'trend': 'up'},
      {'name': 'Communaute de Limete', 'points': 980, 'trend': 'up'},
      {'name': 'Champ Apostolique KSO', 'points': 850, 'trend': 'down'},
      {'name': 'Commission Musique KSO', 'points': 720, 'trend': 'stable'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.emoji_events, color: Colors.amber),
            SizedBox(width: 10),
            Text('CLASSEMENT DES CONTRIBUTEURS', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rankings.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = rankings[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: index == 0 ? Colors.amber : (index == 1 ? Colors.grey[300] : (index == 2 ? Colors.orange[200] : Colors.blueGrey[50])),
                  child: Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                ),
                title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${item['points']} pts', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003366))),
                    const SizedBox(width: 8),
                    Icon(
                      item['trend'] == 'up' ? Icons.trending_up : (item['trend'] == 'down' ? Icons.trending_down : Icons.trending_flat),
                      color: item['trend'] == 'up' ? Colors.green : (item['trend'] == 'down' ? Colors.red : Colors.grey),
                      size: 16,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyChallenges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.flag, color: Colors.redAccent),
            SizedBox(width: 10),
            Text('DÉFIS DU MOIS', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.redAccent.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              _challengeItem(
                'Objectif YouTube',
                'Atteindre 5.000 abonnés sur @ecclesiaste.app',
                0.75,
                '3.750 / 5.000',
              ),
              const SizedBox(height: 16),
              _challengeItem(
                'Rayonnement Digital',
                'Générer 10.000 partages de contenus brandés',
                0.45,
                '4.500 / 10.000',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _challengeItem(String title, String subtitle, double progress, String status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Text(status, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.redAccent)),
          ],
        ),
        Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.redAccent),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildLiveFeed() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF003366).withValues(alpha: 0.05), Colors.blue.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF003366).withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          const Icon(Icons.flash_on, size: 40, color: Colors.amber),
          const SizedBox(height: 10),
          const Text(
            'VOTRE IMPACT DIGITAL',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
          ),
          const SizedBox(height: 5),
          Text(
            'En partageant, vous aidez $_entityName à monter dans le classement national.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
          ),
          const SizedBox(height: 15),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ImpactStat(label: 'Vues générées', value: '1.2k'),
              _ImpactStat(label: 'Partages', value: '45'),
              _ImpactStat(label: 'Abonnés KSO+', value: '+12'),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _generateAndShare() async {
    if (_activityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veuillez saisir un titre d\'activité')));
      return;
    }
    await _shareService.shareHierarchyBrandedContent(context, _activityController.text, _entityName, _level, _commission);
  }
}

class _ImpactStat extends StatelessWidget {
  final String label;
  final String value;
  const _ImpactStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}

