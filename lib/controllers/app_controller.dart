import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fyndr_ng/controllers/auth_controller.dart';
import 'package:fyndr_ng/controllers/product_controller.dart';
import 'package:fyndr_ng/data/api/api_checker.dart';
import 'package:fyndr_ng/data/api/api_client.dart';
import 'package:fyndr_ng/helpers/global_loader_controller.dart';
import 'package:fyndr_ng/screens/home/pages/browse_screen.dart';
import 'package:fyndr_ng/screens/home/pages/genie_screen.dart';
import 'package:fyndr_ng/screens/home/pages/home_screen.dart';
import 'package:fyndr_ng/screens/home/pages/jobs_screen.dart';
import 'package:fyndr_ng/screens/home/pages/profile_scree.dart';
import 'package:fyndr_ng/screens/vendor/main/%20vendor_profile.dart';
import 'package:fyndr_ng/screens/vendor/main/vendor_home.dart';
import 'package:fyndr_ng/screens/vendor/main/vendor_jobs.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


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
  ProductController productController = Get.find<ProductController>();
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
      await productController.getProducts();
      await authController.getUserProfile();
      String? firebaseToken = await FirebaseMessaging.instance.getToken();
      if (firebaseToken != null) {
        await saveDeviceToken(firebaseToken);
      }

    } else {
      print("No token found -> Get Started");
      Get.offAllNamed(AppRoutes.getStartedScreen);
    }
  }

  Future<void> saveDeviceToken(String token) async {
    String platform = Platform.isAndroid ? 'android' : 'ios';

    print("🔔 Updating Device Token: $platform");

    Response response = await appRepo.updateDeviceToken(token, platform);

    if (response.statusCode == 200) {
      print("✅ Device Token Updated Successfully");
    } else {
      print("⚠️ Failed to update token: ${response.body}");
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
    changeCurrentAppPage(0);
    appRepo.sharedPreferences.remove(AppConstants.authToken);
    apiClient.token = '';
    apiClient.updateHeader('');
    Get.offAllNamed(AppRoutes.getStartedScreen);
  }
}
