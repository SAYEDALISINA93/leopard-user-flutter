class SelectedLocationInfo {
  final int? id;

  final double? latitude;
  final double? longitude;
  final String? placeName;
  final String? address;
  final String? city;
  final String? country;
  final String? fullAddress;

  SelectedLocationInfo({
    this.id,
    this.latitude,
    this.longitude,
    this.placeName,
    this.address,
    this.city,
    this.country,
    this.fullAddress,
  });

  factory SelectedLocationInfo.fromJson(Map<String, dynamic> json) {
    return SelectedLocationInfo(
      id: json["id"],
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      placeName: json['placeName'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      fullAddress: json['fullAddress'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'placeName': placeName,
      'address': address,
      'city': city,
      'country': country,
      'full_address': fullAddress,
    };
  }

  String getFullAddress({bool showFull = false}) {
    if (latitude == null && longitude == null) {
      return '';
    } else {
      if (showFull == false) {
        return "$placeName, $address, $city, $country";
      } else {
        return "$fullAddress";
      }
    }
  }
}
