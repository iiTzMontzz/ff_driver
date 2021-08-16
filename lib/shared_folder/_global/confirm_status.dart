import 'package:ff_driver/shared_folder/_constants/size_config.dart';
import 'package:ff_driver/shared_folder/_buttons/second_button.dart';
import 'package:flutter/material.dart';

class ConfirmStatus extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function onPressed;
  final Color buttonColor;
  ConfirmStatus({
    this.title,
    this.subtitle,
    this.onPressed,
    this.buttonColor,
  });
  @override
  Widget build(BuildContext context) {
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
            Text(
              title,
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
                      SizedBox(width: getProportionateScreenWidth(18)),
                      Expanded(
                        child: Container(
                          child: Text(
                            subtitle,
                            style: TextStyle(
                                fontFamily: 'Muli',
                                fontSize: getProportionateScreenHeight(20)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(15)),
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
                        title: 'Cancel',
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: getProportionateScreenWidth(10)),
                  Expanded(
                    child: Container(
                      child: MyButton2(
                        color: buttonColor,
                        title: 'Confirm',
                        onPressed: onPressed,
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
