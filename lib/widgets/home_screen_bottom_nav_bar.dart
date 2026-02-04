import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fyndr_ng/routes/routes.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:fyndr_ng/widgets/snackbars.dart';
import 'package:get/get.dart';

import '../controllers/app_controller.dart';
import '../utils/dimensions.dart';
import 'bottom_bar_item.dart';

class HomeScreenBottomNavBar extends StatelessWidget {
  const HomeScreenBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    AppController appController = Get.find<AppController>();

    return Obx(
          () => SizedBox(
        height: Dimensions.height10 * 8.7,
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.radius30),
                topRight: Radius.circular(Dimensions.radius30),
              ),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.only(
                  bottom: Dimensions.height30,
                  left: Dimensions.width20,
                  right: Dimensions.width20,
                  top: Dimensions.height15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BottomBarItem(
                      name: 'Home',
                      image: 'home-icon',
                      isActive: appController.currentAppPage.value == 0,
                      onClick: () => appController.changeCurrentAppPage(0),
                    ),
                    BottomBarItem(
                      name: 'Declutter',
                      image: 'browse-icon',
                      isActive: appController.currentAppPage.value == 1,
                      onClick: () => appController.changeCurrentAppPage(1),
                    ),

                    SizedBox(width: Dimensions.width10 * 7),

                    BottomBarItem(
                      name: 'My jobs',
                      image: 'jobs-icon',
                      isActive: appController.currentAppPage.value == 3,
                      onClick: () => appController.changeCurrentAppPage(3),
                    ),
                    BottomBarItem(
                      name: 'Profile',
                      image: 'profile-icon',
                      isActive: appController.currentAppPage.value == 4,
                      onClick: () => appController.changeCurrentAppPage(4),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              bottom: Dimensions.height30,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    CustomSnackBar.processing(message: 'Genie AI, Coming Soon');
                  },
                  customBorder: const CircleBorder(),
                  child: Container(
                    padding: EdgeInsets.all(Dimensions.height5),
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Floating Icon
                        Image.asset(
                          AppConstants.getPngAsset('genie-icon'),
                          height: Dimensions.height10 * 6, // Added explicit height to prevent layout jumps
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: Dimensions.height5),
                        Text(
                          'Genie AI',
                          style: TextStyle(
                            color: AppColors.color2,
                            fontSize: Dimensions.font12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VendorBottomNavBar extends StatelessWidget {
  const VendorBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    AppController appController = Get.find<AppController>();

    return Obx(
          () => SizedBox(
        height: Dimensions.height10 * 9,
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.radius30),
                topRight: Radius.circular(Dimensions.radius30),
              ),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.only(
                  bottom: Dimensions.height30,
                  left: Dimensions.width20,
                  right: Dimensions.width20,
                  top: Dimensions.height15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BottomBarItem(
                      name: 'Home',
                      image: 'home-icon',
                      isActive: appController.currentAppPage.value == 0,
                      onClick: () => appController.changeCurrentAppPage(0),
                    ),
                    BottomBarItem(
                      name: 'Market',
                      image: 'browse-icon',
                      isActive: appController.currentAppPage.value == 1,
                      onClick: () => appController.changeCurrentAppPage(1),
                    ),

                    SizedBox(width: Dimensions.width10 * 5),

                    BottomBarItem(
                      name: 'My jobs',
                      image: 'jobs-icon',
                      isActive: appController.currentAppPage.value == 3,
                      onClick: () => appController.changeCurrentAppPage(3),
                    ),
                    BottomBarItem(
                      name: 'Profile',
                      image: 'profile-icon',
                      isActive: appController.currentAppPage.value == 4,
                      onClick: () => appController.changeCurrentAppPage(4),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              bottom: Dimensions.height30,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    CustomSnackBar.processing(message: 'Coming Soon');
                  },
                  customBorder: const CircleBorder(),
                  child: Container(
                    padding: EdgeInsets.all(Dimensions.height5),
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Floating Icon
                        Image.asset(
                          AppConstants.getPngAsset('genie-icon'),
                          height: Dimensions.height10 * 6, // Added explicit height to prevent layout jumps
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: Dimensions.height5),
                        Text(
                          'Genie AI',
                          style: TextStyle(
                            color: AppColors.color2,
                            fontSize: Dimensions.font12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
