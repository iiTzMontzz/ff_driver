import 'package:ff_driver/screens_folder/_front/get_started.dart';
import 'package:ff_driver/screens_folder/_front/routes.dart';
import 'package:ff_driver/shared_folder/_constants/theme.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme(),
      home: GetStarted(),
      routes: routes,
    );
  }
}
