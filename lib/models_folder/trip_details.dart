import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetails {
  String pickupAddress;
  String destinationAddress;
  LatLng pickupLatLng;
  LatLng destinationLatLng;
  String tripId;
  String paymentMethod;
  String passengerName;
  String passengerPhone;
  String rideType;

  TripDetails({
    this.pickupAddress,
    this.destinationAddress,
    this.pickupLatLng,
    this.destinationLatLng,
    this.tripId,
    this.paymentMethod,
    this.passengerName,
    this.passengerPhone,
    this.rideType,
  });
}
