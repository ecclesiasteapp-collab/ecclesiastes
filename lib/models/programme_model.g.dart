// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'programme_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProgrammeAdapter extends TypeAdapter<Programme> {
  @override
  final int typeId = 110;

  @override
  Programme read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Programme(
      id: fields[0] as String,
      responsableId: fields[1] as String,
      responsableType: fields[2] as String,
      entiteId: fields[3] as String,
      type: fields[4] as ProgrammeType,
      titre: fields[5] as String,
      description: fields[6] as String?,
      activites: (fields[7] as List).cast<Activite>(),
      dateDebut: fields[8] as DateTime,
      dateFin: fields[9] as DateTime,
      statut: fields[10] as StatutProgramme,
    );
  }

  @override
  void write(BinaryWriter writer, Programme obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.responsableId)
      ..writeByte(2)
      ..write(obj.responsableType)
      ..writeByte(3)
      ..write(obj.entiteId)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.titre)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.activites)
      ..writeByte(8)
      ..write(obj.dateDebut)
      ..writeByte(9)
      ..write(obj.dateFin)
      ..writeByte(10)
      ..write(obj.statut);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgrammeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ActiviteAdapter extends TypeAdapter<Activite> {
  @override
  final int typeId = 111;

  @override
  Activite read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Activite(
      id: fields[0] as String,
      titre: fields[1] as String,
      date: fields[2] as DateTime,
      lieu: fields[3] as String?,
      description: fields[4] as String?,
      responsablesIds: (fields[5] as List).cast<String>(),
      estAnnonce: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Activite obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.titre)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.lieu)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.responsablesIds)
      ..writeByte(6)
      ..write(obj.estAnnonce);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActiviteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
