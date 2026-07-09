// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FinanceTransactionModelAdapter
    extends TypeAdapter<FinanceTransactionModel> {
  @override
  final int typeId = 256;

  @override
  FinanceTransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinanceTransactionModel(
      id: fields[0] as String,
      entityId: fields[1] as String,
      personId: fields[2] as String,
      amount: fields[3] as double,
      currency: fields[4] as String,
      typeIndex: fields[5] as int,
      methodIndex: fields[6] as int,
      date: fields[7] as DateTime,
      description: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FinanceTransactionModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.entityId)
      ..writeByte(2)
      ..write(obj.personId)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.currency)
      ..writeByte(5)
      ..write(obj.typeIndex)
      ..writeByte(6)
      ..write(obj.methodIndex)
      ..writeByte(7)
      ..write(obj.date)
      ..writeByte(8)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinanceTransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
