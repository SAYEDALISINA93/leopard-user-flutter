import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:leoparduser/core/helper/shared_preference_helper.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/model/language/language_model.dart';

class LocalizationController extends GetxController {
  final SharedPreferences sharedPreferences;

  LocalizationController({required this.sharedPreferences}) {
    loadCurrentLanguage();
  }

  Locale _locale = Locale(MyStrings.myLanguages[0].languageCode,
      MyStrings.myLanguages[0].countryCode);
  bool _isLtr = true;
  final List<MyLanguageModel> _languages = [];

  Locale get locale => _locale;
  bool get isLtr => _isLtr;
  List<MyLanguageModel> get languages => _languages;

  void setLanguage(Locale locale, String imageUrl) {
    Get.updateLocale(locale);
    _locale = locale;
    if (_locale.languageCode == 'ar') {
      _isLtr = false;
    } else {
      _isLtr = true;
    }
    saveLanguage(_locale, imageUrl);
    update();
  }

  void loadCurrentLanguage() async {
    _locale = Locale(
        sharedPreferences.getString(SharedPreferenceHelper.languageCode) ??
            MyStrings.myLanguages[0].languageCode,
        sharedPreferences.getString(SharedPreferenceHelper.countryCode) ??
            MyStrings.myLanguages[0].countryCode);
    _isLtr = _locale.languageCode != 'ar';
    update();
  }

  void saveLanguage(Locale locale, String? imageUrl) async {
    sharedPreferences.setString(
        SharedPreferenceHelper.languageCode, locale.languageCode);
    sharedPreferences.setString(
        SharedPreferenceHelper.countryCode, locale.countryCode ?? '');
    sharedPreferences.setString(
        SharedPreferenceHelper.languageImagePath, imageUrl ?? '');
  }

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void setSelectIndex(int index) {
    _selectedIndex = index;
    update();
  }
}
