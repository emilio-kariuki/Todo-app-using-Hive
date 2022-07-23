import 'package:auto_size_text/auto_size_text.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hives/Model/UserModel.dart';
import 'package:hives/View/Completed.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import 'Add.dart';
import 'Boxes.dart';
import 'widgets/Task.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final name = TextEditingController();
  final email = TextEditingController();
  DateTime _date = DateTime.now();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 50,
        width: 50,
        child: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          onPressed: () {
            Get.to(() => const Completed());
          },
          child: const Icon(
            Icons.check,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: InkWell(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  rowDate(),
                  dateTimeline(),
                  cartCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget cartCard() {
    return ValueListenableBuilder<Box<UserModel>>(
      valueListenable: Boxes.getTask().listenable(),
      builder: (context, box, index) {
        final tasks = box.values.toList().cast<UserModel>();
        final unfinishedTasks = tasks.where((task) => !task.isCompleted);

        return ListView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: unfinishedTasks
              .map((fav) => Task(
                    userModel: fav,
                  ))
              .toList(),
        );
      },
    );
  }

  Widget dateTimeline() {
    return DatePicker(
      DateTime.now(),
      height: 100,
      width: 70,
      daysCount: 10,
      initialSelectedDate: DateTime.now(),
      selectionColor: Colors.deepPurple,
      selectedTextColor: Colors.white,
      monthTextStyle: GoogleFonts.quicksand(
        fontSize: 11,
        color: Colors.grey,
        fontWeight: FontWeight.w600,
      ),
      dayTextStyle: GoogleFonts.quicksand(
        fontSize: 14,
        color: Colors.grey,
        fontWeight: FontWeight.w600,
      ),
      dateTextStyle: GoogleFonts.quicksand(
        fontSize: 25,
        color: Colors.grey[500],
        fontWeight: FontWeight.w600,
      ),
      onDateChange: (date) {
        setState(() {
          _date = date;
        });
      },
    );
  }

  Widget rowDate() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              showText(DateFormat.yMMMMd().format(DateTime.now()), Colors.grey),
              showText("Today", Colors.black87)
            ],
          ),
          Expanded(child: Container()),
          showButton("Add", () => Get.to(() => const Add()))
        ],
      ),
    );
  }

  Widget showField(
    TextEditingController controller,
    String hint,
  ) {
    return Flexible(
      flex: 1,
      child: TextFormField(
        focusNode: _focusNode,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 255, 255, 255),
                width: 1.0,
              ),
            ),
            filled: true,
            hintStyle: GoogleFonts.quicksand(
                fontSize: 16,
                color: Colors.black38,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.001),
            focusColor: Colors.red,
            hintText: hint,
            fillColor: Colors.white),
        controller: controller,
      ),
    );
  }

  Widget showButton(String text, Function() onPressed) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.065,
      width: MediaQuery.of(context).size.width * 0.4,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(1),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
            Theme.of(context).primaryColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add,
              size: 15,
              color: Colors.white,
            ),
            Text(text,
                style: GoogleFonts.quicksand(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget showTitle(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.quicksand(
          fontSize: 25, color: Colors.black38, fontWeight: FontWeight.bold),
    );
  }

  Widget showText(String text, Color color) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.quicksand(
          fontSize: 22, color: color, fontWeight: FontWeight.w600),
    );
  }
}
