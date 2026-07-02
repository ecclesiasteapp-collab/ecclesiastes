// lib/services/database/hive_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/district_model.dart';
import '../../models/report_model.dart';
import '../../models/validation_model.dart';

class HiveService {
  static Future<void> initialize() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(DistrictModelAdapter());
    Hive.registerAdapter(ReportModelAdapter());
    Hive.registerAdapter(ValidationModelAdapter());
    // Open Boxes
    await Future.wait([
      Hive.openBox<DistrictModel>('districts'),
      Hive.openBox<ReportModel>('reports'),
      Hive.openBox<ValidationModel>('validations'),
    ]);
  }
}

