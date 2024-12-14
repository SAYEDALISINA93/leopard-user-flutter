import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:leoparduser/core/helper/shared_preference_helper.dart';
import 'package:leoparduser/core/utils/my_strings.dart';

class ThemeController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;
  bool _darkTheme = true;

  bool get darkTheme => _darkTheme;

  ThemeController({required this.sharedPreferences}) {
    _loadCurrentTheme();
  }

  void _loadCurrentTheme() {
    _darkTheme =
        sharedPreferences.getBool(SharedPreferenceHelper.theme) ?? true;
    update();
  }

  void changeTheme() {
    _darkTheme = !_darkTheme;
    sharedPreferences.setBool(MyStrings.theme, _darkTheme);
    if (_darkTheme) {
      //Get.changeTheme(dark);
    } else {
      //Get.changeTheme(light);
    }

    update();
  }
}
