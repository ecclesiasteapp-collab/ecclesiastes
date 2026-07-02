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
      rapporteurId: fields[36] as String?,
      validateur: fields[28] as String?,
      dateValidation: fields[29] as DateTime?,
      motifRejet: fields[30] as String?,
      champsPersonnalises: (fields[31] as Map).cast<String, String>(),
      signaturePath: fields[35] as String?,
      version: fields[32] as int,
      updatedAt: fields[33] as DateTime?,
      lastModifiedBy: fields[34] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ChurchReport obj) {
    writer
      ..writeByte(37)
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
      ..writeByte(36)
      ..write(obj.rapporteurId)
      ..writeByte(28)
      ..write(obj.validateur)
      ..writeByte(29)
      ..write(obj.dateValidation)
      ..writeByte(30)
      ..write(obj.motifRejet)
      ..writeByte(31)
      ..write(obj.champsPersonnalises)
      ..writeByte(35)
      ..write(obj.signaturePath)
      ..writeByte(32)
      ..write(obj.version)
      ..writeByte(33)
      ..write(obj.updatedAt)
      ..writeByte(34)
      ..write(obj.lastModifiedBy);
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
        return ReportTypeExt.visitePastorale;
      case 2:
        return ReportTypeExt.communionFraternelle;
      case 3:
        return ReportTypeExt.ordinationInstallation;
      case 4:
        return ReportTypeExt.funerailles;
      case 5:
        return ReportTypeExt.mariage;
      case 6:
        return ReportTypeExt.bapteme;
      case 7:
        return ReportTypeExt.sainteCene;
      case 8:
        return ReportTypeExt.sacristie;
      case 33:
        return ReportTypeExt.scellement;
      case 9:
        return ReportTypeExt.ecodim;
      case 10:
        return ReportTypeExt.econfi;
      case 11:
        return ReportTypeExt.jeunesse;
      case 12:
        return ReportTypeExt.papas;
      case 13:
        return ReportTypeExt.mamans;
      case 14:
        return ReportTypeExt.aines;
      case 15:
        return ReportTypeExt.musiqueTechnique;
      case 16:
        return ReportTypeExt.musiqueOrchestre;
      case 17:
        return ReportTypeExt.presseMedias;
      case 18:
        return ReportTypeExt.josephArimathee;
      case 19:
        return ReportTypeExt.securiteProtocole;
      case 20:
        return ReportTypeExt.medicale;
      case 21:
        return ReportTypeExt.construction;
      case 22:
        return ReportTypeExt.consolidationCommunaute;
      case 23:
        return ReportTypeExt.consolidationDistrict;
      case 24:
        return ReportTypeExt.consolidationChamp;
      case 25:
        return ReportTypeExt.consolidationTerritorial;
      case 26:
        return ReportTypeExt.consolidationInternational;
      case 27:
        return ReportTypeExt.collecteFundraising;
      case 28:
        return ReportTypeExt.evenementSpecial;
      case 29:
        return ReportTypeExt.mensuelActivite;
      case 30:
        return ReportTypeExt.trimestrielActivite;
      case 31:
        return ReportTypeExt.annuelActivite;
      case 32:
        return ReportTypeExt.autre;
      case 34:
        return ReportTypeExt.reunionCommission;
      case 35:
        return ReportTypeExt.seminaire;
      case 36:
        return ReportTypeExt.repetition;
      case 37:
        return ReportTypeExt.formation;
      case 38:
        return ReportTypeExt.activiteSociale;
      case 39:
        return ReportTypeExt.inventaire;
      case 40:
        return ReportTypeExt.gestionDistrict;
      case 41:
        return ReportTypeExt.gestionCommunaute;
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
      case ReportTypeExt.visitePastorale:
        writer.writeByte(1);
        break;
      case ReportTypeExt.communionFraternelle:
        writer.writeByte(2);
        break;
      case ReportTypeExt.ordinationInstallation:
        writer.writeByte(3);
        break;
      case ReportTypeExt.funerailles:
        writer.writeByte(4);
        break;
      case ReportTypeExt.mariage:
        writer.writeByte(5);
        break;
      case ReportTypeExt.bapteme:
        writer.writeByte(6);
        break;
      case ReportTypeExt.sainteCene:
        writer.writeByte(7);
        break;
      case ReportTypeExt.sacristie:
        writer.writeByte(8);
        break;
      case ReportTypeExt.scellement:
        writer.writeByte(33);
        break;
      case ReportTypeExt.ecodim:
        writer.writeByte(9);
        break;
      case ReportTypeExt.econfi:
        writer.writeByte(10);
        break;
      case ReportTypeExt.jeunesse:
        writer.writeByte(11);
        break;
      case ReportTypeExt.papas:
        writer.writeByte(12);
        break;
      case ReportTypeExt.mamans:
        writer.writeByte(13);
        break;
      case ReportTypeExt.aines:
        writer.writeByte(14);
        break;
      case ReportTypeExt.musiqueTechnique:
        writer.writeByte(15);
        break;
      case ReportTypeExt.musiqueOrchestre:
        writer.writeByte(16);
        break;
      case ReportTypeExt.presseMedias:
        writer.writeByte(17);
        break;
      case ReportTypeExt.josephArimathee:
        writer.writeByte(18);
        break;
      case ReportTypeExt.securiteProtocole:
        writer.writeByte(19);
        break;
      case ReportTypeExt.medicale:
        writer.writeByte(20);
        break;
      case ReportTypeExt.construction:
        writer.writeByte(21);
        break;
      case ReportTypeExt.consolidationCommunaute:
        writer.writeByte(22);
        break;
      case ReportTypeExt.consolidationDistrict:
        writer.writeByte(23);
        break;
      case ReportTypeExt.consolidationChamp:
        writer.writeByte(24);
        break;
      case ReportTypeExt.consolidationTerritorial:
        writer.writeByte(25);
        break;
      case ReportTypeExt.consolidationInternational:
        writer.writeByte(26);
        break;
      case ReportTypeExt.collecteFundraising:
        writer.writeByte(27);
        break;
      case ReportTypeExt.evenementSpecial:
        writer.writeByte(28);
        break;
      case ReportTypeExt.mensuelActivite:
        writer.writeByte(29);
        break;
      case ReportTypeExt.trimestrielActivite:
        writer.writeByte(30);
        break;
      case ReportTypeExt.annuelActivite:
        writer.writeByte(31);
        break;
      case ReportTypeExt.autre:
        writer.writeByte(32);
        break;
      case ReportTypeExt.reunionCommission:
        writer.writeByte(34);
        break;
      case ReportTypeExt.seminaire:
        writer.writeByte(35);
        break;
      case ReportTypeExt.repetition:
        writer.writeByte(36);
        break;
      case ReportTypeExt.formation:
        writer.writeByte(37);
        break;
      case ReportTypeExt.activiteSociale:
        writer.writeByte(38);
        break;
      case ReportTypeExt.inventaire:
        writer.writeByte(39);
        break;
      case ReportTypeExt.gestionDistrict:
        writer.writeByte(40);
        break;
      case ReportTypeExt.gestionCommunaute:
        writer.writeByte(41);
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
