import 'package:ecclesiaste/models/church_report.dart';
import 'package:ecclesiaste/models/hierarchy_models.dart';
import 'package:ecclesiaste/services/hive_report_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'dart:io';

void main() {
  group('HiveReportRepository Tests', () {
    late HiveReportRepository repository;

    setUpAll(() {
      final tempDir = Directory.systemTemp.createTempSync();
      Hive.init(tempDir.path);
      
      if (!Hive.isAdapterRegistered(ChurchReportAdapter().typeId)) {
        Hive.registerAdapter(ChurchReportAdapter());
        Hive.registerAdapter(ReportTypeExtAdapter());
        Hive.registerAdapter(EntityLevelAdapter());
        Hive.registerAdapter(ReportStatusAdapter());
      }
    });

    setUp(() {
      repository = HiveReportRepository();
    });

    tearDown(() async {
      await Hive.deleteFromDisk();
    });

    test('Sauvegarder et valider un ChurchReport', () async {
      final report = ChurchReport(
        id: 'rep-1',
        type: ReportTypeExt.serviceDivin,
        niveauEntite: EntityLevel.communaute,
        nomEntite: 'JEREMIE',
        nomChamp: 'TSHIKAPA',
        nomDistrict: 'TSHIKAPA',
        dateRapport: DateTime.now(),
        heureDebut: DateTime.now(),
        rapporteur: 'Conducteur Test',
        rapporteurId: 'USER-01',
        statut: ReportStatus.soumis,
      );

      await repository.saveChurchReport(report);
      
      // Validation
      await repository.validateReport('rep-1', 'VAL-01');
      
      final fetched = await repository.getChurchReportById('rep-1');
      expect(fetched!.statut, ReportStatus.valide);
      expect(fetched.validateur, 'VAL-01');
      expect(fetched.dateValidation, isNotNull);
    });

    test('Gérer les rapports dynamiques (Map)', () async {
      const reportId = 'dyn-123';
      final data = {'presence': 50, 'offrande': 1500};
      
      await repository.saveDynamicReport(
        id: reportId,
        type: 'Rapport Mensuel Ecodim',
        data: data,
        entityId: 'COMM-01',
        rapporteurId: 'USER-01',
      );
      
      final reports = await repository.getDynamicReportsByEntity('COMM-01');
      expect(reports.length, 1);
      expect(reports.first['id'], reportId);
      expect(reports.first['data']['presence'], 50);
    });

    test('Rejeter un rapport avec un motif', () async {
      final report = ChurchReport(
        id: 'rep-reject',
        type: ReportTypeExt.sacristie,
        niveauEntite: EntityLevel.communaute,
        nomEntite: 'TEST',
        nomChamp: '',
        nomDistrict: '',
        dateRapport: DateTime.now(),
        heureDebut: DateTime.now(),
        rapporteur: 'Test',
        statut: ReportStatus.soumis,
      );

      await repository.saveChurchReport(report);
      await repository.rejectReport('rep-reject', 'Données incomplètes');
      
      final fetched = await repository.getChurchReportById('rep-reject');
      expect(fetched!.statut, ReportStatus.rejete);
      expect(fetched.motifRejet, 'Données incomplètes');
    });
  });
}
