import 'package:connectivity/connectivity.dart';
import 'package:ff_driver/models_folder/user.dart';
import 'package:ff_driver/services_folder/_database/auth.dart';
import 'package:ff_driver/services_folder/_database/data.dart';
import 'package:ff_driver/shared_folder/_buttons/default_button.dart';
import 'package:ff_driver/shared_folder/_buttons/keyboard.dart';
import 'package:ff_driver/shared_folder/_buttons/trans_button.dart';
import 'package:ff_driver/shared_folder/_constants/constants.dart';
import 'package:ff_driver/shared_folder/_constants/custom_surfix_icon.dart';
import 'package:ff_driver/shared_folder/_constants/form_error.dart';
import 'package:ff_driver/shared_folder/_constants/progressDialog.dart';
import 'package:ff_driver/shared_folder/_constants/size_config.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  final _auth = AuthService();
  var _fullname = TextEditingController();
  var _email = TextEditingController();
  var _cartype = TextEditingController();

  void showSnackBar(String title) {
    final snackbar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: getProportionateScreenHeight(18), fontFamily: 'Muli'),
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

  void register(String uid, String phone) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            ProgressDialog(status: 'Please Wait...'));
    try {
      if (uid != null) {
        await Data(uid: uid)
            .addDriver(_fullname.text, _email.text, phone, _cartype.text);
        DatabaseReference dbref =
            FirebaseDatabase.instance.reference().child('drivers/$uid');
        Map userMap = {
          'Email': _email.text,
          'FullName': _fullname.text,
          'phone': phone,
          'carType': _cartype.text,
        };
        await dbref.set(userMap);
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed('/cardetails');
      } else {
        showSnackBar("Error");
      }
    } catch (e) {
      Navigator.of(context).pop();
      showSnackBar(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    SizeConfig().init(context);
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
                  SizedBox(height: SizeConfig.screenHeight * 0.05),
                  Text("Ehatid Driver", style: headingStyle),
                  Text(
                    "Complete your details",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.06),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        buildFullname(),
                        SizedBox(height: getProportionateScreenHeight(30)),
                        buildEmail(),
                        SizedBox(height: getProportionateScreenHeight(30)),
                        buildCartype(),
                        SizedBox(height: getProportionateScreenHeight(30)),
                        FormError(errors: errors),
                        SizedBox(height: getProportionateScreenHeight(40)),
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
                              register(user.uid, user.phone);
                            }
                          },
                        ),
                        SizedBox(height: getProportionateScreenHeight(30)),
                        TransparentButton(
                          text: "Cancel",
                          color: Colors.blue,
                          press: () async {
                            await _auth.signOut();
                            Navigator.of(context)
                                .pushReplacementNamed('/wrapper');
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(30)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildCartype() {
    return TextFormField(
      controller: _cartype,
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
        labelText: "Car Type",
        hintText: "Normal",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildFullname() {
    return TextFormField(
      controller: _fullname,
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
        labelText: "Full Name",
        hintText: "John Doe",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildEmail() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _email,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Example@email.com",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
