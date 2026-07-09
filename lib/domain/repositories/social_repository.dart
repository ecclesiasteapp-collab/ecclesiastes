import '../../domain/entities/social_action.dart';

abstract class SocialRepository {
  Future<List<SocialAction>> getActionsForEntity(String entityId);
  Future<void> saveAction(SocialAction action);
  Future<void> deleteAction(String id);
}
