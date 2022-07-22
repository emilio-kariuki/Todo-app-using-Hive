import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hives/Model/UserModel.dart';
import 'package:hives/View/widgets/inputField.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import 'Boxes.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final name = TextEditingController();
  final description = TextEditingController();
  final startTime = TextEditingController();
  final endTime = TextEditingController();
  int _selectedColor = 0;
  late FocusNode myFocusNode;

  String selectedDate = "select date";
  String selectedStart = "select time";
  String selectedEnd = "select time";

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                playSound: true,
                icon: 'assets/logo.png',
              ),
            ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("A new message was opened");
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                  title: Text(notification.title!),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.body!),
                    ],
                  ));
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getBack(),
                  showTitle("Add Task"),
                  const SizedBox(height: 10),
                  showText("Name", Colors.black54),
                  showField(name, "Enter your name", 1),
                  const SizedBox(height: 16),
                  showText("Name", Colors.black54),
                  showField(description, "Enter description", 4),
                  rowTime(),
                  InputField(
                    title: "Date",
                    hint: selectedDate,
                    widget: IconButton(
                      icon: const Icon(Icons.date_range),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2025),
                        ).then((date) {
                          setState(() {
                            selectedDate = DateFormat.yMMMd().format(date!);
                          });
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        colorPalette(),
                        //Expanded(child: Container()),
                        showButton("Add Task", () {
                          addTask(name.text, description.text, selectedStart,
                              selectedEnd, selectedDate, _selectedColor);

                          Get.back();
                        }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  addTask(String name, String description, String startTime, String endTime,
      String date, int color) {
    final task = UserModel(
        startTime: startTime = startTime == " " ? " " : startTime,
        endTime: endTime = endTime == " " ? " " : endTime,
        date: date = date == " " ? " " : date,
        name: name == " " ? "Task" : name,
        description: description == " " ? " " : description,
        color: color == 0 ? 0 : color,
        isCompleted: false);

    final box = Boxes.getTask();
    box.add(task);
    flutterLocalNotificationsPlugin.show(
        0,
        task.name,
        "Task Added Successfully",
        NotificationDetails(
            android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.high,
          color: Colors.blue,
          playSound: true,
          icon: '@mipmap/logo',
        )));
  }

  Widget colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showText("Color", Colors.black54),
        const SizedBox(height: 3),
        Wrap(
          children: List.generate(
              3,
              (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = index;
                        print(_selectedColor);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 3),
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: index == 0
                            ? Colors.deepPurple
                            : index == 1
                                ? Colors.orangeAccent
                                : Colors.pink,
                        child: _selectedColor == index
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              )
                            : Container(),
                      ),
                    ),
                  )),
        ),
      ],
    );
  }

  Widget rowTime() {
    return Row(
      children: [
        Expanded(
          child: InputField(
            title: "Start Time",
            hint: selectedStart,
            widget: IconButton(
              icon: const Icon(Icons.access_time),
              onPressed: () async {
                // showTimePicker(
                //   context: context,
                //   initialTime: TimeOfDay.now(),
                // ).then((time) {
                //   setState(() {
                //     selectedEnd = tim
                //   });
                // });
                String? token = await FirebaseMessaging.instance.getToken();
                print('token: $token');
                FocusScope.of(context).requestFocus(FocusNode());
                final TimeOfDay? result = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (context, child) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          alwaysUse24HourFormat: true,
                        ),
                        child: child!,
                      );
                    });
                if (result != null) {
                  setState(() {
                    selectedStart = result.format(context);
                  });
                }
              },
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: InputField(
            title: "End Time",
            hint: selectedEnd,
            widget: IconButton(
              icon: const Icon(Icons.access_time),
              onPressed: () async {
                // showTimePicker(
                //   context: context,
                //   initialTime: TimeOfDay.now(),
                // ).then((time) {
                //   setState(() {
                //     selectedEnd = tim
                //   });
                // });
                final TimeOfDay? result = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (context, child) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          alwaysUse24HourFormat: true,
                        ),
                        child: child!,
                      );
                    });
                if (result != null) {
                  setState(() {
                    selectedEnd = result.format(context);
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget showField(
    TextEditingController? controller,
    String hint,
    int maxLength,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
          height: 50,
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            maxLines: maxLength,
            autofocus: false,
            cursorColor: Colors.grey,
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.quicksand(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 0,
                ),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 0,
                ),
              ),
            ),
          )),
    );
  }

  Widget showText(String text, Color color) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.quicksand(
        fontSize: 14,
        fontWeight: FontWeight.w600,
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
}
