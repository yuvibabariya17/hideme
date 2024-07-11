part of 'FileModel.dart';

class TodoAdapter extends TypeAdapter<FileModel> {
  @override
  final int typeId = 0;

  @override
  FileModel read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FileModel(anonymizedName: '',originalPath: '')
      ..originalPath = fields[0] as String
      ..anonymizedName = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, FileModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.originalPath)
      ..writeByte(1)
      ..write(obj.anonymizedName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}