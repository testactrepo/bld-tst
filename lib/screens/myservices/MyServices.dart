import 'package:bld_test/constants/AppColors.dart';
import 'package:bld_test/constants/StringConstants.dart';
import 'package:bld_test/screens/home/TakeTest/QuestionsScreen.dart';
import 'package:bld_test/utils/SizeConfig.dart';
import 'package:bld_test/widgets/CommonWidgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class Myservices extends StatefulWidget
{
  @override
  _MyservicesState createState() => _MyservicesState();
}

class _MyservicesState extends State<Myservices>
{
  User user;
  var getData;
  int index=0;
  bool testcompleted = false;
  @override
  void initState()
  {
    super.initState();
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
          testcompleted = getData['istestcompleted'];
        });
      });
    });
    FirebaseFirestore.instance
        .collection("usertestreports")
        .where("uid", isEqualTo: user.uid)
        .snapshots()
        .listen((testdata) {
        index = testdata.docs[0]['testindex'] + 1;
        setState(() {

        });
      });
  }

  @override
  Widget build(BuildContext context)
  {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,/* set Status bar icons color in Android devices.*/
        statusBarBrightness: Brightness.light));
    SizeConfig().init(context);
   var progress = double.parse(getData!=null?getData['testprogress']:"0").toStringAsFixed(1);
    double prog = double.parse(progress);
    return Container(
        width: SizeConfig.blockSizeHorizontal*100,
        height: SizeConfig.blockSizeVertical*100,
        color: Colors.white,
        child: Scaffold(body: SingleChildScrollView(child: Column(children: [
          Stack(children: [
            Container(
              width: SizeConfig.blockSizeHorizontal*100,height: SizeConfig.blockSizeVertical*24,
                child:  Image.asset("asset/images/myservice_grad.png",fit: BoxFit.fill,)),
            Container(
                margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*4,right: SizeConfig.blockSizeHorizontal*4,top: SizeConfig.blockSizeVertical*2),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*1.5),alignment: Alignment.center,
                        child:Text(StringConstants.myservices.toLowerCase(),style: TextStyle(fontSize: SizeConfig.blockSizeVertical*3.5,fontFamily: StringConstants.font,fontStyle: FontStyle.normal,fontWeight: FontWeight.w600,color: Colors.white,letterSpacing: SizeConfig.blockSizeHorizontal*0.1),)),
                  ],)),

            Container(
              width: SizeConfig.blockSizeHorizontal*100,height: SizeConfig.blockSizeVertical*20,
              margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*5,right: SizeConfig.blockSizeHorizontal*5,top: SizeConfig.blockSizeVertical*14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 4,
                    blurRadius: 16,
                    offset: Offset(0,3), // changes position of shadow
                  ),
                ],

              ),
              child:getData!=null?getData['istest']!=null?getData['istest']?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2.5,left: SizeConfig.blockSizeHorizontal*5),
                      child:Text(StringConstants.psychometric,style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.5,fontFamily: StringConstants.font,
                        fontStyle: FontStyle.normal,fontWeight: FontWeight.w700,color: Colors.black,),textAlign: TextAlign.center,)),
                  Row(children: [
                  Container(
                    width: SizeConfig.blockSizeHorizontal*50,
                    margin: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 2,
                        left: SizeConfig.blockSizeHorizontal * 5,
                        right: SizeConfig.blockSizeHorizontal * 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(9.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0,2), // changes position of shadow
                        ),
                      ],

                    ),
                    child: FAProgressBar(
                      currentValue: prog.toInt(),
                      progressColor: AppColors.testprogress,
                      size: 5,
                      borderRadius: 7,
                    ),
                  ),
                    Expanded(
                      child: Container(margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2,left: SizeConfig.blockSizeHorizontal*4),
                          child:Text(progress.toString()+StringConstants.complete,style: TextStyle(fontSize: SizeConfig.blockSizeVertical*1.8,fontFamily: StringConstants.font,
                            fontStyle: FontStyle.normal,fontWeight: FontWeight.w600,color: Colors.black,),textAlign: TextAlign.center,)),
                    ),

                  ],),
                  InkWell(
                    onTap: () {
                      if(!getData['istestcompleted']) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    QuestionScreen("Services", index))).then((
                            value) {
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
                      }
                    },
                    child: Container(
                        width: SizeConfig.blockSizeHorizontal * 25,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.blockSizeVertical * 0.5),
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 2.75,
                            left: SizeConfig.blockSizeHorizontal * 4),
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
                         testcompleted?StringConstants.completed: StringConstants.resme.toUpperCase(),
                          style: TextStyle(
                              fontFamily: StringConstants.font,
                              fontWeight: FontWeight.w700,
                              fontSize:
                              SizeConfig.blockSizeVertical * 1.7,
                              color: Colors.black,
                              fontStyle: FontStyle.normal),
                        )),
                  ),
                ],): Container( width: SizeConfig.blockSizeHorizontal*100,
                  height:SizeConfig.blockSizeVertical*18, alignment: Alignment.center,
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*1,left: SizeConfig.blockSizeHorizontal*4),
                  child:Text(StringConstants.purchase,style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.25,fontFamily: StringConstants.font,
                    fontStyle: FontStyle.normal,fontWeight: FontWeight.w700,color: Colors.black,),textAlign: TextAlign.center,)): Container( width: SizeConfig.blockSizeHorizontal*100,
                  height:SizeConfig.blockSizeVertical*18, alignment: Alignment.center,margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*1,left: SizeConfig.blockSizeHorizontal*4),
                  child:Text(StringConstants.purchase,style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.25,fontFamily: StringConstants.font,
                    fontStyle: FontStyle.normal,fontWeight: FontWeight.w600,color: Colors.black,),textAlign: TextAlign.center,)):Container( width: SizeConfig.blockSizeHorizontal*100,
                  height:SizeConfig.blockSizeVertical*18, alignment: Alignment.center,
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*1,left: SizeConfig.blockSizeHorizontal*4),
                  child:Text(StringConstants.purchase,style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.25,fontFamily: StringConstants.font,
                    fontStyle: FontStyle.normal,fontWeight: FontWeight.w700,color: Colors.black,),textAlign: TextAlign.center,)),
            ),
          ],),
          Container(
            width: SizeConfig.blockSizeHorizontal*75,height: SizeConfig.blockSizeVertical*28,
              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*4),
              child:  Image.asset("asset/images/myservice_bg.png",fit: BoxFit.fill,)),
          Container(
              width: SizeConfig.blockSizeHorizontal*75,
              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*5),
              child:Text(StringConstants.servicedetail,textAlign:TextAlign.center,style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.15,fontFamily: StringConstants.font,fontStyle: FontStyle.normal,fontWeight: FontWeight.w700,color: Colors.black,),)),


        ],),),

        ));
  }

}

