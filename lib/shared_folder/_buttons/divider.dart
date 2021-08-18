import 'package:ff_driver/shared_folder/_constants/size_config.dart';
import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: getProportionateScreenHeight(1),
      color: Colors.grey[300],
      thickness: 1.0,
    );
  }
}
