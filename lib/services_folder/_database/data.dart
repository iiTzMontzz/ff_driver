import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ff_driver/models_folder/driver.dart';
import 'package:ff_driver/models_folder/person.dart';
import 'package:ff_driver/models_folder/vehicle.dart';

class Data {
  final String uid;
  Data({this.uid});
  final _db = Firestore.instance;

  //Add Pesron
  Future addPerson(String type, String availability) async {
    return await _db
        .collection('Persons')
        .document(uid)
        .setData({'uid': uid, 'Type': type, 'Availability': availability});
  }

//DocumentSnapshot person
  Person _person(DocumentSnapshot snapshot) {
    return Person(
        uid: uid,
        type: snapshot.data['Type'],
        availability: snapshot.data['Availability']);
  }

  //Stream Person
  Stream<Person> get persons {
    return _db.collection('Persons').document(uid).snapshots().map(_person);
  }

  //Add Driver
  Future addDriver(
      String fullname, String email, String phone, String cartype) async {
    return await _db.collection('Drivers').document(uid).setData({
      'uid': uid,
      'Fullname': fullname,
      'Email': email,
      'phone': phone,
      'carType': cartype,
    });
  }

  //DocumentSnapshot Driver
  Driver _drivers(DocumentSnapshot snapshot) {
    return Driver(
        uid: uid,
        fullname: snapshot.data['Fullname'],
        email: snapshot.data['Email'],
        phone: snapshot.data['phone']);
  }

  //Stream Driver
  Stream<Driver> get driverData {
    return _db.collection('Drivers').document(uid).snapshots().map(_drivers);
  }

  //Adding Vehicle
  Future addDriverVehicle(String model, String carcolor, String plateno) async {
    return await _db
        .collection('Drivers')
        .document(uid)
        .collection('Vehicles')
        .document(uid)
        .setData({
      'uid': uid,
      'Model': model,
      'Color': carcolor,
      'plateNo': plateno,
    });
  }

  //Document Snapshot for Vehicle
  Vehicle _vehicleList(DocumentSnapshot snapshot) {
    return Vehicle(
        uid: uid,
        model: snapshot.data['Model'],
        color: snapshot.data['Color'],
        plateNo: snapshot.data['plateNo']);
  }

  //Stream for Vehicles
  Stream<Vehicle> get vehicles {
    return _db
        .collection('Drivers')
        .document(uid)
        .collection('Vehicles')
        .document(uid)
        .snapshots()
        .map(_vehicleList);
  }
}
