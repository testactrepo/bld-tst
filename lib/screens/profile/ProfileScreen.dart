import 'dart:io';

import 'package:bld_test/constants/AppColors.dart';
import 'package:bld_test/constants/StringConstants.dart';
import 'package:bld_test/data/models/DropDownItem.dart';
import 'package:bld_test/screens/login/LoginScreen.dart';
import 'package:bld_test/screens/profile/TestReport.dart';
import 'package:bld_test/utils/SharedPref.dart';
import 'package:bld_test/utils/SizeConfig.dart';
import 'package:bld_test/widgets/CommonWidgets.dart';
import 'package:bld_test/widgets/Spinner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:images_picker/images_picker.dart';
import 'package:path/path.dart' as Path;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User user;
  var getData;
  File _image;
  bool isupdated = false, ismobile = false, isdetail = false,isloading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController mobile = new TextEditingController();
  final TextEditingController name = new TextEditingController();
  final TextEditingController email = new TextEditingController();
  CountryCode country;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var gender, selectedgender = 0, chosengender;
  var profileeducation;
  String countrycode;
  bool istestcompleted = false;
  List<String> education = new List();
  @override
  void initState() {
    super.initState();
    isloading = true;
    user = FirebaseAuth.instance.currentUser;
    gender = [
      DropDownItem(StringConstants.male),
      DropDownItem(StringConstants.female),
    ];
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light));
    // getting profile details from database
    FirebaseFirestore.instance
        .collection("profile")
        .where("uid", isEqualTo: user.uid)
        .snapshots()
        .listen((postdata) {
      setState(() {
        var data = postdata;
        data.docs.forEach((element) {
          getData = element.data();
          mobile.text = getData['mobile'];
          name.text = getData['firstname'];
          email.text = getData['email'];
          countrycode = getData['countrycode'];
          istestcompleted = getData['istestcompleted'];
          if(getData['gender']==StringConstants.male)
            {
              selectedgender =0;
            }
          else
            {
              selectedgender = 1;
            }
          FirebaseFirestore.instance
              .collection("intrests")
              .snapshots()
              .listen((data) {
            setState(() {
              isloading = false;
              // adding elements in array
              for (int i = 0; i < data.docs[0]['education'].length; i++) {
                education.add(data.docs[0]['education'].elementAt(i));
                if(getData['class']==data.docs[0]['education'].elementAt(i))
                  {
                    profileeducation = education.elementAt(i);
                  }
              }
            });
          });
        });
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    List<Widget> widgetList = new List<Widget>();
    var child = Container(
        width: SizeConfig.blockSizeHorizontal * 100,
        height: SizeConfig.blockSizeVertical * 100,
        child: Scaffold(
          key: _scaffoldKey,
          body: Container(
            color: Colors.white,
            width: SizeConfig.blockSizeHorizontal * 100,
            height: SizeConfig.blockSizeVertical * 100,
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: SizeConfig.blockSizeHorizontal * 100,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 3.5),
                        child: Text(
                          StringConstants.profile.toLowerCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical * 3,
                            fontFamily: StringConstants.font,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        )),
                    InkWell(
                      onTap: ()
                      {
                        if(isdetail) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  contentPadding: EdgeInsets.zero,
                                  content: setupAlertDialoadContainer(context),
                                );
                              });
                        }
                      },
                      child:Container(
                        width: SizeConfig.blockSizeHorizontal * 16,
                        height: SizeConfig.blockSizeHorizontal * 16,
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 3.5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,color: Colors.transparent,
                          border: Border.all(
                            color:
                                randomColor(), //                   <--- border color
                            width: 1,
                          ),
                          image: DecorationImage(
                            image:_image!=null?_image.path!=null && _image.path!=""?FileImage(File(_image.path)):CachedNetworkImageProvider(getData!=null?getData['profilePicUrl']!=null?getData['profilePicUrl']:"":""):CachedNetworkImageProvider(getData!=null?getData['profilePicUrl']!=null?getData['profilePicUrl']:"":""),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        width: SizeConfig.blockSizeHorizontal * 100,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 2),
                        child: Text(
                          name.text.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical * 2.25,
                            fontFamily: StringConstants.font,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        )),
                    !isdetail?
                    Container(
                        width: SizeConfig.blockSizeHorizontal * 100,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 0.75),
                        child: Text(
                          getData!=null?getData['class']!=null?getData['class']:"":"",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical * 1.65,
                            fontFamily: StringConstants.font,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            color: Colors.black45,
                          ),
                        )):
                    Container(
                      width: profileeducation.length<=5?SizeConfig.blockSizeHorizontal*30:SizeConfig.blockSizeHorizontal*45,
                      margin: EdgeInsets.only(
                          top: SizeConfig.blockSizeVertical * 0.5),
                      child: FormField<String>(
                        builder: (FormFieldState<String> state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                                isDense: true,),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: profileeducation,
                                isDense: true,isExpanded: true,
                                onChanged: (String newValue)
                                {
                                  setState(() {
                                    profileeducation = newValue;
                                    state.didChange(newValue);
                                  });
                                },
                                items: education.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                      child: Container(
                                          width: profileeducation.length<=5?SizeConfig.blockSizeHorizontal*30:SizeConfig.blockSizeHorizontal*44,alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(
                                              left: SizeConfig
                                                  .blockSizeHorizontal *
                                                  5),
                                          child: Text(value,
                                              style: TextStyle(
                                            fontSize: SizeConfig.blockSizeVertical * 1.65,
                                            fontFamily: StringConstants.font,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black45,
                                          ),)),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                        width: SizeConfig.blockSizeHorizontal * 100,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 4),
                        child: Text(
                          StringConstants.accdetail,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical * 1.9,
                              fontFamily: StringConstants.font,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              letterSpacing:
                                  SizeConfig.blockSizeHorizontal * 0.075),
                        )),
                    Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.blockSizeVertical * 2.5),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              InkWell(
                                  child: Container(
                                child: Icon(
                                  Icons.phone,
                                  size: SizeConfig.blockSizeVertical * 2.75,
                                  color: AppColors.profileicon,
                                ),
                              )),

                              Stack(children: [
                                ismobile?
                                Container(
                                  width:countrycode.length>3?SizeConfig.blockSizeHorizontal * 27:SizeConfig.blockSizeHorizontal*25,
                                  alignment: Alignment.bottomRight,
                                  child: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: SizeConfig.blockSizeVertical * 3.75,
                                  ),
                                ):SizedBox(),
                              Container(
                                width:
                                ismobile?countrycode.length>3?SizeConfig.blockSizeHorizontal * 25:SizeConfig.blockSizeHorizontal*22:SizeConfig.blockSizeHorizontal * 17.5,
                                height:
                                SizeConfig.blockSizeVertical * 4.25,
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(
                                    left: SizeConfig.blockSizeHorizontal * 4),
                                child: CountryCodePicker(
                                  onChanged: _onCountryChange,enabled: ismobile,
                                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                  initialSelection:getData!=null?getData['country']!=null?getData['country']:'US':'US',
                                  // optional. Shows only country name and flag
                                  showCountryOnly: false,
                                  padding: EdgeInsets.all(0.0),
                                  textStyle: TextStyle(
                                      fontFamily: StringConstants.cera,
                                      fontSize:
                                      SizeConfig.blockSizeVertical * 1.95,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal),
                                  showFlag: false,
                                  // optional. Shows only country name and flag when popup is closed.
                                  showOnlyCountryWhenClosed: false,
                                  // optional. aligns the flag and the Text left
                                  alignLeft: false,
                                ),
                              ),

                              ],),
                              Container(
                                width: ismobile?SizeConfig.blockSizeHorizontal * 49:SizeConfig.blockSizeHorizontal * 56,alignment: Alignment.centerLeft,
                                child: TextFormField(
                                  cursorColor: Colors.black,
                                  enabled: ismobile,textAlign: TextAlign.start,
                                  onFieldSubmitted: (v)
                                  {

                                  },
                                  controller: mobile,
                                  style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeVertical * 1.9,
                                    fontFamily: StringConstants.font,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          top: SizeConfig.blockSizeVertical *
                                              0.2,
                                          bottom: SizeConfig.blockSizeVertical *
                                              0.2,
                                          left: ismobile?SizeConfig.blockSizeVertical *
                                              0.45:SizeConfig.blockSizeHorizontal*0.2),
                                      isDense: true,
                                      hintText: StringConstants.hintmobile,
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                          fontFamily: StringConstants.font,
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              SizeConfig.blockSizeVertical *
                                                  1.8,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black54)),
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.done,
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      isupdated = true;
                                      ismobile = true;
                                      isdetail = false;
                                    });
                                  },
                                  child: Container(
                                    child: Icon(
                                      Icons.edit,
                                      size: SizeConfig.blockSizeVertical * 2.75,
                                      color: AppColors.profileicon,
                                    ),
                                  )),
                            ],
                          ),
                          Container(
                              margin: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 2.5,
                                  left: SizeConfig.blockSizeHorizontal * 4),
                              width: SizeConfig.blockSizeHorizontal * 100,
                              height: SizeConfig.blockSizeVertical * 0.125,
                              color: Colors.black,
                              child: SizedBox())
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical * 2.25),
                            child: Text(
                              StringConstants.profdetail,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical * 1.9,
                                  fontFamily: StringConstants.font,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  letterSpacing:
                                      SizeConfig.blockSizeHorizontal * 0.075),
                            )),
                        Spacer(),
                        InkWell(
                            onTap: () {
                              setState(() {
                                isupdated = true;
                                ismobile = false;
                                isdetail = true;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 2),
                              child: Icon(
                                Icons.edit,
                                size: SizeConfig.blockSizeVertical * 2.75,
                                color: AppColors.profileicon,
                              ),
                            )),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.blockSizeVertical * 3.5),
                      child: Row(
                        children: [
                          InkWell(
                              child: Container(
                            child: Icon(
                              Icons.person_outline,
                              size: SizeConfig.blockSizeVertical * 3,
                              color: AppColors.profileicon,
                            ),
                          )),
                          Container(
                            width: SizeConfig.blockSizeHorizontal * 80,
                            child: TextFormField(
                              cursorColor: Colors.black,
                              enabled: isdetail,
                              onFieldSubmitted: (v) {},
                              controller: name,
                              style: TextStyle(
                                fontSize: SizeConfig.blockSizeVertical * 2.1,
                                fontFamily: StringConstants.font,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      top: SizeConfig.blockSizeVertical * 0.2,
                                      bottom:
                                          SizeConfig.blockSizeVertical * 0.2,
                                      left:
                                          SizeConfig.blockSizeVertical * 2.75),
                                  isDense: true,
                                  hintText: StringConstants.hintmobile,
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      fontFamily: StringConstants.font,
                                      fontStyle: FontStyle.normal,
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 2,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54)),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.blockSizeVertical * 3.5),
                      child: Row(
                        children: [
                          InkWell(
                              child: Container(
                            child: Icon(
                              Icons.email,
                              size: SizeConfig.blockSizeVertical * 3,
                              color: AppColors.profileicon,
                            ),
                          )),
                          Container(
                            width: SizeConfig.blockSizeHorizontal * 80,
                            child: TextFormField(
                              cursorColor: Colors.black,
                              enabled: isdetail,
                              onFieldSubmitted: (v) {},
                              controller: email,
                              style: TextStyle(
                                fontSize: SizeConfig.blockSizeVertical * 2.1,
                                fontFamily: StringConstants.font,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      top: SizeConfig.blockSizeVertical * 0.2,
                                      bottom:
                                          SizeConfig.blockSizeVertical * 0.2,
                                      left:
                                          SizeConfig.blockSizeVertical * 2.75),
                                  isDense: true,
                                  hintText: StringConstants.hintmobile,
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      fontFamily: StringConstants.font,
                                      fontStyle: FontStyle.normal,
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 2,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54)),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.blockSizeVertical * 3.5),
                      child: Row(
                        children: [
                          InkWell(
                              child: Container(
                            child: Image.asset(
                              'asset/images/gender.png',
                              width: SizeConfig.blockSizeVertical * 3,
                              height: SizeConfig.blockSizeVertical * 3,
                            ),
                          )),
                          !isdetail?
                          Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.blockSizeHorizontal * 5),
                              child: Text(
                                getData!=null?getData['gender']!=null?getData['gender']:"":"",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical * 2.1,
                                  fontFamily: StringConstants.font,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              )):
                          Expanded(
                            child: DropDownSpinner(gender, (value) {
                              chosengender = value.title;
                            }, selectPos: selectedgender),
                          )
                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 4,
                            left: SizeConfig.blockSizeHorizontal * 4),
                        width: SizeConfig.blockSizeHorizontal * 100,
                        height: SizeConfig.blockSizeVertical * 0.125,
                        color: Colors.black,
                        child: SizedBox()),
                    Visibility(
                      visible: isupdated,
                      child: InkWell(
                        child: Container(
                            width: SizeConfig.blockSizeHorizontal * 35,
                            margin: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical * 2.25),
                            padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.blockSizeVertical *1.25,
                                horizontal: SizeConfig.blockSizeHorizontal * 2.5),
                            decoration: BoxDecoration(
                                color: AppColors.profileicon,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.blockSizeHorizontal * 1.5),
                              child: Text(
                                StringConstants.update,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical * 1.85,
                                  fontFamily: StringConstants.font,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing:
                                      SizeConfig.blockSizeHorizontal * 0.075,
                                ),
                              ),
                            )),
                        onTap: () {
                          if (ismobile) {
                            setState(() {
                              isloading = true;
                            });
                            FirebaseFirestore.instance
                                .collection("profile").doc(getData['uid'])
                                .update({
                              "mobile" : mobile.text.toString(),
                              "country" :country!=null?country.code:getData['country'],
                              "countrycode" : countrycode
                            }).whenComplete(() {
                              setState(() {
                                ismobile = false;
                                isdetail = false;
                                isupdated = false;
                                isloading = false;
                              });
                            });
                          } else if (isdetail)
                          {
                            setState(() {
                              isloading = true;
                            });
                          FirebaseFirestore.instance
                              .collection("profile").doc(getData['uid'])
                              .update({
                            "email" : email.text.toString(),
                            "firstname": name.text.toString(),
                            "gender" : chosengender.toString(),
                            "class" : profileeducation.toString()
                          }).whenComplete(() {
                            if(_image!=null && _image!="") {
                              uploadFile().then((String imageurl) {
                                if (imageurl.isNotEmpty) {
                                  FirebaseFirestore.instance
                                      .collection('profile')
                                      .doc(getData['uid'])
                                      .update({
                                    "profilePicUrl": imageurl,
                                  });
                                  setState(() {
                                    ismobile = false;
                                    isdetail = false;
                                    isupdated = false;
                                    isloading = false;
                                  });
                                }
                              }).catchError((onError) {});
                            }
                            else
                              {
                                setState(() {
                                  ismobile = false;
                                  isdetail = false;
                                  isupdated = false;
                                  isloading = false;
                                });
                              }
                            });
                          }
                        },
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if(istestcompleted) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      TestReport()));
                        }
                        else
                          {
                            showInSnackBar(StringConstants.reporterror);
                          }
                      },
                      child: Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 3.5),
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.blockSizeVertical * 1.65,
                              horizontal: SizeConfig.blockSizeHorizontal * 5),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1.25),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: Text(
                            StringConstants.testreport,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeVertical * 1.45,
                                fontFamily: StringConstants.font,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                letterSpacing:
                                    SizeConfig.blockSizeHorizontal * 0.075),
                          )),
                    ),
                    InkWell(
                      child: Container(
                          width: SizeConfig.blockSizeHorizontal * 30,
                          margin: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 3.25),
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.blockSizeVertical * 0.75,
                              horizontal: SizeConfig.blockSizeHorizontal * 2),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1.25),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout,
                                size: SizeConfig.blockSizeVertical * 2.5,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: SizeConfig.blockSizeHorizontal * 1.5),
                                child: Text(
                                  StringConstants.logout,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeVertical * 1.3,
                                    fontFamily: StringConstants.font,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                    letterSpacing:
                                        SizeConfig.blockSizeHorizontal * 0.075,
                                  ),
                                ),
                              )
                            ],
                          )),
                      onTap: () {
                        _signOut().then((value) {
                          // after signout redirecting to Login Screen
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => Login()));
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
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

    return Stack(children: widgetList);
  }

  // signout user from app
  Future<void> _signOut() async {
    // setting user as logged out in database
    SharedPreferencesTest().checkIsLogin("2");
    await _auth.signOut();
  }

  getname(String firstname, String lastname) {
    if (firstname != null && lastname != null) {
      return firstname + " " + lastname;
    } else {
      return "";
    }
  }
  void _onCountryChange(CountryCode countryCodeq) {
    setState(() {
      country = countryCodeq;
      countrycode = countryCodeq.dialCode;
    });
  }
  Widget setupAlertDialoadContainer(BuildContext context) {
    return Container(
        height: 240.0, // Change as per your requirement
        width: 80.0, // Change as per your requirement
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Container(
            height: 45,
            padding: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 4.0),
            color: AppColors.profileicon,
            child: Center(
              child: Text(
                "Select Picture",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,fontFamily: StringConstants.font,fontStyle: FontStyle.normal,
                    fontSize: SizeConfig.blockSizeVertical*2),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(top: 20),
            child: Material(
              color: AppColors.profileicon,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(const Radius.circular(50.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(9.0),
                child: InkWell(
                  onTap: () async {
                    chooseCameraFile().then((File file) {
                      print("file");
                      if (file != null) {
                        setState(() {
                          //   loading = true;
                        });
                      }
                    }).catchError((onError) {});
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 100,
                    child: Text(
                      "CAMERA",
                      textAlign: TextAlign.center,
                        style:TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,fontFamily: StringConstants.font,fontStyle: FontStyle.normal,
                            fontSize: SizeConfig.blockSizeVertical*2)
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(top: 20),
            child: Material(
              color: AppColors.profileicon,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(const Radius.circular(50.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(9.0),
                child: InkWell(
                  onTap: () async {
                    chooseImageFile().then((File file) {
                      if (file != null) {
                        setState(() {
                          //  loading = true;
                        });
                      }
                    }).catchError((onError) {});
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 100,
                    child: Text(
                      "GALLERY",
                      textAlign: TextAlign.center,
                        style:TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,fontFamily: StringConstants.font,fontStyle: FontStyle.normal,
                            fontSize: SizeConfig.blockSizeVertical*2)
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(top: 20),
            child: Material(
              color: AppColors.profileicon,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(const Radius.circular(40.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(9.0),
                child: InkWell(
                  onTap: () async {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                      width: 100,
                      child: Text(
                        "CANCEL",
                        textAlign: TextAlign.center,
                         style:TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,fontFamily: StringConstants.font,fontStyle: FontStyle.normal,
                              fontSize: SizeConfig.blockSizeVertical*2)
                      )),
                ),
              ),
            ),
          ),
        ]));
  }
  Future<File> chooseCameraFile() async {
    /*await ImagePicker().getImage(source: ImageSource.camera).then((image) {
      setState(() {
        _image = image;
      });
    });*/
    await ImagesPicker.openCamera(pickType: PickType.image,maxTime: 30).then((value) {
      setState(() {
        _image = new File(value.elementAt(0).path);
      });
    });
    return _image;
  }

  Future<File> chooseImageFile() async {
   /* await ImagePicker().getImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });*/
    await ImagesPicker.pick(count:1,pickType: PickType.image).then((value) {
      setState(() {
        _image = new File(value.elementAt(0).path);
      });
    });
    return _image;
  }


  Future<String> uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('profileImages/${Path.basename(_image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(File(_image.path));
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }
  void showInSnackBar(String value)
  {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
  }
}









