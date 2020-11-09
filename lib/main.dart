import 'package:bld_test/screens/dashboard/Dashboard.dart';
import 'package:bld_test/screens/login/LoginScreen.dart';
import 'package:bld_test/screens/signup/SignupScreen.dart';
import 'package:bld_test/utils/SharedPref.dart';
import 'package:bld_test/widgets/CommonWidgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(StatefullWidgetDemo());
}

class StatefullWidgetDemo extends StatefulWidget {

  @override
  _StatefulWidgetDemoState createState() {
    return new _StatefulWidgetDemoState();
  }

}

class _StatefulWidgetDemoState extends State<StatefullWidgetDemo> with WidgetsBindingObserver
{
  String islogged="";
  DateTime startTime;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      startTime = DateTime.now();
      print("Hii1"+startTime.toString());
    }

    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.paused) {
      var usageTime = DateTime.now().difference(startTime);
      print("Hii"+usageTime.toString());
      // do whatever with the usageTime
    }
  }

  @override
  void initState()
  {

    WidgetsBinding.instance.addObserver(this);
    super.initState();
    getlogintoken().then((val) {
      setState(() {
        islogged = val;
      });
    });
  }
  Future<String> getlogintoken() async {
    var login = await SharedPreferencesTest().checkIsLogin("1");
    return login;
  }
  @override
  Widget build(BuildContext context)
  {

    if(islogged =="true")
      {
        return MaterialApp(
            title: 'BLD',
            debugShowCheckedModeBanner: false,
            home: DashboardView());
      }
    else{
      return MaterialApp(
          title: 'BLD',
          debugShowCheckedModeBanner: false,
          home: Login());
    }
  }

}

