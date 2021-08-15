import 'package:ff_driver/authentication_folder/sign_up.dart';
import 'package:ff_driver/models_folder/person.dart';
import 'package:ff_driver/models_folder/user.dart';
import 'package:ff_driver/screens_folder/_pages/home.dart';
import 'package:ff_driver/services_folder/_database/data.dart';
import 'package:ff_driver/wrapper_folder/onReview.dart';
import 'package:ff_driver/wrapper_folder/upassenger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserWrapper extends StatefulWidget {
  @override
  _UserWrapperState createState() => _UserWrapperState();
}

class _UserWrapperState extends State<UserWrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    return StreamBuilder<Person>(
      stream: Data(uid: user.uid).persons,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.type == 'Driver') {
            if (snapshot.data.availability == 'Enabled') {
              return Home();
            } else {
              return OnReview();
            }
          } else {
            return UPassnger();
          }
        } else {
          return Signup();
        }
      },
    );
  }
}
