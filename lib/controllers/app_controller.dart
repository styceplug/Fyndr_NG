import 'package:flutter/material.dart';
import 'package:fyndr_ng/screens/home/pages/browse_screen.dart';
import 'package:fyndr_ng/screens/home/pages/genie_screen.dart';
import 'package:fyndr_ng/screens/home/pages/home_screen.dart';
import 'package:fyndr_ng/screens/home/pages/jobs_screen.dart';
import 'package:fyndr_ng/screens/home/pages/profile_scree.dart';
import 'package:fyndr_ng/screens/vendor/main/vendor_home.dart';

import 'package:get/get.dart';


import '../data/repo/app_repo.dart';
import '../routes/routes.dart';

class AppController extends GetxController {
  final AppRepo appRepo;

  AppController({required this.appRepo});

  Rx<ThemeMode> themeMode = Rx<ThemeMode>(ThemeMode.system);

  var currentAppPage = 0.obs;
  var isFirstTime = false.obs;
  PageController pageController = PageController();



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
    JobsScreen(),
    ProfileScree(),
  ];

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> initializeApp() async {
    print('Initializing....');
    await checkFirstTimeUse();

  }


 /* Future<void> checkLoginAndNavigate() async {
    final loggedIn = authController.userLoggedIn();

    if (isFirstTime.value) {
      Get.offAllNamed(AppRoutes.onboardingScreen);
    } else if (loggedIn) {
      Get.offAllNamed(AppRoutes.homeScreen);
    } else {
      Get.offAllNamed(AppRoutes.splashScreen);
    }
  }*/

  Future<void> checkFirstTimeUse() async {
    final prefs = appRepo.sharedPreferences;
    final seen = prefs.getBool('hasSeenOnboarding') ?? false;

    if (!seen) {
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
}
