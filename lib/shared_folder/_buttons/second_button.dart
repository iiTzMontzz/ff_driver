import 'package:ff_driver/shared_folder/_constants/size_config.dart';
import 'package:flutter/material.dart';

class MyButton2 extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Color color;
  MyButton2({this.title, this.onPressed, this.color});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(25),
          ),
          primary: color,
          onPrimary: Colors.white),
      onPressed: onPressed,
      child: Container(
        height: getProportionateScreenHeight(50),
        width: getProportionateScreenWidth(200),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                fontFamily: 'Muli',
                fontSize: getProportionateScreenHeight(20),
                fontWeight: FontWeight.w900),
          ),
        ),
      ),
    );
  }
}
