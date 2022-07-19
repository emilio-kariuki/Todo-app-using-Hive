import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hives/Model/UserModel.dart';

import 'View/Home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); //intialize hive
  Hive.registerAdapter(UserModelAdapter()); //register adapter
  await Hive.openBox<UserModel>('task');
  runApp(GetMaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
  ));
}
