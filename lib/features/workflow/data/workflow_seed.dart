import '../domain/models/workflow_models.dart';
import '../../../../models/hierarchy_models.dart';
import '../domain/repositories/workflow_repository.dart';

class WorkflowSeed {
  static Future<void> seed(WorkflowRepository repository) async {
    final existing = await repository.getAllDefinitions();
    if (existing.isNotEmpty) return;

    final memberCreation = WorkflowDefinition(
      id: 'member_creation',
      name: 'Inscription Nouveau Membre',
      description: 'Processus de validation pour l\'inscription d\'un nouveau membre fidèle.',
      targetEntityType: 'member',
      steps: [
        WorkflowStepDefinition(
          order: 0,
          label: 'Validation Communautaire',
          allowedRoles: [UserRole.berger, UserRole.lead],
          requiresSignature: true,
        ),
        WorkflowStepDefinition(
          order: 1,
          label: 'Validation District',
          allowedRoles: [UserRole.ancien, UserRole.apotreDistrict],
          requiresSignature: true,
          isFinal: true,
        ),
      ],
    );

    final expenseApproval = WorkflowDefinition(
      id: 'expense_approval',
      name: 'Approbation de Dépense',
      description: 'Validation des dépenses et sorties de fonds.',
      targetEntityType: 'finance',
      steps: [
        WorkflowStepDefinition(
          order: 0,
          label: 'Validation Trésorerie',
          allowedRoles: [UserRole.respCommission],
          requiresSignature: false,
        ),
        WorkflowStepDefinition(
          order: 1,
          label: 'Approbation Responsable',
          allowedRoles: [UserRole.berger, UserRole.ancien],
          requiresSignature: true,
          isFinal: true,
        ),
      ],
    );

    await repository.saveDefinition(memberCreation);
    await repository.saveDefinition(expenseApproval);
  }
}
