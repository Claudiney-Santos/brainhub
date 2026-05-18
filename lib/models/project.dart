import 'package:hive_ce_flutter/hive_flutter.dart';

part 'project.g.dart';

@HiveType(typeId: 0)
class Project {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String code;

  Project({required this.name, required this.code});
}
