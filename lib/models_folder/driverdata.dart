import 'package:firebase_database/firebase_database.dart';

class DriverData {
  String fullName;
  String email;
  String phone;
  String id;
  String carModel;
  String carColor;
  String plateNumber;

  DriverData({
    this.fullName,
    this.email,
    this.phone,
    this.id,
    this.carModel,
    this.carColor,
    this.plateNumber,
  });

  DriverData.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    phone = snapshot.value['phone'];
    email = snapshot.value['Email'];
    fullName = snapshot.value['FullName'];
    carModel = snapshot.value['vehicle_detail']['car_model'];
    carColor = snapshot.value['vehicle_detail']['car_color'];
    plateNumber = snapshot.value['vehicle_detail']['plate_no'];
  }
}
