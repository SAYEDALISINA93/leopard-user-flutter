import 'package:get/get.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/model/faq/faq_response_model.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/repo/faq/faq_repo.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class FaqController extends GetxController {
  FaqRepo faqRepo;
  FaqController({required this.faqRepo});

  bool isLoading = false;
  List<Faq> faqList = [];

  bool isPress = false;
  int selectedIndex = -1;

  void changeSelectedIndex(int index) {
    if (selectedIndex == index) {
      selectedIndex = -1;
      update();
      return;
    }
    selectedIndex = index;
    update();
  }

  Future<void> getFaqList() async {
    isLoading = true;
    faqList.clear();
    update();
    ResponseModel responseModel = await faqRepo.getFaqData();
    if (responseModel.statusCode == 200) {
      FaqResponseModel model =
          FaqResponseModel.fromJson((responseModel.responseJson));
      if (model.status == MyStrings.success) {
        List<Faq>? tempList = model.data?.faq ?? [];
        if (tempList.isNotEmpty) {
          selectedIndex = 0;
          faqList.addAll(tempList);
          update();
        }
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }
    isLoading = false;
    update();
  }
}
