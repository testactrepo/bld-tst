import 'SpinnerItem.dart';

class DropDownItem implements SpinnerItem {
  String title;
  String message;

  DropDownItem(this.title, {this.message = ""});

  @override
  String toValue() {
    return title;
  }
}