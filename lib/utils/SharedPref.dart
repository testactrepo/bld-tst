import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesTest {
  final String login = "login";

  Future<String> checkIsLogin(String value) async {
    String a = "Test";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value == "0") {
      prefs.setString("login", "true");
      return a;
    } else if (value == "1") {
      String tok = prefs.getString("login");
      return tok;
    } else {
      prefs.setString("login", "false");
      return a;
    }
  }

}
