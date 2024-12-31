import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:leoparduser/data/controller/map/ride_map_controller.dart';

import '../../../../../environment.dart';

class PolyLineMapScreen extends StatefulWidget {
  const PolyLineMapScreen({
    super.key,
  });

  @override
  State<PolyLineMapScreen> createState() => _PolyLineMapScreenState();
}

class _PolyLineMapScreenState extends State<PolyLineMapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<RideMapController>(
        builder: (controller) {
          return GoogleMap(
            trafficEnabled: false,
            indoorViewEnabled: false,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            myLocationEnabled: true,
            compassEnabled: false,
            initialCameraPosition: CameraPosition(
                target: controller.pickupLatLng,
                zoom: Environment.mapDefaultZoom + 6),
            onMapCreated: (googleMapController) {
              controller.mapController = googleMapController;
              double southWestLat;
              double southWestLong;
              double northEastLat;
              double northEastLong;

              if (controller.pickupLatLng.latitude <=
                  controller.destinationLatLng.latitude) {
                southWestLat = controller.pickupLatLng.latitude;
                northEastLat = controller.destinationLatLng.latitude;
              } else {
                northEastLat = controller.pickupLatLng.latitude;
                southWestLat = controller.destinationLatLng.latitude;
              }

              if (controller.pickupLatLng.longitude <=
                  controller.destinationLatLng.longitude) {
                southWestLong = controller.pickupLatLng.longitude;
                northEastLong = controller.destinationLatLng.longitude;
              } else {
                northEastLong = controller.pickupLatLng.longitude;
                southWestLong = controller.destinationLatLng.longitude;
              }
              LatLngBounds bounds = LatLngBounds(
                northeast: LatLng(northEastLat, northEastLong),
                southwest: LatLng(southWestLat, southWestLong),
              );

              controller.mapController
                  ?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 15.0));
            },
            markers: controller.getMarkers(
              pickup: controller.pickupLatLng,
              destination: controller.destinationLatLng,
              driverLatLng: controller.driverLatLng,
            ),
            polylines: Set<Polyline>.of(controller.polyLines.values),
          );
        },
      ),
    );
  }
}
