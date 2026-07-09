import 'package:ecclesiaste/models/hierarchy_models.dart';
import 'package:ecclesiaste/models/member_profile.dart';
import 'package:ecclesiaste/services/hive_member_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'dart:io';

void main() {
  group('HiveMemberRepository Tests', () {
    late HiveMemberRepository repository;

    setUpAll(() {
      final tempDir = Directory.systemTemp.createTempSync();
      Hive.init(tempDir.path);
      
      // Enregistrement des adaptateurs
      if (!Hive.isAdapterRegistered(MemberProfileAdapter().typeId)) {
        Hive.registerAdapter(MemberProfileAdapter());
        Hive.registerAdapter(CivilStatusAdapter());
        Hive.registerAdapter(MemberStatusAdapter());
        Hive.registerAdapter(AvailabilityAdapter());
        Hive.registerAdapter(CommissionTypeAdapter());
      }
    });

    setUp(() {
      repository = HiveMemberRepository();
    });

    tearDown(() async {
      await Hive.deleteFromDisk();
    });

    test('Ajouter et récupérer un membre par ID', () async {
      final member = MemberProfile(
        id: 'member-123',
        nom: 'Kabasele',
        postNom: 'Tshisekedi',
        prenom: 'Jean',
        isMale: true,
        dateNaissance: DateTime(1990, 5, 20),
        lieuNaissance: 'Kinshasa',
        nationalite: 'Congolaise',
        etatCivil: CivilStatus.marie,
        adresse: 'Av. de la Paix 1',
        communeQuartier: 'Gombe',
        telephone: '+243810000000',
        egliseTerritorialeId: 'RDC_OUEST',
        districtId: 'DIST-01',
        communauteId: 'COMM-01',
        dateEntreeEglise: DateTime.now(),
        statutMembre: MemberStatus.ancien,
        baptise: true,
        prendSainteCene: true,
        scelle: true,
        disponibilite: Availability.hebdomadaire,
        dateInscription: DateTime.now(),
        inscritParMinistreId: 'MIN-01',
      );

      await repository.addMember(member);
      final fetched = await repository.getMemberById('member-123');

      expect(fetched, isNotNull);
      expect(fetched!.nom, 'Kabasele');
      expect(fetched.fullName, 'Jean Kabasele Tshisekedi');
    });

    test('Filtrer les membres par entité (communauté)', () async {
      final member1 = _createTestMember('m1', 'COMM-A');
      final member2 = _createTestMember('m2', 'COMM-B');

      await repository.addMember(member1);
      await repository.addMember(member2);
      
      final membersA = await repository.getMembersByEntity('COMM-A');
      
      expect(membersA.length, 1);
      expect(membersA.first.id, 'm1');
    });
  });
}

MemberProfile _createTestMember(String id, String commId) {
  return MemberProfile(
    id: id,
    nom: 'Test',
    postNom: '',
    prenom: 'Member',
    isMale: true,
    dateNaissance: DateTime(2000),
    lieuNaissance: '',
    nationalite: '',
    etatCivil: CivilStatus.celibataire,
    adresse: '',
    communeQuartier: '',
    telephone: '',
    egliseTerritorialeId: '',
    districtId: '',
    communauteId: commId,
    dateEntreeEglise: DateTime.now(),
    statutMembre: MemberStatus.nouveau,
    baptise: false,
    prendSainteCene: false,
    scelle: false,
    disponibilite: Availability.occasionnelle,
    dateInscription: DateTime.now(),
    inscritParMinistreId: '',
  );
}
