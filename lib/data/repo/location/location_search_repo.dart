import '../../../core/utils/method.dart';
import '../../../environment.dart';
import '../../model/location/prediction.dart';
import '../../services/api_service.dart';

class LocationSearchRepo {
  ApiClient apiClient;
  LocationSearchRepo({required this.apiClient});

  Future<dynamic> searchAddressByLocationName({String text = '', List<String>? countries}) async {
    String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&key=${Environment.mapKey}&components=country:${Environment.defaultCountryCode}';

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
    final url = "https://maps.googleapis.com/maps/api/place/details/json?placeid=${prediction.placeId}&key=${Environment.mapKey}";

    final response = await apiClient.request(url, Method.getMethod, null);
    return response;
  }
}
