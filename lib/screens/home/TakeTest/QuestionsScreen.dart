import 'dart:math' show cos, sqrt, asin;

import 'package:bld_test/constants/AppColors.dart';
import 'package:bld_test/constants/StringConstants.dart';
import 'package:bld_test/data/models/Options.dart';
import 'package:bld_test/data/models/Questions.dart';
import 'package:bld_test/data/models/TestQuestions.dart';
import 'package:bld_test/screens/home/HomeScreen.dart';
import 'package:bld_test/screens/myservices/MyServices.dart';
import 'package:bld_test/screens/profile/ProfileScreen.dart';
import 'package:bld_test/screens/rewards/RewardsScreen.dart';
import 'package:bld_test/utils/SizeConfig.dart';
import 'package:bld_test/widgets/SwipeAnimation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

class QuestionScreen extends StatefulWidget {
  String come;
  int index;
  QuestionScreen(this.come,this.index);
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final questionkey = GlobalKey<ScaffoldState>();
  int selectedIndex;
  double testprogress = 0.0;
  int clickedoption = 0,lastindex=0;
  User user;
  PageController controller = PageController();
  IndexController _controller = IndexController();
  List<Questions> questions = new List();
  bool isloading = false;
  QuerySnapshot snapshot;
  String category = "";
  var pos = 1;
  var testreport;
  var agree = 0, consc = 0, extra = 0, neuro = 0, open = 0;
  bool selectedoption = false;
  List<TextEditingController> text = new List();
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: AppColors.testbgcolor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark));
    super.initState();
    isloading = true;
    user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance
        .collection("questions")
        .orderBy('category', descending: false)
        .snapshots()
        .listen((postdata) {
      setState(() {
        snapshot = postdata;
        for (int i = 0; i < snapshot.docs.length; i++)
        {
          for (int j = 0; j < snapshot.docs[i]['data'].length; j++)
          {
            List<Options> options = new List();
            options.add(new Options(false, StringConstants.sdisagree));
            options.add(new Options(false, StringConstants.disagree));
            options.add(new Options(false, StringConstants.neitherdisagree));
            options.add(new Options(false, StringConstants.agree));
            options.add(new Options(false, StringConstants.sagree));
            questions.add(new Questions(
                snapshot.docs[i]['data'][j], snapshot.docs[i]['category'],
                options: options, points: 0));
          }
          if (snapshot.docs[i].data()['instance'] != null)
          {
            questions.add(new Questions(snapshot.docs[i].data()['instance'],
                snapshot.docs[i]['category'],
                text: new TextEditingController(), points: 0));
          }
        }
        category = questions.elementAt(0).category;
        isloading = false;

        if(widget.come=="Services") {
          FirebaseFirestore.instance
              .collection("usertestreports")
              .where("uid", isEqualTo: user.uid)
              .snapshots()
              .listen((testdata) {
            testreport = testdata;
            if (testreport != null) {
              agree = (double.parse(testreport.docs[0]['agreeableness']) /
                  2.025)
                  .toInt();
              consc = (double.parse(testreport.docs[0]['conscient']) / 2.025)
                  .toInt();
              extra = (double.parse(testreport.docs[0]['extraversion']) /
                  1.625)
                  .toInt();
              neuro = (double.parse(testreport.docs[0]['neuroticism']) /
                  2.025)
                  .toInt();
              open =
                  (double.parse(testreport.docs[0]['openness']) / 1.625)
                      .toInt();
              lastindex = testreport.docs[0]['testindex'];
              selectedIndex = lastindex+1;
              testprogress = double.parse(testreport.docs[0]['testprogress']);
              if(lastindex<questions.length) {
                _controller.move(lastindex + 1);
              }

            }
          });
        }
        else
        {
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    /*WillPopScope(
          onWillPop: () async => false,
          child:*/
    return Container(
      width: SizeConfig.blockSizeHorizontal * 100,
      height: SizeConfig.blockSizeVertical * 100,
      child: Scaffold(
        key: questionkey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.testbgcolor,
          elevation: 0.0,
          title: Text(StringConstants.psychometric.toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: SizeConfig.blockSizeVertical * 2.25,
                  color: Colors.white,
                  fontFamily: StringConstants.font,
                  fontStyle: FontStyle.normal)),
        ),
        backgroundColor: Colors.transparent,
        body: TransformerPageView(
            viewportFraction: 0.5,
            duration: new Duration(milliseconds: 750),
            loop: false,
            scrollDirection: Axis.vertical,
            index: selectedIndex,
            itemCount: questions.length,
            physics: NeverScrollableScrollPhysics(),
            controller: _controller,
            transformer: ScaleAndFadeTransformer(),
            onPageChanged: onPageChanged,
            itemBuilder: (context, ques) {

              return Container(
                  width: SizeConfig.blockSizeHorizontal * 100,
                  height: SizeConfig.blockSizeVertical * 100,
                  color: AppColors.testbgcolor,
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 4,
                      vertical: SizeConfig.blockSizeVertical * 1),
                  child: Column(
                    children: [
                      Container(
                          width: SizeConfig.blockSizeHorizontal * 100,
                          height: SizeConfig.blockSizeVertical * 16,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical * 2.5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    left: SizeConfig.blockSizeHorizontal * 5,
                                  ),
                                  child: Text("${(ques+1).toString()}.",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                          SizeConfig.blockSizeVertical *
                                              2.5,
                                          color: Colors.black,
                                          fontFamily: StringConstants.font,
                                          fontStyle: FontStyle.normal)),
                                ),
                                Expanded(
                                  child: Container(
                                    width: SizeConfig.blockSizeHorizontal * 71,
                                    margin: EdgeInsets.only(
                                        left:
                                        SizeConfig.blockSizeHorizontal * 5,
                                        right:
                                        SizeConfig.blockSizeHorizontal * 2,
                                        bottom: SizeConfig.blockSizeVertical *
                                            0.75),
                                    child: SingleChildScrollView(
                                      child: Text(
                                          questions.elementAt(ques).question,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize:
                                              SizeConfig.blockSizeVertical *
                                                  2.35,
                                              color: Colors.black,
                                              fontFamily: StringConstants.font,
                                              fontStyle: FontStyle.normal)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                      questions.elementAt(ques).options != null
                          ? Container(
                          width: SizeConfig.blockSizeHorizontal * 100,
                          margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 2.5,
                          ),
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:5,
                              itemBuilder: (context, position) {
                                return InkWell(
                                  onTap: ()
                                  {
                                    clickedoption = position;
                                    for (int i = 0;
                                    i < questions.elementAt(ques).options.length; i++) {
                                      if (questions
                                          .elementAt(ques)
                                          .options
                                          .elementAt(i)
                                          .selectedoption) {
                                        selectedoption = true;
                                        if (i != position) {
                                          questions
                                              .elementAt(ques)
                                              .options
                                              .elementAt(i)
                                              .selectedoption = false;
                                        }
                                        break;
                                      }
                                    }
                                    if (selectedoption) {
                                      selectedoption = false;
                                      if (questions
                                          .elementAt(ques)
                                          .options
                                          .elementAt(position)
                                          .selectedoption) {
                                        questions
                                            .elementAt(ques)
                                            .options
                                            .elementAt(position)
                                            .selectedoption = false;
                                      } else {
                                        questions
                                            .elementAt(ques)
                                            .options
                                            .elementAt(position)
                                            .selectedoption = true;
                                      }
                                    } else {
                                      if (questions
                                          .elementAt(ques)
                                          .options
                                          .elementAt(position)
                                          .selectedoption) {
                                        questions
                                            .elementAt(ques)
                                            .options
                                            .elementAt(position)
                                            .selectedoption = false;
                                        selectedoption = false;
                                      } else {
                                        questions
                                            .elementAt(ques)
                                            .options
                                            .elementAt(position)
                                            .selectedoption = true;
                                        selectedoption = false;
                                      }
                                    }
                                    setState(() {

                                    });
                                  },
                                  child: Container(
                                    width: SizeConfig.blockSizeHorizontal *
                                        100,
                                    margin: EdgeInsets.only(
                                        top: SizeConfig.blockSizeVertical *
                                            2.5,
                                        left:
                                        SizeConfig.blockSizeHorizontal *
                                            5,
                                        right:
                                        SizeConfig.blockSizeHorizontal *
                                            5),
                                    padding: EdgeInsets.only(
                                        top: SizeConfig.blockSizeVertical *
                                            2,
                                        bottom:
                                        SizeConfig.blockSizeVertical *
                                            2,
                                        left:
                                        SizeConfig.blockSizeHorizontal *
                                            4),
                                    decoration: BoxDecoration(
                                      color: questions
                                          .elementAt(ques)
                                          .options
                                          .elementAt(position)
                                          .selectedoption
                                          ? AppColors.selectedoption
                                          : Colors.white,
                                      border: Border.all(
                                          color: questions
                                              .elementAt(ques)
                                              .options
                                              .elementAt(position)
                                              .selectedoption
                                              ? AppColors.selectedoption
                                              : AppColors.testoptionborder,
                                          width: 3.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.0)),
                                    ),
                                    child: Text(
                                        questions
                                            .elementAt(ques)
                                            .options
                                            .elementAt(position)
                                            .name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: SizeConfig
                                                .blockSizeVertical *
                                                2.2,
                                            color: questions
                                                .elementAt(ques)
                                                .options
                                                .elementAt(position)
                                                .selectedoption
                                                ? Colors.white
                                                : Colors.black,
                                            fontFamily:
                                            StringConstants.font,
                                            fontStyle: FontStyle.normal)),
                                  ),
                                );
                              }))
                          : SingleChildScrollView(
                        child: Container(
                          width: SizeConfig.blockSizeHorizontal * 100,
                          height: SizeConfig.blockSizeVertical * 57.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.all(Radius.circular(8.0)),
                          ),
                          margin: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 3,
                              bottom:
                              SizeConfig.blockSizeVertical * 0.75),
                          child: TextFormField(
                            cursorColor: Colors.black,
                            onFieldSubmitted: (v) {},
                            controller: questions.elementAt(ques).text,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize:
                                SizeConfig.blockSizeVertical * 2.35,
                                color: Colors.black,
                                fontFamily: StringConstants.font,
                                fontStyle: FontStyle.normal),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 2,
                                  bottom:
                                  SizeConfig.blockSizeVertical * 2,
                                  left: SizeConfig.blockSizeVertical * 2),
                            ),
                            maxLines: 30,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                          ),

                        ),
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.only(
                            bottom: SizeConfig.blockSizeVertical * 1),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              var selected = false;
                              if(ques==8 || ques==45) {
                                selected = true;
                              } else {
                                for (int i = 0; i < questions.elementAt(ques).options.length; i++) {
                                  if (questions.elementAt(ques).options.elementAt(i).selectedoption) {
                                    selected = true;
                                    break;
                                  }
                                } }
                              if(selected) {
                                selectedIndex = ques + 1;
                                if(ques+1<questions.length) {
                                  _controller.move(selectedIndex);
                                }
                                setquescal(ques, clickedoption);
                              }
                              else
                                showInSnackBar("Please Select Option");
                            });
                          },
                          child: Column(

                            children: [
                              Container(
                                  height: SizeConfig.blockSizeVertical * 4,
                                  child: Icon(
                                    Icons.keyboard_arrow_up_rounded,
                                    size: SizeConfig.blockSizeVertical * 4.5,
                                    color: Colors.white,
                                  )),
                              Container(
                                child: Text(StringConstants.swipeup,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize:
                                        SizeConfig.blockSizeVertical * 2.1,
                                        color: Colors.white,
                                        fontFamily: StringConstants.font,
                                        fontStyle: FontStyle.normal)),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ));
            }),

      ),
    );
  }

  void onPageChanged(index) {
    // Index of current tab is focused
    print(index);
    setState(() {
      selectedIndex = index;
      pos = pos + 1;
    });
  }

  void clear() {
    questions.clear();
  }

  setquescal(int question, int option) {
    setState(() {
      // Calculation Algo
      if (question == 2 ||
          question == 4 ||
          question == 7 ||
          question == 11 ||
          question == 14 ||
          question == 16 ||
          question == 18 ||
          question == 21 ||
          question == 22 ||
          question == 29 ||
          question == 31 ||
          question == 33 ||
          question == 34 ||
          question == 37 ||
          question == 39 ||
          question == 44) {
        if (clickedoption==0) {
          questions.elementAt(question).points = 5;
        } else if (clickedoption==1) {
          questions.elementAt(question).points = 4;
        } else if (clickedoption==2) {
          questions.elementAt(question).points = 3;
        } else if (clickedoption==3) {
          questions.elementAt(question).points = 2;
        } else if (clickedoption==4) {
          questions.elementAt(question).points = 1;
        }
      }
      else {
        if (clickedoption==0) {
          questions.elementAt(question).points = 1;
        } else if (clickedoption==1) {
          questions.elementAt(question).points = 2;
        } else if (clickedoption==2) {
          questions.elementAt(question).points = 3;

        } else if (clickedoption==3) {
          questions.elementAt(question).points = 4;
        } else if (clickedoption==4) {
          questions.elementAt(question).points = 5;
        }
      }

      // calculating score for individual item
      if(widget.come=="Services") {

        if (question < 8) {
          agree = agree + questions
              .elementAt(question)
              .points;
        } else if (question > 8 && question < 17) {
          consc = consc + questions
              .elementAt(question)
              .points;
        } else if (question > 16 && question < 27) {
          extra = extra + questions
              .elementAt(question)
              .points;
        } else if (question > 26 && question < 35) {
          neuro = neuro + questions
              .elementAt(question)
              .points;
        } else if (question > 34 && question < 45) {
          open = open + questions
              .elementAt(question)
              .points;
        }
      }
      else
      {
        if (question < 8) {
          agree = agree + questions
              .elementAt(question)
              .points;
        } else if (question > 8 && question < 17) {
          consc = consc + questions
              .elementAt(question)
              .points;
        } else if (question > 16 && question < 27) {
          extra = extra + questions
              .elementAt(question)
              .points;
        } else if (question > 26 && question < 35) {
          neuro = neuro + questions
              .elementAt(question)
              .points;
        } else if (question > 34 && question < 45) {
          open = open + questions
              .elementAt(question)
              .points;
        }
      }
      testprogress = testprogress+2.17;
      // updating data

      FirebaseFirestore.instance.collection("profile").doc(user.uid).update({
        "testprogress": testprogress.toInt()>=97?"100":testprogress.toString(),
        "istestcompleted": testprogress.toInt() >= 97 ? true : false,
      }).whenComplete(() {

      });
      // saving user result

      // uploading score for test
      if(widget.come=="Services" || question >0) {
        FirebaseFirestore.instance.collection("usertestreports").doc(user.uid).update({
          "agreeableness": (agree * 2.025).toString(),
          "conscient": (consc * 2.025).toString(),
          "extraversion": (extra * 1.625).toString(),
          "neuroticism": (neuro * 2.025).toString(),
          "openness": (open * 1.625).toString(),
          "uid": user.uid,
          "testindex": question,
          "testprogress": testprogress.toString(),
        }).whenComplete(() {
          setState(() {
            if(question==questions.length-1)
            {
              showInSnackBar("Test is Completed");
              Navigator.pop(context);
            }
          });
        });
      }
      else
      {
        FirebaseFirestore.instance.collection("usertestreports")
            .doc(user.uid)
            .set({
          "agreeableness": (agree * 2.025).toString(),
          "conscient": (consc * 2.025).toString(),
          "extraversion": (extra * 1.625).toString(),
          "neuroticism": (neuro * 2.025).toString(),
          "openness": (open * 1.625).toString(),
          "uid": user.uid,
          "testindex": question,
          "testprogress": testprogress.toString(),
        }).whenComplete(() {
          setState(() {
            if(question==questions.length-1)
            {
              showInSnackBar("Test is Completed");
              Navigator.pop(context);
            }
          });
        }).catchError((error)
        {
          setState(() {

          });
        });
      }
      isloading = false;
    });
  }
  void showInSnackBar(String value)
  {
    questionkey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
  }
}