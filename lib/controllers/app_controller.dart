import 'package:flutter/material.dart';
import 'package:fyndr_ng/controllers/auth_controller.dart';
import 'package:fyndr_ng/data/api/api_checker.dart';
import 'package:fyndr_ng/data/api/api_client.dart';
import 'package:fyndr_ng/screens/home/pages/browse_screen.dart';
import 'package:fyndr_ng/screens/home/pages/genie_screen.dart';
import 'package:fyndr_ng/screens/home/pages/home_screen.dart';
import 'package:fyndr_ng/screens/home/pages/jobs_screen.dart';
import 'package:fyndr_ng/screens/home/pages/profile_scree.dart';
import 'package:fyndr_ng/screens/vendor/main/%20vendor_profile.dart';
import 'package:fyndr_ng/screens/vendor/main/vendor_home.dart';
import 'package:fyndr_ng/screens/vendor/main/vendor_jobs.dart';
import 'package:fyndr_ng/utils/app_constants.dart';

import 'package:get/get.dart';


import '../data/repo/app_repo.dart';
import '../routes/routes.dart';

class AppController extends GetxController {
  final AppRepo appRepo;

  AppController({required this.appRepo, required this.apiClient, required this.apiChecker});

  Rx<ThemeMode> themeMode = Rx<ThemeMode>(ThemeMode.system);

  var currentAppPage = 0.obs;
  var isFirstTime = false.obs;
  PageController pageController = PageController();
  AuthController authController = Get.find<AuthController>();
  ApiClient apiClient;
  ApiChecker apiChecker;



  final List<Widget> pages = [
    HomePage(),
    BrowseScreen(),
    GenieScreen(),
    JobsScreen(),
    ProfileScree(),
  ];
  final List<Widget> vendorPages = [
    VendorHome(),
    BrowseScreen(),
    GenieScreen(),
    VendorJobs(),
    VendorProfileScreen(),
  ];

  @override
  void onInit() {
    super.onInit();
    // initializeApp();
  }

  Future<void> initializeApp() async {
    print('Initializing App...');

    await checkFirstTimeUse();

    if (isFirstTime.value) {
      print("First time user -> Onboarding");
      Get.offAllNamed(AppRoutes.onboardingScreen);
      return;
    }

    String? token = appRepo.sharedPreferences.getString(AppConstants.authToken);

    if (token != null && token.isNotEmpty) {
      print("Token found. Verifying session...");

      authController.apiClient.updateHeader(token);

      await authController.getUserProfile();

    } else {
      print("No token found -> Get Started");
      Get.offAllNamed(AppRoutes.getStartedScreen);
    }
  }

  Future<void> checkFirstTimeUse() async {
    final prefs = appRepo.sharedPreferences;
    bool hasSeen = prefs.getBool('hasSeenOnboarding') ?? false;

    if (!hasSeen) {
      isFirstTime.value = true;
      await prefs.setBool('hasSeenOnboarding', true);
    } else {
      isFirstTime.value = false;
    }
  }

  void changeCurrentAppPage(int page, {bool movePage = true}) {
    currentAppPage.value = page;

    if (movePage) {
      if (pageController.hasClients) {
        pageController.animateToPage(
          page,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        );
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (pageController.hasClients) {
            pageController.animateToPage(
              page,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    }

    update();
  }

  void clearSharedData() {
    appRepo.sharedPreferences.remove(AppConstants.authToken);
    apiClient.token = '';
    apiClient.updateHeader('');
    Get.offAllNamed(AppRoutes.getStartedScreen);
  }


}
