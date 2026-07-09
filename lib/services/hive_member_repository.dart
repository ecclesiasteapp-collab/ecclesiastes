import '../domain/repositories/member_repository.dart';
import '../models/member_profile.dart';
import 'database_service.dart';

/// Implémentation de [MemberRepository] utilisant Hive.
class HiveMemberRepository implements MemberRepository {
  @override
  Future<List<MemberProfile>> getAllMembers() async {
    final box = await DatabaseService.openBox<MemberProfile>(DatabaseService.membersBoxName);
    return box.values.toList();
  }

  @override
  Future<List<MemberProfile>> getMembersByEntity(String entityId) async {
    final box = await DatabaseService.openBox<MemberProfile>(DatabaseService.membersBoxName);
    return box.values.where((m) => m.communauteId == entityId).toList();
  }

  @override
  Future<MemberProfile?> getMemberById(String id) async {
    final box = await DatabaseService.openBox<MemberProfile>(DatabaseService.membersBoxName);
    return box.get(id);
  }

  @override
  Future<void> addMember(MemberProfile member) async {
    final box = await DatabaseService.openBox<MemberProfile>(DatabaseService.membersBoxName);
    await box.put(member.id, member);
  }

  @override
  Future<void> updateMember(MemberProfile member) async {
    final box = await DatabaseService.openBox<MemberProfile>(DatabaseService.membersBoxName);
    await box.put(member.id, member);
  }

  @override
  Future<void> deleteMember(String id) async {
    final box = await DatabaseService.openBox<MemberProfile>(DatabaseService.membersBoxName);
    await box.delete(id);
  }
}
