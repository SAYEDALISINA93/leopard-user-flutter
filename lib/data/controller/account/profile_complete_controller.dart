import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/shared_preference_helper.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/route/route_middleware.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/model/authorization/authorization_response_model.dart';
import 'package:leoparduser/data/model/country_model/country_model.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/model/profile/profile_response_model.dart';
import 'package:leoparduser/data/model/user_post_model/user_post_model.dart';
import 'package:leoparduser/data/repo/account/profile_repo.dart';
import 'package:leoparduser/environment.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class ProfileCompleteController extends GetxController {
  ProfileRepo profileRepo;
  ProfileCompleteController({required this.profileRepo});

  ProfileResponseModel model = ProfileResponseModel();

  TextEditingController userNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController referController = TextEditingController();

  FocusNode userNameFocusNode = FocusNode();
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode mobileNoFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  FocusNode stateFocusNode = FocusNode();
  FocusNode zipCodeFocusNode = FocusNode();
  FocusNode cityFocusNode = FocusNode();
  FocusNode countryFocusNode = FocusNode();

  bool isLoading = false;

  initialData() async {
    await loadProfileInfo();
    //  await getCountryData();
  }

  ProfileResponseModel profileResponseModel = ProfileResponseModel();

  String imageUrl = '';

  File? imageFile;
  String emailData = '';
  String countryData = '';
  String countryCodeData = '';
  String phoneCodeData = '';
  String phoneData = '';

  String loginType = '';

  Future<void> loadProfileInfo() async {
    isLoading = true;
    update();
    try {
      profileResponseModel = await profileRepo.loadProfileInfo();
      if (profileResponseModel.data != null &&
          profileResponseModel.status?.toLowerCase() ==
              MyStrings.success.toLowerCase()) {
        emailData = profileResponseModel.data?.user?.email ?? '';
        countryData = profileResponseModel.data?.user?.country ?? '';
        countryCodeData = profileResponseModel.data?.user?.countryCode ?? '';
        phoneData = profileResponseModel.data?.user?.mobile ?? '';
        loginType = profileResponseModel.data?.user?.loginBy ?? '';
      } else {
        isLoading = false;
        update();
      }
    } catch (e) {
      isLoading = false;
      update();
    }
    isLoading = false;
    update();
  } // country data

  TextEditingController searchCountryController = TextEditingController();
  bool countryLoading = true;
  List<Countries> countryList = [];
  List<Countries> filteredCountries = [];

  // GET Country Data first
  Future<dynamic> getCountryData() async {
    ResponseModel mainResponse = await profileRepo.getCountryList();

    if (mainResponse.statusCode == 200) {
      countryList.clear();
      CountryModel model =
          CountryModel.fromJson(jsonDecode(mainResponse.responseJson));
      List<Countries>? tempList = model.data?.countries;

      if (tempList != null && tempList.isNotEmpty) {
        countryList.addAll(tempList);
      }

      var selectDefCountry = tempList!.firstWhere(
          (country) =>
              country.countryCode!.toLowerCase() ==
              Environment.defaultCountryCode.toLowerCase(),
          orElse: () => Countries());

      if (selectDefCountry.dialCode != null) {
        selectCountryData(selectDefCountry);
      }
    } else {
      CustomSnackBar.error(errorList: [mainResponse.message]);
    }

    countryLoading = false;
    update();
  }

  Countries selectedCountryData = Countries();
  selectCountryData(Countries value) {
    selectedCountryData = value;
    update();
  }

  bool submitLoading = false;
  updateProfile() async {
    String firstName = firstNameController.text;
    String lastName = lastNameController.text.toString();
    String address = addressController.text.toString();
    String city = cityController.text.toString();
    String zip = zipCodeController.text.toString();
    String state = stateController.text.toString();
    loggerX("model.username");

    submitLoading = true;
    update();

    UserPostModel model = UserPostModel(
      image: null,
      firstname: firstName,
      lastName: lastName,
      mobile: mobileNoController.text,
      email: '',
      username: userNameController.text,
      countryCode: Environment.defaultCountryCode,
      country: Environment.defaultCountry,
      mobileCode: Environment.defaultDialCode,
      address: address,
      state: state,
      zip: zip,
      city: city,
      refer: referController.text,
    );

    AuthorizationResponseModel b =
        await profileRepo.updateProfile(model, false);

    if (b.status == "success") {
      await profileRepo.apiClient.sharedPreferences.setString(
          SharedPreferenceHelper.userFullNameKey, '$firstName $lastName');
      RouteMiddleware.checkNGotoNext(user: b.data?.user);
    } else {
      CustomSnackBar.error(
          errorList: b.message ?? [MyStrings.somethingWentWrong]);
    }

    submitLoading = false;
    update();
  }
}
