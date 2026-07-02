import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../models/report_config.dart';
import '../../widgets/header_officiel.dart';
import '../../widgets/kpi_grid.dart';
import '../../widgets/validation_panel.dart';
import '../../widgets/recommendations_panel.dart';
import '../../widgets/library_panel.dart';

class UniversalReportScreen extends StatefulWidget {
  final ReportConfig config;
  final Map<String, dynamic>? initialData;

  const UniversalReportScreen({super.key, required this.config, this.initialData});

  @override
  State<UniversalReportScreen> createState() => _UniversalReportScreenState();
}

class _UniversalReportScreenState extends State<UniversalReportScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isCommunityValidated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(widget.config.title, style: const TextStyle(fontSize: 16)),
        backgroundColor: const Color(0xFF003366),
      ),
      body: FormBuilder(
        key: _formKey,
        initialValue: widget.initialData ?? {},
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            HeaderOfficiel(
              lines: [
                HeaderLine('CHAMP APOSTOLIQUE', 'Kinshasa Sud-Ouest'),
                HeaderLine('DISTRICT', 'District Modèle'),
                HeaderLine('COMMUNAUTÉ', 'Communauté Modèle'),
              ],
              typeRapport: widget.config.title,
              date: DateTime.now(),
            ),
            const SizedBox(height: 16),

            if (widget.config.kpis.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: KPIGrid(configs: widget.config.kpis),
              ),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('📋 SAISIE DES DONNÉES', 
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey[800], fontSize: 13)),
                    const SizedBox(height: 16),
                    ...widget.config.fields.map((f) => _buildField(f)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (widget.config.recommendations.isNotEmpty)
              RecommendationsPanel(items: widget.config.recommendations),
            const SizedBox(height: 16),

            if (widget.config.libraryRefs.isNotEmpty)
              LibraryAccessPanel(refs: widget.config.libraryRefs, onTap: _openLibrary),
            const SizedBox(height: 16),

            if (widget.config.doubleValidation)
              DoubleValidationPanel(
                isCommunityValidated: _isCommunityValidated,
                onValidateCommunity: () {
                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                    setState(() => _isCommunityValidated = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✅ Validé au niveau Communauté'), backgroundColor: Colors.green)
                    );
                  }
                },
                onValidateHierarchical: _submitReport,
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildField(ReportField f) {
    if (f.type == FieldType.header) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Text(
          f.label.toUpperCase(),
          style: const TextStyle(color: Color(0xFF003366), fontWeight: FontWeight.bold, fontSize: 12),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: _getFieldWidget(f),
    );
  }

  Widget _getFieldWidget(ReportField f) {
    switch (f.type) {
      case FieldType.text:
        return FormBuilderTextField(
          name: f.key, 
          decoration: InputDecoration(labelText: f.label, border: const OutlineInputBorder(), suffixText: f.directiveRef), 
          validator: f.required ? FormBuilderValidators.required() : null
        );
      case FieldType.number:
        return FormBuilderTextField(
          name: f.key, 
          decoration: InputDecoration(labelText: f.label, border: const OutlineInputBorder()), 
          keyboardType: TextInputType.number, 
          validator: f.required ? FormBuilderValidators.required() : null
        );
      case FieldType.date:
        return FormBuilderDateTimePicker(
          name: f.key, 
          decoration: InputDecoration(labelText: f.label, border: const OutlineInputBorder()), 
          inputType: InputType.date
        );
      case FieldType.dropdown:
        return FormBuilderDropdown<String>(
          name: f.key, 
          decoration: InputDecoration(labelText: f.label, border: const OutlineInputBorder()), 
          items: f.options!.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(), 
          validator: f.required ? FormBuilderValidators.required() : null
        );
      case FieldType.checkbox:
        return FormBuilderCheckboxGroup<String>(
          name: f.key, 
          decoration: InputDecoration(labelText: f.label), 
          options: f.options!.map((o) => FormBuilderFieldOption(value: o, child: Text(o))).toList()
        );
      case FieldType.textarea:
        return FormBuilderTextField(
          name: f.key, 
          decoration: InputDecoration(labelText: f.label, border: const OutlineInputBorder()), 
          maxLines: f.maxLines, 
          validator: f.required ? FormBuilderValidators.required() : null
        );
      case FieldType.signature:
        return Container(
          height: 100, 
          decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)), 
          child: const Center(child: Text('Signature par Identifiant & Mot de passe'))
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _submitReport() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Rapport transmis'),
            ],
          ),
          content: const Text('Votre rapport a été généré et transmis avec succès à la hiérarchie (District/Champ).'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx); // Fermer le dialog
                if (mounted) Navigator.pop(context); // Quitter l'écran de rapport
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _openLibrary() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text('📚 RÉFÉRENCES DIRECTIVES', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey[900])),
            ),
            ...widget.config.libraryRefs.map((ref) => ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: Text(ref),
              subtitle: const Text('Consultation hors-ligne disponible'),
              onTap: () => Navigator.pop(ctx),
            )),
          ],
        ),
      ),
    );
  }
}

