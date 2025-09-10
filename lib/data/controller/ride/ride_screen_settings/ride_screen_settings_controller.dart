import 'package:get/get.dart';

class RideScreenSettingsController extends GetxController {
  int selectedTab = 0;

  void changeTab(int tab) {
    selectedTab = tab;
    update();
  }
}
