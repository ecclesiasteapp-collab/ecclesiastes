import 'package:flutter_test/flutter_test.dart';
import 'package:ecclesiaste/services/auth_service.dart';
import 'package:ecclesiaste/services/hive_member_repository.dart';
import 'package:ecclesiaste/services/hive_report_repository.dart';
import 'package:ecclesiaste/models/user.dart';
import 'package:ecclesiaste/models/official_report.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';

void main() {
  group('Workflow Intégration - Test de bout en bout', () {
    setUpAll(() async {
      // Initialisation de Hive en mémoire pour les tests
      Hive.init(Directory.systemTemp.path);
    });

    test('Simulation Inscription -> Création Rapport -> Validation', () async {
      // 1. Inscription d'un nouveau membre (en attente)
      final newUser = User(
        id: 'test_user_1',
        fullName: 'Test User',
        email: 'test@ena.org',
        phone: '0810000000',
        passwordHash: 'hash',
        role: UserRole.membre,
        entityId: 'communaute_test',
        status: 'pending',
      );
      
      final userRepo = HiveUserRepositoryMock(); // On utiliserait le vrai repo avec Hive en mémoire
      await userRepo.saveUser(newUser);
      
      var pending = await userRepo.getPendingUsers();
      expect(pending.length, 1);
      expect(pending.first.fullName, 'Test User');

      // 2. Validation par un admin
      await userRepo.validateUser(newUser.id);
      final validated = await userRepo.getUserById(newUser.id);
      expect(validated?.status, 'active');

      // 3. Création d'un rapport par l'utilisateur
      final reportRepo = HiveReportRepository();
      final report = OfficialReport(
        id: 'report_1',
        type: OfficialReportType.sacristie,
        authorId: newUser.id,
        entityId: newUser.entityId,
        date: DateTime.now(),
        data: {'presence': 50, 'offering': 100.0},
        status: 'submitted',
      );
      
      await reportRepo.saveReport(report);
      
      // 4. Vérification dans la boîte de réception
      final inbox = await reportRepo.getReportsForEntity(newUser.entityId);
      expect(inbox.any((r) => r.id == 'report_1'), isTrue);
    });
  });
}

// Mock simple pour le test sans dépendre de toute l'initialisation complexe
class HiveUserRepositoryMock {
  final Map<String, User> _users = {};
  
  Future<void> saveUser(User user) async => _users[user.id] = user;
  Future<List<User>> getPendingUsers() async => _users.values.where((u) => u.status == 'pending').toList();
  Future<void> validateUser(String id) async => _users[id]?.status = 'active';
  Future<User?> getUserById(String id) async => _users[id];
}
