import 'package:ff_driver/shared_folder/_global/global_var.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging fcm = FirebaseMessaging();
//Getting Notifications from trip request
  Future initialize() async {
    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  //Getting the user token
  Future<String> getToken() async {
    String token = await fcm.getToken();
    print('token: $token');

    DatabaseReference tokenRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentuser.uid}/token');
    tokenRef.set(token);

    fcm.subscribeToTopic('alldrivers');
    fcm.subscribeToTopic('allusers');
    return token;
  }

  //getting Trip Id
  String getTripID(Map<String, dynamic> message) {
    String tripId = message['data']['Trip_Id'];
    print('Trip_ID: $tripId');
    return tripId;
  }
}
