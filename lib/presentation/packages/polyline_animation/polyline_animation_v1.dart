import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:leoparduser/core/utils/my_color.dart';

class PolylineAnimator {
  final Map<String, Timer> _polylinesTimers = {};

  void animatePolyline(
    List<LatLng> points,
    String id,
    Color color,
    Color backgroundColor,
    Map<PolylineId, Polyline> polyline,
    Function updatePolylines,
  ) {
    _polylinesTimers[id]?.cancel();

    PolylineId polylineId = PolylineId(id);
    PolylineId backgroundPolylineId = PolylineId('${id}background');
    PolylineId borderPolylineId = PolylineId('${id}border');

    polyline[borderPolylineId] = Polyline(
      polylineId: borderPolylineId,
      color: MyColor.primaryColor,
      width: 5,
      points: points,
      zIndex: 0,
    );

    polyline[backgroundPolylineId] = Polyline(
      polylineId: backgroundPolylineId,
      color: backgroundColor,
      width: 4,
      points: points,
      zIndex: 1,
    );

    polyline[polylineId] = Polyline(
      polylineId: polylineId,
      color: color,
      width: 4,
      points: const [],
      zIndex: 2,
    );

    int forwardIndex = 0;
    int backwardIndex = -1;

    Timer timer = Timer.periodic(const Duration(milliseconds: 200), (
      Timer timer,
    ) {
      if (polyline[polylineId] != null) {
        var updatedPoints = List<LatLng>.from(polyline[polylineId]!.points);

        if (forwardIndex < points.length) {
          updatedPoints.add(points[forwardIndex]);
          polyline[polylineId] = polyline[polylineId]!.copyWith(
            pointsParam: updatedPoints,
          );
          forwardIndex++;
        }

        if (forwardIndex > points.length / 2 &&
            backwardIndex < forwardIndex - 1) {
          backwardIndex = (backwardIndex == -1) ? 0 : backwardIndex;
          if (backwardIndex < forwardIndex) {
            updatedPoints.removeAt(0);
            polyline[polylineId] = polyline[polylineId]!.copyWith(
              pointsParam: updatedPoints,
            );
            backwardIndex++;
          }
        }

        if (backwardIndex >= forwardIndex - 1) {
          forwardIndex = 0;
          backwardIndex = -1;
          polyline[polylineId] = polyline[polylineId]!.copyWith(
            pointsParam: [],
          );
        }

        updatePolylines();
      }
    });

    _polylinesTimers[id] = timer;
  }

  void dispose() {
    _polylinesTimers.forEach((id, timer) {
      timer.cancel();
    });
    _polylinesTimers.clear();
  }
}
