enum Gender { male, female }

class Person {
  final String id;
  final String lastName;
  final String firstName;
  final String? postName;
  final Gender gender;
  final DateTime birthDate;
  final String? email;
  final String? phone;
  final String? photoUrl;
  
  // Historique spirituel
  final DateTime? baptismDate;
  final DateTime? sealingDate;
  final DateTime? confirmationDate;
  
  final String? familyId; // Lien vers le foyer
  final String? familyRelation; // Ex: "Père", "Mère", "Enfant"

  Person({
    required this.id,
    required this.lastName,
    required this.firstName,
    this.postName,
    required this.gender,
    required this.birthDate,
    this.email,
    this.phone,
    this.photoUrl,
    this.baptismDate,
    this.sealingDate,
    this.confirmationDate,
    this.familyId,
    this.familyRelation,
  });

  String get fullName => "$firstName ${postName ?? ''} $lastName".trim();
}
