import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ecclesiastes/models/church_report.dart';

class FieldApostleSummaryScreen extends StatelessWidget {
  const FieldApostleSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        title: const Text('Résumé Apôtre de Champ'),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<ChurchReport>>(
        future: _loadReports(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          final reports = snapshot.data ?? [];
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return Card(
                child: ListTile(
                  title: Text('Rapport ${report.id}'),
                  subtitle: Text('ID: ${report.id}'),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<ChurchReport>> _loadReports() async {
    final box = Hive.box<ChurchReport>('reports_box');
    return box.values.toList();
  }
}

