import 'package:flutter/material.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/controller/payment_history/payment_history_controller.dart';
import 'package:leoparduser/data/repo/payment_history/payment_history_repo.dart';
import 'package:leoparduser/data/services/api_service.dart';
import 'package:leoparduser/presentation/components/app-bar/custom_appbar.dart';
import 'package:leoparduser/presentation/components/custom_loader/custom_loader.dart';
import 'package:leoparduser/presentation/components/no_data.dart';
import 'package:leoparduser/presentation/components/shimmer/transaction_card_shimmer.dart';
import 'package:leoparduser/presentation/screens/payment_history/widget/custom_payment_card.dart';
import 'package:get/get.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  final ScrollController scrollController = ScrollController();

  fetchData() {
    Get.find<PaymentHistoryController>().loadTransaction();
  }

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (Get.find<PaymentHistoryController>().hasNext()) {
        fetchData();
      }
    }
  }

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(PaymentHistoryRepo(apiClient: Get.find()));
    final controller =
        Get.put(PaymentHistoryController(paymentRepo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initialSelectedValue();
      scrollController.addListener(scrollListener);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<PaymentHistoryController>(
        builder: (controller) => Scaffold(
          backgroundColor: MyColor.screenBgColor,
          appBar: CustomAppBar(
            isTitleCenter: true,
            elevation: 1,
            title: MyStrings.payment,
            actionsWidget: [
              //     ActionButtonIconWidget(pressed: () => controller.changeSearchIcon(), icon: controller.isSearch ? Icons.clear : Icons.filter_alt_sharp),
            ],
          ),
          body: Padding(
              padding: Dimensions.screenPaddingHV,
              child: controller.isLoading
                  ? ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return TransactionCardShimmer();
                      },
                    )
                  : controller.transactionList.isEmpty &&
                          controller.isLoading == false
                      ? Center(child: NoDataWidget(text: MyStrings.noTrxFound))
                      : SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: ListView.separated(
                            controller: scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            itemCount: controller.transactionList.length + 1,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: Dimensions.space10),
                            itemBuilder: (context, index) {
                              if (controller.transactionList.length == index) {
                                return controller.hasNext()
                                    ? Container(
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.all(5),
                                        child: const CustomLoader())
                                    : const SizedBox();
                              }

                              return GestureDetector(
                                onTap: () {
                                  controller.changeExpandIndex(index);
                                },
                                child: CustomPaymentCard(
                                    index: index,
                                    expandIndex: controller.expandIndex),
                              );
                            },
                          ),
                        )),
        ),
      ),
    );
  }
}
