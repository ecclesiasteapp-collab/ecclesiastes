import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:ecclesiastes/core/services/validation_service.dart';
import 'package:ecclesiastes/core/services/validation_repository.dart';
import 'package:ecclesiastes/core/models/validation_task.dart';

@GenerateMocks([ValidationRepository])
import 'validation_service_test.mocks.dart';

void main() {
  group('ValidationService - Double Subordination', () {
    late ValidationService service;
    late MockValidationRepository mockRepo;

    setUp(() {
      mockRepo = MockValidationRepository();
      service = ValidationService(repository: mockRepo);
    });

    test('Soumission initiale doit créer une tâche avec statut "submitted"', () async {
      final task = await service.submitReport(
        reportId: 'report_123',
        commissionId: 'comm_ecodim_limete',
        submitterId: 'user_456',
      );

      expect(task.status, ValidationStatus.submitted);
      verify(mockRepo.save(task)).called(1);
    });

    test('Validation communauté réussie doit mettre à jour le statut', () async {
      final task = ValidationTask(
        entityType: 'REPORT',
        entityId: 'report_123',
        status: ValidationStatus.submitted,
      );
      when(mockRepo.getById(any)).thenAnswer((_) async => task);

      await service.validateCommunity(task.id, 'resp_comm_789');

      expect(task.status, ValidationStatus.communityValidated);
      expect(task.communityValidatorId, 'resp_comm_789');
      verify(mockRepo.save(task)).called(1);
    });
  });
}
