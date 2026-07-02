// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ministry_statistics.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MinistryStatisticsAdapter extends TypeAdapter<MinistryStatistics> {
  @override
  final int typeId = 119;

  @override
  MinistryStatistics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MinistryStatistics(
      id: fields[0] as String,
      entiteId: fields[1] as String,
      entiteLevel: fields[2] as EntityLevel,
      ministerId: fields[3] as String,
      ministryType: fields[4] as String,
      dateMesure: fields[5] as DateTime,
      totalMembres: fields[6] as int,
      presentsMesure: fields[7] as int,
      tauxPresence: fields[8] as double,
      participantsActifs: fields[9] as int,
      participantsInactifs: fields[10] as int,
      activitesRealisees: fields[11] as int,
      activitesPlanifiees: fields[12] as int,
      rapportsRemis: fields[13] as int,
      rapportsEnAttente: fields[14] as int,
      offrandesFC: fields[15] as double,
      offrandesUSD: fields[16] as double,
      budgetAlloue: fields[17] as double,
      nouveauxMembres: fields[18] as int,
      saintScelles: fields[19] as int,
      confirmations: fields[20] as int,
      dateCreation: fields[21] as DateTime?,
      dateModification: fields[22] as DateTime?,
      notes: fields[23] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MinistryStatistics obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.entiteId)
      ..writeByte(2)
      ..write(obj.entiteLevel)
      ..writeByte(3)
      ..write(obj.ministerId)
      ..writeByte(4)
      ..write(obj.ministryType)
      ..writeByte(5)
      ..write(obj.dateMesure)
      ..writeByte(6)
      ..write(obj.totalMembres)
      ..writeByte(7)
      ..write(obj.presentsMesure)
      ..writeByte(8)
      ..write(obj.tauxPresence)
      ..writeByte(9)
      ..write(obj.participantsActifs)
      ..writeByte(10)
      ..write(obj.participantsInactifs)
      ..writeByte(11)
      ..write(obj.activitesRealisees)
      ..writeByte(12)
      ..write(obj.activitesPlanifiees)
      ..writeByte(13)
      ..write(obj.rapportsRemis)
      ..writeByte(14)
      ..write(obj.rapportsEnAttente)
      ..writeByte(15)
      ..write(obj.offrandesFC)
      ..writeByte(16)
      ..write(obj.offrandesUSD)
      ..writeByte(17)
      ..write(obj.budgetAlloue)
      ..writeByte(18)
      ..write(obj.nouveauxMembres)
      ..writeByte(19)
      ..write(obj.saintScelles)
      ..writeByte(20)
      ..write(obj.confirmations)
      ..writeByte(21)
      ..write(obj.dateCreation)
      ..writeByte(22)
      ..write(obj.dateModification)
      ..writeByte(23)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MinistryStatisticsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
