import 'package:hive/hive.dart';
import 'package:hives/Model/UserModel.dart';

class Boxes {
  static Box<UserModel> getTask() => Hive.box<UserModel>('task');
}
