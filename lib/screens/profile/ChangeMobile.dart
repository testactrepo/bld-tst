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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ChangeMobileNumber extends StatefulWidget {
  String countrycode, phonenumber;
  ChangeMobileNumber(this.countrycode, this.phonenumber);
  @override
  _ChangeMobileNumberViewState createState() => _ChangeMobileNumberViewState();
}

class _ChangeMobileNumberViewState extends State<ChangeMobileNumber> {
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
                  child: Text(StringConstants.mobile + ".",
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
// Next Button
              Align(
                alignment: Alignment.center,
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
                            setState(() {
                              if (value != null) {
                                userId = value.user.uid;
                              }
                            });
                          }).catchError((error) {
                            setState(() {
                              isloading = false;
                              showInSnackBar(error.message);
                            });
                          });
                        }
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
