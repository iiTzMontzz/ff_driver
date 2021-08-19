import 'package:ff_driver/models_folder/trip_details.dart';
import 'package:ff_driver/models_folder/user.dart';
import 'package:ff_driver/shared_folder/_buttons/second_button.dart';
import 'package:ff_driver/shared_folder/_constants/size_config.dart';
import 'package:ff_driver/shared_folder/_global/global_var.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            SizedBox(height: 30),
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
                        color: Colors.grey[400],
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
                          // checkAvailability(user.uid, context);
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
}
