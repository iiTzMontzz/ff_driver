import 'package:ff_driver/models_folder/trip_details.dart';
import 'package:ff_driver/models_folder/user.dart';
import 'package:ff_driver/screens_folder/_pages/_functions/new_trip_page.dart';
import 'package:ff_driver/screens_folder/_pages/_widgets/trip_declined.dart';
import 'package:ff_driver/services_folder/_helper/helper_method.dart';
import 'package:ff_driver/shared_folder/_buttons/second_button.dart';
import 'package:ff_driver/shared_folder/_constants/progressDialog.dart';
import 'package:ff_driver/shared_folder/_constants/size_config.dart';
import 'package:ff_driver/shared_folder/_global/global_var.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TripNotification extends StatefulWidget {
  final TripDetails tripDetails;
  const TripNotification({Key key, this.tripDetails}) : super(key: key);

  @override
  _TripNotificationState createState() => _TripNotificationState();
}

class _TripNotificationState extends State<TripNotification> {
  @override
  void initState() {
    super.initState();
    HelperMethod.disableHomeTabLocationUpdates(currentDriverinfo.id);
  }

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
              (widget.tripDetails.rideType == 'Normal')
                  ? 'assets/images/normal.gif'
                  : 'assets/images/pet.gif',
              height: getProportionateScreenHeight(50),
              width: getProportionateScreenWidth(50),
            ),
            SizedBox(height: getProportionateScreenHeight(16)),
            Text(
              'Type: ' + widget.tripDetails.rideType,
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
                            widget.tripDetails.pickupAddress,
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
                            widget.tripDetails.destinationAddress,
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
                        onPressed: () {
                          Navigator.of(context).pop();
                          assetsAudioPlayer.stop();
                          DatabaseReference declinetrip = FirebaseDatabase
                              .instance
                              .reference()
                              .child('drivers/${currentDriverinfo.id}/newTrip');
                          declinetrip.set('waiting');
                          HelperMethod.disableHomeTabLocationUpdates(
                              currentDriverinfo.id);
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) => TripDecline(
                                    title: 'Trip Declined',
                                    description:
                                        'Youve\'ve just Declined a Trip \n as penalty and to give chance to others you can go online in 1 minute',
                                    respo: 'decline',
                                  ));
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
    newTripRef.once().then((DataSnapshot snapshot) async {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      String thisTripID = '';
      if (snapshot.value != null) {
        thisTripID = snapshot.value.toString();
      } else {
        assetsAudioPlayer.stop();
        var response = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => TripDecline(
                  title: 'Trip Notification',
                  description: 'Trip ID not found',
                  respo: 'notfound',
                ));
        if (response == 'notfound') {
          newTripRef.set('waiting');
          HelperMethod.enableHomeTabLocationUpdatess(currentDriverinfo.id);
        }
      }
      if (thisTripID == widget.tripDetails.tripId) {
        assetsAudioPlayer.stop();
        newTripRef.set('Accepted');
        print("Trip Accepted");
        HelperMethod.disableHomeTabLocationUpdates(currentDriverinfo.id);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                NewTripPage(tripDetails: widget.tripDetails)));
        //Trip has been canceled
      } else if (thisTripID == 'Canceled') {
        assetsAudioPlayer.stop();
        var response = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => TripDecline(
                  title: 'Trip Notification',
                  description: 'Trip Request has been canceled',
                  respo: 'canceledout',
                ));
        if (response == 'canceledout') {
          newTripRef.set('waiting');
          HelperMethod.enableHomeTabLocationUpdatess(currentDriverinfo.id);
        }
        assetsAudioPlayer.stop();
        //Trip Timed out
      } else if (thisTripID == 'timeout') {
        assetsAudioPlayer.stop();
        var response = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => TripDecline(
                  title: 'Trip Notification',
                  description: 'Trip Request timed out',
                  respo: 'timedout',
                ));
        if (response == 'timedout') {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed('/wrapper');
        }
        assetsAudioPlayer.stop();
      } else {
        assetsAudioPlayer.stop();
        var response = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => TripDecline(
                  title: 'Trip Notification',
                  description: 'Trip ID not found',
                  respo: 'notfound',
                ));
        if (response == 'notfound') {
          newTripRef.set('waiting');
          HelperMethod.enableHomeTabLocationUpdatess(currentDriverinfo.id);
        }
      }
    });
  }
}
