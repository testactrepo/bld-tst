import 'dart:math' show cos, sqrt, asin;

import 'package:bld_test/constants/AppColors.dart';
import 'package:bld_test/constants/StringConstants.dart';
import 'package:bld_test/screens/home/HomeScreen.dart';
import 'package:bld_test/screens/home/TakeTest/QuestionsScreen.dart';
import 'package:bld_test/screens/myservices/MyServices.dart';
import 'package:bld_test/screens/profile/ProfileScreen.dart';
import 'package:bld_test/screens/rewards/RewardsScreen.dart';
import 'package:bld_test/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Services extends StatefulWidget {
  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedIndex = 0;
  List<String> service = new List();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light));
    service.add(StringConstants.sop);
    service.add(StringConstants.collegewriting.toUpperCase());
    service.add(StringConstants.externship.toUpperCase());
    service.add(StringConstants.collegeshortlisting.toUpperCase());
    service.add(StringConstants.resume.toUpperCase());
  }

  @override
  Widget build(BuildContext context) {
    // showing services detail as per specs
    SizeConfig().init(context);
    return Container(
        width: SizeConfig.blockSizeHorizontal * 100,
        height: SizeConfig.blockSizeVertical * 100,
        color: Colors.white,
        margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.blockSizeVertical * 3,
                      horizontal: SizeConfig.blockSizeHorizontal * 2),
                  child: Column(children: [
                    Stack(
                      children: [
                        Container(
                          width: SizeConfig.blockSizeHorizontal * 100,
                          alignment: Alignment.center,
                          child: Text(
                            StringConstants.applicationservice.toUpperCase(),
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
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal:SizeConfig.blockSizeHorizontal*2,vertical: SizeConfig.blockSizeVertical*0.1),
                              child: Icon(
                                Icons.arrow_back,
                                size: SizeConfig.blockSizeVertical * 3.2,
                                color: Colors.black,
                              ),
                            )),
                      ],
                    ),
                    Container(
                        width: SizeConfig.blockSizeHorizontal * 100,
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 1),
                        child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.25,
                              crossAxisSpacing:
                                  SizeConfig.blockSizeHorizontal * 2,
                              mainAxisSpacing: 1.0,
                            ),
                            itemCount: service.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {},
                                child: Container(
                                  width: SizeConfig.blockSizeHorizontal * 47,
                                  height: SizeConfig.blockSizeVertical * 18,
                                  margin: EdgeInsets.only(
                                      top: SizeConfig.blockSizeVertical * 1),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  child: Stack(
                                    children: [
                                      Container(
                                          width:
                                              SizeConfig.blockSizeHorizontal *
                                                  47,
                                          height:
                                              SizeConfig.blockSizeVertical * 18,
                                          child: Image.asset(
                                            "asset/images/service_grad.png",
                                            fit: BoxFit.fill,
                                          )),
                                      Container(
                                        width:
                                            SizeConfig.blockSizeHorizontal * 47,
                                        height:
                                            SizeConfig.blockSizeVertical * 18,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(children: [
                                            Container(
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  47,
                                              alignment: Alignment.topLeft,
                                              margin: EdgeInsets.only(
                                                  top: SizeConfig
                                                          .blockSizeVertical *
                                                      1.5,
                                                  left: SizeConfig
                                                          .blockSizeHorizontal *
                                                      3),
                                              child: Text(
                                               service.elementAt(index),
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontFamily:
                                                        StringConstants.font,
                                                    fontSize: SizeConfig
                                                            .blockSizeVertical *
                                                        2.1,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle:
                                                        FontStyle.normal),
                                              ),
                                            ),
                                            index==0?
                                            Container(
                                              width: SizeConfig
                                                  .blockSizeHorizontal *
                                                  47,
                                              alignment: Alignment.topLeft,
                                              margin: EdgeInsets.only(
                                                top: SizeConfig.blockSizeVertical*1,
                                                  left: SizeConfig
                                                      .blockSizeHorizontal *
                                                      3),
                                              child: Text(
                                                StringConstants.sopdetail,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontFamily:
                                                    StringConstants.font,
                                                    fontSize: SizeConfig
                                                        .blockSizeVertical *
                                                        1.55,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle:
                                                    FontStyle.normal),
                                              ),
                                            ):SizedBox(),
                                            ],),
                                            InkWell(
                                              onTap: () {},
                                              child: Container(
                                                  width: SizeConfig
                                                          .blockSizeHorizontal *
                                                      25,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: SizeConfig
                                                              .blockSizeVertical *
                                                          0.5),
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      bottom: SizeConfig
                                                              .blockSizeVertical *
                                                          1.5,
                                                      left: SizeConfig
                                                              .blockSizeHorizontal *
                                                          3),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                14.0)),
                                                  ),
                                                  child: Text(StringConstants.explore.toUpperCase(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: SizeConfig.blockSizeVertical * 1.6,
                                                          color: Colors.black,
                                                          fontFamily: StringConstants.font,
                                                          fontStyle: FontStyle.normal))),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })),
                  ])),
            )));
  }
}
