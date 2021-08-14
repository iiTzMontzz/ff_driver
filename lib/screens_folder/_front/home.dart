import 'package:ff_driver/services_folder/_database/auth.dart';
import 'package:ff_driver/shared_folder/_constants/splash.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
          child: MaterialButton(
        onPressed: () async {
          await _auth.signOut();
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Splash(route: '/wrapper')));
        },
        child: Text("Signout"),
      )),
    );
  }
}
