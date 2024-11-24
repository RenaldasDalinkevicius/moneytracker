// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpensesModelAdapter extends TypeAdapter<ExpensesModel> {
  @override
  final int typeId = 2;

  @override
  ExpensesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpensesModel(
      what: fields[0] as String,
      price: fields[1] as int,
      date: fields[2] as DateTime,
      note: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ExpensesModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.what)
      ..writeByte(1)
      ..write(obj.price)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpensesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
