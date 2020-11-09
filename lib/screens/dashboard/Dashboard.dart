
import 'dart:math' show cos, sqrt, asin;

import 'package:bld_test/constants/StringConstants.dart';
import 'package:bld_test/screens/home/HomeScreen.dart';
import 'package:bld_test/screens/myservices/MyServices.dart';
import 'package:bld_test/screens/profile/ProfileScreen.dart';
import 'package:bld_test/screens/rewards/RewardsScreen.dart';
import 'package:bld_test/utils/SizeConfig.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DashboardView extends StatefulWidget
{
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView>
{
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedIndex = 0;
  final List<Widget> _children = [
    HomeScreen(),
    Myservices(),
    Rewards(),
    Profile(),
  ];
  @override
  void initState()
  {
    super.initState();
    // changing Screen Theme
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light));

  }

  @override
  Widget build(BuildContext context)
  {
    SizeConfig().init(context);
      return /*WillPopScope(
          onWillPop: () async => false,
          child:*/Container(
          width: SizeConfig.blockSizeHorizontal*100,
          height: SizeConfig.blockSizeVertical*100,
          color: Colors.white,
          margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2),
          child:
          Scaffold(backgroundColor: Colors.transparent,
            bottomNavigationBar: new SizedBox(width:SizeConfig.blockSizeHorizontal*100,height:SizeConfig.blockSizeVertical*8,child:BottomNavigationBar(
              unselectedFontSize: SizeConfig.blockSizeVertical * 1.3,
              selectedFontSize: SizeConfig.blockSizeVertical * 1.3,
              currentIndex: selectedIndex,
              onTap: onItemTapped,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              showSelectedLabels: true,
              items: [   // bottom navigation Item
                BottomNavigationBarItem(
                  icon: Icon(Icons.home,size: SizeConfig.blockSizeVertical*3.25,color: selectedIndex==0?Colors.black:Colors.black54,),
                  title: new Text(
                    StringConstants.home.toUpperCase(),
                    style: TextStyle(color: selectedIndex==0?Colors.black:Colors.black54,fontWeight: FontWeight.w700,fontFamily: StringConstants.font,fontStyle: FontStyle.normal,fontSize: SizeConfig.blockSizeVertical*1.4),),
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('asset/images/agenda.png',width: SizeConfig.blockSizeVertical*3.25,height: SizeConfig.blockSizeVertical*3.25,color: selectedIndex==1?Colors.black:Colors.black54,),
                  title: new Text(
                    StringConstants.myservices.toUpperCase(),
                    style: TextStyle(color: selectedIndex==1?Colors.black:Colors.black54,fontWeight: FontWeight.w700,fontFamily: StringConstants.font,fontStyle: FontStyle.normal,fontSize: SizeConfig.blockSizeVertical*1.4),),
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('asset/images/trophy.png',width: SizeConfig.blockSizeVertical*3.25,height: SizeConfig.blockSizeVertical*3.25,color: selectedIndex==2?Colors.black:Colors.black54,),
                  title: new Text(
                    StringConstants.rewards.toUpperCase(),
                    style: TextStyle(color: selectedIndex==2?Colors.black:Colors.black54,fontWeight: FontWeight.w700,fontFamily: StringConstants.font,fontStyle: FontStyle.normal,fontSize: SizeConfig.blockSizeVertical*1.4),),
                ), BottomNavigationBarItem(
                  icon: Image.asset('asset/images/profile.png',width: SizeConfig.blockSizeVertical*3.25,height: SizeConfig.blockSizeVertical*3.25,color: selectedIndex==3?Colors.black:Colors.black54,),
                  title: new Text(
                    StringConstants.profile.toUpperCase(),
                    style: TextStyle(color: selectedIndex==3?Colors.black:Colors.black54,fontWeight: FontWeight.w700,fontFamily: StringConstants.font,fontStyle: FontStyle.normal,fontSize: SizeConfig.blockSizeVertical*1.4),),
                ),


              ],
            )),
            body:_children[selectedIndex],
          ));
    }
    // when navigation item clicked
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      print(selectedIndex);
    });
  }
  }

