import 'package:get/get.dart';

class RideScreenSettingsController extends GetxController {
  int selectedTab = 0;

  changeTab(int tab) {
    selectedTab = tab;
    update();
  }
}
