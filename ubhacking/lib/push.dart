import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class Push {
  final FirebaseMessaging messaging;

  Push(this.messaging);

  Future<void> initialize() async {
    if (Platform.isIOS) {
      messaging.requestPermission();
    }

    String token = await messaging.getToken();
    print(token);
  }
}
