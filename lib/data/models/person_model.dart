import 'package:hive/hive.dart';
import '../../domain/entities/person.dart';

part 'person_model.g.dart';

@HiveType(typeId: 251)
class PersonModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String lastName;
  @HiveField(2)
  final String firstName;
  @HiveField(3)
  final String? postName;
  @HiveField(4)
  final int genderIndex;
  @HiveField(5)
  final DateTime birthDate;
  @HiveField(6)
  final String? email;
  @HiveField(7)
  final String? phone;
  @HiveField(8)
  final String? photoUrl;
  @HiveField(9)
  final DateTime? baptismDate;
  @HiveField(10)
  final DateTime? sealingDate;
  @HiveField(11)
  final DateTime? confirmationDate;

  PersonModel({
    required this.id,
    required this.lastName,
    required this.firstName,
    this.postName,
    required this.genderIndex,
    required this.birthDate,
    this.email,
    this.phone,
    this.photoUrl,
    this.baptismDate,
    this.sealingDate,
    this.confirmationDate,
  });

  factory PersonModel.fromEntity(Person person) {
    return PersonModel(
      id: person.id,
      lastName: person.lastName,
      firstName: person.firstName,
      postName: person.postName,
      genderIndex: person.gender.index,
      birthDate: person.birthDate,
      email: person.email,
      phone: person.phone,
      photoUrl: person.photoUrl,
      baptismDate: person.baptismDate,
      sealingDate: person.sealingDate,
      confirmationDate: person.confirmationDate,
    );
  }

  Person toEntity() {
    return Person(
      id: id,
      lastName: lastName,
      firstName: firstName,
      postName: postName,
      gender: Gender.values[genderIndex],
      birthDate: birthDate,
      email: email,
      phone: phone,
      photoUrl: photoUrl,
      baptismDate: baptismDate,
      sealingDate: sealingDate,
      confirmationDate: confirmationDate,
    );
  }
}
