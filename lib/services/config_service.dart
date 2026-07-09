import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../models/app_config_model.dart';

class ConfigService {
  static final ConfigService _instance = ConfigService._internal();
  factory ConfigService() => _instance;
  ConfigService._internal();

  static const String _boxName = 'app_metadata_config';
  
  late Box _configBox;

  Future<void> init() async {
    _configBox = await Hive.openBox(_boxName);
    
    // Si la box est vide, on charge la config par défaut du JSON
    if (_configBox.isEmpty) {
      await loadDefaultConfig();
    }
  }

  Future<void> loadDefaultConfig() async {
    try {
      final String response = await rootBundle.loadString('assets/config/hierarchy_config.json');
      final data = json.decode(response);

      final List<HierarchyLevelConfig> levels = (data['levels'] as List)
          .map((l) => HierarchyLevelConfig.fromJson(l))
          .toList();

      final List<OrganisationTypeConfig> orgTypes = (data['organisation_types'] as List)
          .map((o) => OrganisationTypeConfig.fromJson(o))
          .toList();

      final List<MinistryConfig> ministries = (data['ministries'] as List)
          .map((m) => MinistryConfig.fromJson(m))
          .toList();

      await _configBox.put('levels', levels);
      await _configBox.put('organisation_types', orgTypes);
      await _configBox.put('ministries', ministries);
      await _configBox.put('version', data['version']);
      
    } catch (e) {
      print('Erreur chargement config: $e');
    }
  }

  List<HierarchyLevelConfig> get levels => 
      List<HierarchyLevelConfig>.from(_configBox.get('levels', defaultValue: []));

  List<OrganisationTypeConfig> get organisationTypes => 
      List<OrganisationTypeConfig>.from(_configBox.get('organisation_types', defaultValue: []));

  List<MinistryConfig> get ministries => 
      List<MinistryConfig>.from(_configBox.get('ministries', defaultValue: []));

  String get version => _configBox.get('version', defaultValue: '0.0.0');
}
