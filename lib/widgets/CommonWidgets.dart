

import 'dart:math';

import 'package:bld_test/constants/StringConstants.dart';
import 'package:bld_test/utils/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showtoast(String message)
{
  Fluttertoast.showToast(msg: message);
}
Color randomColor() {
  final Random _random = Random();
  final alpha = 220 + _random.nextInt(256 - 220);
  return Color.fromARGB(
    255,
    _random.nextInt(256),
    _random.nextInt(256),
    _random.nextInt(256),
  );
}
showalert(BuildContext context,String title)
{
  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(StringConstants.alert,style: TextStyle(fontFamily: StringConstants.font,fontStyle: FontStyle.normal,fontWeight: FontWeight.w700,fontSize: SizeConfig.blockSizeVertical*2.75)),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(title,style: TextStyle(fontFamily: StringConstants.font,fontStyle: FontStyle.normal,fontWeight: FontWeight.w600,fontSize: SizeConfig.blockSizeVertical*2.25),),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(StringConstants.ok,style: TextStyle(fontFamily: StringConstants.font,fontStyle: FontStyle.normal,fontWeight: FontWeight.w500,fontSize: SizeConfig.blockSizeVertical*2),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}