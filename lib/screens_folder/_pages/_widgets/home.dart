import 'package:ff_driver/services_folder/_database/auth.dart';
import 'package:ff_driver/services_folder/_helper/helper_method.dart';
import 'package:ff_driver/shared_folder/_constants/size_config.dart';
import 'package:ff_driver/shared_folder/_constants/splash.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    HelperMethod.getcurrentUserInfo(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Ehatid Driver",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: getProportionateScreenHeight(28),
                    fontFamily: 'Muli'),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Category",
                    style: TextStyle(
                      fontFamily: 'Muli',
                      fontSize: getProportionateScreenHeight(18),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  Icon(
                    Icons.more_horiz,
                    color: Colors.grey[800],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildPetCategory(
                          category: 'Go Online',
                          color: Colors.white,
                          image: 'assets/images/autonomous-car.png',
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    Splash(route: '/getonline')));
                          }),
                      buildPetCategory(
                        category: 'Earnings',
                        color: Colors.white,
                        image: 'assets/images/earnings.png',
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  Splash(route: '/earnings')));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Options",
                    style: TextStyle(
                      fontFamily: 'Muli',
                      fontSize: getProportionateScreenHeight(18),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  Icon(
                    Icons.more_horiz,
                    color: Colors.grey[800],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildPetCategory(
                          category: 'Profile',
                          color: Colors.white,
                          image: 'assets/images/user.png',
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushNamed('/myprofile');
                          }),
                      buildPetCategory(
                        category: 'Trip Hsitory',
                        color: Colors.white,
                        image: 'assets/images/history.png',
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Splash(route: '/history')));
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildPetCategory(
                          category: 'Support',
                          color: Colors.white,
                          image: 'assets/images/customer-service.png',
                          onTap: () {}),
                      buildPetCategory(
                        category: 'Log out',
                        color: Colors.white,
                        image: 'assets/images/exit.png',
                        onTap: () async {
                          await _auth.signOut();
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  Splash(route: '/wrapper')));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPetCategory({String category, String image, Color color, onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: getProportionateScreenHeight(80),
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey[200],
              width: getProportionateScreenWidth(1),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Row(
            children: [
              Container(
                height: getProportionateScreenHeight(56),
                width: getProportionateScreenWidth(56),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.5),
                ),
                child: Center(
                  child: SizedBox(
                    height: getProportionateScreenHeight(30),
                    width: getProportionateScreenWidth(30),
                    child: Image.asset(
                      image,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(12),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        category,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: 'Muli',
                          color: Colors.grey[800],
                          fontSize: getProportionateScreenHeight(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
