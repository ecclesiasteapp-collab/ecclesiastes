import 'package:hive_flutter/hive_flutter.dart';
import '../models/person_model.dart';
import '../models/sacrament_model.dart';
import '../models/ordination_model.dart';
import '../models/nomination_model.dart';
import '../models/user.dart';
import '../models/member_profile.dart';

class PersonService {
  static final PersonService instance = PersonService._internal();
  factory PersonService() => instance;
  PersonService._internal();

  static const String _personBox = 'persons';
  static const String _sacramentBox = 'sacraments';
  static const String _ordinationBox = 'ordinations';
  static const String _nominationBox = 'nominations';

  /// Initialise les boîtes Hive pour le Dossier Unique
  Future<void> initialize() async {
    await Hive.openBox<Person>(_personBox);
    await Hive.openBox<Sacrament>(_sacramentBox);
    await Hive.openBox<Ordination>(_ordinationBox);
    await Hive.openBox<Nomination>(_nominationBox);
  }

  /// Récupère une personne par son ID
  Person? getPerson(String id) {
    return Hive.box<Person>(_personBox).get(id);
  }

  /// Récupère le dossier complet d'une personne
  Future<Map<String, dynamic>> getFullDossier(String personId) async {
    final person = getPerson(personId);
    if (person == null) return {};

    final sacraments = Hive.box<Sacrament>(_sacramentBox)
        .values
        .where((s) => s.personId == personId)
        .toList();

    final ordinations = Hive.box<Ordination>(_ordinationBox)
        .values
        .where((o) => o.personId == personId)
        .toList();

    final nominations = Hive.box<Nomination>(_nominationBox)
        .values
        .where((n) => n.personId == personId)
        .toList();

    return {
      'person': person,
      'sacraments': sacraments,
      'ordinations': ordinations,
      'nominations': nominations,
    };
  }

  /// Crée une Personne à partir d'un profil membre existant (Migration/Unification)
  Future<Person> createPersonFromMember(MemberProfile member) async {
    final person = Person(
      id: member.id, // On réutilise l'ID pour la cohérence initiale
      ecclesiasticalId: 'DEU-${member.id.substring(0, 8).toUpperCase()}',
      lastName: member.nom,
      secondName: member.postNom,
      firstName: member.prenom,
      isMale: member.isMale,
      birthDate: member.dateNaissance,
      birthPlace: member.lieuNaissance,
      nationality: member.nationalite,
      civilStatus: member.etatCivil,
      address: member.adresse,
      phone: member.telephone,
      email: member.email,
      currentEntityId: member.communauteId,
      currentEntityLevel: member.egliseTerritorialeId == 'RDC_OUEST' 
          ? (member.champApostoliqueId != null ? 1 : 0) as dynamic // Simplifié pour l'instant
          : 0 as dynamic, // Devra être affiné avec les vrais niveaux
    );
    
    // Ajout à la box
    await Hive.box<Person>(_personBox).put(person.id, person);
    
    // Liaison inverse
    member.personId = person.id;
    await member.save();
    
    return person;
  }

  /// Enregistre un nouveau sacrement
  Future<void> addSacrament(Sacrament sacrament) async {
    await Hive.box<Sacrament>(_sacramentBox).put(sacrament.id, sacrament);
  }

  /// Enregistre une nouvelle ordination
  Future<void> addOrdination(Ordination ordination) async {
    await Hive.box<Ordination>(_ordinationBox).put(ordination.id, ordination);
  }

  /// Enregistre une nouvelle nomination
  Future<void> addNomination(Nomination nomination) async {
    await Hive.box<Nomination>(_nominationBox).put(nomination.id, nomination);
  }
}
