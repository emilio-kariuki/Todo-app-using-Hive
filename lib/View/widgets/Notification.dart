import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  PushNotificationService(this.messaging);

  Future initialise() async {
    String? token = await messaging.getToken();
    print("FirebaseMessaging token: $token");

    
  }
}
