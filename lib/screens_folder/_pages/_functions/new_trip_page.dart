import 'dart:async';
import 'package:ff_driver/messeging/chatroom_list.dart';
import 'package:ff_driver/models_folder/trip_details.dart';
import 'package:ff_driver/screens_folder/_pages/_functions/payments_dialog.dart';
import 'package:ff_driver/screens_folder/_pages/_widgets/canceled_trip.dart';
import 'package:ff_driver/services_folder/_helper/helper_method.dart';
import 'package:ff_driver/services_folder/_helper/map_kit_helper.dart';
import 'package:ff_driver/shared_folder/_buttons/main_button.dart';
import 'package:ff_driver/shared_folder/_constants/progressDialog.dart';
import 'package:ff_driver/shared_folder/_constants/size_config.dart';
import 'package:ff_driver/shared_folder/_global/global_var.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewTripPage extends StatefulWidget {
  final TripDetails tripDetails;

  const NewTripPage({Key key, this.tripDetails}) : super(key: key);
  @override
  _NewTripPageState createState() => _NewTripPageState();
}

class _NewTripPageState extends State<NewTripPage> {
  GoogleMapController tripMapController;
  Completer<GoogleMapController> _controller = Completer();
  StreamSubscription<Event> tripSubscription;
  Set<Marker> _markers = Set<Marker>();
  Set<Circle> _circles = Set<Circle>();
  Set<Polyline> _polylines = Set<Polyline>();
  String durationString = '';
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Position myPosition;
  BitmapDescriptor movingMarkerIcon;
  double mapPaddingBottom = 0;
  String status = 'Accepted';
  bool isRequestedDirection = false;
  String buttonTitle = 'Arrived';
  Color buttoncolor = Colors.blueAccent[400];
  Timer timer;
  int durationCounter = 0;
  var geolocator = Geolocator();
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.bestForNavigation);

// Accepting trip when opening new trip page
  @override
  void initState() {
    super.initState();
    acceptTrip();
    HelperMethod.disableHomeTabLocationUpdates(currentDriverinfo.id);
  }

  @override
  Widget build(BuildContext context) {
    createMarker();
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(
                bottom: getProportionateScreenHeight(mapPaddingBottom)),
            compassEnabled: true,
            mapType: MapType.normal,
            circles: _circles,
            markers: _markers,
            polylines: _polylines,
            onMapCreated: onMapCreated,
            trafficEnabled: false,
            initialCameraPosition: initialposition,
          ),
          //New Trip Pannel
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15.0,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0.7,
                        0.7,
                      ),
                    ),
                  ]),
              height: getProportionateScreenHeight(360),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 18.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            durationString,
                            style: TextStyle(
                              fontFamily: 'Muli',
                              fontSize: getProportionateScreenHeight(16),
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(5)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                (widget.tripDetails != null)
                                    ? widget.tripDetails.passengerName
                                    : 'Passenger Name',
                                style: TextStyle(
                                  fontFamily: 'Muli',
                                  fontSize: getProportionateScreenHeight(24),
                                  fontWeight: FontWeight.w800,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: GestureDetector(
                                  child: Icon(Icons.call),
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) =>
                                            ChatRoomList(
                                                tripID: tripRef.key,
                                                passenger: widget.tripDetails
                                                    .passengerName));
                                    print("TRIP ID: " + tripRef.key);
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: getProportionateScreenHeight(25)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset('assets/images/rec.png',
                                  height: getProportionateScreenHeight(16),
                                  width: getProportionateScreenWidth(16)),
                              SizedBox(width: getProportionateScreenWidth(18)),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    (widget.tripDetails != null)
                                        ? widget.tripDetails.pickupAddress
                                        : 'Pick Up Address',
                                    style: TextStyle(
                                        fontFamily: 'Muli',
                                        fontSize:
                                            getProportionateScreenHeight(20)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: getProportionateScreenHeight(15)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset('assets/images/pin.png',
                                  height: getProportionateScreenHeight(16),
                                  width: getProportionateScreenWidth(16)),
                              SizedBox(width: getProportionateScreenWidth(18)),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    (widget.tripDetails != null)
                                        ? widget.tripDetails.destinationAddress
                                        : 'Destination Address',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontFamily: 'Muli',
                                        fontSize:
                                            getProportionateScreenHeight(20)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: getProportionateScreenHeight(25)),
                          MainButton(
                            title: buttonTitle,
                            color: buttoncolor,
                            onpress: () async {
                              HelperMethod.disableHomeTabLocationUpdates(
                                  currentDriverinfo.id);
                              if (status == 'Accepted') {
                                status = 'Arrived';
                                tripRef.child('status').set('Arrived');
                                setState(() {
                                  buttonTitle = 'Start';
                                  buttoncolor = Colors.greenAccent[400];
                                });
                                HelperMethod.showprogressDialog(
                                    context, 'Getting Directions....');
                                await getDirections(
                                    widget.tripDetails.pickupLatLng,
                                    widget.tripDetails.destinationLatLng);
                                Navigator.of(context).pop();
                              } else if (status == 'Arrived') {
                                status = 'OnTrip';
                                tripRef.child('status').set('OnTrip');
                                setState(() {
                                  buttonTitle = 'End';
                                  buttoncolor = Colors.redAccent[400];
                                });
                                startTimer();
                              } else if (status == 'OnTrip') {
                                endTrip(currentDriverinfo.id);
                              }
                            },
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ), //New T
        ],
      ),
    );
  }

  //Updating map controller when the widget is opened
  void onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    tripMapController = controller;
    setState(() {
      mapPaddingBottom = getProportionateScreenHeight(320);
    });
    var currentLatLng =
        LatLng(currentPosition.latitude, currentPosition.longitude);
    var pickupLatLng = widget.tripDetails.pickupLatLng;
    await getDirections(currentLatLng, pickupLatLng);
    getlocationUpdate();
  }

  //Getting destination details
  Future<void> getDirections(
      LatLng pickupLatLng, LatLng destinationLatLng) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            ProgressDialog(status: 'Getting Directions.....'));
    var thisDetails =
        await HelperMethod.getDirectionDetails(pickupLatLng, destinationLatLng);
    Navigator.of(context).pop();
    PolylinePoints polylinepoints = PolylinePoints();
    List<PointLatLng> result =
        polylinepoints.decodePolyline(thisDetails.encodedPoints);
    polylineCoordinates.clear();
    if (result.isNotEmpty) {
      //Looping through the encoded points to convert into polyline points
      result.forEach((PointLatLng points) {
        polylineCoordinates.add(LatLng(points.latitude, points.longitude));
      });
    }
    _polylines.clear();
    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId('polyID'),
        color: Colors.blueAccent[700],
        points: polylineCoordinates,
        jointType: JointType.round,
        width: 6,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      _polylines.add(polyline);
    });
    //Fitting polyline points in the map after picking a destination adrress
    LatLngBounds bounds;
    if (pickupLatLng.latitude > destinationLatLng.latitude &&
        pickupLatLng.longitude > destinationLatLng.longitude) {
      bounds =
          LatLngBounds(southwest: destinationLatLng, northeast: pickupLatLng);
    } else if (pickupLatLng.longitude > destinationLatLng.longitude &&
        pickupLatLng.longitude > destinationLatLng.longitude) {
      bounds = LatLngBounds(
        southwest: LatLng(pickupLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, pickupLatLng.longitude),
      );
    } else if (pickupLatLng.latitude > destinationLatLng.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, pickupLatLng.longitude),
        northeast: LatLng(pickupLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      bounds = LatLngBounds(
        southwest: pickupLatLng,
        northeast: destinationLatLng,
      );
    }
    tripMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
    //Markers
    Marker pickupMarker = Marker(
      markerId: MarkerId('pickup'),
      position: pickupLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );
    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      _markers.add(pickupMarker);
      _markers.add(destinationMarker);
    });
    //Cricles
    Circle pickupCircle = Circle(
      circleId: CircleId('pickup'),
      strokeColor: Colors.green,
      strokeWidth: 3,
      radius: 12,
      center: pickupLatLng,
      fillColor: Colors.green,
    );
    Circle destinationCircle = Circle(
      circleId: CircleId('destination'),
      strokeColor: Colors.purpleAccent,
      strokeWidth: 3,
      radius: 12,
      center: destinationLatLng,
      fillColor: Colors.purpleAccent,
    );

    setState(() {
      _circles.add(pickupCircle);
      _circles.add(destinationCircle);
    });
  }

//Accepting Trip Request
  void acceptTrip() {
    String tripID = widget.tripDetails.tripId;
    tripRef =
        FirebaseDatabase.instance.reference().child('rideRequest/$tripID');
    tripRef.child('status').set('Accepted');
    tripRef.child('driver_name').set(currentDriverinfo.fullName);
    tripRef
        .child('vehicle_detail')
        .set('${currentDriverinfo.carColor} - ${currentDriverinfo.carModel}');
    tripRef.child('driver_phone').set(currentDriverinfo.phone);
    tripRef.child('driver_id').set(currentDriverinfo.id);
    tripRef.child('plate_no').set(currentDriverinfo.plateNumber);
    Map locationMap = {
      'lat': currentPosition.latitude.toString(),
      'lng': currentPosition.longitude.toString(),
    };
    tripRef.child('driver_location').set(locationMap);

    //Check if there is changes during Going to pick up location
    tripSubscription = tripRef.onValue.listen((event) async {
      //Checking if event is null
      if (event.snapshot.value == null) {
        return;
      }
      //Check if status is not null
      if (event.snapshot.value['status'] != null) {
        setState(() {
          tripStatus = event.snapshot.value['status'].toString();
        });
      }
      //Check Trip Status if canceled
      if (tripStatus == 'Canceled') {
        tripPositionStream.cancel();
        tripPositionStream = null;
        var response = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => TripCanceled());

        if (response == 'tripCanceled') {
          tripRef.onDisconnect();
          tripRef = null;
          tripSubscription.cancel();
          tripSubscription = null;
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context).pushReplacementNamed('/wrapper');
        }
      }
    });

    DatabaseReference historyRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentDriverinfo.id}/history/$tripID');
    historyRef.set(true);
  }

//Create Moving Markers
  void createMarker() {
    if (movingMarkerIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/images/paw-print.png')
          .then((icon) {
        movingMarkerIcon = icon;
      });
    }
  }

// /Get Location Update of the driver
  void getlocationUpdate() {
    HelperMethod.disableHomeTabLocationUpdates(currentDriverinfo.id);
    print('Diara ohh');
    LatLng oldPosition = LatLng(0, 0);
    tripPositionStream = geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      myPosition = position;
      currentPosition = position;
      LatLng pos = LatLng(position.latitude, position.longitude);

      var rotation = MapKitHelper.getMarkerRotation(oldPosition.latitude,
          oldPosition.longitude, pos.latitude, pos.longitude);
      Marker movingmarker = Marker(
          markerId: MarkerId('moving'),
          position: pos,
          icon: movingMarkerIcon,
          rotation: rotation,
          infoWindow: InfoWindow(title: 'Current Location'));
      setState(() {
        CameraPosition cp = new CameraPosition(target: pos, zoom: 18);
        tripMapController.animateCamera(CameraUpdate.newCameraPosition(cp));
        _markers.removeWhere((marker) => marker.markerId.value == 'moving');
        _markers.add(movingmarker);
      });
      oldPosition = pos;
      updateTripDetails();
      Map locationMap = {
        'lat': myPosition.latitude.toString(),
        'lng': myPosition.longitude.toString()
      };
      tripRef.child('driver_location').set(locationMap);
    });
  }

//Update Trip Detais
  void updateTripDetails() async {
    HelperMethod.disableHomeTabLocationUpdates(currentDriverinfo.id);
    if (!isRequestedDirection) {
      isRequestedDirection = true;
      if (myPosition == null) {
        return;
      }
      var positionLatLng = LatLng(myPosition.latitude, myPosition.longitude);
      LatLng destinationLatLng;
      if (status == 'Accepted') {
        destinationLatLng = widget.tripDetails.pickupLatLng;
      } else {
        destinationLatLng = widget.tripDetails.destinationLatLng;
      }
      var directionDetails = await HelperMethod.getDirectionDetails(
          positionLatLng, destinationLatLng);
      if (directionDetails != null) {
        setState(() {
          durationString = directionDetails.durationText;
        });
      }
      isRequestedDirection = false;
    }
  }

//Trip Time Duration
  void startTimer() {
    HelperMethod.disableHomeTabLocationUpdates(currentDriverinfo.id);
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer) {
      durationCounter++;
    });
  }

//Edning Trip
  void endTrip(String uid) async {
    HelperMethod.disableHomeTabLocationUpdates(currentDriverinfo.id);
    timer.cancel();
    HelperMethod.showprogressDialog(context, 'Calculating fares....');
    var currentLatLng = LatLng(myPosition.latitude, myPosition.longitude);
    var directionDetails = await HelperMethod.getDirectionDetails(
        widget.tripDetails.pickupLatLng, currentLatLng);
    Navigator.of(context).pop();
    int fares = HelperMethod.estimatedFare(directionDetails, durationCounter);
    tripRef.child('fare').set(fares.toString());
    tripRef.child('status').set('Ended');
    tripPositionStream.cancel();
    tripPositionStream = null;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => PaymentsDialog(
              fare: fares,
              tripDetails: widget.tripDetails,
            ));
  }
}
