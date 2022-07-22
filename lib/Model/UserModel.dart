import 'package:hive/hive.dart';

part 'UserModel.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String description;
  @HiveField(2)
  String startTime;
  @HiveField(3)
  String endTime;
  @HiveField(4)
  String date;
  @HiveField(5)
  int color;
  @HiveField(6)
  late bool isCompleted = false;

  UserModel({
    required this.name,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.color,
    required this.isCompleted,
  });
}
