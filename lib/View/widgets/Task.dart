import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hives/Model/UserModel.dart';
import 'package:flutter/material.dart';

class Task extends StatelessWidget {
  final UserModel userModel;
  const Task({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      height: size.height * 0.16,
      width: double.infinity,
      decoration: BoxDecoration(
          color: userModel.color == 0
              ? Colors.deepPurple
              : userModel.color == 1
                  ? Colors.orange
                  : Colors.pink,
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                showText(userModel.name, Colors.white),
                const SizedBox(height: 2),
                Row(
                  children: [
                    showText("9.30", Colors.white),
                    const SizedBox(width: 15),
                    showText("4.30", Colors.white),
                  ],
                ),
                const SizedBox(height: 2),
                SizedBox(
                    width: size.width * 0.75,
                    child: showText(userModel.description, Colors.white)),
              ],
            ),
          ),
          Expanded(child: Container()),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: size.height * 0.13,
            width: 0.6,
            color: Colors.black.withOpacity(0.7),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              userModel.isCompleted == false ? "TASKS" : "COMPLETED",
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget showText(String text, Color color) {
    return AutoSizeText(
      text,
      maxLines: 10,
      minFontSize: 11,
      //overflow: TextOverflow.visible,
      textAlign: TextAlign.left,
      style: GoogleFonts.quicksand(
        color: color,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  void deleteTask(UserModel userModel) {
    Hive.box("user").delete(userModel);
  }
}
