import 'package:ff_driver/models_folder/user.dart';
import 'package:ff_driver/screens_folder/_front/get_started.dart';
import 'package:ff_driver/shared_folder/_constants/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user != null) {
      return Splash(route: '/userwrapper');
    } else {
      return GetStarted();
    }
  }
}
