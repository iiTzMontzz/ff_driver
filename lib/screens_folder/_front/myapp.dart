import 'package:ff_driver/models_folder/user.dart';
import 'package:ff_driver/screens_folder/_front/routes.dart';
import 'package:ff_driver/services_folder/_database/app_data.dart';
import 'package:ff_driver/services_folder/_database/auth.dart';
import 'package:ff_driver/shared_folder/_constants/theme.dart';
import 'package:ff_driver/wrapper_folder/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(value: AuthService().user),
        ChangeNotifierProvider(create: (context) => AppData()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme(),
        home: Wrapper(),
        routes: routes,
      ),
    );
  }
}
