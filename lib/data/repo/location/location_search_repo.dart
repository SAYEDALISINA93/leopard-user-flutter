import 'package:leoparduser/core/helper/string_format_helper.dart';

import '../../../core/utils/method.dart';
import '../../../environment.dart';
import '../../model/location/prediction.dart';
import '../../services/api_service.dart';

class LocationSearchRepo {
  ApiClient apiClient;
  LocationSearchRepo({required this.apiClient});

  Future<dynamic> searchAddressByLocationName(
      {String text = '', List<String>? countries}) async {
    loggerX(apiClient.getOperatingCountry());
    List<String> codes = apiClient
        .getOperatingCountry()
        .map(
            (e) => 'country:${e.countryCode ?? Environment.defaultCountryCode}')
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
