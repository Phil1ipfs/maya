// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionTypeAdapter extends TypeAdapter<TransactionType> {
  @override
  final int typeId = 1;

  @override
  TransactionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionType.addMoney;
      case 1:
        return TransactionType.sendMoney;
      case 2:
        return TransactionType.payBills;
      case 3:
        return TransactionType.buyLoad;
      case 4:
        return TransactionType.bankTransfer;
      case 5:
        return TransactionType.receive;
      default:
        return TransactionType.addMoney;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionType obj) {
    switch (obj) {
      case TransactionType.addMoney:
        writer.writeByte(0);
        break;
      case TransactionType.sendMoney:
        writer.writeByte(1);
        break;
      case TransactionType.payBills:
        writer.writeByte(2);
        break;
      case TransactionType.buyLoad:
        writer.writeByte(3);
        break;
      case TransactionType.bankTransfer:
        writer.writeByte(4);
        break;
      case TransactionType.receive:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 2;

  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionModel(
      id: fields[0] as String,
      type: fields[1] as TransactionType,
      amount: fields[2] as double,
      description: fields[3] as String,
      createdAt: fields[4] as DateTime,
      recipientName: fields[5] as String?,
      recipientNumber: fields[6] as String?,
      referenceNumber: fields[7] as String?,
      balanceAfter: fields[8] as double,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.recipientName)
      ..writeByte(6)
      ..write(obj.recipientNumber)
      ..writeByte(7)
      ..write(obj.referenceNumber)
      ..writeByte(8)
      ..write(obj.balanceAfter);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
