import 'package:hive/hive.dart';

part 'UserModel.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final String startTime;
  @HiveField(3)
  final String endTime;
  @HiveField(4)
  final String date;
  @HiveField(5)
  int color;
  @HiveField(6)
  final bool isCompleted;

  UserModel({
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.name,
    required this.color,
    required this.isCompleted,
  });
}
