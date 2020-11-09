import 'package:bld_test/data/models/Options.dart';
import 'package:flutter/cupertino.dart';

class Questions
{
  String question;
  String category;
  List<Options> options;
  int points;
  TextEditingController text =new TextEditingController();

  Questions(this.question, this.category,{this.options,this.text,this.points});
  /*Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
    data['question'] = this.question;
    data['category'] = this.category;
    data['points'] = this.points;
    data['text'] = this.text;

    return data;
  }*/
}