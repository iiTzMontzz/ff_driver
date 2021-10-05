import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:ff_driver/models_folder/driverdata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String tripStatus = '';
FirebaseUser currentuser;
Position currentPosition;
DriverData currentDriverinfo;
DatabaseReference tripRef;
DatabaseReference tripRequestRef;
double ratings = 0.0;
bool flag = true;
StreamSubscription<Position> hometabPositionStream;
StreamSubscription<Position> tripPositionStream;
final assetsAudioPlayer = AssetsAudioPlayer();
final CameraPosition initialposition = CameraPosition(
  target: LatLng(7.1907, 125.4553),
  zoom: 14.4746,
);
