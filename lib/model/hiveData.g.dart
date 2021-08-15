// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hiveData.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoviesDataAdapter extends TypeAdapter<MoviesData> {
  @override
  final int typeId = 0;

  @override
  MoviesData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoviesData()
      ..movie = fields[0] as String
      ..director = fields[1] as String
      ..duration = fields[2] as String
      ..image = fields[3] as String;
  }

  @override
  void write(BinaryWriter writer, MoviesData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.movie)
      ..writeByte(1)
      ..write(obj.director)
      ..writeByte(2)
      ..write(obj.duration)
      ..writeByte(3)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoviesDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
