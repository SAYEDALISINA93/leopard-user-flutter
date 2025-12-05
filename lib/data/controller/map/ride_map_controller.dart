import 'dart:typed_data';

import 'package:leoparduser/presentation/packages/flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/helper.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_images.dart';
import 'package:leoparduser/environment.dart';
import 'package:leoparduser/presentation/packages/polyline_animation/polyline_animation_v1.dart';

class RideMapController extends GetxController {
  bool isLoading = false;
  final PolylineAnimator animator = PolylineAnimator();

  LatLng pickupLatLng = const LatLng(0, 0);
  LatLng destinationLatLng = const LatLng(0, 0);
  LatLng driverLatLng = const LatLng(0, 0);
  Map<PolylineId, Polyline> polyLines = {};

  void updateDriverLocation({required LatLng latLng, required bool isRunning}) {
    printX('ride map update $latLng, $isRunning');
    driverLatLng = latLng;
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(driverLatLng.latitude, driverLatLng.longitude),
          zoom: 14,
        ),
      ),
    );
    update();
    getCurrentDriverAddress();
  }

  void loadMap({
    required LatLng pickup,
    required LatLng destination,
    bool? isRunning = false,
  }) async {
    pickupLatLng = pickup;
    destinationLatLng = destination;
    update();
    getPolyLinePoints().then((data) {
      polylineCoordinates = data;
      generatePolyLineFromPoints(data);
      fitPolylineBounds(data);
      animator.animatePolyline(
        data,
        'polyline_id',
        MyColor.colorYellow,
        MyColor.primaryColor,
        polyLines,
        () {
          update();
        },
      );
    });
    await setCustomMarkerIcon();
  }

  // map controller
  GoogleMapController? mapController;
  void animateMapCameraPosition() {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(pickupLatLng.latitude, pickupLatLng.longitude),
          zoom: Environment.mapDefaultZoom,
        ),
      ),
    );
  }

  //
  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    isLoading = true;
    update();
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: MyColor.getPrimaryColor(),
      points: polylineCoordinates,
      width: 3,
    );
    polyLines[id] = polyline;
    isLoading = false;
    update();
  }

  List<LatLng> polylineCoordinates = [];
  Future<List<LatLng>> getPolyLinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(pickupLatLng.latitude, pickupLatLng.longitude),
        destination: PointLatLng(
          destinationLatLng.latitude,
          destinationLatLng.longitude,
        ),
        mode: TravelMode.driving,
      ),
      googleApiKey: Environment.mapKey,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      printX(result.errorMessage);
    }
    return polylineCoordinates;
  }

  // icons
  Uint8List? pickupIcon;
  Uint8List? destinationIcon;
  Uint8List? driverIcon;

  Set<Marker> getMarkers({
    required LatLng pickup,
    required LatLng destination,
    LatLng? driverLatLng,
  }) {
    return {
      if (driverLatLng != null) ...[
        Marker(
          markerId: MarkerId('driver_marker_id'),
          position: driverLatLng,
          icon: driverIcon == null
              ? BitmapDescriptor.defaultMarker
              : BitmapDescriptor.bytes(
                  driverIcon!,
                  height: 45,
                  width: 45,
                  bitmapScaling: MapBitmapScaling.auto,
                ),
          infoWindow: InfoWindow(title: driverAddress, onTap: () {}),
          onTap: () async {
            getCurrentDriverAddress();
            printX('Driver current position $driverLatLng');
            printX('Driver current address $driverAddress');
          },
        ),
      ],
      Marker(
        markerId: MarkerId('pickup_marker_id'),
        position: LatLng(pickup.latitude, pickup.longitude),
        icon: pickupIcon == null
            ? BitmapDescriptor.defaultMarker
            : BitmapDescriptor.bytes(
                pickupIcon!,
                height: 45,
                width: 45,
                bitmapScaling: MapBitmapScaling.auto,
              ),
        onTap: () async {
          mapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(pickupLatLng.latitude, pickupLatLng.longitude),
                zoom: Environment.mapDefaultZoom,
              ),
            ),
          );
        },
      ),
      Marker(
        markerId: MarkerId('destination_marker_id'),
        position: LatLng(destination.latitude, destination.longitude),
        icon: destinationIcon == null
            ? BitmapDescriptor.defaultMarker
            : BitmapDescriptor.bytes(
                destinationIcon!,
                height: 45,
                width: 45,
                bitmapScaling: MapBitmapScaling.auto,
              ),
        onTap: () async {
          mapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(destination.latitude, destination.longitude),
                zoom: Environment.mapDefaultZoom,
              ),
            ),
          );
        },
      ),
    };
  }

  Future<void> setCustomMarkerIcon() async {
    pickupIcon = await Helper.getBytesFromAsset(MyImages.mapPickup, 80);
    destinationIcon = await Helper.getBytesFromAsset(
      MyImages.mapDestination,
      80,
    );
    driverIcon = await Helper.getBytesFromAsset(MyImages.mapDriver, 80);
  }

  String driverAddress = 'Loading...';

  Future<void> getCurrentDriverAddress() async {
    try {
      final List<Placemark> placeMark = await placemarkFromCoordinates(
        driverLatLng.latitude,
        driverLatLng.longitude,
      );
      driverAddress = "";
      driverAddress =
          "${placeMark[0].street} ${placeMark[0].subThoroughfare} ${placeMark[0].thoroughfare},${placeMark[0].subLocality},${placeMark[0].locality},${placeMark[0].country}";
      update();
      printX('appLocations position $driverAddress');
    } catch (e) {
      printX('Error in getting  position');
    }
  }

  void fitPolylineBounds(List<LatLng> coords) {
    if (coords.isEmpty) return;

    LatLngBounds bounds = _createLatLngBounds(coords);
    mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  /// Function to create bounds from polyline coordinates
  LatLngBounds _createLatLngBounds(List<LatLng> coords) {
    double minLat = coords.first.latitude;
    double maxLat = coords.first.latitude;
    double minLng = coords.first.longitude;
    double maxLng = coords.first.longitude;

    for (var latLng in coords) {
      if (latLng.latitude < minLat) minLat = latLng.latitude;
      if (latLng.latitude > maxLat) maxLat = latLng.latitude;
      if (latLng.longitude < minLng) minLng = latLng.longitude;
      if (latLng.longitude > maxLng) maxLng = latLng.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  void onClose() {
    // Critical: Dispose animator to stop timer and prevent memory leaks
    animator.dispose();
    mapController?.dispose();
    super.onClose();
  }
}
