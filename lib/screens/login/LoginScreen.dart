import 'dart:math' show cos, sqrt, asin;

import 'package:bld_test/constants/AppColors.dart';
import 'package:bld_test/constants/StringConstants.dart';
import 'package:bld_test/screens/dashboard/Dashboard.dart';
import 'package:bld_test/screens/signup/SignupScreen.dart';
import 'package:bld_test/utils/SizeConfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  final _LoginViewState _myApp = new _LoginViewState();
  @override
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<Login> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  CountryCode country;
  String countrycode;
  @override
  void initState() {
    super.initState();
    countrycode = "+1";
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
          width: SizeConfig.blockSizeHorizontal * 100,
          height: SizeConfig.blockSizeVertical * 100,
          child: Stack(
            children: [
              Container(
                height: SizeConfig.blockSizeVertical * 65,
                child: Stack(children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          "asset/images/background.png",
                        ),
                      ),
                    ),
                    height: SizeConfig.blockSizeVertical * 70,
                  ),
                  Container(
                    height: SizeConfig.blockSizeVertical * 70,
                    decoration: BoxDecoration(
                      color: AppColors.layercolor.withOpacity(0.48),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        height: SizeConfig.blockSizeVertical * 26,
                        child: Column(
                          children: [
                            Container(
                              height: SizeConfig.blockSizeVertical * 7,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Container(
                                        width: SizeConfig.blockSizeHorizontal *
                                            32.5,
                                        height:
                                            SizeConfig.blockSizeVertical * 3,
                                        margin: EdgeInsets.only(
                                            left:
                                                SizeConfig.blockSizeHorizontal *
                                                    12.75),
                                        decoration: BoxDecoration(
                                          color: AppColors.red,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(13),
                                            topRight: Radius.circular(13),
                                            bottomLeft: Radius.circular(13),
                                            bottomRight: Radius.circular(13),
                                          ),
                                        ),
                                        child: SizedBox()),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left:
                                            SizeConfig.blockSizeHorizontal * 4),
                                    alignment: Alignment.centerLeft,
                                    width: SizeConfig.blockSizeHorizontal * 45,
                                    child: Text(
                                      StringConstants.medici,
                                      style: TextStyle(
                                          fontSize:
                                              SizeConfig.blockSizeVertical *
                                                  4.75,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          letterSpacing:
                                              SizeConfig.blockSizeHorizontal *
                                                  0.15,
                                          fontFamily: StringConstants.font,
                                          fontStyle: FontStyle.normal),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.blockSizeHorizontal * 4,
                                  top: SizeConfig.blockSizeVertical * 1.75),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                StringConstants.blueyard,
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeVertical * 2.25,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing:
                                        SizeConfig.blockSizeHorizontal * 0.15,
                                    fontFamily: StringConstants.font,
                                    fontStyle: FontStyle.normal),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.blockSizeHorizontal * 4,
                                  top: SizeConfig.blockSizeVertical * 2.25),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                StringConstants.educationredef,
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeVertical * 3.15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing:
                                        SizeConfig.blockSizeHorizontal * 0.15,
                                    fontFamily: StringConstants.font,
                                    fontStyle: FontStyle.normal),
                              ),
                            ),
                          ],
                        )),
                  ),
                ]),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  height: SizeConfig.blockSizeVertical * 38,
                  width: SizeConfig.blockSizeHorizontal * 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 7,
                            left: SizeConfig.blockSizeHorizontal * 6),
                        child: Text(
                          StringConstants.dashboardtext,
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical * 3,
                              fontWeight: FontWeight.w700,
                              fontFamily: StringConstants.font,
                              fontStyle: FontStyle.normal),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 5,
                            left: SizeConfig.blockSizeHorizontal * 6),
                        child: Stack(
                          children: [
                            Container(
                              width: SizeConfig.blockSizeHorizontal * 33,
                              alignment: Alignment.bottomRight,
                              child:
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: SizeConfig.blockSizeVertical * 3.75,
                              ),
                            ),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width:
                                          SizeConfig.blockSizeHorizontal * 33,
                                      height:
                                          SizeConfig.blockSizeVertical * 4.25,
                                      alignment: Alignment.centerLeft,
                                      child: CountryCodePicker(
                                        onChanged: _onCountryChange,
                                        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                        initialSelection: 'US',
                                        // optional. Shows only country name and flag
                                        showCountryOnly: false,
                                        padding: EdgeInsets.only(right: getmargin(countrycode!=null?countrycode:"")),
                                        textStyle: TextStyle(
                                            fontFamily: StringConstants.cera,
                                            fontSize:
                                                SizeConfig.blockSizeVertical * 2.25,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal),
                                        showFlag: true,
                                        // optional. Shows only country name and flag when popup is closed.
                                        showOnlyCountryWhenClosed: false,
                                        // optional. aligns the flag and the Text left
                                        alignLeft: false,
                                      ),
                                    ),
                                    Container(
                                      height: 2.5,
                                      width:
                                          SizeConfig.blockSizeHorizontal * 33,
                                      color: AppColors.underline,
                                      child: SizedBox(),
                                    )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: SizeConfig.blockSizeHorizontal * 5),
                                  width: SizeConfig.blockSizeHorizontal * 40,
                                  child: TextFormField(
                                    style: TextStyle(
                                        fontFamily: StringConstants.cera,
                                        fontSize:
                                            SizeConfig.blockSizeVertical * 2.25,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w700,letterSpacing: SizeConfig.blockSizeVertical*0.15,
                                        fontStyle: FontStyle.normal),
                                    keyboardType: TextInputType.phone,
                                    textInputAction: TextInputAction.done,
                                    controller: _phoneController,
                                    scrollPadding:
                                        EdgeInsets.only(top: 0, bottom: 0),
                                    decoration: new InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical:
                                            SizeConfig.blockSizeVertical * 0.6,
                                      ),
                                      hintText: "5555 5555",
                                      enabledBorder: new UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: AppColors.underline,
                                              width: 2.5)),
                                      hintStyle: TextStyle(
                                          fontFamily: StringConstants.cera,
                                          fontSize:
                                              SizeConfig.blockSizeVertical *
                                                  2.25,
                                          color: Colors.black26,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            if (_phoneController.text.trim().toString() !=
                                    null &&
                                _phoneController.text.trim().toString() != "") {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Signup(countrycode, _phoneController.text.trim().toString(),country)));
                            } else {
                              Fluttertoast.showToast(
                                  msg: StringConstants.entermobile);
                            }
                          },
                          child: Container(
                              width: SizeConfig.blockSizeHorizontal * 36,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.blockSizeVertical * 1.4),
                              margin: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 5.5,
                                  right: SizeConfig.blockSizeHorizontal * 8),
                              decoration: BoxDecoration(
                                color: AppColors.buttoncolor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24),
                                  bottomLeft: Radius.circular(24),
                                  bottomRight: Radius.circular(24),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: Offset(
                                        0, 0.5), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Text(
                                StringConstants.otp,
                                style: TextStyle(
                                    fontFamily: StringConstants.font,
                                    fontWeight: FontWeight.w700,
                                    fontSize:
                                        SizeConfig.blockSizeVertical * 1.9,
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  // country selected by user
  void _onCountryChange(CountryCode countryCodeq) {
    setState(() {
      country = countryCodeq;
      countrycode = country.dialCode;
    });
  }
  getmargin(String code)
  {
    if(code.length<=3)
      {
        return SizeConfig.blockSizeHorizontal*10.5;
      }
    else if(code.length<=4)
      {
        return SizeConfig.blockSizeHorizontal*8;
      }
    else
      {
        return SizeConfig.blockSizeHorizontal*4.5;
      }
  }
}
