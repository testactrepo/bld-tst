import 'dart:async';
import 'dart:math' show cos, sqrt, asin;

import 'package:animations/animations.dart';
import 'package:bld_test/constants/AppColors.dart';
import 'package:bld_test/constants/StringConstants.dart';
import 'package:bld_test/data/models/Interest.dart';
import 'package:bld_test/screens/dashboard/Dashboard.dart';
import 'package:bld_test/utils/SharedPref.dart';
import 'package:bld_test/utils/SizeConfig.dart';
import 'package:bld_test/widgets/CommonWidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Signup extends StatefulWidget {
  String countrycode, phonenumber;
  CountryCode selectedcountry;
  Signup(this.countrycode, this.phonenumber,this.selectedcountry);
  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<Signup> {
  String currentpin = "";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController firstname = new TextEditingController();
  final TextEditingController lastname = new TextEditingController();
  final TextEditingController email = new TextEditingController();
  String verificationId;
  final GlobalKey<ScaffoldState> snackkey = new GlobalKey<ScaffoldState>();


  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  StreamController<ErrorAnimationType> errorController;

  int progressvalue = 25;
  String userId="";
  List<String> education = new List();
  var _formKey = GlobalKey<FormState>();
  List<Interest> intrestlist = new List();
  List<String> selectedintrest = new List();
  var selectededucation;
  bool hasError = false,
      iscode = false,
      isdetail = false,
      isinterest = false,
      isloading = false;
  @override
  void initState() {
    // changing app theme
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light));
    super.initState();
    // getting current user session
    isloading = true;
    // sending otp to user
    verifyPhone(context);
    iscode = true;
    // getting intrest list from database
    FirebaseFirestore.instance
        .collection("intrests")
        .snapshots()
        .listen((postdata) {
      setState(() {
        // adding elements in array
        for (int i = 0; i < postdata.docs[0]['fields'].length; i++) {
          intrestlist.add(new Interest(
              name: postdata.docs[0]['fields'].elementAt(i),
              isselected: false));
        }
        for (int i = 0; i < postdata.docs[0]['education'].length; i++) {
          education.add(postdata.docs[0]['education'].elementAt(i));
        }
        selectededucation = education.elementAt(0);
        isloading = false;
      });
    });
    // setup controller for otp
    errorController = StreamController<ErrorAnimationType>.broadcast();
  }

  @override
  void dispose() {
    // closing controller stream
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    List<Widget> widgetList = new List<Widget>();
    var child = Scaffold(
      // resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      body: Container(
        color: Colors.white,
        height: SizeConfig.blockSizeVertical * 100,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  width: SizeConfig.blockSizeHorizontal * 100,
                  alignment: Alignment.center,
                  margin:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 6),
                  child: Text(StringConstants.signup + ".",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: SizeConfig.blockSizeVertical * 3,
                          color: Colors.black,
                          fontFamily: StringConstants.malternate,
                          fontStyle: FontStyle.normal))),
              Container(
                margin: EdgeInsets.only(
                    top: SizeConfig.blockSizeVertical * 3,
                    left: SizeConfig.blockSizeHorizontal * 3,
                    right: SizeConfig.blockSizeHorizontal * 3),
                child: FAProgressBar(
                  currentValue: progressvalue,
                  progressColor: AppColors.progresscolor,
                  size: 15,
                  borderRadius: 7,
                ),
              ),
              // Entering Code
              Visibility(
                  visible: iscode,
                  child: Column(
                    children: [
                      Container(
                          width: SizeConfig.blockSizeHorizontal * 100,
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 3.5,
                              left: SizeConfig.blockSizeHorizontal * 4),
                          child: Text(StringConstants.verificationcode,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing:
                                      SizeConfig.blockSizeHorizontal * 0.1,
                                  fontSize: SizeConfig.blockSizeVertical * 2.1,
                                  color: Colors.black,
                                  fontFamily: StringConstants.font,
                                  fontStyle: FontStyle.normal))),
                      Container(
                          width: SizeConfig.blockSizeHorizontal * 100,
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 3.5,
                              left: SizeConfig.blockSizeHorizontal * 4,
                              right: SizeConfig.blockSizeHorizontal * 4),
                          child: Card(
                              elevation: 3.5,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        SizeConfig.blockSizeVertical * 1.25,
                                    horizontal:
                                        SizeConfig.blockSizeHorizontal * 4),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: SizeConfig.blockSizeHorizontal *
                                              3,
                                          right:
                                              SizeConfig.blockSizeHorizontal *
                                                  4),
                                      child: Text(
                                          widget.countrycode != null
                                              ? widget.countrycode
                                              : "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize:
                                                  SizeConfig.blockSizeVertical *
                                                      2.15,
                                              letterSpacing: SizeConfig
                                                      .blockSizeHorizontal *
                                                  1,
                                              color: Colors.black,
                                              fontFamily: StringConstants.font,
                                              fontStyle: FontStyle.normal)),
                                    ),
                                    Container(
                                        width: SizeConfig.blockSizeHorizontal *
                                            0.25,
                                        height:
                                            SizeConfig.blockSizeVertical * 2,
                                        color: Colors.black,
                                        child: SizedBox()),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: SizeConfig.blockSizeHorizontal *
                                              5,
                                          right:
                                              SizeConfig.blockSizeHorizontal *
                                                  4),
                                      child: Text(
                                          widget.phonenumber != null
                                              ? widget.phonenumber
                                              : "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize:
                                                  SizeConfig.blockSizeVertical *
                                                      2.15,
                                              letterSpacing: SizeConfig
                                                      .blockSizeHorizontal *
                                                  1,
                                              color: Colors.black38,
                                              fontFamily: StringConstants.font,
                                              fontStyle: FontStyle.normal)),
                                    ),
                                  ],
                                ),
                              ))),
                      Container(
                        width: SizeConfig.blockSizeHorizontal * 80,
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 5),
                        child: PinCodeTextField(
                          appContext: context,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          pastedTextStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              fontFamily: StringConstants.font,
                              fontSize: SizeConfig.blockSizeVertical * 2.5),
                          length: 6,
                          obscureText: false, enablePinAutofill: true,
                          obscuringCharacter: '*',
                          animationType: AnimationType.fade,
                          backgroundColor: Colors.white,
                          validator: (v) {
                            if (v.length < 3) {
                              return "";
                            } else {
                              return null;
                            }
                          },
                          pinTheme: PinTheme(
                              shape: PinCodeFieldShape.circle,
                              borderRadius: BorderRadius.circular(2),
                              fieldHeight: SizeConfig.blockSizeVertical * 5.5,
                              fieldWidth: SizeConfig.blockSizeVertical * 5.5,
                              inactiveColor:
                                  hasError ? Colors.red : Colors.black,
                              selectedColor: Colors.white,
                              activeFillColor: Colors.white,
                              inactiveFillColor: Colors.white,
                              selectedFillColor: Colors.black38,
                              activeColor: Colors.black,
                              borderWidth: 1.25),
                          cursorColor: Colors.black,
                          animationDuration: Duration(milliseconds: 300),
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontFamily: StringConstants.font,
                            fontSize: SizeConfig.blockSizeVertical * 2.5,
                          ),
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          keyboardType: TextInputType.number,
                          onCompleted: (v) {
                            print("Completed");
                          },
                          beforeTextPaste: (text) {
                            return true;
                          },
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              currentpin = value;
                              if (currentpin.length >= 6)
                                hasError = false;
                              else
                                hasError = true;
                            });
                          },
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // verifying otp
                          verifyPhone(context);
                        },
                        child: Container(
                            width: SizeConfig.blockSizeHorizontal * 100,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical*0.5,horizontal: SizeConfig.blockSizeHorizontal*1.5),
                            margin: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical * 2.5),
                            child: Text(
                                StringConstants.resendcode.toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize:
                                        SizeConfig.blockSizeVertical * 1.9,
                                    color: AppColors.resendcolor,
                                    fontFamily: StringConstants.font,
                                    fontStyle: FontStyle.normal))),
                      )
                    ],
                  )),

              // Entry fields after otp verification
              Visibility(
                  visible: isdetail,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                            width: SizeConfig.blockSizeHorizontal * 100,
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical * 3.5,
                                left: SizeConfig.blockSizeHorizontal * 4),
                            child: Text(StringConstants.knowbetter,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing:
                                        SizeConfig.blockSizeHorizontal * 0.12,
                                    fontSize:
                                        SizeConfig.blockSizeVertical * 2.15,
                                    color: Colors.black,
                                    fontFamily: StringConstants.font,
                                    fontStyle: FontStyle.normal))),
                        Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 5,
                              left: SizeConfig.blockSizeHorizontal * 3,
                              right: SizeConfig.blockSizeHorizontal * 3),
                          child: TextFormField(
                            cursorColor: Colors.black,
                            onFieldSubmitted: (v) {
                            },
                            controller: firstname,
                            style: TextStyle(
                                fontFamily: StringConstants.font,
                                fontStyle: FontStyle.normal,
                                fontSize: SizeConfig.blockSizeVertical * 1.95,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    top: SizeConfig.blockSizeVertical * 2,
                                    bottom: SizeConfig.blockSizeVertical * 2,
                                    left: SizeConfig.blockSizeVertical * 2),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                    width: 1.25,
                                    color: Colors.black,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                    width: 1.25,
                                    color: Colors.black,
                                  ),
                                ),
                                labelText: StringConstants.firstname,
                                labelStyle: TextStyle(
                                    fontFamily: StringConstants.font,
                                    fontStyle: FontStyle.normal,
                                    fontSize:
                                        SizeConfig.blockSizeVertical * 1.85,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black)),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 5,
                              left: SizeConfig.blockSizeHorizontal * 3,
                              right: SizeConfig.blockSizeHorizontal * 3),
                          child: TextFormField(
                            cursorColor: Colors.black,
                            onFieldSubmitted: (v) {},
                            controller: lastname,
                            style: TextStyle(
                                fontFamily: StringConstants.font,
                                fontStyle: FontStyle.normal,
                                fontSize: SizeConfig.blockSizeVertical * 1.95,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    top: SizeConfig.blockSizeVertical * 2,
                                    bottom: SizeConfig.blockSizeVertical * 2,
                                    left: SizeConfig.blockSizeVertical * 2),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                    width: 1.25,
                                    color: Colors.black,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                    width: 1.25,
                                    color: Colors.black,
                                  ),
                                ),
                                labelText: StringConstants.lastname,
                                labelStyle: TextStyle(
                                    fontFamily: StringConstants.font,
                                    fontStyle: FontStyle.normal,
                                    fontSize:
                                        SizeConfig.blockSizeVertical * 1.85,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black)),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 5,
                              left: SizeConfig.blockSizeHorizontal * 3,
                              right: SizeConfig.blockSizeHorizontal * 3),
                          child: TextFormField(
                            cursorColor: Colors.black,
                            onFieldSubmitted: (v) {},
                            controller: email,
                            style: TextStyle(
                                fontFamily: StringConstants.font,
                                fontStyle: FontStyle.normal,
                                fontSize: SizeConfig.blockSizeVertical * 1.95,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    top: SizeConfig.blockSizeVertical * 2,
                                    bottom: SizeConfig.blockSizeVertical * 2,
                                    left: SizeConfig.blockSizeVertical * 2),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                    width: 1.25,
                                    color: Colors.black,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                    width: 1.25,
                                    color: Colors.black,
                                  ),
                                ),
                                labelText: StringConstants.email,
                                labelStyle: TextStyle(
                                    fontFamily: StringConstants.font,
                                    fontStyle: FontStyle.normal,
                                    fontSize:
                                        SizeConfig.blockSizeVertical * 1.85,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black)),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 4.5,
                              left: SizeConfig.blockSizeHorizontal * 3,
                              right: SizeConfig.blockSizeHorizontal * 3),
                          child: FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    labelText: StringConstants.education,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(
                                        width: 1.25,
                                        color: Colors.black,
                                      ),
                                    ),
                                    labelStyle: TextStyle(
                                        fontFamily: StringConstants.font,
                                        fontStyle: FontStyle.normal,
                                        fontSize:
                                            SizeConfig.blockSizeVertical * 1.85,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                    isDense: true,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectededucation,
                                    isDense: true,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        selectededucation = newValue;
                                        state.didChange(newValue);
                                      });
                                    },
                                    items: education.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                left: SizeConfig
                                                        .blockSizeHorizontal *
                                                    1),
                                            child: Text(value,
                                                style: TextStyle(
                                                    fontFamily:
                                                        StringConstants.font,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: SizeConfig
                                                            .blockSizeVertical *
                                                        1.95,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black54))),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  )),

              // Interests Form
              Visibility(
                visible: isinterest,
                child: SingleChildScrollView(
                  child: Column(children: [
                    Container(
                        width: SizeConfig.blockSizeHorizontal * 100,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 3.5,
                            left: SizeConfig.blockSizeHorizontal * 4),
                        child: Text(
                            StringConstants.almost +
                                firstname.text.trim().toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                letterSpacing:
                                    SizeConfig.blockSizeHorizontal * 0.05,
                                fontSize: SizeConfig.blockSizeVertical * 2.25,
                                color: Colors.black,
                                fontFamily: StringConstants.font,
                                fontStyle: FontStyle.normal))),
                    Container(
                        width: SizeConfig.blockSizeHorizontal * 100,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 0.5,
                            left: SizeConfig.blockSizeHorizontal * 4),
                        child: Text(StringConstants.persnalizeexperience,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                letterSpacing:
                                    SizeConfig.blockSizeHorizontal * 0.05,
                                fontSize: SizeConfig.blockSizeVertical * 2.25,
                                color: Colors.black,
                                fontFamily: StringConstants.font,
                                fontStyle: FontStyle.normal))),
                    Container(
                        width: SizeConfig.blockSizeHorizontal * 100,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 1.75,
                            left: SizeConfig.blockSizeHorizontal * 4),
                        child: Text(StringConstants.intrest.toLowerCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                letterSpacing:
                                    SizeConfig.blockSizeHorizontal * 0.05,
                                fontSize: SizeConfig.blockSizeVertical * 2.05,
                                color: AppColors.intrest,
                                fontFamily: StringConstants.font,
                                fontStyle: FontStyle.normal))),
                    Container(
                        width: SizeConfig.blockSizeHorizontal * 100,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: intrestlist.length,
                          itemBuilder: (context, position) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  if (intrestlist
                                      .elementAt(position)
                                      .isselected)
                                    intrestlist.elementAt(position).isselected =
                                        false;
                                  else
                                    intrestlist.elementAt(position).isselected =
                                        true;
                                });
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          SizeConfig.blockSizeHorizontal * 3,
                                      vertical:
                                          SizeConfig.blockSizeVertical * 1.35),
                                  margin: EdgeInsets.only(
                                      top: SizeConfig.blockSizeVertical * 1.25,
                                      left: SizeConfig.blockSizeHorizontal * 3,
                                      right:
                                          SizeConfig.blockSizeHorizontal * 3),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3.0)),
                                    border: Border.all(
                                        color: Colors.black, width: 1.25),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left:
                                                SizeConfig.blockSizeHorizontal *
                                                    1,
                                            right:
                                                SizeConfig.blockSizeHorizontal *
                                                    6),
                                        child: Image(
                                          width:
                                              SizeConfig.blockSizeHorizontal *
                                                  4,
                                          height:
                                              SizeConfig.blockSizeVertical * 3,
                                          image: AssetImage(intrestlist
                                                  .elementAt(position)
                                                  .isselected
                                              ? "asset/checking.png"
                                              : "asset/unselected.png"),
                                        ),
                                      ),
                                      Container(
                                          child: Text(
                                              intrestlist
                                                  .elementAt(position)
                                                  .name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: SizeConfig
                                                          .blockSizeHorizontal *
                                                      0.05,
                                                  fontSize: intrestlist
                                                          .elementAt(position)
                                                          .isselected
                                                      ? SizeConfig
                                                              .blockSizeVertical *
                                                          2.2
                                                      : SizeConfig
                                                              .blockSizeVertical *
                                                          2.1,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      StringConstants.font,
                                                  fontStyle: FontStyle.normal)))
                                    ],
                                  )),
                            );
                            //controller: _scrollController,
                          },
                        ))
                  ]),
                ),
              ),
// Next Button
              Align(
                alignment: iscode ? Alignment.center : Alignment.bottomRight,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      // verifying otp
                      if (iscode) {
                        if (currentpin.length < 6) {
                          errorController.add(ErrorAnimationType
                              .shake); // Triggering error shake animation
                          setState(() {
                            hasError = true;
                          });
                        } else {
                          setState(() {
                            hasError = false;
                          });
                          isloading = true;
                          signInWithCredential(PhoneAuthProvider.credential(
                            verificationId: verificationId,
                            smsCode: currentpin,
                          )).then((UserCredential value) {
                              if (value != null) {
                                userId = value.user.uid;
                                FirebaseFirestore.instance
                                    .collection("profile")
                                    .where("mobile", isEqualTo:
                                        widget.phonenumber)
                                    .snapshots()
                                    .listen((postdata) {
                                  setState(() {
                                  isloading = false;
                                  });
                                  if (postdata.docs.isEmpty) {
                                    setState(() {
                                      progressvalue = 75;
                                      isdetail = true;
                                      iscode = false;
                                      isinterest = false;
                                      errorController.close();
                                    });
                                  } else {
                                    // when user fills number and proceed to Otp
                                    SharedPreferencesTest().checkIsLogin("0");
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DashboardView()),
                                    );
                                  }
                                });
                              }
                          }).catchError((error) {
                            setState(() {
                              isloading = false;
                              showInSnackBar(error.message);
                            });
                          });
                        }
                      } else if (isdetail) {
                        // verifying details being entered by user
                        if (firstname.text.trim().isEmpty)
                          showInSnackBar(StringConstants.firstname);
                        else if (lastname.text.trim().isEmpty)
                          showInSnackBar(StringConstants.lastname);
                        else if (email.text.trim().isEmpty)
                          showInSnackBar(StringConstants.emptyemail);
                        else if (emailValidator(email.text.toString()))
                          showInSnackBar(StringConstants.validemail);
                        else {
                          progressvalue = 100;
                          isdetail = false;
                          iscode = false;
                          isinterest = true;
                          errorController.close();
                        }
                      } else {
                        setState(() {
                          isloading = true;
                          // getting user interest
                          for (int i = 0; i < intrestlist.length; i++)
                          {
                            if (intrestlist.elementAt(i).isselected) {
                              selectedintrest
                                  .add(intrestlist.elementAt(i).name);
                            }
                          }
                          // saving user data in database
                          FirebaseFirestore.instance
                              .collection("profile")
                              .doc(userId)
                              .set({
                            "firstname": firstname.text.trim().toString(),
                            "lastname": lastname.text.trim().toString(),
                            "email": email.text.trim().toString(),
                            "class": selectededucation,
                            "intrest[]": selectedintrest,
                            "uid" : userId,
                            "mobile" : widget.phonenumber,
                            "gender" : "Male",
                            "countrycode" :widget.countrycode,
                            "country" : widget.selectedcountry.code,
                            "istest" : false,
                            "testprogress" : "0",
                            "mypoints" : "0",
                            "Discount 10" :false,
                            "Discount 30" :false,
                            "Discount 50" :false,
                            "timespent" :false,
                            "istestcompleted" :false,
                            "profilePicUrl":"",
                            "istestpointclaimed" : false
                          }).then((value) {
                            setState(() {
                              isloading = false;
                              // after successfull login saving user as logged in database
                              SharedPreferencesTest().checkIsLogin("0");
                              // redirecting to dashboard
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => DashboardView()));
                            });
                          }).catchError((error) {
                            setState(() {
                              isloading = false;
                              showInSnackBar(error.message);
                            });
                          });
                        });
                      }
                    });
                  },
                  child: Container(
                      width: SizeConfig.blockSizeHorizontal * 40,
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.blockSizeVertical * 1.25),
                      alignment:
                          iscode ? Alignment.center : Alignment.bottomCenter,
                      margin: EdgeInsets.only(
                        top: iscode || isdetail
                            ? SizeConfig.blockSizeVertical * 4.5
                            : SizeConfig.blockSizeVertical * 2,
                        right: iscode ? 0 : SizeConfig.blockSizeHorizontal * 4,
                        bottom: iscode ? 0 : SizeConfig.blockSizeVertical * 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.buttonbg,
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Text(StringConstants.next.toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.blockSizeVertical * 2.5,
                              color: Colors.white,
                              fontFamily: StringConstants.font,
                              fontStyle: FontStyle.normal))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    widgetList.add(child);
    if (isloading) {
      final modal = new Stack(
        children: [
          new Opacity(
            opacity: 0.5,
            child: ModalBarrier(dismissible: false, color: Colors.grey),
          ),
          new Center(
            child: new CircularProgressIndicator(
              valueColor:
                  new AlwaysStoppedAnimation<Color>(AppColors.progresscolor),
            ),
          ),
        ],
      );
      widgetList.add(modal);
    }

    return WillPopScope(
        onWillPop: () {
          setState(() {
            if (isdetail) {
              progressvalue = 25;
              iscode = true;
              errorController.close();
              isdetail = false;
              isinterest = false;
            } else if (isinterest) {
              progressvalue = 75;
              iscode = false;
              isdetail = true;
              errorController.close();
              isinterest = false;
            } else {
              errorController.close();
              isloading = false;
            }
          });
        },
        child: Stack(children: widgetList));
  }
  // sending otp to user
  Future<void> verifyPhone(BuildContext context) async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      print(verId);
    };
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: widget.countrycode +
              widget.phonenumber, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent: (String verificationId, [int forceResendingToken]) {
            this.verificationId = verificationId;
            print(verificationId);
            showInSnackBar(StringConstants.code);
          }, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (FirebaseAuthException exception) {
            print('${exception.message}');
            showInSnackBar(exception.message);
          });
    } catch (e) {
      print("error" + e.toString());

    }
  }

  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    return _firebaseAuth.signInWithCredential(credential);
  }

  void showInSnackBar(String value)
  {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
  }

  bool emailValidator(String value)
  {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return true;
    } else {
      return false;
    }
  }
}
