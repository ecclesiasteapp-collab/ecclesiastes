import '../entities/erp_statistics.dart';
import '../repositories/organization_repository.dart';
import '../repositories/workflow_repository.dart';
import '../entities/mandate.dart';

class GetERPStatistics {
  final OrganizationRepository orgRepo;
  final WorkflowRepository workflowRepo;

  GetERPStatistics(this.orgRepo, this.workflowRepo);

  Future<ERPStatistics> execute(String entityId) async {
    // 1. Récupérer les mandats pour compter membres et ministres
    final mandates = await orgRepo.getMandatesForEntity(entityId);
    
    // Un ministre est quelqu'un ayant un mandat de type "ordination" ou "mission"
    final ministersCount = mandates.where((m) => 
      m.type == MandateType.ordination || m.type == MandateType.mission
    ).length;

    // Les membres sont toutes les personnes liées à l'entité (simplification)
    final persons = await orgRepo.getPersonsForEntity(entityId);

    // 2. Récupérer les workflows en attente (Rapports soumis)
    final workflows = await workflowRepo.getInstancesForEntity(entityId);
    final pendingCount = workflows.where((w) => w.status.index == 1).length; // 1 = submitted

    return ERPStatistics(
      totalMembers: persons.length,
      totalMinisters: ministersCount,
      pendingReports: pendingCount,
      financialTrend: 0.0, // Sera calculé par un autre use case pour les graphiques
    );
  }
}
