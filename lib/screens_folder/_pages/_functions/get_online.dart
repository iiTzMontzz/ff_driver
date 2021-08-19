import 'dart:async';
import 'package:ff_driver/models_folder/user.dart';
import 'package:ff_driver/services_folder/_helper/helper_method.dart';
import 'package:ff_driver/shared_folder/_buttons/third_button.dart';
import 'package:ff_driver/shared_folder/_constants/size_config.dart';
import 'package:ff_driver/shared_folder/_global/confirm_status.dart';
import 'package:ff_driver/shared_folder/_global/global_var.dart';
import 'package:ff_driver/wrapper_folder/wrapper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class GetOnline extends StatefulWidget {
  @override
  _GetOnlineState createState() => _GetOnlineState();
}

class _GetOnlineState extends State<GetOnline> {
  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();
  var geolocator = Geolocator();
  var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 4);
  String titlestatus = 'OFFLINE';
  Color colorstatus = Colors.redAccent[400];
  bool isStatus = false;

  @override
  void initState() {
    super.initState();
    HelperMethod.getcurrentUserInfo(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Stack(
      children: [
        GoogleMap(
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: initialposition,
          onMapCreated: onMapCreated,
        ),
        //Back Button
        Positioned(
          top: getProportionateScreenHeight(50),
          left: getProportionateScreenWidth(20),
          child: GestureDetector(
            onTap: () {
              if (isStatus == true) {
                goOffline(user.uid);
                setState(() {
                  colorstatus = Colors.redAccent[200];
                  titlestatus = 'OFFLINE';
                  isStatus = false;
                });
                Navigator.of(context).pop();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Wrapper()));
              } else {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Wrapper()));
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7))
                  ]),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black45,
                ),
              ),
            ),
          ),
        ),

        //Offline and Online Button
        Positioned(
          left: 0,
          right: 0,
          bottom: getProportionateScreenHeight(50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyButton3(
                color: colorstatus,
                title: titlestatus,
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) => ConfirmStatus(
                            title: (!isStatus) ? 'GO ONLINE' : 'Are You Sure?',
                            subtitle: (!isStatus)
                                ? 'You are about to go Online'
                                : 'You are about to go Offline',
                            buttonColor: (!isStatus)
                                ? Colors.greenAccent[400]
                                : Colors.redAccent[400],
                            onPressed: () async {
                              if (!isStatus) {
                                goOnline(user.uid);
                                getLocationUpdate(user.uid);
                                Navigator.of(context).pop();
                                setState(() {
                                  colorstatus = Colors.greenAccent[400];
                                  titlestatus = 'ONLINE';
                                  isStatus = true;
                                });
                              } else {
                                goOffline(user.uid);
                                Navigator.of(context).pop();
                                setState(() {
                                  colorstatus = Colors.redAccent[400];
                                  titlestatus = 'OFFLINE';
                                  isStatus = false;
                                });
                              }
                            },
                          ));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  //Updating map controller when the widget is opened
  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    mapController = controller;
    getCurrentPosition();
  }

  //Getting current position
  void getCurrentPosition() async {
    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = new CameraPosition(target: pos, zoom: 16);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));
  }

//Going online using Geofire
  void goOnline(String uid) {
    Geofire.initialize('availableDrivers');
    Geofire.setLocation(
        uid, currentPosition.latitude, currentPosition.longitude);

    tripRequestRef =
        FirebaseDatabase.instance.reference().child('drivers/$uid/newTrip');
    tripRequestRef.set('waiting');

    tripRequestRef.onValue.listen((event) {});
  }

//GOing Offline
  void goOffline(String uid) {
    Geofire.removeLocation(uid);
    tripRequestRef.onDisconnect();
    tripRequestRef.remove();
    tripRequestRef = null;
  }

//Getting the location update of the driver
  void getLocationUpdate(String uid) {
    hometabPositionStream = geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      currentPosition = position;
      if (isStatus) {
        Geofire.setLocation(uid, position.latitude, position.longitude);
      }
      LatLng pos = LatLng(position.latitude, position.longitude);
      CameraPosition cp = new CameraPosition(target: pos, zoom: 16);
      mapController.animateCamera(CameraUpdate.newCameraPosition(cp));
    });
  }
}
