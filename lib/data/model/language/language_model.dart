class MyLanguageModel {
  String languageName;
  String languageCode;
  String countryCode;
  String? imageUrl;

  MyLanguageModel({
    required this.languageName,
    required this.countryCode,
    required this.languageCode,
    this.imageUrl,
  });
}
