import 'dart:io';
import 'package:ff_driver/models_folder/user.dart';
import 'package:ff_driver/shared_folder/_constants/FadeAnimation.dart';
import 'package:ff_driver/shared_folder/_constants/progressDialog.dart';
import 'package:ff_driver/shared_folder/_constants/size_config.dart';
import 'package:ff_driver/shared_folder/_constants/splash.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class UploadLisence extends StatefulWidget {
  @override
  _UploadLisenceState createState() => _UploadLisenceState();
}

class _UploadLisenceState extends State<UploadLisence> {
  String imageUrl;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    SizeConfig().init(context);
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          FadeAnimation(
              2,
              Text(
                "Liscense Image",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(28),
                  fontWeight: FontWeight.bold,
                ),
              )),
          SizedBox(height: SizeConfig.screenHeight * 0.12),
          (imageUrl != null)
              ? Center(
                  child: Container(
                    height: 300,
                    width: 300,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Center(
                  child: RaisedButton(
                    onPressed: () {
                      chooseImage(user.uid);
                    },
                    child: Text('Choose Image'),
                    color: Colors.lightBlue,
                  ),
                ),
          SizedBox(height: getProportionateScreenHeight(15)),
          (imageUrl != null)
              ? Column(children: [
                  RaisedButton(
                    onPressed: () {
                      chooseImage(user.uid);
                    },
                    child: Text('Choose Image'),
                    color: Colors.lightBlue,
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              Splash(route: '/frontcarview')));
                    },
                    child: Text('Proceed'),
                    color: Colors.lightBlue,
                  ),
                ])
              : SizedBox(height: getProportionateScreenHeight(20)),
        ],
      ),
    );
  }

  chooseImage(String uid) async {
    final _picker = ImagePicker();
    final _storage = FirebaseStorage.instance;
    PickedFile imageLiscense;
    //Permissions
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      //Select Image
      imageLiscense = await _picker.getImage(source: ImageSource.gallery);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) =>
              ProgressDialog(status: 'Uploading.....'));
      //Upload to firebase
      var file = File(imageLiscense.path);
      if (imageLiscense != null) {
        var snapshot = await _storage
            .ref()
            .child('lisencesImages/$uid')
            .putFile(file)
            .onComplete;
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
        });
      } else {
        print('No image path');
      }
      Navigator.of(context).pop();
    } else {
      print('Permission Denied');
    }
  }
}
