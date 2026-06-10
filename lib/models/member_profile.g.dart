// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemberProfileAdapter extends TypeAdapter<MemberProfile> {
  @override
  final int typeId = 33;

  @override
  MemberProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MemberProfile(
      id: fields[0] as String,
      nom: fields[1] as String,
      postNom: fields[2] as String,
      prenom: fields[3] as String,
      isMale: fields[4] as bool,
      dateNaissance: fields[5] as DateTime,
      lieuNaissance: fields[6] as String,
      nationalite: fields[7] as String,
      etatCivil: fields[8] as CivilStatus,
      adresse: fields[15] as String,
      communeQuartier: fields[16] as String,
      telephone: fields[17] as String,
      egliseTerritorialeId: fields[19] as String,
      districtId: fields[21] as String,
      communauteId: fields[22] as String,
      dateEntreeEglise: fields[23] as DateTime,
      statutMembre: fields[24] as MemberStatus,
      baptise: fields[26] as bool,
      prendSainteCene: fields[28] as bool,
      scelle: fields[29] as bool,
      disponibilite: fields[34] as Availability,
      dateInscription: fields[39] as DateTime,
      inscritParMinistreId: fields[40] as String,
      profession: fields[9] as String?,
      nomPere: fields[10] as String?,
      pereNeApostolique: fields[11] as bool?,
      nomMere: fields[12] as String?,
      mereNeeApostolique: fields[13] as bool?,
      membreNeApostolique: fields[14] as bool,
      email: fields[18] as String?,
      champApostoliqueId: fields[20] as String?,
      communauteOrigine: fields[25] as String?,
      dateBapteme: fields[27] as DateTime?,
      dateScellement: fields[30] as DateTime?,
      fonctionEglise: fields[31] as String?,
      commissions: (fields[32] as List).cast<CommissionType>(),
      donsCompetences: fields[33] as String?,
      contactUrgenceNom: fields[35] as String?,
      contactUrgenceLien: fields[36] as String?,
      contactUrgenceTel: fields[37] as String?,
      observations: fields[38] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MemberProfile obj) {
    writer
      ..writeByte(41)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nom)
      ..writeByte(2)
      ..write(obj.postNom)
      ..writeByte(3)
      ..write(obj.prenom)
      ..writeByte(4)
      ..write(obj.isMale)
      ..writeByte(5)
      ..write(obj.dateNaissance)
      ..writeByte(6)
      ..write(obj.lieuNaissance)
      ..writeByte(7)
      ..write(obj.nationalite)
      ..writeByte(8)
      ..write(obj.etatCivil)
      ..writeByte(9)
      ..write(obj.profession)
      ..writeByte(10)
      ..write(obj.nomPere)
      ..writeByte(11)
      ..write(obj.pereNeApostolique)
      ..writeByte(12)
      ..write(obj.nomMere)
      ..writeByte(13)
      ..write(obj.mereNeeApostolique)
      ..writeByte(14)
      ..write(obj.membreNeApostolique)
      ..writeByte(15)
      ..write(obj.adresse)
      ..writeByte(16)
      ..write(obj.communeQuartier)
      ..writeByte(17)
      ..write(obj.telephone)
      ..writeByte(18)
      ..write(obj.email)
      ..writeByte(19)
      ..write(obj.egliseTerritorialeId)
      ..writeByte(20)
      ..write(obj.champApostoliqueId)
      ..writeByte(21)
      ..write(obj.districtId)
      ..writeByte(22)
      ..write(obj.communauteId)
      ..writeByte(23)
      ..write(obj.dateEntreeEglise)
      ..writeByte(24)
      ..write(obj.statutMembre)
      ..writeByte(25)
      ..write(obj.communauteOrigine)
      ..writeByte(26)
      ..write(obj.baptise)
      ..writeByte(27)
      ..write(obj.dateBapteme)
      ..writeByte(28)
      ..write(obj.prendSainteCene)
      ..writeByte(29)
      ..write(obj.scelle)
      ..writeByte(30)
      ..write(obj.dateScellement)
      ..writeByte(31)
      ..write(obj.fonctionEglise)
      ..writeByte(32)
      ..write(obj.commissions)
      ..writeByte(33)
      ..write(obj.donsCompetences)
      ..writeByte(34)
      ..write(obj.disponibilite)
      ..writeByte(35)
      ..write(obj.contactUrgenceNom)
      ..writeByte(36)
      ..write(obj.contactUrgenceLien)
      ..writeByte(37)
      ..write(obj.contactUrgenceTel)
      ..writeByte(38)
      ..write(obj.observations)
      ..writeByte(39)
      ..write(obj.dateInscription)
      ..writeByte(40)
      ..write(obj.inscritParMinistreId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemberProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CivilStatusAdapter extends TypeAdapter<CivilStatus> {
  @override
  final int typeId = 30;

  @override
  CivilStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CivilStatus.celibataire;
      case 1:
        return CivilStatus.marie;
      case 2:
        return CivilStatus.veuf;
      case 3:
        return CivilStatus.divorce;
      default:
        return CivilStatus.celibataire;
    }
  }

  @override
  void write(BinaryWriter writer, CivilStatus obj) {
    switch (obj) {
      case CivilStatus.celibataire:
        writer.writeByte(0);
        break;
      case CivilStatus.marie:
        writer.writeByte(1);
        break;
      case CivilStatus.veuf:
        writer.writeByte(2);
        break;
      case CivilStatus.divorce:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CivilStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MemberStatusAdapter extends TypeAdapter<MemberStatus> {
  @override
  final int typeId = 31;

  @override
  MemberStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MemberStatus.nouveau;
      case 1:
        return MemberStatus.ancien;
      case 2:
        return MemberStatus.transfert;
      default:
        return MemberStatus.nouveau;
    }
  }

  @override
  void write(BinaryWriter writer, MemberStatus obj) {
    switch (obj) {
      case MemberStatus.nouveau:
        writer.writeByte(0);
        break;
      case MemberStatus.ancien:
        writer.writeByte(1);
        break;
      case MemberStatus.transfert:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemberStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AvailabilityAdapter extends TypeAdapter<Availability> {
  @override
  final int typeId = 32;

  @override
  Availability read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Availability.hebdomadaire;
      case 1:
        return Availability.mensuelle;
      case 2:
        return Availability.occasionnelle;
      default:
        return Availability.hebdomadaire;
    }
  }

  @override
  void write(BinaryWriter writer, Availability obj) {
    switch (obj) {
      case Availability.hebdomadaire:
        writer.writeByte(0);
        break;
      case Availability.mensuelle:
        writer.writeByte(1);
        break;
      case Availability.occasionnelle:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AvailabilityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
