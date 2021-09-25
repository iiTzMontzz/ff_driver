import 'package:ff_driver/services_folder/_database/app_data.dart';
import 'package:ff_driver/shared_folder/_buttons/divider.dart';
import 'package:ff_driver/shared_folder/_constants/FadeAnimation.dart';
import 'package:ff_driver/shared_folder/_constants/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Earnings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            color: Colors.blue[400],
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
                  FadeAnimation(
                    1.8,
                    Text(
                      'Total Earnings',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Muli',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  FadeAnimation(
                    1.9,
                    Text(
                      'Php ${Provider.of<AppData>(context).earnings}',
                      style: TextStyle(
                          color: Colors.black87,
                          fontFamily: 'Muli',
                          fontSize: 45,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
          FadeAnimation(2, CustomDivider()),
          FadeAnimation(
              1.5,
              FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/deposit.png',
                        color: Colors.blue[300],
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
              )),
          FadeAnimation(1.9, CustomDivider()),
        ],
      ),
    );
  }
}
