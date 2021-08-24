import 'package:ff_driver/models_folder/trip_details.dart';
import 'package:ff_driver/services_folder/_helper/helper_method.dart';
import 'package:ff_driver/shared_folder/_buttons/divider.dart';
import 'package:ff_driver/shared_folder/_buttons/main_button.dart';
import 'package:ff_driver/shared_folder/_constants/progressDialog.dart';
import 'package:ff_driver/shared_folder/_constants/size_config.dart';
import 'package:ff_driver/shared_folder/_global/global_var.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PaymentsDialog extends StatelessWidget {
  final int fare;
  final TripDetails tripDetails;

  const PaymentsDialog({this.fare, this.tripDetails});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            Text('Total Payment'),
            SizedBox(height: getProportionateScreenHeight(20)),
            CustomDivider(),
            SizedBox(height: getProportionateScreenHeight(30)),
            Text(
              'Php $fare',
              style: TextStyle(
                fontFamily: 'Muli',
                fontSize: getProportionateScreenHeight(50),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(16)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Total Fare',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(30)),
            Container(
              width: getProportionateScreenWidth(230),
              child: MainButton(
                title: 'Payment Accepted',
                color: Colors.greenAccent[400],
                onpress: () async {
                  topUpEarnings(fare, context);
                },
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(40)),
          ],
        ),
      ),
    );
  }

  //Saving Eranings
  void topUpEarnings(int fares, context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            ProgressDialog(status: 'Recieving Payment...'));
    DatabaseReference earningsRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentDriverinfo.id}/earnings');
    earningsRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        double pastEarnings = double.parse(snapshot.value.toString());
        double adjustedEarnings = (fares.toDouble() * 0.85) + pastEarnings;
        earningsRef.set(adjustedEarnings.toStringAsFixed(2));
      } else {
        double adjustedEarnings = (fares.toDouble() * 0.85);
        earningsRef.set(adjustedEarnings.toStringAsFixed(2));
      }

      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      HelperMethod.enableHomeTabLocationUpdates(currentDriverinfo.id);
    });
  }
}
