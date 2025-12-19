import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:get/get.dart';
import '../../routes/routes.dart';
import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';


class OnboardingScreen extends StatelessWidget {
  final OnboardingController controller = Get.put(OnboardingController());

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: controller.pages.length,
                onPageChanged: controller.onPageChanged,
                itemBuilder: (context, index) {
                  return _buildPageContent(controller.pages[index]);
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                left: Dimensions.width30,
                right: Dimensions.width30,
                bottom: Dimensions.height70,
              ),
              child: Column(
                children: [

                  Obx(() => _buildDotIndicators(controller.pages.length, controller.currentPageIndex.value)),

                  SizedBox(height: Dimensions.height20),

                  CustomButton(
                    text: 'Continue',
                    onPressed: () {
                      Get.toNamed(AppRoutes.getStartedScreen);
                    },
                  ),

                  SizedBox(height: Dimensions.height10),

                  InkWell(
                    onTap: (){Get.toNamed(AppRoutes.loginScreen);},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?'),
                        Text(
                          ' Log in',
                          style: TextStyle(
                            color: AppColors.color2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildPageContent(OnboardingModel page) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: Dimensions.height50 * 2),
        ...page.titleWords.asMap().entries.map((entry) {
          int index = entry.key;
          String word = entry.value;


          Color color = (index == 1 || index == 3)
              ? AppColors.color2
              : AppColors.color1;

          return Text(
            word,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Dimensions.font10 * 3.5,
              fontWeight: FontWeight.w700,
              color: color,
              height: 1.0,
            ),
          );
        }).toList(),

        SizedBox(height: Dimensions.height50 * 1.5),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
          child: Image.asset(AppConstants.getPngAsset(page.imageAssetPath)),
        ),
      ],
    );
  }

  Widget _buildDotIndicators(int count, int currentIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        bool isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: Dimensions.width5 / 2),
          height: Dimensions.height10,
          width: isActive ? Dimensions.width20 : Dimensions.width10,
          decoration: BoxDecoration(
            color: isActive ? AppColors.color2 : AppColors.color1.withOpacity(0.5),
            borderRadius: BorderRadius.circular(Dimensions.height5),
          ),
        );
      }),
    );
  }
}

class OnboardingModel {
  final List<String> titleWords;
  final String imageAssetPath;

  OnboardingModel({required this.titleWords, required this.imageAssetPath});
}

class OnboardingController extends GetxController {
  late final List<OnboardingModel> pages;

  var currentPageIndex = 0.obs;

  late PageController pageController;

  @override
  void onInit() {
    pages = [
      OnboardingModel(
        titleWords: ['Find verified', 'professionals', 'near you'],
        imageAssetPath: 'splash1',
      ),
      OnboardingModel(
        titleWords: ['Connect with', 'customers', 'who need your', 'expertise'],
        imageAssetPath: 'splash2',
      ),
    ];

    pageController = PageController();

    _startAutoScroll();

    super.onInit();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (pageController.hasClients) {
        int nextPageIndex = (currentPageIndex.value + 1) % pages.length;

        pageController.animateToPage(
          nextPageIndex,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  void onPageChanged(int index) {
    currentPageIndex.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}