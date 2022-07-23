import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../Model/UserModel.dart';
import 'Boxes.dart';
import 'complete.dart';

class Completed extends StatefulWidget {
  const Completed({Key? key}) : super(key: key);

  @override
  State<Completed> createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getBack(),
              Center(child: showTitle("Completed Tasks")),
              const SizedBox(height: 5),
              completedCard()
            ],
          ),
        ),
      ),
    ));
  }

  Widget getBack() {
    return InkWell(
      onTap: () => Get.back(),
      child: Container(
        height: 30,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black54,
          size: 18,
        ),
      ),
    );
  }

  Widget showTitle(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.quicksand(
          fontSize: 25, color: Colors.black87, fontWeight: FontWeight.bold),
    );
  }

  Widget completedCard() {
    return ValueListenableBuilder<Box<UserModel>>(
      valueListenable: Boxes.getTask().listenable(),
      builder: (context, box, index) {
        final tasks = box.values.toList().cast<UserModel>();
        final finishedTasks = tasks.where((task) => task.isCompleted);

        return ListView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: finishedTasks
              .map((fav) => Complete(
                    userModel: fav,
                  ))
              .toList(),
        );
      },
    );
  }
}
