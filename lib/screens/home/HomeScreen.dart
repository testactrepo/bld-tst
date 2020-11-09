import 'dart:developer';

import 'package:bld_test/constants/AppColors.dart';
import 'package:bld_test/constants/StringConstants.dart';
import 'package:bld_test/screens/home/ServicesDetail.dart';
import 'package:bld_test/screens/home/TestScreen.dart';
import 'package:bld_test/utils/SizeConfig.dart';
import 'package:bld_test/widgets/CommonWidgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> photos = new List();
  @override
  void initState() {
    super.initState();
    photos.clear();
    // getting sneakpeek stories from database
    FirebaseFirestore.instance
        .collection("sneakpeek")
        .snapshots()
        .listen((postdata) {
      setState(() {
        for(int i=0;i<postdata.docs[0]['data'].length;i++)
          {
            photos.add(postdata.docs[0]['data'].elementAt(i).toString());
          }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
        width: SizeConfig.blockSizeHorizontal * 100,
        height: SizeConfig.blockSizeVertical * 100,
        color: Colors.white,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: SizeConfig.blockSizeHorizontal * 100,
                      height: SizeConfig.blockSizeVertical * 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Image.asset(
                        "asset/images/dashboard_bg.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                        width: SizeConfig.blockSizeHorizontal * 100,
                        height: SizeConfig.blockSizeVertical * 42,
                        decoration: new BoxDecoration(
                            ),
                        child: Image.asset(
                          "asset/images/dash_gradient.png",
                          fit: BoxFit.fill,
                        )),
                    Container(
                        margin: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal * 4,
                            right: SizeConfig.blockSizeHorizontal * 4,
                            top: SizeConfig.blockSizeVertical * 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(
                                      top: SizeConfig.blockSizeVertical * 1,
                                    ),
                                    child: Icon(
                                      Icons.menu,
                                      color: Colors.white,
                                      size: SizeConfig.blockSizeVertical * 4,
                                    )),
                                Container(
                                    width: SizeConfig.blockSizeHorizontal * 21,
                                    margin: EdgeInsets.only(
                                        top: SizeConfig.blockSizeVertical * 1,
                                        left:
                                            SizeConfig.blockSizeHorizontal * 4),
                                    child: Text(
                                      StringConstants.medici +"\n"+
                                          StringConstants.labs.toUpperCase(),
                                      style: TextStyle(
                                          fontSize:
                                              SizeConfig.blockSizeVertical *
                                                  2.35,
                                          fontFamily: StringConstants.font,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ))
                              ],
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                    top: SizeConfig.blockSizeVertical * 2.75),
                                alignment: Alignment.centerLeft,
                                width: SizeConfig.blockSizeHorizontal * 70,
                                child: Text(
                                  StringConstants.college.toUpperCase(),
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 3,
                                      fontFamily: StringConstants.font,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing:
                                          SizeConfig.blockSizeHorizontal * 0.15),
                                )),
                            Container(
                                margin: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 2,
                                  left: SizeConfig.blockSizeHorizontal * 1,
                                ),
                                width: SizeConfig.blockSizeHorizontal * 85,
                                child: Text(
                                  StringConstants.writingservices,
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 2,
                                      fontFamily: StringConstants.font,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing:
                                          SizeConfig.blockSizeHorizontal * 0.1),
                                )),
                            Container(
                                margin: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 0.1,
                                  left: SizeConfig.blockSizeHorizontal * 1,
                                ),
                                width: SizeConfig.blockSizeHorizontal * 85,
                                child: Text(
                                  StringConstants.yourneeds,
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 2,
                                      fontFamily: StringConstants.font,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing:
                                          SizeConfig.blockSizeHorizontal *
                                              0.05),
                                )),

                          ],
                        ))
                  ],
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 1.75,
                        left: SizeConfig.blockSizeHorizontal * 4,
                        right: SizeConfig.blockSizeHorizontal * 4),
                    child: Text(
                      StringConstants.sneak.toUpperCase(),
                      style: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical * 2.2,
                        fontFamily: StringConstants.font,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.left,
                    )),
                Container(
                    margin: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 1.5,
                        left: SizeConfig.blockSizeHorizontal * 4,
                        right: SizeConfig.blockSizeHorizontal * 4),
                    width: SizeConfig.blockSizeHorizontal * 100,
                    height: SizeConfig.blockSizeHorizontal * 18,
                    child: ListView.builder(
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: photos.length,
                      itemBuilder: (context, position) {
                        return InkWell(
                          onTap: () {},
                          child: Container(
                            width: SizeConfig.blockSizeHorizontal * 16,
                            height: SizeConfig.blockSizeHorizontal * 16,
                            margin: EdgeInsets.only(
                                right: SizeConfig.blockSizeHorizontal * 6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    randomColor(), //                   <--- border color
                                width: 3.0,
                              ),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(photos.elementAt(position)),
                              ),
                            ),
                          ),
                        );
                        //controller: _scrollController,
                      },
                    )),
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 2.5,
                        left: SizeConfig.blockSizeHorizontal * 4,
                        right: SizeConfig.blockSizeHorizontal * 4),
                    child: Text(
                      StringConstants.tailor.toUpperCase(),
                      style: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical * 2.2,
                        fontFamily: StringConstants.font,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.left,
                    )),
                InkWell(
                  onTap: () {

                  },
                  child: Container(
                      width: SizeConfig.blockSizeHorizontal * 100,
                      height: SizeConfig.blockSizeVertical * 20,
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * 4,
                          vertical: SizeConfig.blockSizeVertical * 2),
                      decoration: BoxDecoration(
                          color: AppColors.tilecolor,
                          borderRadius:
                              BorderRadius.all(Radius.circular(6.0))),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(
                                      top: SizeConfig.blockSizeVertical * 1.75,
                                      left: SizeConfig.blockSizeHorizontal * 6),
                                  child: Text(
                                    StringConstants.psychometric,
                                    style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 2.5,
                                      fontFamily: StringConstants.font,
                                      letterSpacing:
                                          SizeConfig.blockSizeHorizontal *
                                              0.125,
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
                                      left: SizeConfig.blockSizeHorizontal * 6),
                                  child: Text(
                                    StringConstants.ptestdetail,
                                    style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 1.7,
                                      fontFamily: StringConstants.font,
                                      letterSpacing:
                                          SizeConfig.blockSizeHorizontal *
                                              0.125,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.left,
                                  )),
                              InkWell(
                                  onTap: () {
                                    // redirecting to Test Screen
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) => TestScreen()));
                                  },
                                  child: Container(
                                      width:
                                          SizeConfig.blockSizeHorizontal * 35,
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              SizeConfig.blockSizeVertical *
                                                  0.75),
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(
                                          top: SizeConfig.blockSizeVertical *
                                              2.25,
                                          left: SizeConfig.blockSizeHorizontal *
                                              6),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(22.0)),
                                      ),
                                      child: Text(
                                          StringConstants.takenow.toUpperCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize:
                                                  SizeConfig.blockSizeVertical *
                                                      1.7,
                                              color: Colors.black,
                                              fontFamily: StringConstants.font,
                                              fontStyle: FontStyle.normal)))),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                                margin: EdgeInsets.only(
                                    right: SizeConfig.blockSizeHorizontal * 8),
                                child: Image.asset(
                                  "asset/images/brain.png",
                                  fit: BoxFit.fill,
                                )),
                          ),
                        ],
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 1.75,
                            left: SizeConfig.blockSizeHorizontal * 4,
                            right: SizeConfig.blockSizeHorizontal * 4),
                        child: Text(
                          StringConstants.ourservices.toUpperCase(),
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical * 2.2,
                            fontFamily: StringConstants.font,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.left,
                        )),
                    Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 1.75,
                            left: SizeConfig.blockSizeHorizontal * 4,
                            right: SizeConfig.blockSizeHorizontal * 4),
                        child: Text(
                          StringConstants.exploreall,
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical * 1.95,
                            fontFamily: StringConstants.font,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            color: AppColors.explore,
                          ),
                          textAlign: TextAlign.left,
                        )),
                  ],
                ),
                InkWell(
                  onTap: () {

                    // redirecting to services Screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Services()));
                  },
                  child: Container(
                    width: SizeConfig.blockSizeHorizontal * 100,
                    height: SizeConfig.blockSizeVertical * 20,
                    margin: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 4,
                        vertical: SizeConfig.blockSizeVertical * 3),
                    decoration: BoxDecoration(
                        color: AppColors.tilecolor,
                        borderRadius: BorderRadius.all(Radius.circular(6.0))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical * 1.75,
                                left: SizeConfig.blockSizeHorizontal * 6),
                            child: Text(
                              StringConstants.applicationservice + ".",
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
                            width: SizeConfig.blockSizeHorizontal * 50,
                            margin: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical * 2.2,
                                left: SizeConfig.blockSizeHorizontal * 6),
                            child: Text(
                              StringConstants.kickstart,
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
                  ),
                ),
                InkWell(
                  onTap: ()
                  {
                    // shwoing alert of coming soon
                    showalert(context, StringConstants.comingsoon);
                  },
                  child: Container(
                    width: SizeConfig.blockSizeHorizontal * 100,
                    height: SizeConfig.blockSizeVertical * 20,
                    margin: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 4,right: SizeConfig.blockSizeHorizontal * 4,
                        bottom: SizeConfig.blockSizeVertical * 2),
                    decoration: BoxDecoration(
                        color: AppColors.tilecolor,
                        borderRadius: BorderRadius.all(Radius.circular(6.0))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical * 1.75,
                                left: SizeConfig.blockSizeHorizontal * 6),
                            child: Text(
                              StringConstants.counselling + ".",
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
                            width: SizeConfig.blockSizeHorizontal * 70,
                            margin: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical * 2.2,
                                left: SizeConfig.blockSizeHorizontal * 6),
                            child: Text(
                              StringConstants.careerdetail,
                              style: TextStyle(
                                fontSize: SizeConfig.blockSizeVertical * 1.7,
                                fontFamily: StringConstants.font,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.left,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

}
