import 'package:dio/dio.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/environment.dart';
import 'package:leoparduser/presentation/packages/flutter_polyline_points/flutter_polyline_points.dart';
import 'package:leoparduser/presentation/packages/flutter_polyline_points/src/new_route_coordinate_model.dart';

class NetworkUtil {
  static const String STATUS_OK = "ok";

  final Dio _dio = Dio();

  /// Get the encoded string from google directions api
  ///
  Future<List<PolylineResult>> getRouteBetweenCoordinates({
    required PolylineRequest request,
    String? googleApiKey,
    bool isOldAPI = true,
  }) async {
    List<PolylineResult> results = [];

    if (!isOldAPI) {
      try {
        Response response = await _dio.post(
          "https://routes.googleapis.com/directions/v2:computeRoutes",
          options: Options(
            headers: {
              "content-type": "application/json",
              "X-Goog-Api-Key": Environment.mapKey,
              "X-Goog-FieldMask":
                  "routes.distanceMeters,routes.duration,routes.polyline.encodedPolyline",
            },
          ),
          data: {
            "origin": {
              "location": {
                "latLng": {"latitude": 28.66, "longitude": 77.23},
              },
            },
            "destination": {
              "location": {
                "latLng": {"latitude": 28.79, "longitude": 77.05},
              },
            },
            "travelMode": "DRIVE",
            "routingPreference": "TRAFFIC_AWARE",
          },
        );

        if (response.statusCode == 200) {
          NewRouteCoordinateModel model =
              NewRouteCoordinateModel.fromJson(response.data);

          if (model.routes != null && model.routes!.isNotEmpty) {
            List<RouteCoordinate> routeList = model.routes!;
            for (var route in routeList) {
              List<PointLatLng> lines = PolylinePoints().decodePolyline(
                route.polyline?.encodedPolyline ?? '',
              );
              results.add(
                PolylineResult(
                  points: lines,
                  errorMessage: "",
                  status: "OK",
                  alternatives: [],
                  overviewPolyline: route.polyline?.encodedPolyline,
                ),
              );
            }
            printX("routes>> ${results[0].status}");
          } else {
            throw Exception("Unable to get route: Response ---> ${500}");
          }
        }
      } catch (e) {
        throw Exception("Dio Exception (new API): $e");
      }
    } else {
      try {
        Response response = await _dio.getUri(
          request.toUri(apiKey: googleApiKey),
          options: Options(headers: request.headers),
        );

        printX("url>> ${response.realUri}");
        if (response.statusCode == 200) {
          var parsedJson = response.data;
          printX("response of cordinate>> $parsedJson");
          if (parsedJson["status"]?.toLowerCase() == STATUS_OK &&
              parsedJson["routes"] != null &&
              parsedJson["routes"].isNotEmpty) {
            List<dynamic> routeList = parsedJson["routes"];
            for (var route in routeList) {
              results.add(
                PolylineResult(
                  points:
                      PolylineDecoder.run(route["overview_polyline"]["points"]),
                  errorMessage: "",
                  status: parsedJson["status"],
                  totalDistanceValue: route['legs']
                      .map((leg) => leg['distance']['value'])
                      .reduce((v1, v2) => v1 + v2),
                  distanceTexts: <String>[
                    ...route['legs'].map((leg) => leg['distance']['text'])
                  ],
                  distanceValues: <int>[
                    ...route['legs'].map((leg) => leg['distance']['value'])
                  ],
                  overviewPolyline: route["overview_polyline"]["points"],
                  totalDurationValue: route['legs']
                      .map((leg) => leg['duration']['value'])
                      .reduce((v1, v2) => v1 + v2),
                  durationTexts: <String>[
                    ...route['legs'].map((leg) => leg['duration']['text'])
                  ],
                  durationValues: <int>[
                    ...route['legs'].map((leg) => leg['duration']['value'])
                  ],
                  endAddress: route["legs"].last['end_address'],
                  startAddress: route["legs"].first['start_address'],
                ),
              );
            }
          } else {
            throw Exception(
                "Unable to get route: Response ---> ${parsedJson["status"]} ");
          }
        }
      } catch (e) {
        throw Exception("Dio Exception (old API): $e");
      }
    }

    return results;
  }
}
