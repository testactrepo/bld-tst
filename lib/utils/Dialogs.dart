import 'package:flutter/material.dart';

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  elevation: 0.0,
                  backgroundColor: Colors.transparent,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.blue),
                        ) /*valueColor: new AlwaysStoppedAnimation<Color>(
                            AppColors.buttoncolor),)*/
                        ,
                        SizedBox(
                          height: 10,
                        ),
                      ]),
                    )
                  ]));
        });
  }
}
