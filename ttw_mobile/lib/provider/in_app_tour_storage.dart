import 'package:shared_preferences/shared_preferences.dart';

class SaveInAppTour {
  Future<SharedPreferences> data = SharedPreferences.getInstance();

  void saveMainStatus() async {
    final value = await data;

    value.setBool("mainPage", true);
  }

  Future<bool> getMainStatus() async {
    final value = await data;

    if (value.containsKey("mainPage")) {
      bool? getData = value.getBool("mainPage");
      return getData!;
    } else {
      return false;
    }
  }
}
