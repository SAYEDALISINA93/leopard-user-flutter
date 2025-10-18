import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/model/location/selected_location_info.dart';
import 'package:leoparduser/environment.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';
import 'package:leoparduser/presentation/packages/flutter_polyline_points/flutter_polyline_points.dart';
import 'package:leoparduser/presentation/packages/polyline_animation/polyline_animation_v1.dart';

import '../../model/location/place_details.dart';
import '../../model/location/prediction.dart';
import '../../repo/location/location_search_repo.dart';
import '../home/home_controller.dart';

/// Controller responsible for handling location selection functionality
class SelectLocationController extends GetxController {
  // Dependencies
  final LocationSearchRepo locationSearchRepo;
  int selectedLocationIndex; // Current selected location index (0 = pickup, 1 = destination)

  // Constructor with required dependencies
  SelectLocationController({
    required this.locationSearchRepo,
    required this.selectedLocationIndex,
  });

  /// Update the current index
  void changeIndex(int i) {
    selectedLocationIndex = i;
    update();
  }

  // Location coordinates
  LatLng pickupLatlong = const LatLng(0, 0);
  LatLng destinationLatlong = const LatLng(0, 0);

  // Current position and address information
  Position? currentPosition;
  final currentAddress = "".obs;
  double selectedLatitude = 0.0;
  double selectedLongitude = 0.0;

  // Loading state variables
  bool isLoading = false;
  bool isLoadingFirstTime = false;

  // Controllers
  final HomeController homeController = Get.find();
  final TextEditingController searchLocationController = TextEditingController();
  final TextEditingController valueOfLocation = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController pickUpController = TextEditingController();
  final FocusNode searchFocus = FocusNode();

  // Polyline animator for route visualization
  final PolylineAnimator animator = PolylineAnimator();

  // Map controller for camera manipulation
  GoogleMapController? mapController;
  GoogleMapController? editMapController;

  // Polyline data
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  // Search results
  bool isSearched = false;
  List<Prediction> allPredictions = [];
  String selectedAddressFromSearch = '';

  /// Clear text field based on index (0 = pickup, 1 = destination)
  void clearTextFiled(int index) {
    if (index == 0) {
      pickUpController.text = '';
    } else {
      destinationController.text = '';
    }
  }

  /// Initialize the controller, setting up locations from homeController
  void initialize() async {
    loggerX("homeController.selectedLocations.length ${homeController.selectedLocations.length}");

    // Set pickup location if available
    if (homeController.selectedLocations.isNotEmpty) {
      final pickupInfo = homeController.getSelectedLocationInfoAtIndex(0);
      if (pickupInfo != null) {
        pickupLatlong = LatLng(pickupInfo.latitude ?? 0, pickupInfo.longitude ?? 0);
        pickUpController.text = pickupInfo.getFullAddress(showFull: true);
      }

      // Set destination location if available
      if (homeController.selectedLocations.length > 1) {
        final destInfo = homeController.getSelectedLocationInfoAtIndex(1);
        if (destInfo != null) {
          destinationLatlong = LatLng(destInfo.latitude ?? 0, destInfo.longitude ?? 0);
          destinationController.text = destInfo.getFullAddress(showFull: true);
        }

        // Generate polyline route between pickup and destination
        await _generateRoutePolyline();
      }
    }

    // Get the current position based on the index
    if (homeController.selectedLocations.length < 2) {
      await getCurrentPosition(isLoading1stTime: true, pickupLocationForIndex: selectedLocationIndex);
    }
  }

  /// Generate polyline for the route between pickup and destination
  Future<void> _generateRoutePolyline() async {
    final points = await getPolylinePoints();
    polylineCoordinates = points;
    generatePolyLineFromPoints(points);
    // fitPolylineBounds(points);
    fitPolylineInTopHalf(points);

    animator.animatePolyline(
      points,
      'polyline_id',
      MyColor.colorYellow,
      MyColor.primaryColor,
      polylines,
      () {
        update();
      },
    );
  }

  /// Check and request location permissions
  Future<bool> handleLocationPermission() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      CustomSnackBar.error(errorList: [MyStrings.locationServiceDisableMsg]);
      return false;
    }

    printX("serviceEnabled $serviceEnabled");

    // Check location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        CustomSnackBar.error(errorList: [MyStrings.locationPermissionDenied]);
        return false;
      }
    }

    // Handle permanently denied permission
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      CustomSnackBar.error(errorList: [MyStrings.locationPermissionPermanentDenied]);
      return false;
    }

    return true;
  }

  /// Get the current position and update the map
  Future<void> getCurrentPosition({
    bool isLoading1stTime = false,
    int pickupLocationForIndex = -1,
    bool isFromEdit = false,
  }) async {
    // Set loading states
    isLoadingFirstTime = isLoading1stTime;
    isLoading = true;
    update();

    // Check location permissions
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) {
      _endLoading();
      return;
    }

    // Get selected location data if available
    final getSelectLocationData = homeController.getSelectedLocationInfoAtIndex(pickupLocationForIndex);
    final effectiveIndex = getSelectLocationData == null ? -1 : pickupLocationForIndex;

    // Get current position if no selected location
    if (effectiveIndex == -1) {
      await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((value) => currentPosition = value);
    }

    // Update camera position based on current or selected location
    if (currentPosition != null && getSelectLocationData == null) {
      changeCurrentLatLongBasedOnCameraMove(
        currentPosition!.latitude,
        currentPosition!.longitude,
      );
      update();
      animateMapCameraPosition(isFromEdit: isFromEdit);
    } else if (getSelectLocationData != null) {
      changeCurrentLatLongBasedOnCameraMove(
        getSelectLocationData.latitude!,
        getSelectLocationData.longitude!,
      );
      update();
      animateMapCameraPosition(isFromEdit: isFromEdit);
    }

    _endLoading();
  }

  /// End loading states
  void _endLoading() {
    isLoading = false;
    isLoadingFirstTime = false;
    update();
  }

  /// Get the initial target location for the map
  LatLng getInitialTargetLocationForMap({int pickupLocationForIndex = -1}) {
    // selectedLocationIndex = pickupLocationForIndex;
    final getSelectLocationData = homeController.getSelectedLocationInfoAtIndex(pickupLocationForIndex);

    if (getSelectLocationData == null) {
      // Default to current position or US center if not available
      return currentPosition != null ? LatLng(currentPosition!.latitude, currentPosition!.longitude) : const LatLng(37.0902, 95.7129); // US center coordinates
    } else {
      return LatLng(
        getSelectLocationData.latitude!,
        getSelectLocationData.longitude!,
      );
    }
  }

  /// Open the map and get address from coordinates
  Future<void> openMap(double latitude, double longitude) async {
    try {
      String address = '';

      // Reverse geocoding
      if (Environment.addressPickerFromMapApi) {
        // Use external API (e.g., Google)
        address = await locationSearchRepo.getFormattedAddress(latitude, longitude) ?? '';

        // Fallback to local reverse geocoding if API returns empty
        if (address.trim().isEmpty) {
          final placemarks = await placemarkFromCoordinates(latitude, longitude);
          printInfo(info: "Placemark from local reverse geocoding: $placemarks");
          if (placemarks.isNotEmpty) {
            address = _formatAddress(placemarks.first);
          }
        }
      } else {
        // Use local reverse geocoding
        final placemarks = await placemarkFromCoordinates(latitude, longitude);
        if (placemarks.isNotEmpty) {
          address = _formatAddress(placemarks.first);
        }
      }

      // Update address value
      currentAddress.value = address;
      update();
      // Update the appropriate controller based on index
      final bool useSearchedAddress = selectedAddressFromSearch.isNotEmpty && Get.currentRoute != RouteHelper.editLocationPickUpScreen;
      String displayAddress = useSearchedAddress ? selectedAddressFromSearch : currentAddress.value;

      if (selectedLocationIndex == 0) {
        pickUpController.text = displayAddress;
        pickupLatlong = LatLng(latitude, longitude);
      } else {
        destinationController.text = displayAddress;
        destinationLatlong = LatLng(latitude, longitude);
      }

      // Add or update location in homeController
      homeController.addLocationAtIndex(
        SelectedLocationInfo(
          latitude: latitude,
          longitude: longitude,
          fullAddress: displayAddress,
        ),
        selectedLocationIndex,
      );

      // Clear one-time searched address so future picks use fresh reverse geocode
      selectedAddressFromSearch = '';
      update();

      // Generate route polyline if both pickup and destination are set
      if (pickupLatlong.latitude != 0 && destinationLatlong.latitude != 0) {
        await _generateRoutePolyline();
      }
    } catch (e) {
      printX("Error getting address: ${e.toString()}");
      animateMapCameraPosition();
    }
  }

  /// Format address from placemark components
  String _formatAddress(Placemark placemark) {
    // Prefer Building/Place name, Street, City
    final building = placemark.name ?? '';
    final street = placemark.street ?? '';
    final city = (placemark.locality ?? placemark.subAdministrativeArea ?? '').trim();

    // Avoid duplicates if name == street, etc.
    final parts = <String>[];
    if (building.isNotEmpty) parts.add(building);
    if (street.isNotEmpty && street.toLowerCase() != building.toLowerCase()) parts.add(street);
    if (city.isNotEmpty && !parts.map((e) => e.toLowerCase()).contains(city.toLowerCase())) parts.add(city);

    // Fallback to broader components if all empty
    if (parts.isEmpty) {
      final admin = placemark.administrativeArea ?? '';
      final country = placemark.country ?? '';
      parts.addAll([street, city, admin, country].where((e) => e.isNotEmpty));
    }

    return parts.join(', ');
  }

  /// Update the selected latitude and longitude based on camera movement
  void changeCurrentLatLongBasedOnCameraMove(
    double latitude,
    double longitude,
  ) {
    selectedLatitude = latitude;
    selectedLongitude = longitude;
    update();
  }

  /// Animate the map camera to a new position
  void animateMapCameraPosition({bool isFromEdit = false}) {
    if (isFromEdit) {
      editMapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(selectedLatitude, selectedLongitude),
            zoom: 18,
          ),
        ),
      );
    } else {
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(selectedLatitude, selectedLongitude),
            zoom: 18,
          ),
        ),
      );
    }
  }

  /// Pick location at the current map center
  Future<void> pickLocation() async {
    await openMap(selectedLatitude, selectedLongitude);
  }

  /// Clear the search field and results
  void clearSearchField() {
    allPredictions = [];
    searchLocationController.clear();
    update();
  }

  /// Update the selected address from search results
  void updateSelectedAddressFromSearch(String address) {
    selectedAddressFromSearch = address;
    update();
  }

  /// Search for addresses by location name
  Future<void> searchYourAddress({String locationName = '', void Function()? onSuccessCallback}) async {
    if (locationName.isEmpty) {
      allPredictions.clear();
      update();
      return;
    }

    isSearched = true;
    update();

    try {
      // Clear previous results
      allPredictions.clear();

      // Fetch address suggestions
      final ResponseModel? response = await locationSearchRepo.searchAddressByLocationName(
        text: locationName,
      );

      if (response != null) {
        final subscriptionResponse = PlacesAutocompleteResponse.fromJson((response.responseJson));

        if (subscriptionResponse.predictions != null && subscriptionResponse.predictions!.isNotEmpty) {
          allPredictions.addAll(subscriptionResponse.predictions!);
          onSuccessCallback?.call();
        }
      }
    } catch (e) {
      printX("Search error: ${e.toString()}");
    } finally {
      isSearched = false;
      update();
    }
  }

  /// Get latitude and longitude from a place prediction
  Future<LatLng?> getLangAndLatFromMap(Prediction prediction) async {
    try {
      // Get place details
      final ResponseModel response = await locationSearchRepo.getPlaceDetailsFromPlaceId(prediction);
      final placeDetails = PlaceDetails.fromJson((response.responseJson));

      if (placeDetails.result == null) {
        return null;
      }

      // Extract location coordinates
      final lat = placeDetails.result!.geometry!.location!.lat ?? 0.0;
      final lng = placeDetails.result!.geometry!.location!.lng ?? 0.0;

      // Update prediction with coordinates
      prediction.lat = lat.toString();
      prediction.lng = lng.toString();

      // Update the current map position
      changeCurrentLatLongBasedOnCameraMove(lat, lng);

      // Animate camera to the new position
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, lng),
            zoom: 15,
          ),
        ),
      );

      // Clear predictions and update UI
      allPredictions = [];
      update();

      return LatLng(lat, lng);
    } catch (e) {
      printX("Error getting place details: ${e.toString()}");
      return null;
    }
  }

  /// Get polyline points for route between pickup and destination
  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> points = [];

    try {
      final PolylinePoints polylinePoints = PolylinePoints();
      final PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(pickupLatlong.latitude, pickupLatlong.longitude),
          destination: PointLatLng(
            destinationLatlong.latitude,
            destinationLatlong.longitude,
          ),
          mode: TravelMode.driving,
        ),
        googleApiKey: Environment.mapKey,
      );

      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          points.add(LatLng(point.latitude, point.longitude));
        }
      } else {
        printX("Polyline error: ${result.errorMessage}");
      }
    } catch (e) {
      printX("Error getting polyline: ${e.toString()}");
    }

    return points;
  }

  /// Generate polyline from coordinate points
  void generatePolyLineFromPoints(List<LatLng> coordinates) {
    if (coordinates.isEmpty) return;

    isLoading = true;
    update();

    // Create a polyline
    const PolylineId id = PolylineId("poly");
    final Polyline polyline = Polyline(
      polylineId: id,
      color: MyColor.primaryColor,
      points: coordinates,
      width: 5,
    );

    polylines[id] = polyline;

    isLoading = false;
    update();
  }

  /// Fit map bounds to show the entire polyline route
  void fitPolylineBounds(List<LatLng> coords, {double bottomSheetExtent = 0.4}) {
    if (coords.isEmpty) return;

    final LatLngBounds bounds = _createLatLngBounds(coords, bottomSheetExtent);
    mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }

  LatLngBounds _createLatLngBounds(List<LatLng> coords, double bottomSheetExtent) {
    if (coords.isEmpty) {
      return LatLngBounds(
        southwest: const LatLng(0, 0),
        northeast: const LatLng(1, 1),
      );
    }

    double minLat = coords.first.latitude;
    double maxLat = coords.first.latitude;
    double minLng = coords.first.longitude;
    double maxLng = coords.first.longitude;

    for (var latLng in coords) {
      minLat = latLng.latitude < minLat ? latLng.latitude : minLat;
      maxLat = latLng.latitude > maxLat ? latLng.latitude : maxLat;
      minLng = latLng.longitude < minLng ? latLng.longitude : minLng;
      maxLng = latLng.longitude > maxLng ? latLng.longitude : maxLng;
    }

    // Adjust vertical bounds based on the draggable sheet
    final latPaddingRatio = bottomSheetExtent.clamp(0.0, 1.0); // e.g. 0.3 for 30%
    final latSpan = maxLat - minLat;
    final extraPadding = latSpan * latPaddingRatio;

    return LatLngBounds(
      southwest: LatLng(minLat + extraPadding, minLng), // raise bottom edge
      northeast: LatLng(maxLat, maxLng),
    );
  }

  void fitPolylineInTopHalf(List<LatLng> polylinePoints) async {
    final bounds = _calculateBounds(polylinePoints);

    await mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        bounds,
        50.0, // padding
      ),
    );
  }

  LatLngBounds _calculateBounds(List<LatLng> points) {
    double x0 = points.first.latitude;
    double x1 = points.first.latitude;
    double y0 = points.first.longitude;
    double y1 = points.first.longitude;

    for (LatLng latLng in points) {
      if (latLng.latitude > x1) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1) y1 = latLng.longitude;
      if (latLng.longitude < y0) y0 = latLng.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(x0, y0),
      northeast: LatLng(x1, y1),
    );
  }

  @override
  void onClose() {
    // Dispose resources
    searchLocationController.dispose();
    valueOfLocation.dispose();
    destinationController.dispose();
    pickUpController.dispose();
    searchFocus.dispose();
    mapController?.dispose();
    super.onClose();
  }
}
