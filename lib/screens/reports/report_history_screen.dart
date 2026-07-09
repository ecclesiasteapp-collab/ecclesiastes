import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../../services/pdf_official_generator.dart';
import '../../models/territory_config.dart';

class ReportHistoryScreen extends StatelessWidget {
  const ReportHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des Rapports'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('reports').listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('Aucun rapport enregistré.'));
          }

          final reports = box.values.toList().reversed.toList();

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index] as Map;
              final date = report['date'] as DateTime;
              final type = report['type'] as String;
              final community = report['communaute'] as String;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: Text('$type - $community'),
                  subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(date)),
                  trailing: IconButton(
                    icon: const Icon(Icons.print),
                    onPressed: () async {
                      final pdf = await PdfOfficialGenerator.generateServiceDivin(
                        config: TerritoryConfig(
                          id: 'default',
                          officialName: 'Église Néo-Apostolique',
                          shortName: 'ENA',
                          logoAssetPath: 'assets/logos/logo_ena.png',
                          defaultCurrency: 'CDF',
                          primaryLanguage: 'FR',
                        ),
                        data: Map<String, dynamic>.from(report['data']),
                      );
                      await Printing.layoutPdf(onLayout: (format) => pdf.save());
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
