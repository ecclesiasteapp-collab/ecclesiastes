import 'package:flutter/material.dart';

import 'package:ecclesiastes/models/report_config.dart';
import 'package:ecclesiastes/core/theme.dart';
import 'package:ecclesiastes/widgets/header_officiel.dart';
import 'package:ecclesiastes/services/auth_service.dart';
import 'package:ecclesiastes/services/database_helper.dart';

class UniversalMonthlyReportScreen extends StatefulWidget {
  final ReportConfig reportConfig;
  final Map<String, dynamic> reportData;

  const UniversalMonthlyReportScreen({
    super.key,
    required this.reportConfig,
    required this.reportData,
  });

  @override
  State<UniversalMonthlyReportScreen> createState() => _UniversalMonthlyReportScreenState();
}

class _UniversalMonthlyReportScreenState extends State<UniversalMonthlyReportScreen> {
  String champName = 'Chargement...';
  String districtName = 'Chargement...';
  String communauteName = 'Chargement...';
  bool _isLoadingHierarchy = true;

  @override
  void initState() {
    super.initState();
    _loadHierarchyNames();
  }

  Future<void> _loadHierarchyNames() async {
    final user = AuthService.currentUser;
    if (user == null || user.entityId == null) {
      setState(() {
        champName = 'Non défini';
        districtName = 'Non défini';
        communauteName = 'Non défini';
        _isLoadingHierarchy = false;
      });
      return;
    }

    try {
      final db = DatabaseHelper.instance;
      final chain = await db.getChaineAncestres(user.entityId!);
      
      String? cName, dName, chName;

      for (var entite in chain) {
        final type = entite['type'];
        if (type == 'COMMUNAUTE') cName = entite['nom'];
        if (type == 'DISTRICT') dName = entite['nom'];
        if (type == 'CHAMP_APOSTOLIQUE') chName = entite['nom'];
      }

      if (mounted) {
        setState(() {
          communauteName = cName ?? 'N/A';
          districtName = dName ?? 'N/A';
          champName = chName ?? 'N/A';
          _isLoadingHierarchy = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          champName = 'Erreur';
          districtName = 'Erreur';
          communauteName = 'Erreur';
          _isLoadingHierarchy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 900),
            margin: EdgeInsets.all(isMobile ? 8 : 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: _isLoadingHierarchy 
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderOfficiel.standard(
                        champ: champName, 
                        district: districtName, 
                        communaute: communauteName, 
                        typeRapport: widget.reportConfig.title.toUpperCase(),
                        date: DateTime.now(),
                        codeRapport: widget.reportConfig.id.toUpperCase(),
                      ),
                      const SizedBox(height: 24),
                      _buildInfoSection(context),
                      const SizedBox(height: 32),
                      _buildProgressionChart(),
                      const SizedBox(height: 32),
                      _buildActivitiesSection(),
                    ],
                  ),
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Présence',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.primary),
                ),
                const SizedBox(height: 12),
                ...widget.reportConfig.fields
                    .where((field) => field.key.contains('presence') || field.key.contains('effectif'))
                    .map((field) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            '${field.label}: ${widget.reportData[field.key] ?? 'N/A'}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black87),
                          ),
                        )),
                const SizedBox(height: 12),
                const Divider(color: Colors.grey),
                const SizedBox(height: 8),
                if (widget.reportConfig.kpis.any((kpi) => kpi.label.contains('Taux présence Responsable')))
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: 18, color: AppTheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Taux présence Responsable:',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.primary),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${widget.reportData['taux_presence_responsable'] ?? '0'}%',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Résolutions',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.primary),
              ),
              const SizedBox(height: 12),
              ...(widget.reportData['resolutions'] as String? ?? '')
                  .split('\n')
                  .where((s) => s.trim().isNotEmpty)
                  .map((resolution) => _buildResolutionItem(context, resolution))
                  ,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResolutionItem(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle_outline, size: 20, color: AppTheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressionChart() {
    final List<double> data = (widget.reportData['progression_data'] as List<dynamic>?)?.map((e) => e as double).toList() ?? [];
    final List<String> labels = (widget.reportData['progression_labels'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progression mensuelle des engagements',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.primary),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: CustomPaint(
            size: const Size(double.infinity, 200),
            painter: ProgressionChartPainter(data: data),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 40, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: labels.map((label) => Text(label, style: Theme.of(context).textTheme.labelSmall)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildActivitiesSection() {
    final List<Map<String, String>> activities = (
        widget.reportData['activities'] as List<dynamic>?
    )?.map((e) => Map<String, String>.from(e as Map)).toList() ?? [
      {'icon': 'edit_note', 'title': 'Atelier Bible jeunesse', 'date': '05/03'},
      {'icon': 'description', 'title': 'Visite aux familles', 'date': '12/03'},
      {'icon': 'church', 'title': 'Célébration de Pâques', 'date': '28/03'},
      {'icon': 'school', 'title': 'Formation moniteurs', 'date': '31/03'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activités du mois',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.primary),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            IconButton(icon: Icon(Icons.chevron_left, color: AppTheme.primary), onPressed: () {}),
            Expanded(
              child: SizedBox(
                height: 130,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: activities.map((activity) => _buildActivityCard(
                    icon: _getIconData(activity['icon']!),
                    title: activity['title']!,
                    date: activity['date']!,
                  )).toList(),
                ),
              ),
            ),
            IconButton(icon: Icon(Icons.chevron_right, color: AppTheme.primary), onPressed: () {}),
          ],
        ),
      ],
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'edit_note': return Icons.edit_note;
      case 'description': return Icons.description;
      case 'church': return Icons.church;
      case 'school': return Icons.school;
      default: return Icons.help_outline;
    }
  }

  Widget _buildActivityCard({required IconData icon, required String title, required String date}) {
    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: AppTheme.primary),
          const SizedBox(height: 10),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
          const SizedBox(height: 4),
          Text('— $date', style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }
}

class ProgressionChartPainter extends CustomPainter {
  final List<double> data;
  ProgressionChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final leftPadding = 40.0;
    final bottomPadding = 10.0;
    final topPadding = 10.0;
    final chartWidth = size.width - leftPadding;
    final chartHeight = size.height - bottomPadding - topPadding;

    final yLabels = ['100%', '80%', '60%', '40%', '20%', '0'];
    for (int i = 0; i < yLabels.length; i++) {
      final y = topPadding + (i / (yLabels.length - 1)) * chartHeight;
      canvas.drawLine(Offset(leftPadding, y), Offset(size.width, y), Paint()..color = Colors.grey.shade300..strokeWidth = 0.5);
      TextPainter(text: TextSpan(text: yLabels[i], style: const TextStyle(fontSize: 11, color: Colors.black54)), textDirection: TextDirection.ltr)..layout(maxWidth: 35)..paint(canvas, Offset(0, y - 6));
    }

    canvas.drawLine(Offset(leftPadding, size.height - bottomPadding), Offset(size.width, size.height - bottomPadding), Paint()..color = Colors.grey.shade400..strokeWidth = 1);

    if (data.isEmpty) return;

    final dataPaint = Paint()..color = AppTheme.accent..strokeWidth = 3..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final path = Path();
    for (int i = 0; i < data.length; i++) {
      final x = leftPadding + (i / (data.length - 1)) * chartWidth;
      final y = topPadding + (1 - data[i]) * chartHeight;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 4, Paint()..color = AppTheme.accent);
    }
    canvas.drawPath(path, dataPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

