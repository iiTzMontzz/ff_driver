import 'package:ff_driver/authentication_folder/car_details.dart';
import 'package:ff_driver/authentication_folder/login.dart';
import 'package:ff_driver/authentication_folder/sign_up.dart';
import 'package:ff_driver/screens_folder/_front/get_started.dart';
import 'package:ff_driver/screens_folder/_front/home.dart';
import 'package:ff_driver/wrapper_folder/onReview.dart';
import 'package:ff_driver/wrapper_folder/upassenger.dart';
import 'package:ff_driver/wrapper_folder/user_wrapper.dart';
import 'package:ff_driver/wrapper_folder/wrapper.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  '/intro': (BuildContext context) => GetStartedIntro(),
  '/login': (BuildContext context) => Login(),
  '/signup': (BuildContext context) => Signup(),
  '/home': (BuildContext context) => Home(),
  '/onreview': (BuildContext context) => OnReview(),
  '/upassnger': (BuildContext context) => UPassnger(),
  '/userwrapper': (BuildContext context) => UserWrapper(),
  '/wrapper': (BuildContext context) => Wrapper(),
  '/cardetails': (BuildContext context) => CarDetails(),
};
