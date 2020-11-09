import 'package:bld_test/constants/StringConstants.dart';
import 'package:bld_test/data/models/SpinnerItem.dart';
import 'package:bld_test/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
bool padd;
class DropDownSpinner<T extends SpinnerItem> extends StatefulWidget {
  final List<T> items;
  final int selectPos;
  final bool displayBorder;
  final bool ispadding;
  get dropDownState => DropDownWidget<T>();
  final ValueChanged<T> valueChangeListener;

  DropDownSpinner(this.items, this.valueChangeListener,{
    this.selectPos = 0, this.displayBorder = true,this.ispadding=true})
  {
    padd = ispadding;
  }

  @override
  State<StatefulWidget> createState() {
    return dropDownState;
  }
}

class DropDownWidget<T extends SpinnerItem> extends State<DropDownSpinner>  with AutomaticKeepAliveClientMixin<DropDownSpinner>{
  T selectedValue;
  List<DropdownMenuItem<T>> itemList;

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    itemList = widget.items
        .map((item) => DropdownMenuItem<T>(
        value: item,
        child: Text(item?.toValue() ?? "ss",
          style: TextStyle(
            fontSize: SizeConfig.blockSizeVertical * 2.1,
            fontFamily: StringConstants.font,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),)))
        .toList();
    selectedValue = itemList[widget.selectPos ?? 0].value;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    widget.valueChangeListener(selectedValue);
    return Container(
      child: Padding(
        padding: padd?EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*5,
            right:12.0
          /*right:SizeConfig.blockSizeHorizontal*3,*/):
        EdgeInsets.all(0.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            isDense: true,
            hint: Text(selectedValue?.toValue() ?? "s",
            ),
            value: selectedValue,
            style: TextStyle(
              fontSize: SizeConfig.blockSizeVertical * 2.1,
              fontFamily: StringConstants.font,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            items: itemList,
            onChanged: (value) {
              widget.valueChangeListener(value); // no need
              selectedValue = value;
              setState(() {
                selectedValue = value;
              });
            },
            isExpanded: true,
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
