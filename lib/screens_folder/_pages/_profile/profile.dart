import 'package:ff_driver/models_folder/driver.dart';
import 'package:ff_driver/screens_folder/_pages/_profile/profile_body.dart';
import 'package:ff_driver/screens_folder/_pages/_profile/profile_edit.dart';
import 'package:ff_driver/screens_folder/_pages/_profile/profile_header.dart';
import 'package:ff_driver/services_folder/_database/data.dart';
import 'package:ff_driver/shared_folder/_constants/FadeAnimation.dart';
import 'package:ff_driver/shared_folder/_global/global_var.dart';
import 'package:flutter/material.dart';

class MyProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Driver>(
        stream: Data(uid: currentDriverinfo.id).driverData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/home');
                  },
                ),
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    FadeAnimation(2, ProfileHeader()),
                    SizedBox(height: 20),
                    FadeAnimation(
                        1.5,
                        ProfileBody(
                          text: snapshot.data != null
                              ? snapshot.data.phone
                              : 'Loading.....',
                          icon: "assets/icons/Phone.svg",
                          editable: false,
                          press: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) => ProfileEdit(
                                      title: 'Edit Phone',
                                      edits: 'phone',
                                    ));
                          },
                        )),
                    FadeAnimation(
                        1.6,
                        ProfileBody(
                          text: snapshot.data != null
                              ? snapshot.data.fullname
                              : 'Loading.....',
                          icon: "assets/icons/User Icon.svg",
                          editable: true,
                          press: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) => ProfileEdit(
                                      title: 'Edit Name',
                                      edits: 'FullName',
                                    ));
                          },
                        )),
                    FadeAnimation(
                        1.7,
                        ProfileBody(
                          text: snapshot.data != null
                              ? snapshot.data.email
                              : 'Loading.....',
                          icon: "assets/icons/Mail.svg",
                          editable: true,
                          press: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) => ProfileEdit(
                                      title: 'Edit Email',
                                      edits: 'Email',
                                    ));
                          },
                        )),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
