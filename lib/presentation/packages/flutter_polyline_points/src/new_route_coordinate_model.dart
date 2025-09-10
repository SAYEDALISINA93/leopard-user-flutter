class NewRouteCoordinateModel {
  final List<RouteCoordinate>? routes;

  NewRouteCoordinateModel({this.routes});

  factory NewRouteCoordinateModel.fromJson(Map<String, dynamic> json) => NewRouteCoordinateModel(
        routes: json["routes"] == null
            ? []
            : List<RouteCoordinate>.from(
                json["routes"]!.map((x) => RouteCoordinate.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "routes": routes == null ? [] : List<dynamic>.from(routes!.map((x) => x.toJson())),
      };
}

class RouteCoordinate {
  final int? distanceMeters;
  final String? duration;
  final Polyline? polyline;

  RouteCoordinate({this.distanceMeters, this.duration, this.polyline});

  factory RouteCoordinate.fromJson(Map<String, dynamic> json) => RouteCoordinate(
        distanceMeters: json["distanceMeters"],
        duration: json["duration"],
        polyline: json["polyline"] == null ? null : Polyline.fromJson(json["polyline"]),
      );

  Map<String, dynamic> toJson() => {
        "distanceMeters": distanceMeters,
        "duration": duration,
        "polyline": polyline?.toJson(),
      };
}

class Polyline {
  final String? encodedPolyline;

  Polyline({this.encodedPolyline});

  factory Polyline.fromJson(Map<String, dynamic> json) => Polyline(encodedPolyline: json["encodedPolyline"]);

  Map<String, dynamic> toJson() => {"encodedPolyline": encodedPolyline};
}
