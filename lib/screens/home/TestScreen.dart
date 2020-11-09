import 'dart:math' show cos, sqrt, asin;

import 'package:bld_test/constants/AppColors.dart';
import 'package:bld_test/constants/StringConstants.dart';
import 'package:bld_test/screens/home/HomeScreen.dart';
import 'package:bld_test/screens/home/TakeTest/QuestionsScreen.dart';
import 'package:bld_test/screens/myservices/MyServices.dart';
import 'package:bld_test/screens/profile/ProfileScreen.dart';
import 'package:bld_test/screens/rewards/RewardsScreen.dart';
import 'package:bld_test/utils/SizeConfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final testkey = GlobalKey<ScaffoldState>();
  int selectedIndex = 0;
  String price = "";
  User user;
  final GlobalKey<ScaffoldState> snackkey = new GlobalKey<ScaffoldState>();
  var getData;
  @override
  void initState() {
    super.initState();
    // changing app theme
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,/* set Status bar icons color in Android devices.*/
        statusBarBrightness: Brightness.light));
    // getting price fro database before proceeding to test
    user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection("profile")
        .where("uid", isEqualTo: user.uid)
        .snapshots()
        .listen((postdata)
    {
      setState(() {
        var data = postdata;
        data.docs.forEach((element) {
          getData = element.data();
        });
        FirebaseFirestore.instance
            .collection("prices")
            .snapshots()
            .listen((postdata) {
              setState(() {
                price = postdata.docs[0]['psychometric'];
              });
        });
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,/* set Status bar icons color in Android devices.*/
        statusBarBrightness: Brightness.light));
    SizeConfig().init(context);
    return Container(
        width: SizeConfig.blockSizeHorizontal * 100,
        height: SizeConfig.blockSizeVertical * 100,
        color: Colors.white,
        margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
        child: Scaffold(
          key:testkey,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.blockSizeVertical * 3,
                horizontal: SizeConfig.blockSizeHorizontal * 4),
            child: Column(children: [
              Stack(
                children: [
                  Container(
                    width: SizeConfig.blockSizeHorizontal * 100,
                    alignment: Alignment.center,
                    child: Text(
                      StringConstants.psychometric.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: StringConstants.font,
                          fontSize: SizeConfig.blockSizeVertical * 2.25,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        size: SizeConfig.blockSizeVertical * 3.2,
                        color: Colors.black,
                      )),
                ],
              ),
              InkWell(
                onTap: () {},
                child: Container(
                    width: SizeConfig.blockSizeHorizontal * 100,
                    height: SizeConfig.blockSizeVertical * 17,
                    margin:
                        EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                    decoration: BoxDecoration(
                        color: AppColors.tilecolor,
                        borderRadius: BorderRadius.all(Radius.circular(6.0))),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(
                                    top: SizeConfig.blockSizeVertical * 1.75,
                                    left: SizeConfig.blockSizeHorizontal * 5),
                                child: Text(
                                  StringConstants.psychometric,
                                  style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeVertical * 2.5,
                                    fontFamily: StringConstants.font,
                                    letterSpacing:
                                        SizeConfig.blockSizeHorizontal * 0.125,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.left,
                                )),
                            Container(
                                alignment: Alignment.centerLeft,
                                width: SizeConfig.blockSizeHorizontal * 60,
                                margin: EdgeInsets.only(
                                    top: SizeConfig.blockSizeVertical * 2.2,
                                    left: SizeConfig.blockSizeHorizontal * 5),
                                child: Text(
                                  StringConstants.ptestdetail,
                                  style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeVertical * 1.7,
                                    fontFamily: StringConstants.font,
                                    letterSpacing:
                                        SizeConfig.blockSizeHorizontal * 0.125,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.left,
                                )),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                              margin: EdgeInsets.only(
                                  right: SizeConfig.blockSizeHorizontal * 6),
                              child: Image.asset(
                                "asset/images/brain.png",
                                fit: BoxFit.fill,
                              )),
                        ),
                      ],
                    )),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  margin:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2.2),
                  child: Text(
                    StringConstants.expertinsights,
                    style: TextStyle(
                      fontSize: SizeConfig.blockSizeVertical * 2.25,
                      fontFamily: StringConstants.font,
                      letterSpacing: SizeConfig.blockSizeHorizontal * 0.125,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  )),
              InkWell(
                onTap: () {},
                child: Container(
                  width: SizeConfig.blockSizeHorizontal * 100,
                  height: SizeConfig.blockSizeVertical * 17,
                  margin:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                  child: Stack(
                    children: [
                      Container(
                          width: SizeConfig.blockSizeHorizontal * 100,
                          height: SizeConfig.blockSizeVertical * 17,
                          child: Image.asset(
                            "asset/images/test_grad.png",
                            fit: BoxFit.fill,
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 1.75,
                                  left: SizeConfig.blockSizeHorizontal * 5),
                              child: Text(
                                StringConstants.personality,
                                style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical * 2.5,
                                  fontFamily: StringConstants.font,
                                  letterSpacing:
                                      SizeConfig.blockSizeHorizontal * 0.1,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.left,
                              )),
                          Container(
                              alignment: Alignment.centerLeft,
                              width: SizeConfig.blockSizeHorizontal * 65,
                              margin: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 2.2,
                                  left: SizeConfig.blockSizeHorizontal * 5),
                              child: Text(
                                StringConstants.personalitydetail,
                                style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical * 1.7,
                                  fontFamily: StringConstants.font,
                                  letterSpacing:
                                      SizeConfig.blockSizeHorizontal * 0.05,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.left,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  width: SizeConfig.blockSizeHorizontal * 100,
                  height: SizeConfig.blockSizeVertical * 17,
                  margin:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                  child: Stack(
                    children: [
                      Container(
                          width: SizeConfig.blockSizeHorizontal * 100,
                          height: SizeConfig.blockSizeVertical * 17,
                          child: Image.asset(
                            "asset/images/test_grad.png",
                            fit: BoxFit.fill,
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 1.75,
                                  left: SizeConfig.blockSizeHorizontal * 5),
                              child: Text(
                                StringConstants.interest,
                                style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical * 2.5,
                                  fontFamily: StringConstants.font,
                                  letterSpacing:
                                      SizeConfig.blockSizeHorizontal * 0.125,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.left,
                              )),
                          Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 2.2,
                                  left: SizeConfig.blockSizeHorizontal * 5),
                              child: Text(
                                StringConstants.interestdetail,
                                style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical * 1.65,
                                  fontFamily: StringConstants.font,
                                  letterSpacing:
                                      SizeConfig.blockSizeHorizontal * 0.125,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.left,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  width: SizeConfig.blockSizeHorizontal * 100,
                  height: SizeConfig.blockSizeVertical * 17,
                  margin:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                  child: Stack(
                    children: [
                      Container(
                          width: SizeConfig.blockSizeHorizontal * 100,
                          height: SizeConfig.blockSizeVertical * 17,
                          child: Image.asset(
                            "asset/images/test_grad.png",
                            fit: BoxFit.fill,
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 1.75,
                                  left: SizeConfig.blockSizeHorizontal * 5),
                              child: Text(
                                StringConstants.aptitude,
                                style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical * 2.5,
                                  fontFamily: StringConstants.font,
                                  letterSpacing:
                                      SizeConfig.blockSizeHorizontal * 0.125,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.left,
                              )),
                          Container(
                              alignment: Alignment.centerLeft,
                              width: SizeConfig.blockSizeHorizontal * 65,
                              margin: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 2.2,
                                  left: SizeConfig.blockSizeHorizontal * 5),
                              child: Text(
                                StringConstants.aptitudedetail,
                                style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical * 1.7,
                                  fontFamily: StringConstants.font,
                                  letterSpacing:
                                      SizeConfig.blockSizeHorizontal * 0.125,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.left,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  width: SizeConfig.blockSizeHorizontal * 100,
                  height: SizeConfig.blockSizeVertical * 17,
                  margin:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                  child: Stack(
                    children: [
                      Container(
                          width: SizeConfig.blockSizeHorizontal * 100,
                          height: SizeConfig.blockSizeVertical * 17,
                          child: Image.asset(
                            "asset/images/test_grad.png",
                            fit: BoxFit.fill,
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 1.75,
                                  left: SizeConfig.blockSizeHorizontal * 5),
                              child: Text(
                                StringConstants.more,
                                style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical * 2.5,
                                  fontFamily: StringConstants.font,
                                  letterSpacing:
                                      SizeConfig.blockSizeHorizontal * 0.125,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.left,
                              )),
                          Container(
                              alignment: Alignment.centerLeft,
                              width: SizeConfig.blockSizeHorizontal * 65,
                              margin: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 2.2,
                                  left: SizeConfig.blockSizeHorizontal * 5),
                              child: Text(
                                StringConstants.moredetail,
                                style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical * 1.7,
                                  fontFamily: StringConstants.font,
                                  letterSpacing:
                                      SizeConfig.blockSizeHorizontal * 0.125,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.left,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  width: SizeConfig.blockSizeHorizontal * 100,
                  height: SizeConfig.blockSizeVertical * 17,
                  margin:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.testColor, width: 3),
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 1.75,
                                  left: SizeConfig.blockSizeHorizontal * 5),
                              child: Text(
                                StringConstants.price+price,
                                style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical * 2.5,
                                  fontFamily: StringConstants.font,
                                  letterSpacing:
                                      SizeConfig.blockSizeHorizontal * 0.125,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.left,
                              )),
                          Container(
                              alignment: Alignment.centerLeft,
                              width: SizeConfig.blockSizeHorizontal * 70,
                              margin: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 2.2,
                                  left: SizeConfig.blockSizeHorizontal * 5),
                              child: Text(
                                StringConstants.pricedetail,
                                style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical * 1.7,
                                  fontFamily: StringConstants.font,
                                  letterSpacing:
                                      SizeConfig.blockSizeHorizontal * 0.125,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.left,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // redirecting to Test Screen after payment
                 if(!getData["istest"]) {
                   FirebaseFirestore.instance
                       .collection("profile").doc(getData['uid'])
                       .update({
                     "istest": true,
                   }).whenComplete(() {
                     Navigator.push(
                         context,
                         MaterialPageRoute(
                             builder: (BuildContext context) =>
                                 QuestionScreen("",0))).then((value) {
                       setState(() {
                         SystemChrome.setSystemUIOverlayStyle(
                             SystemUiOverlayStyle.dark.copyWith(
                                 statusBarColor: Colors.white,
                                 statusBarIconBrightness: Brightness
                                     .dark, /* set Status bar icons color in Android devices.*/
                                 statusBarBrightness: Brightness.dark
                             ));
                       });
                     });
                   });
                 }
                 else
                   {
                     showInSnackBar("You have already purchased this test");
                   }

                },
                child: Container(
                    width: SizeConfig.blockSizeHorizontal * 74,
                    margin: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 3.25),
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.blockSizeVertical * 0.75,
                        horizontal: SizeConfig.blockSizeHorizontal * 2),
                    decoration: BoxDecoration(
                        color: AppColors.underline,
                        borderRadius: BorderRadius.all(Radius.circular(24.0))),
                    child: Container(
                      margin: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 1.5),
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.blockSizeVertical * 1),
                      child: Text(
                        StringConstants.proceed.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical * 2.1,
                          fontFamily: StringConstants.font,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: SizeConfig.blockSizeHorizontal * 0.075,
                        ),
                      ),
                    )),
              ),
            ]),
          )),
        ));
  }
  void showInSnackBar(String value)
  {
    testkey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
  }
}
