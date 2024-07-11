import 'package:hive/hive.dart';

part 'file_model.g.dart';

@HiveType(typeId: 0)
class FileModel extends HiveObject {
  @HiveField(0)
  late String originalPath;

  @HiveField(1)
  late String anonymizedName;

  FileModel({required this.originalPath, required this.anonymizedName});
}
