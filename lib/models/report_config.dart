import 'package:flutter/material.dart';

enum FieldType { text, number, date, dropdown, checkbox, textarea, signature, header }

class ReportField {
  final String key;
  final String label;
  final FieldType type;
  final bool required;
  final List<String>? options;
  final int? maxLines;
  final String? directiveRef;

  const ReportField({
    required this.key,
    required this.label,
    required this.type,
    this.required = false,
    this.options,
    this.maxLines = 1,
    this.directiveRef,
  });
}

class KPIConfig {
  final String label;
  final double target;
  final String unit;
  final String? directiveRef;

  const KPIConfig({
    required this.label, 
    required this.target, 
    required this.unit, 
    this.directiveRef
  });
}

class ReportConfig {
  final String id;
  final String title;
  final IconData icon;
  final List<KPIConfig> kpis;
  final List<ReportField> fields;
  final List<String> recommendations;
  final List<String> libraryRefs;
  final bool doubleValidation;

  const ReportConfig({
    required this.id,
    required this.title,
    required this.icon,
    required this.kpis,
    required this.fields,
    required this.recommendations,
    required this.libraryRefs,
    this.doubleValidation = true,
  });
}

