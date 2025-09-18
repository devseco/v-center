// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FavoriteModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteModelAdapter extends TypeAdapter<FavoriteModel> {
  @override
  final int typeId = 2;

  @override
  FavoriteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteModel(
      price: fields[1] as int,
      title: fields[0] as String,
      rate: fields[4] as String,
      image: fields[3] as String,
      lastprice: fields[2] as int,
      item: fields[5] as int,
      id: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.price)
      ..writeByte(2)
      ..write(obj.lastprice)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.rate)
      ..writeByte(5)
      ..write(obj.item)
      ..writeByte(6)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
