import 'package:hive/hive.dart';
import '../models/modification_request.dart';

class ModificationRequestService {
  static final ModificationRequestService _instance = ModificationRequestService._internal();
  factory ModificationRequestService() => _instance;
  ModificationRequestService._internal();

  static const String _boxName = 'modification_requests';

  Future<Box<ModificationRequest>> get _box async => Hive.openBox<ModificationRequest>(_boxName);

  Future<void> createRequest(ModificationRequest request) async {
    final box = await _box;
    await box.put(request.id, request);
  }

  Future<List<ModificationRequest>> getRequests() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<void> approveRequest(String id) async {
    final box = await _box;
    final request = box.get(id);
    if (request != null) {
      final updated = ModificationRequest(
        id: request.id,
        ministerId: request.ministerId,
        ministerName: request.ministerName,
        resourceType: request.resourceType,
        resourceId: request.resourceId,
        request: request.request,
        status: ModificationStatus.approved,
        createdAt: request.createdAt,
      );
      await box.put(id, updated);
    }
  }

  Future<void> rejectRequest(String id) async {
    final box = await _box;
    final request = box.get(id);
    if (request != null) {
      final updated = ModificationRequest(
        id: request.id,
        ministerId: request.ministerId,
        ministerName: request.ministerName,
        resourceType: request.resourceType,
        resourceId: request.resourceId,
        request: request.request,
        status: ModificationStatus.rejected,
        createdAt: request.createdAt,
      );
      await box.put(id, updated);
    }
  }
}

