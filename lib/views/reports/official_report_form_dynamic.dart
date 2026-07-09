import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/official_report.dart';
import '../../core/theme.dart';
import '../../services/auth_service.dart';
import '../../services/repository_providers.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../services/pdf_report_service.dart';

class OfficialReportFormDynamic extends ConsumerStatefulWidget {
  final OfficialReportType reportType;

  const OfficialReportFormDynamic({super.key, required this.reportType});

  @override
  ConsumerState<OfficialReportFormDynamic> createState() => _OfficialReportFormDynamicState();
}

class _OfficialReportFormDynamicState extends ConsumerState<OfficialReportFormDynamic> {
  late OfficialReportTemplate _template;
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _template = OfficialReportTemplates.all.firstWhere((t) => t.type == widget.reportType);
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isSaving = true);

    try {
      final user = AuthService.currentUser;
      final repo = ref.read(reportRepositoryProvider);
      final reportId = const Uuid().v4();

      await repo.saveDynamicReport(
        id: reportId,
        type: _template.titre,
        data: _formData,
        entityId: user?.entityId ?? 'COMM_01',
        rapporteurId: user?.id ?? 'ANONYMOUS',
        status: 'soumis',
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rapport soumis avec succès pour validation'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_template.titre),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _template.sections.length + 1,
                itemBuilder: (context, index) {
                  if (index == _template.sections.length) {
                    return _buildSubmitButton();
                  }
                  return _buildSection(_template.sections[index]);
                },
              ),
            ),
    );
  }

  Widget _buildSection(ReportSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            section.titre,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primary),
          ),
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: section.fields.map((field) => _buildField(field)).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildField(ReportField field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: field.label,
          border: const OutlineInputBorder(),
          hintText: field.obligatoire ? '(Obligatoire)' : null,
        ),
        keyboardType: field.type == FieldType.nombre ? TextInputType.number : TextInputType.text,
        maxLines: field.type == FieldType.texteLong ? 4 : 1,
        validator: (value) {
          if (field.obligatoire && (value == null || value.isEmpty)) {
            return 'Ce champ est requis';
          }
          return null;
        },
        onSaved: (value) => _formData[field.id] = value,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              if (!_formKey.currentState!.validate()) return;
              _formKey.currentState!.save();
              PdfReportService.instance.printReport(
                _template,
                _formData,
                entityName: AuthService.currentUser?.entityId,
                rapporteurName: AuthService.currentUser?.fullName,
              );
            },
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('APERÇU PDF / IMPRIMER'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade800,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitReport,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('SOUMETTRE LE RAPPORT OFFICIEL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
