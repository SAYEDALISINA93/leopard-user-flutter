import 'dart:typed_data';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/helper.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_images.dart';
import 'package:leoparduser/environment.dart';

class RideMapController extends GetxController {
  bool isLoading = false;

  LatLng pickupLatLng = const LatLng(0, 0);
  LatLng destinationLatLng = const LatLng(0, 0);
  LatLng driverLatLng = const LatLng(0, 0);
  Map<PolylineId, Polyline> polyLines = {};

  updateDriverLocation({required LatLng latLng, required bool isRunning}) {
    printx('ride map update $latLng, $isRunning');
    driverLatLng = latLng;
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(driverLatLng.latitude, driverLatLng.longitude),
            zoom: 14),
      ),
    );
    update();
    getCurrentDriverAddress();
  }

  void loadMap(
      {required LatLng pickup,
      required LatLng destination,
      bool? isRunning = false}) async {
    pickupLatLng = pickup;
    destinationLatLng = destination;
    update();
    getPolyLinePoints().then((data) {
      generatePolyLineFromPoints(data);
    });
    await setCustomMarkerIcon();
  }

// map controller
  GoogleMapController? mapController;
  animateMapCameraPosition() {
    mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(pickupLatLng.latitude, pickupLatLng.longitude),
        zoom: Environment.mapDefaultZoom)));
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
        width: 8);
    polyLines[id] = polyline;
    isLoading = false;
    update();
  }

  Future<List<LatLng>> getPolyLinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(pickupLatLng.latitude, pickupLatLng.longitude),
        destination: PointLatLng(
            destinationLatLng.latitude, destinationLatLng.longitude),
        mode: TravelMode.driving,
      ),
      googleApiKey: Environment.mapKey,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      printx(result.errorMessage);
    }
    return polylineCoordinates;
  }

  // icons
  Uint8List? pickupIcon;
  Uint8List? destinationIcon;
  Uint8List? driverIcon;

  Set<Marker> getMarkers(
      {required LatLng pickup,
      required LatLng destination,
      LatLng? driverLatLng}) {
    return {
      if (driverLatLng != null) ...[
        Marker(
          markerId: MarkerId('driver_marker_id'),
          position: driverLatLng,
          icon: pickupIcon == null
              ? BitmapDescriptor.defaultMarker
              : BitmapDescriptor.bytes(pickupIcon!,
                  height: 45, width: 45, bitmapScaling: MapBitmapScaling.auto),
          infoWindow: InfoWindow(title: driverAddress, onTap: () {}),
          onTap: () async {
            getCurrentDriverAddress();
            printx('Driver current position $driverLatLng');
            printx('Driver current address $driverAddress');
          },
        )
      ],
      Marker(
        markerId: MarkerId('pickup_marker_id'),
        position: LatLng(pickup.latitude, pickup.longitude),
        icon: destinationIcon == null
            ? BitmapDescriptor.defaultMarker
            : BitmapDescriptor.bytes(destinationIcon!,
                height: 45, width: 45, bitmapScaling: MapBitmapScaling.auto),
      ),
      Marker(
        markerId: MarkerId('destination_marker_id'),
        position: LatLng(destination.latitude, destination.longitude),
        icon: BitmapDescriptor.defaultMarker,
      ),
    };
  }

  Future<void> setCustomMarkerIcon() async {
    pickupIcon = await Helper.getBytesFromAsset(MyImages.mapDriver, 80);
    destinationIcon = await Helper.getBytesFromAsset(MyImages.mapHome, 80);
    driverIcon = await Helper.getBytesFromAsset(MyImages.mapCar, 80);
  }

  String driverAddress = 'Loading...';

  Future<void> getCurrentDriverAddress() async {
    try {
      final List<Placemark> placeMark = await placemarkFromCoordinates(
          driverLatLng.latitude, driverLatLng.longitude);
      driverAddress = "";
      driverAddress =
          "${placeMark[0].street} ${placeMark[0].subThoroughfare} ${placeMark[0].thoroughfare},${placeMark[0].subLocality},${placeMark[0].locality},${placeMark[0].country}";
      update();
      printx('appLocations position $driverAddress');
    } catch (e) {
      printx('Error in getting  position');
    }
  }
}
