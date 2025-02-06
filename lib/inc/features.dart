  import 'package:gaimon/gaimon.dart';
import 'package:shared_preferences/shared_preferences.dart';

vibrateSelection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? status = prefs.getBool('catkeys_haptics');
    if (status == true) {
        Gaimon.selection();
    }
  }

  vibrateError() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? status = prefs.getBool('catkeys_haptics');
    if (status == true) {
      Gaimon.error();
    }
  }