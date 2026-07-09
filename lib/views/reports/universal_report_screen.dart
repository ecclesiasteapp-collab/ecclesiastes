import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../services/auth_service.dart';
import '../../services/repository_providers.dart';
import '../../models/report_config.dart';
import '../../models/hierarchy_models.dart';
import '../../widgets/header_officiel.dart';
import '../../widgets/kpi_grid.dart';
import '../../widgets/validation_panel.dart';
import '../../widgets/recommendations_panel.dart';
import '../../widgets/library_panel.dart';

class UniversalReportScreen extends ConsumerStatefulWidget {
  final ReportConfig config;
  final Map<String, dynamic>? initialData;

  const UniversalReportScreen({super.key, required this.config, this.initialData});

  @override
  ConsumerState<UniversalReportScreen> createState() => _UniversalReportScreenState();
}

class _UniversalReportScreenState extends ConsumerState<UniversalReportScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isCommunityValidated = false;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final Map<String, dynamic> initialValues = widget.initialData ?? {};
    
    // Auto-remplissage du rapporteur si le champ existe et est vide
    if (user != null && initialValues['officiant'] == null) {
      initialValues['officiant'] = user.fullName;
    }
    if (user != null && initialValues['tenuePar'] == null) {
      initialValues['tenuePar'] = user.fullName;
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(widget.config.title, style: const TextStyle(fontSize: 16)),
        backgroundColor: const Color(0xFF003366),
        actions: [
          IconButton(
            icon: const Icon(Icons.visibility_outlined),
            tooltip: 'Aperçu Officiel',
            onPressed: _showOfficialPreview,
          ),
        ],
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
    final user = AuthService.currentUser;
    final isCommissionUser = user?.commissionType != CommissionType.none && user?.entityRole != 'responsable';

    // Restriction : Les commissions ne peuvent pas modifier les données d'entité (Sacristie, SD)
    // Elles ne voient que leurs champs spécifiques
    if (isCommissionUser && (widget.config.id == 'sacristie' || widget.config.id == 'service_divin')) {
      return const SizedBox.shrink();
    }

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

  void _showOfficialPreview() {
    _formKey.currentState?.save();
    final data = Map<String, dynamic>.from(_formKey.currentState?.value ?? {});
    
    // Ajout de l'entiteId pour la résolution de la hiérarchie dans l'aperçu
    data['entiteId'] = AuthService.currentEntiteId;

    String route = '';
    if (widget.config.id == 'sacristie') {
      route = '/reports/official/sacristie';
    } else if (widget.config.id == 'service_divin') {
      route = '/reports/official/sd';
    } else if (widget.config.id == 'presence_reunion') {
      route = '/reports/official/presence';
    } else if (widget.config.id == 'communique') {
      route = '/reports/official/communique';
    } else {
      route = '/reports/official/generic';
      data['official_title'] = widget.config.title;
    }

    if (route.isNotEmpty) {
      context.push(route, extra: data);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aperçu non disponible pour ce type de rapport')),
      );
    }
  }

  void _submitReport() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() => _isSaving = true);
      
      try {
        final data = Map<String, dynamic>.from(_formKey.currentState!.value);
        final user = AuthService.currentUser;
        final repo = ref.read(reportRepositoryProvider);

        await repo.saveDynamicReport(
          id: const Uuid().v4(),
          type: widget.config.id,
          data: data,
          entityId: AuthService.currentEntiteId,
          rapporteurId: user?.id ?? 'ANONYMOUS',
          status: widget.config.doubleValidation ? 'valide_communaute' : 'soumis',
        );

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
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'envoi : $e'), backgroundColor: Colors.red),
        );
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
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

