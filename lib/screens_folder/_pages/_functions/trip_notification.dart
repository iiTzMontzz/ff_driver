import 'package:ff_driver/models_folder/trip_details.dart';
import 'package:ff_driver/models_folder/user.dart';
import 'package:ff_driver/screens_folder/_pages/_functions/new_trip_page.dart';
import 'package:ff_driver/services_folder/_helper/helper_method.dart';
import 'package:ff_driver/shared_folder/_buttons/second_button.dart';
import 'package:ff_driver/shared_folder/_constants/progressDialog.dart';
import 'package:ff_driver/shared_folder/_constants/size_config.dart';
import 'package:ff_driver/shared_folder/_global/global_var.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class TripNotification extends StatelessWidget {
  final TripDetails tripDetails;
  const TripNotification({Key key, this.tripDetails}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: getProportionateScreenHeight(30)),
            Image.asset(
              (tripDetails.rideType == 'Normal')
                  ? 'assets/images/normal.gif'
                  : 'assets/images/pet.gif',
              height: getProportionateScreenHeight(50),
              width: getProportionateScreenWidth(50),
            ),
            SizedBox(height: getProportionateScreenHeight(16)),
            Text(
              'Type: ' + tripDetails.rideType,
              style: TextStyle(
                  fontFamily: 'Muli',
                  fontSize: getProportionateScreenHeight(24),
                  fontWeight: FontWeight.w800),
            ),
            SizedBox(height: getProportionateScreenHeight(30)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/rec.png',
                          height: getProportionateScreenHeight(16),
                          width: getProportionateScreenWidth(16)),
                      SizedBox(width: getProportionateScreenWidth(18)),
                      Expanded(
                        child: Container(
                          child: Text(
                            tripDetails.pickupAddress,
                            style: TextStyle(
                                fontFamily: 'Muli',
                                fontSize: getProportionateScreenHeight(20)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(15)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/pin.png',
                          height: getProportionateScreenHeight(16),
                          width: getProportionateScreenWidth(16)),
                      SizedBox(width: getProportionateScreenWidth(18)),
                      Expanded(
                        child: Container(
                          child: Text(
                            tripDetails.destinationAddress,
                            style: TextStyle(
                                fontFamily: 'Muli',
                                fontSize: getProportionateScreenHeight(20)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            Divider(),
            SizedBox(height: getProportionateScreenHeight(8)),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      child: MyButton2(
                        color: Colors.red[400],
                        title: 'Decline',
                        onPressed: () async {
                          assetsAudioPlayer.stop();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: getProportionateScreenWidth(10)),
                  Expanded(
                    child: Container(
                      child: MyButton2(
                        color: Colors.greenAccent[400],
                        title: 'Accept',
                        onPressed: () async {
                          assetsAudioPlayer.stop();
                          checkAvailability(user.uid, context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(15)),
          ],
        ),
      ),
    );
  }

  void checkAvailability(String uid, context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            ProgressDialog(status: 'Accepting Trip...'));
    DatabaseReference newTripRef =
        FirebaseDatabase.instance.reference().child('drivers/$uid/newTrip');
    newTripRef.once().then((DataSnapshot snapshot) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      String thisTripID = '';
      if (snapshot.value != null) {
        thisTripID = snapshot.value.toString();
      } else {
        assetsAudioPlayer.stop();
        Toast.show("Trip Request Not Found", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
      if (thisTripID == tripDetails.tripId) {
        assetsAudioPlayer.stop();
        newTripRef.set('Accepted');
        HelperMethod.disableHomeTabLocationUpdates(uid);
        print("Trip Accepted");
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NewTripPage(tripDetails: tripDetails)));
      } else if (thisTripID == 'Canceled') {
        assetsAudioPlayer.stop();
        Toast.show("Trip Request Canceled", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else if (thisTripID == 'timeout') {
        assetsAudioPlayer.stop();
        Toast.show("Trip Request Timed out", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        assetsAudioPlayer.stop();
        Toast.show("Trip Request Not Found", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });
  }
}
