import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/data/services/api_client.dart';

import '../../../core/utils/method.dart';
import '../../../environment.dart';
import '../../model/location/prediction.dart';

class LocationSearchRepo {
  ApiClient apiClient;
  LocationSearchRepo({required this.apiClient});

  Future<String?> getFormattedAddress(double lat, double lng) async {
    const apiKey = Environment.mapKey;
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey';

    final response = await apiClient.request(url, Method.getMethod, null);

    if (response.statusCode == 200) {
      final data = response.responseJson;
      if (data['results'] != null && data['results'].length > 0) {
        return data['results'][0]['formatted_address'];
      }
    }
    return null;
  }

  Future<dynamic> searchAddressByLocationName({
    String text = '',
    List<String>? countries,
  }) async {
    loggerX(apiClient.getOperatingCountries());
    List<String> codes = apiClient
        .getOperatingCountries()
        .map(
          (e) => 'country:${e.countryCode ?? Environment.defaultCountryCode}',
        )
        .toList();
    loggerX(codes);

    String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&key=${Environment.mapKey}&components=${codes.join('|')}&language=en';
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
}
