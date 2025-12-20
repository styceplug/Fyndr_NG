import 'dart:math';

import 'package:fyndr_ng/screens/auth/create_account_screen.dart';
import 'package:fyndr_ng/screens/auth/forgotten_pass_screen.dart';
import 'package:fyndr_ng/screens/auth/login_screen.dart';
import 'package:fyndr_ng/screens/auth/phone_verification_screen.dart';
import 'package:fyndr_ng/screens/auth/verified_screen.dart';
import 'package:fyndr_ng/screens/home/home_screen.dart';
import 'package:fyndr_ng/screens/home/pages/genie_screen.dart';
import 'package:fyndr_ng/screens/in_app/job_details_screen.dart';
import 'package:fyndr_ng/screens/in_app/job_in_progress.dart';
import 'package:fyndr_ng/screens/in_app/notification_screen.dart';
import 'package:fyndr_ng/screens/in_app/quote_detail_screen.dart';
import 'package:fyndr_ng/screens/in_app/toasts/booking_confirmed.dart';
import 'package:fyndr_ng/screens/in_app/toasts/counter_offer_sent.dart';
import 'package:fyndr_ng/screens/in_app/toasts/rating_screen.dart';
import 'package:fyndr_ng/screens/in_app/toasts/service_completed.dart';
import 'package:fyndr_ng/screens/in_app/toasts/thank_you_screen.dart';
import 'package:fyndr_ng/screens/settings/edit_profile.dart';
import 'package:fyndr_ng/screens/settings/help_center.dart';
import 'package:fyndr_ng/screens/settings/payment_method_screen.dart';
import 'package:fyndr_ng/screens/settings/terms_condition_screen.dart';
import 'package:fyndr_ng/screens/splash_screens/get_started.dart';
import 'package:fyndr_ng/screens/splash_screens/splash_screen.dart';
import 'package:fyndr_ng/screens/vendor/main/%20vendor_profile.dart';
import 'package:fyndr_ng/screens/vendor/main/earnings_screen.dart';
import 'package:fyndr_ng/screens/vendor/main/lead_details.dart';
import 'package:fyndr_ng/screens/vendor/main/leads_screen.dart';
import 'package:fyndr_ng/screens/vendor/main/vendo_home_page.dart';
import 'package:fyndr_ng/screens/vendor/main/vendor_home.dart';
import 'package:fyndr_ng/screens/vendor/main/vendor_jobs.dart';
import 'package:fyndr_ng/screens/vendor/onboard/become_vendor.dart';
import 'package:fyndr_ng/screens/vendor/onboard/business_registration.dart';
import 'package:fyndr_ng/screens/vendor/onboard/congratulations.dart';
import 'package:fyndr_ng/screens/vendor/onboard/get_verified.dart';
import 'package:fyndr_ng/screens/vendor/onboard/loading_screen.dart';
import 'package:fyndr_ng/screens/vendor/onboard/switch_profile.dart';
import 'package:fyndr_ng/screens/vendor/onboard/vendor_completed.dart';
import 'package:fyndr_ng/screens/vendor/onboard/verification_in_progress.dart';
import 'package:get/get.dart';

import '../screens/splash_screens/no_internet_screen.dart';
import '../screens/splash_screens/onboarding_screen.dart';
import '../screens/splash_screens/update_app_screen.dart';

class AppRoutes {
  static const String splashScreen = '/splash-screen';
  static const String onboardingScreen = '/onboarding-screen';
  static const String updateAppScreen = '/update-app-screen';
  static const String noInternetScreen = '/no-internet-screen';
  static const String getStartedScreen = '/get-started-screen';

  //auth
  static const String loginScreen = '/login-screen';
  static const String createAccountScreen = '/create-account-screen';
  static const String phoneVerificationScreen = '/phone-verification-screen';
  static const String verifiedScreen = '/verified-screen';
  static const String forgottenPassScreen = '/forgotten-pass-screen';

  //in-app
  static const String homeScreen = '/home-screen';
  static const String genieAiScreen = '/genie-ai-screen';
  static const String jobDetailsScreen = '/job-details-screen';
  static const String quoteDetailsScreen = '/quote-details-screen';
  static const String bookingConfirmedScreen = '/booking-confirmed-screen';
  static const String counterOfferScreen = '/counter-offer-screen';
  static const String jobInProgress = '/job-in-progress';
  static const String notificationScreen = '/notification-screen';
  static const String ratingScreen = '/rating-screen';
  static const String serviceCompletedScreen = '/service-completed-screen';
  static const String thankYouScreen = '/thank-you-screen';

  //settings
  static const String editProfile = '/edit-profile';
  static const String helpCenter = '/help-center';
  static const String paymentMethod = '/payment-method';
  static const String termsConditionScreen = '/terms-condition-screen';

  //vendor
  static const String vendorHomeScreen = '/vendor-home-screen';
  static const String vendorProfileScreen = '/vendor-profile-screen';
  static const String vendorJobsScreen = '/vendor-jobs-screen';
  static const String vendorEarningsScreen = '/vendor-earnings-screen';
  static const String vendorLeadsScreen = '/vendor-leads-screen';
  static const String vendorLeadDetailsScreen = '/vendor-lead-details-screen';
  static const String vendorGetVerifiedScreen = '/vendor-get-verified-screen';
  static const String vendorCongratulationsScreen = '/vendor-congratulations-screen';
  static const String vendorVerificationInProgressScreen = '/vendor-verification-in-progress-screen';
  static const String becomeVendorScreen = '/become-vendor-screen';
  static const String vendorCompletedScreen = '/vendor-completed-screen';
  static const String vendorRegistrationScreen = '/vendor-registration-screen';
  static const String vendorLoadingScreen = '/vendor-loading-screen';
  static const String switchScreen = '/switch-screen';
  static const String vendorHomePage = '/vendor-home-page';





  static final routes = [

    //vendor
    GetPage(
      name: vendorHomeScreen,
      page: () {
        return VendorHome();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: vendorHomePage,
      page: () {
        return VendorHomePage();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: vendorProfileScreen,
      page: () {
        return VendorProfileScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: vendorJobsScreen,
      page: () => const VendorJobs(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: vendorEarningsScreen,
      page: () => const VendorEarningScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: vendorLeadsScreen,
      page: () => const VendorLeadScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: vendorLeadDetailsScreen,
      page: () => const VendorLeadDetailsScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: vendorGetVerifiedScreen,
      page: () => const GetVerifiedVendors(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: vendorCongratulationsScreen,
      page: () => const CongratulationsVendors(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: vendorVerificationInProgressScreen,
      page: () => const VerificationInProgress(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: becomeVendorScreen,
      page: () => const BecomeVendor(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: vendorCompletedScreen,
      page: () => const VendorCompleted(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: vendorRegistrationScreen,
      page: () => const BusinessRegistration(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: vendorLoadingScreen,
      page: () => const LoadingScreenVendors(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: switchScreen,
      page: () => const SwitchProfile(),
      transition: Transition.fadeIn,
    ),





    //main
    GetPage(
      name: splashScreen,
      page: () {
        return const SplashScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: onboardingScreen,
      page: () {
        return OnboardingScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: updateAppScreen,
      page: () {
        return const UpdateAppScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: noInternetScreen,
      page: () {
        return const NoInternetScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: getStartedScreen,
      page: () {
        return const GetStartedScreen();
      },
      transition: Transition.fadeIn,
    ),

    //auth
    GetPage(
      name: loginScreen,
      page: () {
        return const LoginScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: createAccountScreen,
      page: () {
        return const CreateAccountScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: phoneVerificationScreen,
      page: () {
        return const PhoneVerificationScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: verifiedScreen,
      page: () {
        return const VerifiedScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: homeScreen,
      page: () {
        return const HomeScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: genieAiScreen,
      page: () {
        return const GenieScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: editProfile,
      page: () {
        return const EditProfileScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: helpCenter,
      page: () {
        return const HelpCenter();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: paymentMethod,
      page: () {
        return const PaymentMethodScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: termsConditionScreen,
      page: () {
        return const TermsConditionScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: jobDetailsScreen,
      page: () {
        return const JobDetailsScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: quoteDetailsScreen,
      page: () {
        return const QuoteDetailScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: forgottenPassScreen,
      page: () {
        return const ForgottenPassScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: bookingConfirmedScreen,
      page: () {
        return const BookingConfirmed();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: counterOfferScreen,
      page: () {
        return const CounterOfferSent();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: jobInProgress,
      page: () {
        return const JobInProgress();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: notificationScreen,
      page: () {
        return const NotificationScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: ratingScreen,
      page: () {
        return const RatingScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: serviceCompletedScreen,
      page: () {
        return const ServiceCompleted();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: thankYouScreen,
      page: () {
        return const ThankYouScreen();
      },
      transition: Transition.fadeIn,
    ),
  ];
}
