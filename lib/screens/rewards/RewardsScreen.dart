import 'package:bld_test/constants/AppColors.dart';
import 'package:bld_test/constants/StringConstants.dart';
import 'package:bld_test/data/models/Rewards.dart';
import 'package:bld_test/utils/SizeConfig.dart';
import 'package:bld_test/widgets/CommonWidgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Rewards extends StatefulWidget
{
  @override
  _RewardsState createState() => _RewardsState();
}

class _RewardsState extends State<Rewards> with SingleTickerProviderStateMixin
{
  TabController _tabController;
  var count = 0;
  var getdata;

  List<Reward> tasks = new List();
  List<Reward> rewards = new List();
  User user;
  var getData;
  String mypoints="0";
  bool istest=false,dis10=false,dis30=false,dis50 = false,timespent=false;
  @override
  void initState()
  {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    _tabController = TabController(vsync: this, length: 2, initialIndex: 0);

    tasks.add(Reward("Spend 10 minutes in App","20"));
    tasks.add(Reward("Take the Psychometric Test","200"));
    tasks.add(Reward("Buy a Course","400"));
    rewards.add(Reward("10% discount on all services","50"));
    rewards.add(Reward("30% discount on all services","150"));
    rewards.add(Reward("50% discount on all services","200"));

    FirebaseFirestore.instance
        .collection("profile")
        .where("uid", isEqualTo: user.uid)
        .snapshots()
        .listen((postdata) {
      setState(() {
        var data = postdata;
        data.docs.forEach((element) {
          getData = element.data();
          mypoints = getData['mypoints'];
          istest = getData['istestcompleted'];
          timespent = getData['timespent'];
          dis10 = getData['Discount 10'];
          dis30 = getData['Discount 30'];
          dis50 = getData['Discount 50'];
        });
      });
    });
  }

  @override
  Widget build(BuildContext context)
  {
    SizeConfig().init(context);
    return Container(
      width: SizeConfig.blockSizeHorizontal*100,
      height: SizeConfig.blockSizeVertical*100,
      child: Scaffold(body: Container(
        color: Colors.white,  width: SizeConfig.blockSizeHorizontal*100,
        height: SizeConfig.blockSizeVertical*100,
        child:  Container(
          color: Colors.white,padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*1.75),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: SizeConfig.blockSizeHorizontal*100,alignment: Alignment.center,
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*3.5),
                  child:Text(StringConstants.rewards.toLowerCase(),textAlign:TextAlign.center,style: TextStyle(fontSize: SizeConfig.blockSizeVertical*3,fontFamily: StringConstants.font,fontStyle: FontStyle.normal,fontWeight: FontWeight.w600,color: Colors.black,),)),
              Container(
                  width: mypoints!=null?mypoints.length>=4?SizeConfig.blockSizeHorizontal*65:SizeConfig.blockSizeHorizontal*50:SizeConfig.blockSizeHorizontal*50,
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2),padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical*1.1,horizontal: SizeConfig.blockSizeHorizontal*5),
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.rewardsbord,width: 1.75),
                      borderRadius: BorderRadius.all(Radius.circular(24.0))
                  ),
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset("asset/images/medal.png",width: SizeConfig.blockSizeVertical*2.5,height: SizeConfig.blockSizeVertical*2.5,),
                      Container(margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*1.5),
                        child: Text(StringConstants.mypoints,textAlign:TextAlign.center,style:
                        TextStyle(fontSize: SizeConfig.blockSizeVertical*1.7,fontFamily: StringConstants.font,fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,color: Colors.black,letterSpacing: SizeConfig.blockSizeHorizontal*0.075,),),
                      ),
                      Spacer(),
                      Container(margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*1.5),
                        child: Text(mypoints!=null?mypoints:"0",textAlign:TextAlign.center,style:
                        TextStyle(fontSize: SizeConfig.blockSizeVertical*1.85,fontFamily: StringConstants.font,fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w700,color: Colors.black,letterSpacing: SizeConfig.blockSizeHorizontal*0.075,),),
                      )
                    ],)),
              ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  Container(
                      color: Colors.transparent,
                      child: TabBar(
                        onTap: (index) {
                          setState(() {
                            count = 1;
                          });
                        },
                        isScrollable: false,
                        controller: _tabController,
                        labelColor: Colors.black,
                        indicatorColor: Colors.black87,
                        indicatorWeight: 1.5,
                        labelPadding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal*3.2,
                          vertical: SizeConfig.blockSizeVertical*0.25,
                        ),

                        unselectedLabelColor: Colors.black54,
                        tabs: <Widget>[
                          Container(
                            child: Text(StringConstants.tasks.toUpperCase(),style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.1,fontFamily: StringConstants.font,fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700,color: Colors.black,letterSpacing: SizeConfig.blockSizeHorizontal*0.075),),),
                          Container(
                            padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*1.75),
                            child: Text(StringConstants.redeem.toUpperCase(),style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.1,fontFamily: StringConstants.font,fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700,color: Colors.black,letterSpacing: SizeConfig.blockSizeHorizontal*0.075),),),

                        ],
                      )),
                  Container(
                    height: SizeConfig.blockSizeVertical*67,color:Colors.white,
                    padding: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical*1),
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        Container(
                            width: SizeConfig.blockSizeHorizontal * 100,
                            child: ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: tasks.length,
                              itemBuilder: (context, position) {
                                return Container(
                                  width: SizeConfig.blockSizeHorizontal*100,height: SizeConfig.blockSizeVertical*16,
                                  margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2,right: SizeConfig.blockSizeHorizontal*2,top: SizeConfig.blockSizeVertical*2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],


                                  ),
                                  child:
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(alignment: Alignment.topLeft, margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*3,left: SizeConfig.blockSizeHorizontal*5),
                                          child:Text(tasks.elementAt(position).name,style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.25,fontFamily: StringConstants.font,
                                            fontStyle: FontStyle.normal,fontWeight: FontWeight.w600,color: Colors.black,),textAlign: TextAlign.center,)),
                                      Container(
                                          margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2.5,left: SizeConfig.blockSizeHorizontal*5,right: SizeConfig.blockSizeHorizontal*5),
                                          width: SizeConfig.blockSizeHorizontal*100,height: SizeConfig.blockSizeVertical*0.125,color:Colors.black,
                                          child:SizedBox()),
                                      Container(
                                          margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2,left: SizeConfig.blockSizeHorizontal*5,right: SizeConfig.blockSizeHorizontal*5),
                                          child:
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Image.asset("asset/images/medal.png",width: SizeConfig.blockSizeVertical*3.25,height: SizeConfig.blockSizeVertical*3.25,),
                                              Container(margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*3),
                                                child: Text(tasks.elementAt(position).points+" points",textAlign:TextAlign.center,style:
                                                TextStyle(fontSize: SizeConfig.blockSizeVertical*1.7,fontFamily: StringConstants.font,fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.w600,color: Colors.black,letterSpacing: SizeConfig.blockSizeHorizontal*0.075,),),
                                              ),
                                              Spacer(),
                                              InkWell(
                                                onTap: ()
                                                {
                                                  if(position ==0)
                                                  {
                                                    if(timespent)
                                                    {
                                                      var points = int.parse(
                                                          mypoints) + 20;
                                                      FirebaseFirestore.instance
                                                          .collection("profile")
                                                          .doc(getData['uid'])
                                                          .update({
                                                        "mypoints": points
                                                            .toString(),
                                                      })
                                                          .whenComplete(() {
                                                        setState(() {

                                                        });
                                                      });
                                                    }
                                                  }
                                                  else if(position ==1)
                                                  {
                                                    if(istest) {
                                                      var points = int.parse(
                                                          mypoints) + 200;
                                                      FirebaseFirestore.instance.collection("profile").doc(getData['uid']).update({"mypoints": points.toString(),"istestcompleted": false,
                                                      }).whenComplete(() {
                                                        setState(() {

                                                        });
                                                      });
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  width: SizeConfig.blockSizeHorizontal*36,padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical*0.75),
                                                  margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*3),color: gettaskscolor(position),
                                                  child: Text(gettasksstatus(position),textAlign:TextAlign.center,style:
                                                  TextStyle(fontSize: SizeConfig.blockSizeVertical*1.9,fontFamily: StringConstants.font,fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.w700,color: Colors.black,letterSpacing: SizeConfig.blockSizeHorizontal*0.075,),),
                                                ),
                                              )
                                            ],)),
                                    ],),
                                );
                                //controller: _scrollController,
                              },
                            )),
                        Container(
                            width: SizeConfig.blockSizeHorizontal * 100,
                            child: ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: rewards.length,
                              itemBuilder: (context, position) {
                                return Container(
                                  width: SizeConfig.blockSizeHorizontal*100,height: SizeConfig.blockSizeVertical*16,
                                  margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2,right: SizeConfig.blockSizeHorizontal*2,top: SizeConfig.blockSizeVertical*2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],

                                  ),
                                  child:
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(alignment: Alignment.topLeft, margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*3,left: SizeConfig.blockSizeHorizontal*5),
                                          child:Text(rewards.elementAt(position).name,style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.25,fontFamily: StringConstants.font,
                                            fontStyle: FontStyle.normal,fontWeight: FontWeight.w600,color: Colors.black,),textAlign: TextAlign.center,)),
                                      Container(
                                          margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2.5,left: SizeConfig.blockSizeHorizontal*5,right: SizeConfig.blockSizeHorizontal*5),
                                          width: SizeConfig.blockSizeHorizontal*100,height: SizeConfig.blockSizeVertical*0.125,color:Colors.black,
                                          child:SizedBox()),
                                      Container(
                                          margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2,left: SizeConfig.blockSizeHorizontal*5,right: SizeConfig.blockSizeHorizontal*5),
                                          child:
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Image.asset("asset/images/medal.png",width: SizeConfig.blockSizeVertical*3.25,height: SizeConfig.blockSizeVertical*3.25,),
                                              Container(margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*3),
                                                child: Text(rewards.elementAt(position).points+" points",textAlign:TextAlign.center,style:
                                                TextStyle(fontSize: SizeConfig.blockSizeVertical*1.7,fontFamily: StringConstants.font,fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.w600,color: Colors.black,letterSpacing: SizeConfig.blockSizeHorizontal*0.075,),),
                                              ),
                                              Spacer(),
                                              InkWell(
                                                onTap: ()
                                                {
                                                  setState(() {
                                                    var points =0;
                                                    if(position ==0)
                                                    {
                                                      if(int.parse(mypoints)>=50 && !dis10)
                                                      {
                                                        points = int.parse(mypoints) -50;
                                                        mypoints = points.toString();
                                                        updatepoints(points,"Discount 10",true);
                                                      }
                                                    }
                                                    else if(position ==1)
                                                    {
                                                      if(int.parse(mypoints)>=150 && !dis30)
                                                      {
                                                        points = int.parse(mypoints) -150;
                                                        mypoints = points.toString();
                                                        updatepoints(points,"Discount 30",true);
                                                      }
                                                    }
                                                    else
                                                    {
                                                      if(int.parse(mypoints)>=200 && !dis50)
                                                      {
                                                        points = int.parse(mypoints) -200;
                                                        mypoints = points.toString();
                                                        updatepoints(points,"Discount 50",true);
                                                      }
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  width: SizeConfig.blockSizeHorizontal*36,padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical*0.75),
                                                  margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*3),color: getrewradsstatuscolor(position),
                                                  child: Text(getrewardstext(position),textAlign:TextAlign.center,style:
                                                  TextStyle(fontSize: SizeConfig.blockSizeVertical*1.9,fontFamily: StringConstants.font,fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.w700,color: Colors.black,letterSpacing: SizeConfig.blockSizeHorizontal*0.075,),),
                                                ),
                                              )
                                            ],)),
                                    ],),
                                );
                                //controller: _scrollController,
                              },
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ],),
        ),),
      ),

    );
  }
  gettasksstatus(int index)
  {
    if(index ==0)
    {
      if(timespent)
        return StringConstants.claimed.toUpperCase();
      else
        return StringConstants.pending.toUpperCase();
    }
    else if(index ==1)
    {
      if(istest)
        return StringConstants.claim.toUpperCase();
      else
        return StringConstants.pending.toUpperCase();
    }
    else if(index ==2)
    {
      return StringConstants.pending.toUpperCase();
    }
  }
  gettaskscolor(int index)
  {
    if(index ==0)
    {
      if(timespent)
        return AppColors.claimcolor;
      else
        return AppColors.pendingcolor;
    }
    else if(index ==1)
    {
      if(istest)
        return AppColors.claimcolor;
      else
        return AppColors.pendingcolor;
    }
    else if(index ==2)
    {
      return AppColors.pendingcolor;
    }
  }
  getrewardstext(int index)
  {
    if(index ==0)
    {
      if(dis10)
        return StringConstants.claimed.toUpperCase();
      else
        return StringConstants.claim.toUpperCase();
    }
    else if(index ==1)
    {
      if(dis30)
        return StringConstants.claimed.toUpperCase();
      else
        return StringConstants.claim.toUpperCase();
    }
    else if(index ==2)
    {
      if(dis50)
        return StringConstants.claimed.toUpperCase();
      else
        return StringConstants.claim.toUpperCase();
    }
  }
  getrewradsstatuscolor(int index)
  {
    if(index ==0)
    {
      if(int.parse(mypoints)>=50 && !dis10)
        return AppColors.claimcolor;
      else
        return AppColors.pendingcolor;
    }
    else if(index ==1)
    {
      if(int.parse(mypoints)>=150 && !dis30)
        return AppColors.claimcolor;
      else
        return AppColors.pendingcolor;
    }
    else if(index ==2)
    {
      if(int.parse(mypoints)>=200 && !dis50)
        return AppColors.claimcolor;
      else
        return AppColors.pendingcolor;
    }
  }
  updatepoints(int points,String key,bool value)
  {
    FirebaseFirestore.instance
        .collection("profile").doc(getData['uid'])
        .update({
      "mypoints" : points.toString(),
      key:value
    }).whenComplete(() {
      setState(() {

      });
    });
  }
}
