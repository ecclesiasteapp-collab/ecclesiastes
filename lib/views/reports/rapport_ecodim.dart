import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../widgets/header_officiel.dart';

class ReportEcodimPage extends StatelessWidget {
  const ReportEcodimPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0d1b3e),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0d1b3e),
        elevation: 0,
        title: const Text('Rapport École du Dimanche'),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec logo
              HeaderOfficiel(
                lines: [
                  HeaderLine('CHAMP APOSTOLIQUE', 'KSO'),
                  HeaderLine('DISTRICT', 'Tshikapa'),
                  HeaderLine('COMMUNAUTÉ', 'Jérémie'),
                ],
                typeRapport: 'Rapport Mensuel ECODIM',
                date: DateTime.now(),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 20),

              // Sections Présence et Résolutions
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildPresenceCard(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: _buildResolutionsCard(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Graphique de progression
              _buildSectionTitle('Progression mensuelle des engagements'),
              const SizedBox(height: 16),
              _buildProgressChart(),
              const SizedBox(height: 24),

              // Activités du mois
              _buildSectionTitle('Activités du mois'),
              const SizedBox(height: 16),
              _buildActivitiesCarousel(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPresenceCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Présence', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0d1b3e))),
          const SizedBox(height: 12),
          _buildPresenceRow('Enfants:', '42'),
          const SizedBox(height: 8),
          _buildPresenceRow('Moniteurs:', '8'),
        ],
      ),
    );
  }

  Widget _buildPresenceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.black87)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0d1b3e))),
      ],
    );
  }

  Widget _buildResolutionsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Résolutions 'Moi aussi je veux...'", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0d1b3e))),
          const SizedBox(height: 12),
          _buildResolutionItem('Moi aussi je veux servir au culte'),
          const SizedBox(height: 8),
          _buildResolutionItem('Moi aussi je veux apprendre la Bible'),
          const SizedBox(height: 8),
          _buildResolutionItem('Moi aussi je veux aider les nouveaux'),
        ],
      ),
    );
  }

  Widget _buildResolutionItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 16),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.black87))),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0d1b3e)));
  }

  Widget _buildProgressChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.only(top: 20, right: 20),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const titles = ['S1', 'S2', 'S3', 'S4'];
                  if (value.toInt() >= 0 && value.toInt() < titles.length) {
                    return Text(titles[value.toInt()], style: const TextStyle(fontSize: 10));
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [FlSpot(0, 10), FlSpot(1, 45), FlSpot(2, 75), FlSpot(3, 95)],
              isCurved: true,
              color: const Color(0xFF003366),
              barWidth: 3,
              belowBarData: BarAreaData(show: true, color: const Color(0xFF003366).withValues(alpha: 0.1)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitiesCarousel() {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildActivityCard('Atelier Bible', '05/03', Icons.edit_note),
          const SizedBox(width: 12),
          _buildActivityCard('Visite familles', '12/03', Icons.assignment),
          const SizedBox(width: 12),
          _buildActivityCard('Célébration', '28/03', Icons.church),
        ],
      ),
    );
  }

  Widget _buildActivityCard(String title, String date, IconData icon) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF003366), size: 24),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          Text(date, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }
}

