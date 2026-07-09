import 'package:flutter_riverpod/flutter_riverpod.dart' hide Family;
import '../domain/entities/mandate.dart';
import '../domain/entities/ecclesiastical_entity.dart';
import '../domain/services/hub_service.dart';
import '../domain/usecases/get_library_documents.dart';
import '../domain/usecases/get_full_user_profile.dart';
import '../domain/usecases/submit_report_workflow.dart';
import '../domain/usecases/upload_library_document.dart';
import '../domain/usecases/sign_workflow_step.dart';
import '../domain/usecases/get_erp_statistics.dart';
import '../domain/usecases/get_chart_statistics.dart';
import '../domain/usecases/record_financial_offering.dart';
import '../domain/usecases/create_family.dart';
import '../domain/usecases/export_consolidated_report_pdf.dart';
import '../domain/usecases/consolidate_finance.dart';
import '../data/repositories/hive_organization_repository.dart';
import '../data/repositories/hive_library_repository.dart';
import '../data/repositories/hive_workflow_repository.dart';
import '../data/repositories/hive_finance_repository.dart';
import '../services/auth_service.dart';
import '../domain/entities/user_profile.dart';
import '../domain/entities/erp_statistics.dart';
import '../domain/entities/family.dart';
import '../domain/entities/chart_data_point.dart';
import 'scope_provider.dart';

// Repositories
final organizationRepositoryProvider = Provider((ref) => HiveOrganizationRepository());
final libraryRepositoryProvider = Provider((ref) => HiveLibraryRepository());
final workflowRepositoryProvider = Provider((ref) => HiveWorkflowRepository());
final financeRepositoryProvider = Provider((ref) => HiveFinanceRepository());

// Services
final hubServiceProvider = Provider((ref) => HubService());

// Use Cases
final getLibraryDocumentsProvider = Provider((ref) {
  final repo = ref.watch(libraryRepositoryProvider);
  return GetLibraryDocuments(repo);
});

final getFullUserProfileProvider = Provider((ref) {
  final repo = ref.watch(organizationRepositoryProvider);
  return GetFullUserProfile(repo);
});

final submitReportWorkflowProvider = Provider((ref) {
  final repo = ref.watch(workflowRepositoryProvider);
  return SubmitReportWorkflow(repo);
});

final uploadLibraryDocumentProvider = Provider((ref) {
  final repo = ref.watch(libraryRepositoryProvider);
  return UploadLibraryDocument(repo);
});

final signWorkflowStepProvider = Provider((ref) {
  final repo = ref.watch(workflowRepositoryProvider);
  return SignWorkflowStep(repo);
});

final getERPStatisticsProvider = Provider((ref) {
  final org = ref.watch(organizationRepositoryProvider);
  final wf = ref.watch(workflowRepositoryProvider);
  return GetERPStatistics(org, wf);
});

final getChartStatisticsProvider = Provider((ref) {
  final org = ref.watch(organizationRepositoryProvider);
  final finance = ref.watch(financeRepositoryProvider);
  final consolidate = ref.watch(consolidateFinanceProvider);
  return GetChartStatistics(org, finance, consolidate);
});

final recordFinancialOfferingProvider = Provider((ref) {
  final finance = ref.watch(financeRepositoryProvider);
  final workflow = ref.watch(submitReportWorkflowProvider);
  return RecordFinancialOffering(finance, workflow);
});

final createFamilyProvider = Provider((ref) {
  final repo = ref.watch(organizationRepositoryProvider);
  return CreateFamily(repo);
});

final consolidateFinanceProvider = Provider((ref) {
  final finance = ref.watch(financeRepositoryProvider);
  final org = ref.watch(organizationRepositoryProvider);
  return ConsolidateFinance(finance, org);
});

final exportConsolidatedReportPdfProvider = Provider((ref) => ExportConsolidatedReportPdf());

// List Families Provider
final familiesProvider = FutureProvider<List<Family>>((ref) async {
  final repo = ref.watch(organizationRepositoryProvider);
  final entityId = ref.watch(activeEntityIdProvider);
  return repo.getFamiliesForEntity(entityId);
});

// Chart Data Providers
final membershipGrowthProvider = FutureProvider<List<ChartDataPoint>>((ref) async {
  final useCase = ref.watch(getChartStatisticsProvider);
  final entityId = ref.watch(activeEntityIdProvider);
  return useCase.getMembershipGrowth(entityId);
});

final financialTrendProvider = FutureProvider<List<ChartDataPoint>>((ref) async {
  final useCase = ref.watch(getChartStatisticsProvider);
  final entityId = ref.watch(activeEntityIdProvider);
  return useCase.getFinancialTrend(entityId);
});

// Profile State Provider
final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  final useCase = ref.watch(getFullUserProfileProvider);
  final userId = AuthService.currentUserId;
  if (userId.isEmpty) throw Exception('User not logged in');
  return useCase.execute(userId);
});

// Statistics Provider
final erpStatisticsProvider = FutureProvider<ERPStatistics>((ref) async {
  final useCase = ref.watch(getERPStatisticsProvider);
  final entityId = ref.watch(activeEntityIdProvider);
  return useCase.execute(entityId);
});

// Mock Session Provider (En attendant le vrai Auth pour les mandats)
final activeMandatesProvider = Provider<List<Mandate>>((ref) {
  final profile = ref.watch(userProfileProvider).value;
  return profile?.activeMandates ?? [];
});

final userMaxLevelProvider = Provider<EntityLevel>((ref) {
  final profile = ref.watch(userProfileProvider).value;
  return profile?.primaryEntity?.level ?? EntityLevel.communaute;
});
