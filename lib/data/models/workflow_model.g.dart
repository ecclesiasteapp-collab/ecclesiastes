// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkflowInstanceModelAdapter extends TypeAdapter<WorkflowInstanceModel> {
  @override
  final int typeId = 253;

  @override
  WorkflowInstanceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkflowInstanceModel(
      id: fields[0] as String,
      definitionId: fields[1] as String,
      entityId: fields[2] as String,
      initiatorId: fields[3] as String,
      statusIndex: fields[4] as int,
      currentStepId: fields[5] as String,
      data: (fields[6] as Map).cast<dynamic, dynamic>(),
      history: (fields[7] as List).cast<WorkflowLogModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, WorkflowInstanceModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.definitionId)
      ..writeByte(2)
      ..write(obj.entityId)
      ..writeByte(3)
      ..write(obj.initiatorId)
      ..writeByte(4)
      ..write(obj.statusIndex)
      ..writeByte(5)
      ..write(obj.currentStepId)
      ..writeByte(6)
      ..write(obj.data)
      ..writeByte(7)
      ..write(obj.history);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkflowInstanceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkflowLogModelAdapter extends TypeAdapter<WorkflowLogModel> {
  @override
  final int typeId = 254;

  @override
  WorkflowLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkflowLogModel(
      stepId: fields[0] as String,
      actorId: fields[1] as String,
      actionIndex: fields[2] as int,
      timestamp: fields[3] as DateTime,
      comment: fields[4] as String?,
      signatureHash: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WorkflowLogModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.stepId)
      ..writeByte(1)
      ..write(obj.actorId)
      ..writeByte(2)
      ..write(obj.actionIndex)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.comment)
      ..writeByte(5)
      ..write(obj.signatureHash);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkflowLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
