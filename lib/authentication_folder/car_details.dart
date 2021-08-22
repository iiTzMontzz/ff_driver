import 'package:connectivity/connectivity.dart';
import 'package:ff_driver/models_folder/user.dart';
import 'package:ff_driver/services_folder/_database/auth.dart';
import 'package:ff_driver/services_folder/_database/data.dart';
import 'package:ff_driver/shared_folder/_buttons/default_button.dart';
import 'package:ff_driver/shared_folder/_buttons/keyboard.dart';
import 'package:ff_driver/shared_folder/_buttons/trans_button.dart';
import 'package:ff_driver/shared_folder/_constants/FadeAnimation.dart';
import 'package:ff_driver/shared_folder/_constants/constants.dart';
import 'package:ff_driver/shared_folder/_constants/custom_surfix_icon.dart';
import 'package:ff_driver/shared_folder/_constants/form_error.dart';
import 'package:ff_driver/shared_folder/_constants/size_config.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarDetails extends StatefulWidget {
  @override
  _CarDetailsState createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var _carModel = TextEditingController();
  var _carColor = TextEditingController();
  var _plateNo = TextEditingController();
  final _auth = AuthService();
  final List<String> errors = [];
  String _status = 'Enabled';
  String _type = 'Driver';

  void showSnackBar(String title) {
    final snackbar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontFamily: 'Muli'),
      ),
    );
    scaffoldkey.currentState.showSnackBar(snackbar);
  }

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  void updateProfile(String uid) {
    DatabaseReference driverRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/$uid/vehicle_detail');

    Map map = {
      'car_color': _carColor.text,
      'car_model': _carModel.text,
      'plate_no': _plateNo.text
    };
    driverRef.set(map);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      key: scaffoldkey,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                  FadeAnimation(
                      1.1, Text('Vehicle Information', style: headingStyle)),
                  SizedBox(height: SizeConfig.screenHeight * 0.06),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        FadeAnimation(1.2, buildmodel()),
                        SizedBox(height: getProportionateScreenHeight(30)),
                        FadeAnimation(1.3, buildColor()),
                        SizedBox(height: getProportionateScreenHeight(30)),
                        FadeAnimation(1.4, buildPlatNo()),
                        SizedBox(height: getProportionateScreenHeight(30)),
                        FormError(errors: errors),
                        SizedBox(height: getProportionateScreenHeight(40)),
                        FadeAnimation(
                            1.6,
                            DefaultButton(
                              text: "continue",
                              color: Colors.blue[400],
                              press: () async {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  var connResult =
                                      await Connectivity().checkConnectivity();
                                  if (connResult != ConnectivityResult.mobile &&
                                      connResult != ConnectivityResult.wifi) {
                                    showSnackBar("Check Internet Connection");
                                    return;
                                  }

                                  KeyboardUtil.hideKeyboard(context);
                                  dynamic result = await Data(uid: user.uid)
                                      .addDriverVehicle(_carModel.text,
                                          _carColor.text, _plateNo.text);
                                  if (result == null) {
                                    await Data(uid: user.uid)
                                        .addPerson(_type, _status);
                                    updateProfile(user.uid);

                                    Navigator.of(context)
                                        .pushReplacementNamed('/wrapper');
                                  }
                                }
                              },
                            )),
                        SizedBox(height: getProportionateScreenHeight(30)),
                        FadeAnimation(
                          1.7,
                          TransparentButton(
                            text: "Cancel",
                            color: Colors.blue,
                            press: () async {
                              await _auth.signOut();
                              Navigator.of(context)
                                  .pushReplacementNamed('/wrapper');
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  FadeAnimation(
                    1.9,
                    Text(
                      "By continuing your confirm that you agree \nwith our Term and Condition",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildmodel() {
    return TextFormField(
      controller: _carModel,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Car Model",
        hintText: "Savana",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildColor() {
    return TextFormField(
      controller: _carColor,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Car Color",
        hintText: "ex. Red",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildPlatNo() {
    return TextFormField(
      controller: _plateNo,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Plate Number",
        hintText: "XXX 123",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
