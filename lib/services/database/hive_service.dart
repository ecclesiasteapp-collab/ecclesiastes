// lib/services/database/hive_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/district_model.dart';
import '../../models/report_model.dart';
import '../../models/validation_model.dart';
// New ERP Models
import '../../data/models/ecclesiastical_entity_model.dart';
import '../../data/models/person_model.dart';
import '../../data/models/mandate_model.dart';
import '../../data/models/workflow_model.dart';
import '../../data/models/library_document_model.dart';
import '../../data/models/finance_transaction_model.dart';
import '../../data/models/family_model.dart';

class HiveService {
  static Future<void> initialize() async {
    await Hive.initFlutter();

    // Register Legacy Adapters
    Hive.registerAdapter(DistrictModelAdapter());
    Hive.registerAdapter(ReportModelAdapter());
    Hive.registerAdapter(ValidationModelAdapter());

    // Register New ERP Adapters (Phase 1, 2, 3, Finance & Family)
    Hive.registerAdapter(EcclesiasticalEntityModelAdapter());
    Hive.registerAdapter(PersonModelAdapter());
    Hive.registerAdapter(MandateModelAdapter());
    Hive.registerAdapter(WorkflowInstanceModelAdapter());
    Hive.registerAdapter(WorkflowLogModelAdapter());
    Hive.registerAdapter(LibraryDocumentModelAdapter());
    Hive.registerAdapter(FinanceTransactionModelAdapter());
    Hive.registerAdapter(FamilyModelAdapter());

    // Open Boxes
    await Future.wait([
      Hive.openBox<DistrictModel>('districts'),
      Hive.openBox<ReportModel>('reports'),
      Hive.openBox<ValidationModel>('validations'),
    ]);
  }
}

