class SignUpModel {
  final String mobile;
  final String email;
  final bool? agree;
  final String username;
  final String fName;
  final String lName;
  final String password;
  final String countryCode;
  final String country;
  final String mobileCode;
  String? referName;
  String? firebaseToken;

  SignUpModel({
    required this.mobile,
    required this.email,
    required this.agree,
    required this.username,
    required this.fName,
    required this.lName,
    required this.password,
    required this.countryCode,
    required this.country,
    required this.mobileCode,
    this.referName,
    this.firebaseToken,
  });
}
