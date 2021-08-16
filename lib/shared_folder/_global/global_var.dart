import 'dart:async';
import 'package:ff_driver/models_folder/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

FirebaseUser currentuser;
UserData currentUserinfo;
Position currentPosition;
DatabaseReference tripRequestRef;
StreamSubscription<Position> hometabPositionStream;
final CameraPosition initialposition = CameraPosition(
  target: LatLng(7.1907, 125.4553),
  zoom: 14.4746,
);
