import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/church_structure.dart';

class DataLoaderService {
  static Future<List<MinistryRank>> loadMinistries() async {
    final String response = await rootBundle.loadString('assets/data/ministries.json');
    final data = json.decode(response);
    return (data['rangs'] as List).map((e) => MinistryRank.fromJson(e)).toList();
  }

  static Future<List<Commission>> loadCommissions() async {
    final String response = await rootBundle.loadString('assets/data/commissions.json');
    final data = json.decode(response);
    return (data['commissions'] as List).map((e) => Commission.fromJson(e)).toList();
  }

  static Future<KsoYouthData> loadKsoYouth() async {
    final String response = await rootBundle.loadString('assets/data/kso_youth.json');
    final data = json.decode(response);
    return KsoYouthData.fromJson(data);
  }
}
