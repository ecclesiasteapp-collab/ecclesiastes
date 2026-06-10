import 'package:isar/isar.dart';
import '../models/event_proposal.dart';

class ConflictResult {
  final String status; // SAFE, WARNING, BLOCKED
  final String message;
  final DateTime? suggestedDate;
  ConflictResult(this.status, this.message, [this.suggestedDate]);
}

class ConflictDetectionService {
  static late Isar _db;
  static void init(Isar db) => _db = db;

  // Dates liturgiques bloquantes (extrait du PDF Programme)
  static const blockedDates = [
    // 2026
    { 'year': 2026, 'month': 4, 'day': 3 }, // Vendredi Saint
    { 'year': 2026, 'month': 4, 'day': 5 }, // Pâques
    { 'year': 2026, 'month': 5, 'day': 14 }, // Ascension
    { 'year': 2026, 'month': 5, 'day': 24 }, // Pentecôte
    { 'year': 2026, 'month': 12, 'day': 25 }, // Noël
  ];

  static Future<ConflictResult> checkConflict(EventProposal proposal) async {
    // 1. Vérification dates liturgiques
    if (blockedDates.any((d) => _isSameDay(DateTime(d['year']!, d['month']!, d['day']!), proposal.date))) {
      return ConflictResult('BLOCKED', 'Conflit avec un jour liturgique majeur. Proposez une autre date.');
    }

    // 2. Vérification hiérarchie supérieure
    final higherLevels = ['DISTRICT', 'CHAMP', 'TERRITORIAL'];
    final levels = ['COMMUNITY', 'DISTRICT', 'CHAMP', 'TERRITORIAL'];
    final myIndex = levels.indexOf(proposal.level);
    
    if (myIndex < 3 && myIndex != -1) {
      final relevantHigherLevels = higherLevels.sublist(myIndex); 
      // levels are COMMUNITY(0), DISTRICT(1), CHAMP(2), TERRITORIAL(3)
      // if COMMUNITY, higher are DISTRICT, CHAMP, TERRITORIAL
      
      final events = await _db.eventProposals
          .filter()
          .anyOf(relevantHigherLevels, (q, String lv) => q.levelEqualTo(lv))
          .dateEqualTo(proposal.date)
          .findAll();
      
      if (events.isNotEmpty) {
        return ConflictResult('WARNING', 'Événement de niveau supérieur détecté. Demande de dérogation recommandée.');
      }
    }

    // 3. Vérification même niveau (chevauchement)
    final sameLevel = await _db.eventProposals
        .filter()
        .levelEqualTo(proposal.level)
        .dateEqualTo(proposal.date)
        .not()
        .idEqualTo(proposal.id)
        .findAll();

    if (sameLevel.isNotEmpty) {
      final nextWeek = proposal.date.add(const Duration(days: 7));
      return ConflictResult('WARNING', 'Chevauchement détecté. Suggestion: ${nextWeek.day}/${nextWeek.month}/${nextWeek.year}', nextWeek);
    }

    return ConflictResult('SAFE', 'Aucun conflit détecté.');
  }

  static bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
}
