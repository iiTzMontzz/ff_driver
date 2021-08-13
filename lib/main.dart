import 'package:ff_driver/screens_folder/_front/myapp.dart';
import 'package:ff_driver/shared_folder/key.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseApp.configure(
    name: dbName,
    options: const FirebaseOptions(
      googleAppID: googleID,
      apiKey: androidID,
      databaseURL: dbUrl,
    ),
  );

  runApp(MyApp());
}
