import 'package:ff_driver/screens_folder/_pages/_history/history_page.dart';
import 'package:ff_driver/services_folder/_database/app_data.dart';
import 'package:ff_driver/shared_folder/_buttons/divider.dart';
import 'package:ff_driver/shared_folder/_constants/size_config.dart';
import 'package:ff_driver/shared_folder/_global/global_var.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TripHistory extends StatefulWidget {
  @override
  _TripHistoryState createState() => _TripHistoryState();
}

class _TripHistoryState extends State<TripHistory> {
  DatabaseReference ratingsRef;

  @override
  void initState() {
    super.initState();
    getRatings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/wrapper');
            }),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Text('Ratings',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Muli',
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  Text(
                      (ratings != null)
                          ? ratings.toStringAsFixed(2)
                          : 'Getting ratings..',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Muli',
                          fontSize: 30,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
          CustomDivider(),
          FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HistoryPage()));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: getProportionateScreenWidth(70),
                    child: Image.asset(
                      'assets/images/destination.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(16),
                  ),
                  Text(
                    'Trips',
                    style: TextStyle(
                        fontSize: getProportionateScreenHeight(20),
                        fontFamily: 'Muli'),
                  ),
                  Expanded(
                      child: Container(
                          child: Text(
                    Provider.of<AppData>(context).tripCount.toString(),
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 18),
                  ))),
                ],
              ),
            ),
          ),
          CustomDivider(),
        ],
      ),
    );
  }

  void getRatings() {
    ratingsRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentDriverinfo.id}/ratings');
    ratingsRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        ratings = double.parse(snapshot.value);
        print(ratings);
      }
    });
  }
}
