import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:ff_driver/models_folder/trip_details.dart';
import 'package:ff_driver/screens_folder/_pages/_functions/trip_notification.dart';
import 'package:ff_driver/shared_folder/_constants/progressDialog.dart';
import 'package:ff_driver/shared_folder/_global/global_var.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationService {
  final FirebaseMessaging fcm = FirebaseMessaging();
//Getting Notifications from trip request
  Future initialize(context) async {
    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        getTripInfo(getTripID(message), context);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        getTripInfo(getTripID(message), context);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        getTripInfo(getTripID(message), context);
      },
    );
  }

  //Getting the user token
  Future<String> getToken() async {
    String token = await fcm.getToken();
    print('token: $token');

    DatabaseReference tokenRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentDriverinfo.id}/token');
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

  //Getting Trip Information
  void getTripInfo(String tripID, context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            ProgressDialog(status: 'Getting Info...'));
    DatabaseReference tripRef =
        FirebaseDatabase.instance.reference().child('rideRequest/$tripID');
    tripRef.once().then((DataSnapshot snapshot) {
      Navigator.of(context).pop();
      if (snapshot.value != null) {
        assetsAudioPlayer.open(Audio('assets/sounds/alert.mp3'));
        assetsAudioPlayer.play();
        double pickupLat =
            double.parse(snapshot.value['location']['lat'].toString());
        double pickupLng =
            double.parse(snapshot.value['location']['lng'].toString());
        double destinationLat =
            double.parse(snapshot.value['destination']['lat'].toString());
        double destinationLng =
            double.parse(snapshot.value['destination']['lng'].toString());
        String destinationAddress =
            snapshot.value['destination_address'].toString();
        String pickupAddress = snapshot.value['pickup_address'].toString();
        String paymentMehtod = snapshot.value['payment_method'].toString();
        String passengerName = snapshot.value['name'].toString();
        String passengerPhone = snapshot.value['phone'].toString();
        String rideType = snapshot.value['ride_type'].toString();

        print('Trip_ID Details: $tripID');
        print('Pick up Address: $pickupAddress');
        print('Destination Address: $destinationAddress');
        print('PickupLATLNG: $pickupLat && $pickupLng');
        print('DestinationLATLNG: $destinationLat && $destinationLng');
        print('Payment Method: $paymentMehtod');
        print('Passnger name: $passengerName');
        print('Passenger phone: $passengerPhone');
        print('Ride_Type: $rideType');

        TripDetails tripDetails = TripDetails();
        tripDetails.tripId = tripID;
        tripDetails.pickupAddress = pickupAddress;
        tripDetails.destinationAddress = destinationAddress;
        tripDetails.pickupLatLng = LatLng(pickupLat, pickupLng);
        tripDetails.destinationLatLng = LatLng(destinationLat, destinationLng);
        tripDetails.passengerName = passengerName;
        tripDetails.passengerPhone = passengerPhone;
        tripDetails.paymentMethod = paymentMehtod;
        tripDetails.rideType = rideType;

        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => TripNotification(
                  tripDetails: tripDetails,
                ));
      }
    });
  }
}
