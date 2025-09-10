import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/theme/light/light.dart';
import 'package:leoparduser/core/utils/debouncer.dart';
import 'package:leoparduser/core/utils/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:leoparduser/core/utils/my_images.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/data/controller/home/home_controller.dart';
import 'package:leoparduser/environment.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:leoparduser/presentation/components/annotated_region/annotated_region_widget.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';
import 'package:leoparduser/presentation/components/custom_loader/custom_loader.dart';
import 'package:leoparduser/presentation/components/divider/custom_spacer.dart';
import 'package:leoparduser/presentation/components/text-form-field/location_pick_text_field.dart';
import 'package:leoparduser/presentation/components/text/label_text.dart';

import '../../../../../core/utils/dimensions.dart';
import '../../../../../core/utils/helper.dart';
import '../../../../../core/utils/my_color.dart';
import '../../../../../core/utils/my_strings.dart';
import '../../../../../data/controller/location/select_location_controller.dart';
import '../../../../../data/repo/location/location_search_repo.dart';

class LocationPickerScreen extends StatefulWidget {
  final int pickupLocationForIndex;
  const LocationPickerScreen({super.key, required this.pickupLocationForIndex});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  TextEditingController searchLocationController = TextEditingController(
    text: '',
  );
  int index = 0;
  Uint8List? pickUpIcon;
  Uint8List? destinationIcon;
  bool isSearching = false;
  bool isFirsTime = true;
  //Sheet Size
  // final DraggableScrollableController sheetController = DraggableScrollableController();
  @override
  void initState() {
    index = widget.pickupLocationForIndex;
    loggerX(index);
    super.initState();

    Get.put(LocationSearchRepo(apiClient: Get.find()));
    var controller = Get.put(
      SelectLocationController(
          locationSearchRepo: Get.find(), selectedLocationIndex: index),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadMarker();
      controller.initialize();
    }); //Sheet
    // sheetController.addListener(() {

    // });
  }

  Future<void> loadMarker() async {
    searchLocationController.text = '';
    pickUpIcon = await Helper.getBytesFromAsset(MyIcons.mapMarkerIcon, 150);
    destinationIcon =
        await Helper.getBytesFromAsset(MyImages.mapDestination, 80);
  }

  void changeIndex(int i) {
    index = i;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegionWidget(
      child: GetBuilder<SelectLocationController>(
        builder: (controller) {
          return Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            backgroundColor: MyColor.screenBgColor,
            resizeToAvoidBottomInset: true,
            body: Stack(
              clipBehavior: Clip.none,
              children: [
                if (controller.isLoading == true &&
                    controller.isLoadingFirstTime == true)
                  const SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                  )
                else ...[
                  Stack(
                    children: [
                      SizedBox(
                        height: context.height * .7,
                        child: GoogleMap(
                          trafficEnabled: false,
                          indoorViewEnabled: false,
                          zoomControlsEnabled: false,
                          zoomGesturesEnabled: true,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          mapType: MapType.normal,
                          liteModeEnabled: false,
                          minMaxZoomPreference: const MinMaxZoomPreference(
                            0,
                            100,
                          ),
                          markers: <Marker>{
                            Marker(
                              markerId: const MarkerId("pickup_location"),
                              position: LatLng(
                                controller.pickupLatlong.latitude,
                                controller.pickupLatlong.longitude,
                              ),
                              infoWindow: InfoWindow(
                                title: "Pickup",
                                snippet: controller.homeController
                                    .selectedLocations[0].fullAddress,
                                onTap: () {
                                  Get.toNamed(
                                      RouteHelper.editLocationPickUpScreen,
                                      arguments: 0);
                                },
                              ),
                              icon: pickUpIcon == null
                                  ? BitmapDescriptor.defaultMarker
                                  : BitmapDescriptor.bytes(
                                      pickUpIcon!,
                                      height: 45,
                                      width: 47,
                                    ),
                              onDragStart: (LatLng l) {},
                              onDrag: (LatLng l) {},
                              onTap: () {
                                // controller.changeIndex(0);
                                Get.toNamed(
                                    RouteHelper.editLocationPickUpScreen,
                                    arguments: 0);
                              },
                            ),
                            Marker(
                              markerId: const MarkerId("destination_location"),
                              position: LatLng(
                                controller.destinationLatlong.latitude,
                                controller.destinationLatlong.longitude,
                              ),
                              infoWindow: InfoWindow(
                                title: "Destination",
                                snippet: controller.destinationController.text,
                                onTap: () {
                                  Get.toNamed(
                                      RouteHelper.editLocationPickUpScreen,
                                      arguments: 1);
                                },
                              ),
                              icon: destinationIcon == null
                                  ? BitmapDescriptor.defaultMarker
                                  : BitmapDescriptor.bytes(
                                      destinationIcon!,
                                      height: 45,
                                      width: 45,
                                    ),
                              onDragStart: (LatLng l) {},
                              onDrag: (LatLng l) {},
                              onTap: () {
                                Get.toNamed(
                                    RouteHelper.editLocationPickUpScreen,
                                    arguments: 1);
                              },
                            ),
                          },
                          initialCameraPosition: CameraPosition(
                            target: controller.getInitialTargetLocationForMap(
                              pickupLocationForIndex:
                                  widget.pickupLocationForIndex,
                            ),
                            zoom: Environment.mapDefaultZoom,
                            bearing: 20,
                            tilt: 0,
                          ),
                          onMapCreated: (googleMapController) {
                            controller.mapController = googleMapController;
                          },
                          polylines: Set<Polyline>.of(
                            controller.polylines.values,
                          ),
                          style: googleMapLightStyleJson,
                        ),
                      ),
                    ],
                  ),
                ],
                Align(
                  alignment: Alignment.center,
                  child: controller.isLoading
                      ? CircularProgressIndicator(
                          color: MyColor.getPrimaryColor(),
                        )
                      : const SizedBox.shrink(),
                ),
                Positioned(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.space12,
                      ),
                      child: IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: MyColor.colorWhite,
                        ),
                        color: MyColor.colorBlack,
                        onPressed: () {
                          Get.back(result: true);
                        },
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottomSheet: buildConfirmDestination(
              pickupLocationForIndex: widget.pickupLocationForIndex,
            ),
          );
        },
      ),
    );
  }

  Widget buildConfirmDestination({required int pickupLocationForIndex}) {
    final debouncer = MyDeBouncer(delay: const Duration(seconds: 1));

    return GetBuilder<SelectLocationController>(
      builder: (controller) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          height: controller.allPredictions.isEmpty
              ? context.height * .4
              : context.height * .3 + controller.allPredictions.length * 50,
          padding: EdgeInsets.symmetric(vertical: Dimensions.space10),
          decoration: BoxDecoration(
            color: MyColor.colorWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: MyColor.colorGrey.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(Dimensions.space15),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsetsDirectional.symmetric(
                    vertical: Dimensions.space3,
                    horizontal: Dimensions.space8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      Dimensions.mediumRadius,
                    ),
                  ),
                  child: GetBuilder<HomeController>(
                    builder: (homeController) {
                      return SingleChildScrollView(
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LabelText(text: MyStrings.pickUpLocation),
                              SizedBox(height: Dimensions.space10),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: controller.selectedLocationIndex == 0
                                        ? MyColor.primaryColor
                                        : MyColor.colorGrey.withValues(
                                            alpha: 0.1,
                                          ),
                                    width: controller.selectedLocationIndex == 0
                                        ? 1
                                        : 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.mediumRadius,
                                  ),
                                ),
                                child: LocationPickTextField(
                                  hintText: MyStrings.pickUpLocation,
                                  controller: controller.pickUpController,
                                  onTap: () {
                                    controller.changeIndex(0);
                                  },
                                  onSubmit: () {},
                                  onChanged: (text) {
                                    if (isFirsTime == true) {
                                      isFirsTime = false;
                                      setState(() {});
                                    }
                                    debouncer.run(() {
                                      controller.searchYourAddress(
                                        locationName: text,
                                      );
                                    });
                                  },
                                  labelText: MyStrings.pickUpLocation.tr,
                                  radius: Dimensions.mediumRadius,
                                  inputAction: TextInputAction.done,
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      controller.clearTextFiled(0);
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      size: Dimensions.space20,
                                      color: MyColor.bodyText,
                                    ),
                                  ),
                                ),
                              ),
                              spaceDown(Dimensions.space20),
                              LabelText(text: MyStrings.destination),
                              SizedBox(height: Dimensions.space10),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: controller.selectedLocationIndex == 1
                                        ? MyColor.primaryColor
                                        : MyColor.colorGrey.withValues(
                                            alpha: 0.1,
                                          ),
                                    width: controller.selectedLocationIndex == 1
                                        ? 1
                                        : 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.mediumRadius,
                                  ),
                                ),
                                child: LocationPickTextField(
                                  inputAction: TextInputAction.done,
                                  hintText: MyStrings.whereTo,
                                  controller: controller.destinationController,
                                  onTap: () {
                                    controller.changeIndex(1);
                                  },
                                  onChanged: (text) {
                                    if (isFirsTime == true) {
                                      isFirsTime = false;
                                      setState(() {});
                                    }
                                    debouncer.run(() {
                                      controller.searchYourAddress(
                                        locationName: text,
                                      );
                                    });
                                  },
                                  labelText: MyStrings.pickUpDestination.tr,
                                  radius: Dimensions.mediumRadius,
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      controller.clearTextFiled(1);
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      size: Dimensions.space20,
                                      color: MyColor.bodyText,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: Dimensions.space10),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                //show search results
                GetBuilder<SelectLocationController>(
                  builder: (controller) {
                    return controller.isSearched
                        ? CustomLoader(isPagination: true)
                        : GestureDetector(
                            onTap: () {},
                            child: SizedBox(
                              height: controller.allPredictions.isNotEmpty
                                  ? context.height * .3
                                  : 0,
                              child: Container(
                                padding: const EdgeInsetsDirectional.symmetric(
                                  vertical: Dimensions.space1,
                                  horizontal: Dimensions.space8,
                                ),
                                child: ListView.builder(
                                  itemCount: controller.allPredictions.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    var item = controller.allPredictions[index];
                                    return InkWell(
                                      radius: Dimensions.defaultRadius,
                                      onTap: () async {
                                        await controller
                                            .getLangAndLatFromMap(item)
                                            .whenComplete(() {
                                          controller.pickLocation();
                                          controller
                                              .updateSelectedAddressFromSearch(
                                            item.description ?? '',
                                          );
                                          controller.animateMapCameraPosition();
                                        });

                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: const EdgeInsetsDirectional
                                            .symmetric(
                                          vertical: Dimensions.space15,
                                          horizontal: Dimensions.space8,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            Dimensions.mediumRadius,
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.location_on_rounded,
                                              size: Dimensions.space20,
                                              color: MyColor.bodyText,
                                            ),
                                            spaceSide(Dimensions.space10),
                                            Expanded(
                                              child: Text(
                                                "${item.description}",
                                                style: regularDefault.copyWith(
                                                  color: MyColor.colorBlack,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                  },
                ),
                //Confirm
                Container(
                  margin: const EdgeInsetsDirectional.only(
                    bottom: Dimensions.space10,
                  ),
                  padding: const EdgeInsetsDirectional.symmetric(
                    vertical: Dimensions.space10,
                    horizontal: Dimensions.space12 + 1,
                  ),
                  child: RoundedButton(
                    text: MyStrings.confirmLocation,
                    press: () {
                      Get.back(result: 'true');
                    },
                    isOutlined: false,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
