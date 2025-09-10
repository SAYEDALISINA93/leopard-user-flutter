import 'dart:io';

class UserPostModel {
  final String firstname;
  final String lastName;
  final String mobile;
  final String email;
  final String username;
  final String countryCode;
  final String country;
  final String mobileCode;
  final File? image;
  final String? address;
  final String? state;
  final String? zip;
  final String? city;
  final String? refer;

  UserPostModel({
    required this.firstname,
    required this.lastName,
    required this.mobile,
    required this.email,
    required this.username,
    required this.countryCode,
    required this.country,
    required this.mobileCode,
    required this.image,
    required this.address,
    required this.state,
    required this.zip,
    required this.city,
    required this.refer,
  });

  factory UserPostModel.fromMap(Map<String, dynamic> map) {
    return UserPostModel(
      firstname: map['firstname'] as String,
      lastName: map['lastName'] as String,
      mobile: map['mobile'] as String,
      email: map['email'] as String,
      username: map['username'] as String,
      countryCode: map['countryCode'] as String,
      country: map['country'] as String,
      mobileCode: map['mobileCode'] as String,
      image: map['image'] as File,
      address: map['address'] as String,
      state: map['state'] as String,
      zip: map['zip'] as String,
      city: map['city'] as String,
      refer: map['reference'] as String,
    );
  }
}
