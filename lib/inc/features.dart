  import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

vibrateSelection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? status = prefs.getBool('catkeys_haptics');
    if (status == true) {
      final hasCustomVibrationsSupport =
          await Vibration.hasCustomVibrationsSupport();
      if (hasCustomVibrationsSupport != null && hasCustomVibrationsSupport) {
        Vibration.vibrate(duration: 50);
      } else {
        Vibration.vibrate();
        await Future.delayed(const Duration(milliseconds: 50));
        Vibration.vibrate();
      }
    }
  }

  vibrateError() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? status = prefs.getBool('catkeys_haptics');
    if (status == true) {
      final hasCustomVibrationsSupport =
          await Vibration.hasCustomVibrationsSupport();
      if (hasCustomVibrationsSupport != null && hasCustomVibrationsSupport) {
        Vibration.vibrate(duration: 200);
      } else {
        Vibration.vibrate();
        await Future.delayed(const Duration(milliseconds: 200));
        Vibration.vibrate();
      }
    }
  }