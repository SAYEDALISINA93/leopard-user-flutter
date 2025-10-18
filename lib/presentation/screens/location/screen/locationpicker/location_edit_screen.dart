import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/theme/light/light.dart';
import 'package:leoparduser/core/utils/my_icons.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/environment.dart';
import 'package:leoparduser/presentation/components/annotated_region/annotated_region_widget.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';
import '../../../../../core/utils/dimensions.dart';
import '../../../../../core/utils/helper.dart';
import '../../../../../core/utils/my_color.dart';
import '../../../../../core/utils/my_strings.dart';
import '../../../../../data/controller/location/select_location_controller.dart';

class EditLocationPickerScreen extends StatefulWidget {
  const EditLocationPickerScreen({super.key, required this.selectedIndex});
  final int selectedIndex;

  @override
  State<EditLocationPickerScreen> createState() => _EditLocationPickerScreenState();
}

class _EditLocationPickerScreenState extends State<EditLocationPickerScreen> {
  Uint8List? locationPicker;
  LatLng? _currentCameraPosition;
  double currentZoom = Environment.mapDefaultZoom;
  double? _previousZoom;
  bool _isZooming = false;
  bool isDragging = false;
  bool showMarker = true;
  int selectedIndex = 0;
  @override
  void initState() {
    selectedIndex = Get.arguments;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Get.find<SelectLocationController>().changeIndex(selectedIndex);
      await loadMarker();
    });
  }

  Future<void> loadMarker() async {
    locationPicker = await Helper.getBytesFromAsset(MyIcons.mapMarkerIcon, 150);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegionWidget(
      child: GetBuilder<SelectLocationController>(builder: (controller) {
        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          backgroundColor: MyColor.screenBgColor,
          resizeToAvoidBottomInset: true,
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              if (controller.isLoading == true && controller.isLoadingFirstTime == true)
                const SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                )
              else ...[
                Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          GoogleMap(
                            style: googleMapLightStyleJson,
                            myLocationEnabled: true,
                            myLocationButtonEnabled: false,
                            initialCameraPosition: CameraPosition(
                              target: controller.getInitialTargetLocationForMap(pickupLocationForIndex: selectedIndex),
                              zoom: currentZoom,
                              // bearing: 20,
                              // tilt: 0,
                            ),
                            markers: showMarker
                                ? {
                                    Marker(
                                      markerId: const MarkerId(
                                        "selected_location",
                                      ),
                                      position: LatLng(
                                        controller.homeController.getSelectedLocationInfoAtIndex(selectedIndex)?.latitude ?? 0,
                                        controller.homeController.getSelectedLocationInfoAtIndex(selectedIndex)?.longitude ?? 0,
                                      ),
                                      icon: locationPicker == null
                                          ? BitmapDescriptor.defaultMarker
                                          : BitmapDescriptor.bytes(
                                              locationPicker!,
                                              height: 45,
                                              width: 47,
                                            ),
                                    ),
                                  }
                                : <Marker>{},
                            // Modify the onMapCreated callback to move camera to the selected position after map creation
                            onMapCreated: (googleMapController) {
                              controller.editMapController = googleMapController;

                              // Add this to center on selected location after map loads
                              controller.editMapController?.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: LatLng(
                                      controller.homeController.getSelectedLocationInfoAtIndex(selectedIndex)?.latitude ?? 0,
                                      controller.homeController.getSelectedLocationInfoAtIndex(selectedIndex)?.longitude ?? 0,
                                    ),
                                    zoom: currentZoom,
                                  ),
                                ),
                              );
                            },
                            zoomGesturesEnabled: false,
                            onTap: (argument) async {
                              // Update location when user taps on the map
                              controller.changeCurrentLatLongBasedOnCameraMove(
                                argument.latitude,
                                argument.longitude,
                              );

                              // Move camera to the tapped location
                              controller.editMapController?.animateCamera(
                                CameraUpdate.newLatLng(argument),
                              );

                              // Fetch address for the tapped location
                              await controller.pickLocation();
                            },
                            onCameraMove: (CameraPosition? position) async {
                              printX("MOving");
                              if (_previousZoom != null && position?.zoom != _previousZoom) {
                                if (!_isZooming) {
                                  setState(() {
                                    _isZooming = true;
                                  });
                                  printX("Started Zooming...");
                                }
                              }
                              _previousZoom = position?.zoom;

                              setState(() {
                                isDragging = true;
                                showMarker = false; // hide marker when dragging
                                _currentCameraPosition = position?.target;
                              });
                            },
                            onCameraIdle: () async {
                              if (isDragging && !_isZooming && _currentCameraPosition != null) {
                                controller.changeCurrentLatLongBasedOnCameraMove(
                                  _currentCameraPosition!.latitude,
                                  _currentCameraPosition!.longitude,
                                );
                                await controller.pickLocation();
                              }

                              setState(() {
                                isDragging = false;
                                _isZooming = false;
                                showMarker = true; // show marker again after done
                              });
                            },
                          ),
                          if (isDragging && !_isZooming && locationPicker != null)
                            Positioned(
                              bottom: 45,
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Align(
                                alignment: Alignment.center,
                                child: Image.memory(locationPicker!, width: 45),
                              ),
                            ),
                        ],
                      ),
                    ),
                    buildConfirmDestination()
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
              //Current location picker
              PositionedDirectional(
                top: 0,
                end: 0,
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
                      onPressed: () async {
                        await controller.getCurrentPosition(pickupLocationForIndex: -1, isFromEdit: true);
                      },
                      icon: const Icon(Icons.location_searching),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget buildConfirmDestination() {
    return GetBuilder<SelectLocationController>(
      builder: (controller) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          padding: EdgeInsets.symmetric(
            vertical: Dimensions.space10,
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            color: MyColor.colorWhite,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: Dimensions.space20),
                Text(
                  MyStrings.setYourLocationPerfectly.tr,
                  style: boldDefault.copyWith(fontSize: 20),
                ),
                Text(
                  MyStrings.zoomInToSetExactLocation.tr,
                  style: lightDefault.copyWith(color: MyColor.bodyText),
                ),
                SizedBox(height: Dimensions.space30),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.space15,
                    vertical: Dimensions.space10,
                  ),
                  decoration: BoxDecoration(
                    color: MyColor.colorGrey2,
                    borderRadius: BorderRadius.circular(Dimensions.largeRadius),
                  ),
                  child: Text(
                    controller.currentAddress.value.isNotEmpty
                        ? controller.currentAddress.value
                        : controller.homeController
                                .getSelectedLocationInfoAtIndex(
                                  controller.selectedLocationIndex,
                                )
                                ?.fullAddress ??
                            "",
                    style: lightDefault.copyWith(color: MyColor.bodyText),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: Dimensions.space40),
                //Confirm
                RoundedButton(
                  text: MyStrings.confirm,
                  verticalPadding: 20,
                  press: () {
                    Get.back();
                  },
                  isOutlined: false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
