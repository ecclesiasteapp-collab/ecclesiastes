// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fundraising_report.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FundraisingReportAdapter extends TypeAdapter<FundraisingReport> {
  @override
  final int typeId = 53;

  @override
  FundraisingReport read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FundraisingReport(
      id: fields[0] as String,
      entityLevel: fields[1] as String,
      entityName: fields[2] as String,
      districtName: fields[3] as String,
      champName: fields[4] as String,
      motif: fields[5] as String,
      commissionOrganisatrice: fields[6] as String,
      dateCollecte: fields[7] as DateTime,
      cotisationsFC: fields[8] as double,
      collecteSpecialeFC: fields[9] as double,
      donsDiversFC: fields[10] as double,
      autresFC: fields[11] as double,
      cotisationsDevise: fields[12] as double,
      collecteSpecialeDevise: fields[13] as double,
      donsDiversDevise: fields[14] as double,
      autresDevise: fields[15] as double,
      nombreContributeurs: fields[16] as int,
      nombreAbsentsCotisants: fields[17] as int,
      destinationFonds: fields[18] as String,
      precisionDestination: fields[19] as String,
      observations: fields[20] as String,
      rapporteur: fields[21] as String,
      approuvePar: fields[22] as String,
      dateSoumission: fields[23] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FundraisingReport obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.entityLevel)
      ..writeByte(2)
      ..write(obj.entityName)
      ..writeByte(3)
      ..write(obj.districtName)
      ..writeByte(4)
      ..write(obj.champName)
      ..writeByte(5)
      ..write(obj.motif)
      ..writeByte(6)
      ..write(obj.commissionOrganisatrice)
      ..writeByte(7)
      ..write(obj.dateCollecte)
      ..writeByte(8)
      ..write(obj.cotisationsFC)
      ..writeByte(9)
      ..write(obj.collecteSpecialeFC)
      ..writeByte(10)
      ..write(obj.donsDiversFC)
      ..writeByte(11)
      ..write(obj.autresFC)
      ..writeByte(12)
      ..write(obj.cotisationsDevise)
      ..writeByte(13)
      ..write(obj.collecteSpecialeDevise)
      ..writeByte(14)
      ..write(obj.donsDiversDevise)
      ..writeByte(15)
      ..write(obj.autresDevise)
      ..writeByte(16)
      ..write(obj.nombreContributeurs)
      ..writeByte(17)
      ..write(obj.nombreAbsentsCotisants)
      ..writeByte(18)
      ..write(obj.destinationFonds)
      ..writeByte(19)
      ..write(obj.precisionDestination)
      ..writeByte(20)
      ..write(obj.observations)
      ..writeByte(21)
      ..write(obj.rapporteur)
      ..writeByte(22)
      ..write(obj.approuvePar)
      ..writeByte(23)
      ..write(obj.dateSoumission);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FundraisingReportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
