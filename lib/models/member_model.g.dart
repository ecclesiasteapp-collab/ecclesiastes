// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemberModelAdapter extends TypeAdapter<MemberModel> {
  @override
  final int typeId = 0;

  @override
  MemberModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MemberModel(
      id: fields[0] as String,
      nom: fields[1] as String,
      postNom: fields[2] as String,
      prenom: fields[3] as String,
      sexe: fields[4] as String,
      dateNaissance: fields[5] as DateTime?,
      lieuNaissance: fields[6] as String,
      etatCivil: fields[7] as String,
      nationalite: fields[8] as String,
      pieceIdentite: fields[9] as String,
      pereNom: fields[10] as String,
      perePrenom: fields[11] as String,
      statutParentPere: fields[12] as String,
      mereNom: fields[13] as String,
      merePrenom: fields[14] as String,
      statutParentMere: fields[15] as String,
      adresse: fields[16] as String,
      commune: fields[17] as String,
      ville: fields[18] as String,
      telephone: fields[19] as String,
      email: fields[20] as String,
      communityId: fields[21] as String,
      communityName: fields[22] as String,
      dateEntreeEglise: fields[23] as DateTime?,
      statutMembre: fields[24] as String,
      isBaptise: fields[25] as bool,
      dateBapteme: fields[26] as DateTime?,
      lieuBapteme: fields[27] as String,
      officiantBapteme: fields[28] as String,
      isScelle: fields[29] as bool,
      dateScelle: fields[30] as DateTime?,
      lieuScelle: fields[31] as String,
      apotreScelle: fields[32] as String,
      isConfirme: fields[33] as bool,
      dateConfirmation: fields[34] as DateTime?,
      aMinistere: fields[35] as bool,
      commission: fields[36] as String,
      roleCommission: fields[37] as String,
      disponibilite: fields[38] as String,
      urgenceNom: fields[39] as String,
      urgenceLien: fields[40] as String,
      urgenceTelephone: fields[41] as String,
      pastoralNotesEncrypted: fields[42] as String,
      dateInscription: fields[43] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MemberModel obj) {
    writer
      ..writeByte(44)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nom)
      ..writeByte(2)
      ..write(obj.postNom)
      ..writeByte(3)
      ..write(obj.prenom)
      ..writeByte(4)
      ..write(obj.sexe)
      ..writeByte(5)
      ..write(obj.dateNaissance)
      ..writeByte(6)
      ..write(obj.lieuNaissance)
      ..writeByte(7)
      ..write(obj.etatCivil)
      ..writeByte(8)
      ..write(obj.nationalite)
      ..writeByte(9)
      ..write(obj.pieceIdentite)
      ..writeByte(10)
      ..write(obj.pereNom)
      ..writeByte(11)
      ..write(obj.perePrenom)
      ..writeByte(12)
      ..write(obj.statutParentPere)
      ..writeByte(13)
      ..write(obj.mereNom)
      ..writeByte(14)
      ..write(obj.merePrenom)
      ..writeByte(15)
      ..write(obj.statutParentMere)
      ..writeByte(16)
      ..write(obj.adresse)
      ..writeByte(17)
      ..write(obj.commune)
      ..writeByte(18)
      ..write(obj.ville)
      ..writeByte(19)
      ..write(obj.telephone)
      ..writeByte(20)
      ..write(obj.email)
      ..writeByte(21)
      ..write(obj.communityId)
      ..writeByte(22)
      ..write(obj.communityName)
      ..writeByte(23)
      ..write(obj.dateEntreeEglise)
      ..writeByte(24)
      ..write(obj.statutMembre)
      ..writeByte(25)
      ..write(obj.isBaptise)
      ..writeByte(26)
      ..write(obj.dateBapteme)
      ..writeByte(27)
      ..write(obj.lieuBapteme)
      ..writeByte(28)
      ..write(obj.officiantBapteme)
      ..writeByte(29)
      ..write(obj.isScelle)
      ..writeByte(30)
      ..write(obj.dateScelle)
      ..writeByte(31)
      ..write(obj.lieuScelle)
      ..writeByte(32)
      ..write(obj.apotreScelle)
      ..writeByte(33)
      ..write(obj.isConfirme)
      ..writeByte(34)
      ..write(obj.dateConfirmation)
      ..writeByte(35)
      ..write(obj.aMinistere)
      ..writeByte(36)
      ..write(obj.commission)
      ..writeByte(37)
      ..write(obj.roleCommission)
      ..writeByte(38)
      ..write(obj.disponibilite)
      ..writeByte(39)
      ..write(obj.urgenceNom)
      ..writeByte(40)
      ..write(obj.urgenceLien)
      ..writeByte(41)
      ..write(obj.urgenceTelephone)
      ..writeByte(42)
      ..write(obj.pastoralNotesEncrypted)
      ..writeByte(43)
      ..write(obj.dateInscription);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemberModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
