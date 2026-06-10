// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'church_report.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChurchReportAdapter extends TypeAdapter<ChurchReport> {
  @override
  final int typeId = 52;

  @override
  ChurchReport read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChurchReport(
      id: fields[0] as String,
      type: fields[1] as ReportTypeExt,
      niveauEntite: fields[2] as EntityLevel,
      nomEntite: fields[3] as String,
      nomChamp: fields[4] as String,
      nomDistrict: fields[5] as String,
      dateRapport: fields[6] as DateTime,
      heureDebut: fields[7] as DateTime,
      heureFin: fields[8] as DateTime?,
      cantiqueIntroduction: fields[9] as String,
      texteBiblique: fields[10] as String,
      officiant: fields[11] as String,
      assistants: (fields[12] as List).cast<String>(),
      presenceTotale: fields[13] as int,
      nombreMembres: fields[14] as int,
      nombreVisiteurs: fields[15] as int,
      offrandeFC: fields[16] as double,
      offrandeDevise: fields[17] as double,
      numeroRecu: fields[18] as String,
      nombreBaptemes: fields[19] as int,
      nombreScelles: fields[20] as int,
      nombreConfirmations: fields[21] as int,
      nombreOrdinations: fields[22] as int,
      nombreMandatements: fields[23] as int,
      nombreNominations: fields[24] as int,
      nombreRetraites: fields[25] as int,
      statut: fields[26] as ReportStatus,
      rapporteur: fields[27] as String,
      validateur: fields[28] as String?,
      dateValidation: fields[29] as DateTime?,
      motifRejet: fields[30] as String?,
      champsPersonnalises: (fields[31] as Map).cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ChurchReport obj) {
    writer
      ..writeByte(32)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.niveauEntite)
      ..writeByte(3)
      ..write(obj.nomEntite)
      ..writeByte(4)
      ..write(obj.nomChamp)
      ..writeByte(5)
      ..write(obj.nomDistrict)
      ..writeByte(6)
      ..write(obj.dateRapport)
      ..writeByte(7)
      ..write(obj.heureDebut)
      ..writeByte(8)
      ..write(obj.heureFin)
      ..writeByte(9)
      ..write(obj.cantiqueIntroduction)
      ..writeByte(10)
      ..write(obj.texteBiblique)
      ..writeByte(11)
      ..write(obj.officiant)
      ..writeByte(12)
      ..write(obj.assistants)
      ..writeByte(13)
      ..write(obj.presenceTotale)
      ..writeByte(14)
      ..write(obj.nombreMembres)
      ..writeByte(15)
      ..write(obj.nombreVisiteurs)
      ..writeByte(16)
      ..write(obj.offrandeFC)
      ..writeByte(17)
      ..write(obj.offrandeDevise)
      ..writeByte(18)
      ..write(obj.numeroRecu)
      ..writeByte(19)
      ..write(obj.nombreBaptemes)
      ..writeByte(20)
      ..write(obj.nombreScelles)
      ..writeByte(21)
      ..write(obj.nombreConfirmations)
      ..writeByte(22)
      ..write(obj.nombreOrdinations)
      ..writeByte(23)
      ..write(obj.nombreMandatements)
      ..writeByte(24)
      ..write(obj.nombreNominations)
      ..writeByte(25)
      ..write(obj.nombreRetraites)
      ..writeByte(26)
      ..write(obj.statut)
      ..writeByte(27)
      ..write(obj.rapporteur)
      ..writeByte(28)
      ..write(obj.validateur)
      ..writeByte(29)
      ..write(obj.dateValidation)
      ..writeByte(30)
      ..write(obj.motifRejet)
      ..writeByte(31)
      ..write(obj.champsPersonnalises);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChurchReportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReportTypeExtAdapter extends TypeAdapter<ReportTypeExt> {
  @override
  final int typeId = 50;

  @override
  ReportTypeExt read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReportTypeExt.serviceDivin;
      case 1:
        return ReportTypeExt.reunionFreres;
      case 2:
        return ReportTypeExt.serviceJeunesse;
      case 3:
        return ReportTypeExt.seminaire;
      case 4:
        return ReportTypeExt.serviceEcodim;
      case 5:
        return ReportTypeExt.serviceFunebre;
      case 6:
        return ReportTypeExt.mariage;
      case 7:
        return ReportTypeExt.concert;
      case 8:
        return ReportTypeExt.evangelisation;
      case 9:
        return ReportTypeExt.repetition;
      case 10:
        return ReportTypeExt.visitePastorale;
      case 11:
        return ReportTypeExt.reunionCommission;
      case 12:
        return ReportTypeExt.formation;
      case 13:
        return ReportTypeExt.activiteSociale;
      case 14:
        return ReportTypeExt.autre;
      default:
        return ReportTypeExt.serviceDivin;
    }
  }

  @override
  void write(BinaryWriter writer, ReportTypeExt obj) {
    switch (obj) {
      case ReportTypeExt.serviceDivin:
        writer.writeByte(0);
        break;
      case ReportTypeExt.reunionFreres:
        writer.writeByte(1);
        break;
      case ReportTypeExt.serviceJeunesse:
        writer.writeByte(2);
        break;
      case ReportTypeExt.seminaire:
        writer.writeByte(3);
        break;
      case ReportTypeExt.serviceEcodim:
        writer.writeByte(4);
        break;
      case ReportTypeExt.serviceFunebre:
        writer.writeByte(5);
        break;
      case ReportTypeExt.mariage:
        writer.writeByte(6);
        break;
      case ReportTypeExt.concert:
        writer.writeByte(7);
        break;
      case ReportTypeExt.evangelisation:
        writer.writeByte(8);
        break;
      case ReportTypeExt.repetition:
        writer.writeByte(9);
        break;
      case ReportTypeExt.visitePastorale:
        writer.writeByte(10);
        break;
      case ReportTypeExt.reunionCommission:
        writer.writeByte(11);
        break;
      case ReportTypeExt.formation:
        writer.writeByte(12);
        break;
      case ReportTypeExt.activiteSociale:
        writer.writeByte(13);
        break;
      case ReportTypeExt.autre:
        writer.writeByte(14);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportTypeExtAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReportStatusAdapter extends TypeAdapter<ReportStatus> {
  @override
  final int typeId = 51;

  @override
  ReportStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReportStatus.brouillon;
      case 1:
        return ReportStatus.soumis;
      case 2:
        return ReportStatus.valide;
      case 3:
        return ReportStatus.rejete;
      case 4:
        return ReportStatus.archive;
      default:
        return ReportStatus.brouillon;
    }
  }

  @override
  void write(BinaryWriter writer, ReportStatus obj) {
    switch (obj) {
      case ReportStatus.brouillon:
        writer.writeByte(0);
        break;
      case ReportStatus.soumis:
        writer.writeByte(1);
        break;
      case ReportStatus.valide:
        writer.writeByte(2);
        break;
      case ReportStatus.rejete:
        writer.writeByte(3);
        break;
      case ReportStatus.archive:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
