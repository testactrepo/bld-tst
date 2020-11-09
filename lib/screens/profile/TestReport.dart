import 'package:bld_test/constants/AppColors.dart';
import 'package:bld_test/constants/StringConstants.dart';
import 'package:bld_test/data/models/Report.dart';
import 'package:bld_test/utils/SizeConfig.dart';
import 'package:bld_test/widgets/CommonWidgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TestReport extends StatefulWidget {
  @override
  _TestReportState createState() => _TestReportState();
}

class _TestReportState extends State<TestReport> {
   List<Report> report = new List();
   double agree=0.0,conscient=0.0,extraversion=0.0,neuro =0,open=0.0;
   User user;
   var data;
  @override
  void initState() {
    super.initState();
    report.add(Report(StringConstants.agreeableness,StringConstants.tough,StringConstants.generous));
    report.add(Report(StringConstants.conscient,StringConstants.easygoing,StringConstants.focused));
    report.add(Report(StringConstants.extraversion,StringConstants.quiet,StringConstants.social));
    report.add(Report(StringConstants.neuroticsm,StringConstants.strong,StringConstants.senstitive));
    report.add(Report(StringConstants.openness,StringConstants.practical,StringConstants.imaginative));
    user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection("usertestreports")
        .where("uid", isEqualTo: user.uid)
        .snapshots()
        .listen((postdata) {
      setState(() {
         data = postdata;
         agree = double.parse(data.docs[0]['agreeableness']);
         conscient = double.parse(data.docs[0]['conscient']);
         extraversion = double.parse(data.docs[0]['extraversion']);
         neuro = double.parse(data.docs[0]['neuroticism']);
         open = double.parse(data.docs[0]['openness']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
        width: SizeConfig.blockSizeHorizontal * 100,
        height: SizeConfig.blockSizeVertical * 100,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              brightness: Brightness.light,
              leading: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * 2,
                          vertical: SizeConfig.blockSizeVertical * 0.25),
                      child: Icon(
                        Icons.arrow_back,
                        size: SizeConfig.blockSizeVertical * 3.5,
                        color: Colors.black,
                      ))),
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: Text(StringConstants.psychometricreport.toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: SizeConfig.blockSizeVertical * 2.05,
                      color: Colors.black,
                      fontFamily: StringConstants.font,
                      fontStyle: FontStyle.normal)),
            ),
            body: Container(
              color: Colors.white,
              width: SizeConfig.blockSizeHorizontal * 100,
              height: SizeConfig.blockSizeVertical * 100,
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: SizeConfig.blockSizeVertical * 1.5,
                    ),
                    width: SizeConfig.blockSizeHorizontal * 100,
                    child: ListView.builder(
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: report.length,
                        itemBuilder: (context, position) {
                          return Container(
                            margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical*5),
                            child: Column(
                              children: [
                                Container(
                                  width: SizeConfig.blockSizeHorizontal*100,
                                  margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*1),
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            SizeConfig.blockSizeHorizontal *
                                                2.5,
                                        vertical:
                                            SizeConfig.blockSizeVertical * 1),
                                    color: AppColors.graphheader,
                                    child: Text(
                                      report.elementAt(position).name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize:
                                              SizeConfig.blockSizeVertical * 2.15,
                                          color: Colors.white,
                                          fontFamily: StringConstants.font,
                                          fontStyle: FontStyle.normal),
                                    )),
                                Column(
                                  children: [
                                    Container(
                                      width: SizeConfig.blockSizeHorizontal * 100,
                                      margin: EdgeInsets.only(
                                          left: SizeConfig.blockSizeHorizontal * 4,
                                          right: SizeConfig.blockSizeHorizontal * 4,
                                          top: SizeConfig.blockSizeVertical * 3),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  30,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: SizeConfig
                                                          .blockSizeVertical *
                                                      0.25),
                                              child: Text(
                                                report.elementAt(position).det1,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: SizeConfig
                                                            .blockSizeVertical *
                                                        1.9,
                                                    color: Colors.black,
                                                    fontFamily:
                                                        StringConstants.font,
                                                    fontStyle:
                                                        FontStyle.normal),
                                              )),
                                          Container(
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  30,
                                              alignment: Alignment.centerRight,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: SizeConfig
                                                          .blockSizeVertical *
                                                      0.25),
                                              child: Text(
                                                report.elementAt(position).det2,
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: SizeConfig
                                                            .blockSizeVertical *
                                                        1.9,
                                                    color: Colors.black,
                                                    fontFamily:
                                                        StringConstants.font,
                                                    fontStyle:
                                                        FontStyle.normal),
                                              )),
                                        ],
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(
                                            top: SizeConfig.blockSizeVertical *
                                                1.5),
                                        height:
                                            SizeConfig.blockSizeVertical * 3.5,
                                        child: Stack(
                                          children: [
                                            Container(
                                              height:
                                                  SizeConfig.blockSizeVertical *
                                                      3.5,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: SizeConfig
                                                            .blockSizeHorizontal *
                                                        25,
                                                    height: SizeConfig
                                                            .blockSizeVertical *
                                                        3,
                                                    color:
                                                        AppColors.graphorange,
                                                    child: SizedBox(),
                                                  ),
                                                  Container(
                                                    width: SizeConfig
                                                            .blockSizeHorizontal *
                                                        25,
                                                    height: SizeConfig
                                                            .blockSizeVertical *
                                                        3,
                                                    color: AppColors.graphblue,
                                                    child: SizedBox(),
                                                  ),
                                                  Container(
                                                    width: SizeConfig
                                                            .blockSizeHorizontal *
                                                        25,
                                                    height: SizeConfig
                                                            .blockSizeVertical *
                                                        3,
                                                    color: AppColors.graphgreen,
                                                    child: SizedBox(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  6.25,
                                              height:
                                                  SizeConfig.blockSizeVertical *
                                                      3.5,
                                              margin: EdgeInsets.only(
                                                  left: getstats(position)),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                border: Border.all(
                                                    //                   <--- border color
                                                    width: 1.0,
                                                    color: Colors.white),
                                              ),
                                              child: SizedBox(),
                                            ),
                                          ],
                                        ))
                                  ],
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                ),
              ),
            )));
  }
  getstats(int index)
  {
    if(index==0)
      {
        if(agree==0)
            agree =12.5;
          else
            agree = agree;
        return SizeConfig.blockSizeHorizontal*agree;
      }
    else if(index==1)
    {
      if(conscient==0)
        conscient =12.5;
        else
          conscient = conscient;
      return SizeConfig.blockSizeHorizontal*conscient;
    }
    else if(index==2)
    {
      if(extraversion==0)
        extraversion =12.5;
      else
        extraversion =extraversion;
      return SizeConfig.blockSizeHorizontal*extraversion;
    }
    else if(index==3)
    {
      if(neuro==0)
        neuro =12.5;
      else
        neuro = neuro;
      return SizeConfig.blockSizeHorizontal*neuro;
    }
    else if(index==4)
    {
      if(open==0)
        open =12.5;
      else
        open = open;
      return SizeConfig.blockSizeHorizontal*open;
    }
  }
}
