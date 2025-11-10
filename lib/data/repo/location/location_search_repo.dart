import 'package:leoparduser/core/helper/string_format_helper.dart';

import '../../../core/utils/method.dart';
import '../../../environment.dart';
import '../../model/location/prediction.dart';
import '../../services/api_service.dart';

class LocationSearchRepo {
  ApiClient apiClient;
  LocationSearchRepo({required this.apiClient});

  Future<dynamic> searchAddressByLocationName(
      {String text = '',
      List<String>? countries,
      double? latitude,
      double? longitude}) async {
    loggerX(apiClient.getOperatingCountry());
    List<String> codes = apiClient
        .getOperatingCountry()
        .map(
            (e) => 'country:${e.countryCode ?? Environment.defaultCountryCode}')
        .toList();
    loggerX(codes);

    String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&key=${Environment.mapKey}&components=${codes.join('|')}&language=en';

    // Bias results towards user's current area to improve establishment keyword matching
    if (latitude != null && longitude != null) {
      // 10km radius bias
      url =
          "$url&locationbias=circle:10000@${latitude.toStringAsFixed(6)},${longitude.toStringAsFixed(6)}";
    }
    loggerI(url);

    if (countries != null) {
      for (int i = 0; i < countries.length; i++) {
        final country = countries[i];

        if (i == 0) {
          url = "$url&components=country:$country";
        } else {
          url = "$url|country:$country";
        }
      }
    }

    final response = await apiClient.request(url, Method.getMethod, null);
    return response;
  }

  Future<dynamic> getPlaceDetailsFromPlaceId(Prediction prediction) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/details/json?placeid=${prediction.placeId}&key=${Environment.mapKey}";

    final response = await apiClient.request(url, Method.getMethod, null);
    return response;
  }

  /// Fallback search when Autocomplete doesn't return results for keyword queries
  /// like business names (e.g., "ABC restaurant").
  Future<dynamic> findPlaceFromText({
    required String text,
    double? latitude,
    double? longitude,
    int radiusMeters = 10000,
  }) async {
    String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$text&inputtype=textquery&fields=place_id,geometry,name,formatted_address&key=${Environment.mapKey}&language=en';

    if (latitude != null && longitude != null) {
      url =
          "$url&locationbias=circle:${radiusMeters}@${latitude.toStringAsFixed(6)},${longitude.toStringAsFixed(6)}";
    }
    loggerI(url);
    final response = await apiClient.request(url, Method.getMethod, null);
    return response;
  }
}
