import 'package:isar/isar.dart';

part 'event_proposal.g.dart';

@collection
class EventProposal {
  Id id = Isar.autoIncrement;
  @Index() late String title;
  @Index() late DateTime date;
  @Index() late String level; // COMMUNITY, DISTRICT, CHAMP, TERRITORIAL
  @Index() late String proposedBy;
  String? conflictStatus; // SAFE, WARNING, BLOCKED
  String? suggestedDate;
}
