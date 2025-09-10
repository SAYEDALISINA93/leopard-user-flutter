import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/data/controller/home/home_controller.dart';
import 'package:leoparduser/data/controller/location/app_location_controller.dart';
import 'package:leoparduser/data/repo/home/home_repo.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:leoparduser/presentation/components/divider/custom_spacer.dart';
import 'package:leoparduser/presentation/screens/home/widgets/home_app_bar.dart';
import 'package:leoparduser/presentation/screens/home/widgets/home_body.dart';

import 'widgets/location_pickup_widget.dart';

class HomeScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? dashBoardScaffoldKey;

  const HomeScreen({super.key, this.dashBoardScaffoldKey});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  double minSize = 80.0;
  double maxSize = 150.0;
  double appBarSize = 90.0;

  @override
  void initState() {
    Get.put(HomeRepo(apiClient: Get.find()));
    Get.put(AppLocationController());
    final controller = Get.put(
      HomeController(homeRepo: Get.find(), appLocationController: Get.find()),
    );
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initialData(shouldLoad: controller.appServices.isEmpty);
    });
  }

  void openDrawer() {
    if (widget.dashBoardScaffoldKey != null) {
      widget.dashBoardScaffoldKey?.currentState?.openEndDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: GetBuilder<HomeController>(
        builder: (controller) {
          return Scaffold(
            extendBody: true, // very important as noted
            backgroundColor: MyColor.screenBgColor,
            extendBodyBehindAppBar: false,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(appBarSize),
              child: HomeScreenAppBar(
                controller: controller,
                openDrawer: openDrawer,
              ),
            ),
            body: RefreshIndicator(
              color: MyColor.primaryColor,
              backgroundColor: MyColor.colorWhite,
              onRefresh: () async {
                controller.initialData(shouldLoad: true);
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    LocationPickUpHomeWidget(controller: controller),
                    spaceDown(Dimensions.space10),
                    HomeBody(controller: controller),
                    spaceDown(Dimensions.space50),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
