import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Model/UserModel.dart';
import '../main.dart';

class Complete extends StatefulWidget {
  final UserModel userModel;
  const Complete({Key? key, required this.userModel}) : super(key: key);

  @override
  State<Complete> createState() => _CompleteState();
}

class _CompleteState extends State<Complete> {
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 3),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          height: size.height * 0.16,
          width: double.infinity,
          decoration: BoxDecoration(
              color: widget.userModel.color == 0
                  ? Colors.deepPurple
                  : widget.userModel.color == 1
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
                    showText(widget.userModel.name, Colors.white),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        showText(widget.userModel.startTime, Colors.white),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: showText("---", Colors.white),
                        ),
                        showText(widget.userModel.endTime, Colors.white),
                      ],
                    ),
                    const SizedBox(height: 2),
                    SizedBox(
                        width: size.width * 0.75,
                        child: showText(
                            widget.userModel.description, Colors.white)),
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
                  widget.userModel.isCompleted == false ? "TASKS" : "DONE",
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
        ),
        Positioned(
            top: 10,
            right: 10,
            child: InkWell(
                onTap: () => delete(widget.userModel),
                child: const Icon(
                  Icons.clear,
                  size: 20,
                  color: Colors.white,
                ))),
        Positioned(
            bottom: 10,
            right: 10,
            child: InkWell(
                onTap: () => rollBack(widget.userModel),
                child: const Icon(
                  Icons.keyboard_backspace_rounded,
                  size: 20,
                  color: Colors.white,
                ))),
      ],
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

  delete(UserModel task) {
    task.delete();
    flutterLocalNotificationsPlugin.show(
        0,
        task.name,
        "Task has been deleted",
        NotificationDetails(
            android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.high,
          color: Colors.blue,
          playSound: true,
          icon: 'logo',
        )));
  }

  rollBack(UserModel task) {
    task.isCompleted = false;
    task.save();
    flutterLocalNotificationsPlugin.show(
        0,
        task.name,
        "Task ${task.name} has been rolled back",
        NotificationDetails(
            android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.low,
          color: Colors.blue,
          playSound: true,
        )));
  }
}
