import 'package:ff_driver/screens_folder/_pages/_widgets/_history/history_page.dart';
import 'package:ff_driver/services_folder/_database/app_data.dart';
import 'package:ff_driver/shared_folder/_buttons/divider.dart';
import 'package:ff_driver/shared_folder/_constants/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TripHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
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
            color: Colors.blue[300],
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Text('Past Trips',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Muli',
                          fontSize: 45,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
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
                  Image.asset(
                    'assets/images/destination.png',
                    width: getProportionateScreenWidth(70),
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
}
