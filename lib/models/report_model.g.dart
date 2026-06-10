// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReportModelAdapter extends TypeAdapter<ReportModel> {
  @override
  final int typeId = 70;

  @override
  ReportModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReportModel(
      id: fields[0] as String,
      type: fields[1] as String,
      communityId: fields[2] as String,
      communityName: fields[3] as String,
      districtName: fields[4] as String,
      champName: fields[5] as String,
      formData: (fields[6] as Map).cast<String, dynamic>(),
      status: fields[7] as String,
      createdBy: fields[8] as String,
      createdAt: fields[9] as DateTime,
      rejectionReason: fields[10] as String?,
      signaturesJson: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ReportModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.communityId)
      ..writeByte(3)
      ..write(obj.communityName)
      ..writeByte(4)
      ..write(obj.districtName)
      ..writeByte(5)
      ..write(obj.champName)
      ..writeByte(6)
      ..write(obj.formData)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.createdBy)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.rejectionReason)
      ..writeByte(11)
      ..write(obj.signaturesJson);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
