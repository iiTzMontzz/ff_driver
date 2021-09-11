import 'package:ff_driver/services_folder/_database/app_data.dart';
import 'package:ff_driver/shared_folder/_buttons/divider.dart';
import 'package:ff_driver/shared_folder/_constants/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Earnings extends StatelessWidget {
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
                  Text(
                    'Total Earnings',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Muli',
                    ),
                  ),
                  Text('Php ${Provider.of<AppData>(context).earnings}',
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
            onPressed: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/deposit.png',
                    width: getProportionateScreenWidth(70),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(16),
                  ),
                  Text(
                    'Cash-in',
                    style: TextStyle(
                        fontSize: getProportionateScreenHeight(20),
                        fontFamily: 'Muli',
                        fontWeight: FontWeight.w600),
                  ),
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
