import 'dart:math';
import 'package:ff_driver/models_folder/direction_details.dart';
import 'package:ff_driver/models_folder/driverdata.dart';
import 'package:ff_driver/services_folder/_helper/push_notif.dart';
import 'package:ff_driver/services_folder/_helper/request_helper.dart';
import 'package:ff_driver/shared_folder/_constants/progressDialog.dart';
import 'package:ff_driver/shared_folder/_global/global_var.dart';
import 'package:ff_driver/shared_folder/_global/key.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HelperMethod {
  //Get user Information
  static void getcurrentUserInfo(context) async {
    currentuser = await FirebaseAuth.instance.currentUser();
    String uid = currentuser.uid;

    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('drivers/$uid');
    userRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        currentDriverinfo = DriverData.fromSnapshot(snapshot);
        print('HELOOO MY NAME ISSSSSS>>>>>>>>>>>' + currentDriverinfo.fullName);
      }
      PushNotificationService pushNotificationService =
          PushNotificationService();
      pushNotificationService.initialize(context);
      pushNotificationService.getToken();
    });
  }

//Gettin Trip request from the Directions APi
  static Future<DirectionDetails> getDirectionDetails(
      LatLng startPosition, LatLng endPosition) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$androidID';
    var response = await RequestHelper.getRequest(url);

    if (response == 'failed') {
      return null;
    }
    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.durationText =
        response['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durationValue =
        response['routes'][0]['legs'][0]['duration']['value'];
    directionDetails.distanceText =
        response['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue =
        response['routes'][0]['legs'][0]['distance']['value'];
    directionDetails.encodedPoints =
        response['routes'][0]['overview_polyline']['points'];
    return directionDetails;
  }

  //DIsable Geofire of the Driver
  static void disableHomeTabLocationUpdates(String uid) {
    hometabPositionStream.pause();
    Geofire.removeLocation(uid);
  }

  //Re Enable Geofire of the Driver
  static void enableHomeTabLocationUpdates(String uid) {
    hometabPositionStream.resume();
    Geofire.setLocation(
        uid, currentPosition.latitude, currentPosition.longitude);
  }

  //Generating Random Number
  static double numberGenerator(int max) {
    var randomNumber = Random();
    int randInt = randomNumber.nextInt(max);

    return randInt.toDouble();
  }

//Getting Fare
  static int estimatedFare(
      DirectionDetails directionDetails, int durationValue) {
    double baseFare = 40;
    double perKm = (directionDetails.distanceValue / 100) * 3;
    double perMin = (durationValue / 60) * 2;

    double totalFare = baseFare + perKm + perMin;
    return totalFare.truncate();
  }

// Show Progress Dialog
  static void showprogressDialog(context, String status) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ProgressDialog(
              status: status,
            ));
  }
}
