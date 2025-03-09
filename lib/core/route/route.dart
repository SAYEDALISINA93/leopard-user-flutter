import 'package:leoparduser/presentation/screens/Profile/profile_screen.dart';

import 'package:leoparduser/presentation/screens/account/change-password/change_password_screen.dart';

import 'package:leoparduser/presentation/screens/auth/email_verification_page/email_verification_screen.dart';

import 'package:leoparduser/presentation/screens/auth/forget_password/forget_password/forget_password.dart';

import 'package:leoparduser/presentation/screens/auth/forget_password/reset_password/reset_password_screen.dart';

import 'package:leoparduser/presentation/screens/auth/forget_password/verify_forget_password/verify_forget_password_screen.dart';

import 'package:leoparduser/presentation/screens/auth/login/login_screen.dart';

import 'package:leoparduser/presentation/screens/auth/profile_complete/profile_complete_screen.dart';
import 'package:leoparduser/presentation/screens/auth/registration/phone_registration_screen.dart';

import 'package:leoparduser/presentation/screens/auth/registration/registration_screen.dart';
import 'package:leoparduser/presentation/screens/auth/sms_verification_page/otp_verification_screen.dart';

import 'package:leoparduser/presentation/screens/auth/sms_verification_page/sms_verification_screen.dart';
import 'package:leoparduser/presentation/screens/dashboard/dashboard_screen.dart';

import 'package:leoparduser/presentation/screens/edit_profile/edit_profile_screen.dart';

import 'package:leoparduser/presentation/screens/faq/faq_screen.dart';
import 'package:leoparduser/presentation/screens/image_preview/preview_image_screen.dart';
import 'package:leoparduser/presentation/screens/inbox/ride_message_screen.dart';

import 'package:leoparduser/presentation/screens/inter_city/inter_city_screen.dart';

import 'package:leoparduser/presentation/screens/language/language_screen.dart';
import 'package:leoparduser/presentation/screens/location/screen/locationpicker/location_picker_screen.dart';

import 'package:leoparduser/presentation/screens/location/screen/ride_details_screen.dart';
import 'package:leoparduser/presentation/screens/maintenance/maintanance_screen.dart';

import 'package:leoparduser/presentation/screens/onbaord/onboard_intro_screen.dart';

import 'package:leoparduser/presentation/screens/coupon/coupon_screen.dart';

import 'package:leoparduser/presentation/screens/payment/payment_screen.dart';

import 'package:leoparduser/presentation/screens/privacy_policy/privacy_policy_screen.dart';
import 'package:leoparduser/presentation/screens/profile_and_settings/profile_and_settings_screen.dart';

import 'package:leoparduser/presentation/screens/referral_a_friends/referral_a_friends_screen.dart';
import 'package:leoparduser/presentation/screens/review/review_history_screen.dart';
import 'package:leoparduser/presentation/screens/review/user_review_history_screen.dart';

import 'package:leoparduser/presentation/screens/ride/ride_screen.dart';

import 'package:leoparduser/presentation/screens/ride_bid_list/ride_bid_list_screen.dart';

import 'package:leoparduser/presentation/screens/splash/splash_screen.dart';

import 'package:leoparduser/presentation/screens/ticket/new_ticket_screen/add_new_ticket_screen.dart';

import 'package:leoparduser/presentation/screens/ticket/support_ticket_screen.dart';

import 'package:leoparduser/presentation/screens/ticket/ticket_details/ticket_details_screen.dart';

import 'package:leoparduser/presentation/screens/payment_history/payments_history_screen.dart';

import 'package:get/get.dart';

import 'package:leoparduser/presentation/screens/web_view/web_view_screen.dart';

class RouteHelper {
  static const String splashScreen = "/splash_screen";

  static const String onboardScreen = "/onboard_screen";

  static const String loginScreen = "/login_screen";

  static const String languageScreen = "/language_screen";

  static const String forgotPasswordScreen = "/forgot_password_screen";

  static const String changePasswordScreen = "/change_password_screen";

  static const String registrationScreen = "/registration_screen";

  static const String phoneRegistrationScreen = "/phone_registration_screen";

  static const String addMoneyHistoryScreen = "/add_money_history_screen";

  static const String profileCompleteScreen = "/profile_complete_screen";

  static const String emailVerificationScreen = "/verify_email_screen";

  static const String smsVerificationScreen = "/verify_sms_screen";

  static const otpVerificationScreen = "/otp_verification_screen";

  static const String verifyPassCodeScreen = "/verify_pass_code_screen";

  static const String resetPasswordScreen = "/reset_pass_screen";

  static const String paymentHistoryScreen = "/payment_history_screen";

  static const String notificationScreen = "/notification_screen";

  static const String profileScreen = "/profile_screen";

  static const String profileAndSettingsScreen = "/profile_and_settings_screen";

  static const String editProfileScreen = "/edit_profile_screen";

  static const String privacyScreen = "/privacy-screen";

  static const String dashboard = "/dashboard_screen";

  static const String homeScreen = '/home_Screen';

  static const String interCityScreen = '/inter_city_Screen';

  static const String rideScreen = '/ride_Screen';

  static const String rideBidScreen = '/ride_bid_Screen';

  static const String paymentScreen = '/payment_Screen';

  static const String couponScreen = '/coupon_Screen';

  static const String referralAFriendsScreen = '/referral_a_friends_screen';

  static const String rideMessageScreen = '/inbox_message_screen';

  static const String locationPickUpScreen = '/location_pickup_screen';

  static const String rideDetailsScreen = '/ride_details_screen';

  static const String webViewScreen = '/my_web_view_screen';

  static const String faqScreen = '/faq_screen';

  static const String supportTicketScreen = '/support_ticket_screen';

  static const String createSupportTicketScreen =
      '/create_support_ticket_screen';

  static const String supportTicketDetailsScreen =
      '/support_ticket_details_screen';

  static const String previewImageScreen = '/preview_image_screen';

  static const String maintenanceScreen = '/maintenance_screen';

  static const String driverReviewScreen = '/driver_review_screen';

  static const String myReviewScreen = '/my_review_screen';

  List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),

    GetPage(name: onboardScreen, page: () => const OnBoardIntroScreen()),

    GetPage(name: loginScreen, page: () => const LoginScreen()),

    GetPage(
        name: forgotPasswordScreen, page: () => const ForgetPasswordScreen()),

    GetPage(
        name: changePasswordScreen, page: () => const ChangePasswordScreen()),

    GetPage(name: registrationScreen, page: () => const RegistrationScreen()),

    GetPage(
        name: phoneRegistrationScreen,
        page: () => const PhoneRegistrationScreen()),

    GetPage(
        name: otpVerificationScreen,
        page: () => OTPVerificationScreen(
              phoneNumber: Get.arguments['phoneNumber'],
              countryCode: Get.arguments['countryCode'],
              verificationId: Get.arguments['verificationId'],
            )),

    GetPage(
        name: profileCompleteScreen, page: () => const ProfileCompleteScreen()),

    GetPage(
        name: dashboard,
        page: () => const DashBoardScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300)),

    GetPage(
        name: rideScreen,
        page: () => const RideScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300)),

    GetPage(
        name: rideDetailsScreen,
        page: () => RideDetailsScreen(rideId: Get.arguments)),

    GetPage(
        name: rideMessageScreen, page: () => RideMessageScreen(rideID: '-1')),

    GetPage(
        name: interCityScreen,
        page: () => const InterCityScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300)),

    GetPage(
        name: rideBidScreen,
        page: () => const RideBidListScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300)),

    GetPage(
        name: paymentScreen,
        page: () => const PaymentScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300)),

    GetPage(
        name: couponScreen,
        page: () => const CouponScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300)),

    GetPage(
        name: driverReviewScreen,
        page: () => ReviewHistoryScreen(driverId: Get.arguments)),
    GetPage(
        name: myReviewScreen,
        page: () => UserReviewHistoryScreen(avgRating: Get.arguments)),

    GetPage(
        name: referralAFriendsScreen,
        page: () => const ReferralAFriendsScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300)),

    GetPage(
        name: webViewScreen,
        page: () => MyWebViewScreen(url: Get.arguments),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300)),
    //
    GetPage(name: profileScreen, page: () => const ProfileScreen()),

    GetPage(name: editProfileScreen, page: () => const EditProfileScreen()),

    GetPage(
        name: profileAndSettingsScreen,
        page: () => const ProfileAndSettingsScreen(
              showBackBtn: true,
            ),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300)),
    //Location
    GetPage(
        name: locationPickUpScreen,
        page: () =>
            LocationPickerScreen(pickupLocationForIndex: Get.arguments[0])),

    GetPage(
        name: paymentHistoryScreen, page: () => const PaymentHistoryScreen()),

    GetPage(
        name: emailVerificationScreen,
        page: () => EmailVerificationScreen(
            needSmsVerification: Get.arguments[0],
            isProfileCompleteEnabled: Get.arguments[1],
            needTwoFactor: Get.arguments[2])),

    GetPage(
        name: smsVerificationScreen, page: () => const SmsVerificationScreen()),

    GetPage(
        name: verifyPassCodeScreen, page: () => const VerifyForgetPassScreen()),

    GetPage(name: resetPasswordScreen, page: () => const ResetPasswordScreen()),

    GetPage(name: privacyScreen, page: () => const PrivacyPolicyScreen()),

    GetPage(name: languageScreen, page: () => const LanguageScreen()),

    GetPage(name: faqScreen, page: () => const FaqScreen()),
    //support
    GetPage(
        name: createSupportTicketScreen,
        page: () => const AddNewTicketScreen()),

    GetPage(name: supportTicketScreen, page: () => const SupportTicketScreen()),

    GetPage(
        name: supportTicketDetailsScreen,
        page: () => const TicketDetailsScreen()),

    GetPage(
        name: previewImageScreen,
        page: () => PreviewImageScreen(url: Get.arguments)),

    GetPage(name: maintenanceScreen, page: () => MaintenanceScreen()),
  ];
}

/**
 
========NEW_RIDE=============================================
  NEW_BID  -> ride_bid_Screen-(rideId)
  ACCEPT_RIDE -> ride_details_screen->(rideId)
  BID_REJECT -> ride_bid_Screen-(rideId) 
  START_RIDE  -> ride_details_screen->(rideId)
  CANCEL_RIDE -> dashboard_screen-(rideId/empty/0)
  COMPLETE_RIDE -> dashboard_screen->(rideId/empty/0)
  COMPLETE_RIDE_PAYMENT -> ride_details_screen->(rideId)
  RECEIVE_RIDE_PAYMENT -> ride_details_screen->(rideId)
  PROMOTIONAL_NOTIFY -> null
================================================================ 

 */
