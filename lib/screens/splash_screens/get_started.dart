import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:fyndr_ng/utils/dimensions.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:get/get.dart';

import '../../routes/routes.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {

  String selectedOption = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        padding: EdgeInsetsGeometry.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height20,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: Dimensions.height100),

                Text(
                  'Let\'s Get Started',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: Dimensions.font10 * 3.2,
                    fontWeight: FontWeight.w700,
                    color: AppColors.color1,
                  ),
                ),
                Text(
                  'What kind of services would you like us to offer',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: Dimensions.font18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.color1,
                  ),
                ),
                Image.asset(AppConstants.getPngAsset('get-started')),
                Spacer(),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: Dimensions.height100 * 3.5,
                padding: EdgeInsetsGeometry.symmetric(
                  vertical: Dimensions.height20,
                ),
                color: AppColors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'I want to',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: Dimensions.font20 * 1.15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: Dimensions.height15),
                    GestureDetector(
                      onTap: () {
                        setState(() => selectedOption = "find");
                        print("Selected: Find services");
                        Get.toNamed(AppRoutes.createAccountScreen);
                      },
                      child: Container(
                        width: Dimensions.screenWidth,
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.height20,
                          horizontal: Dimensions.width20,
                        ),
                        decoration: BoxDecoration(
                          color: selectedOption == "find" ? AppColors.color2 : AppColors.white,
                          borderRadius: BorderRadius.circular(Dimensions.radius15),
                          border: Border.all(
                            color: selectedOption == "find" ? Colors.transparent : AppColors.color5,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              AppConstants.getPngAsset('search-icon'),
                              height: Dimensions.height30,
                              width: Dimensions.width30,
                            ),
                            SizedBox(width: Dimensions.width20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Request services',
                                  style: TextStyle(
                                    fontSize: Dimensions.font20 * 0.95,
                                    fontWeight: FontWeight.w600,
                                    color: selectedOption == "find" ? AppColors.white : AppColors.color2,
                                  ),
                                ),
                                Text(
                                  'Request quotes from verified \nproviders',
                                  style: TextStyle(
                                    fontSize: Dimensions.font14,
                                    fontWeight: FontWeight.w400,
                                    color: selectedOption == "find" ? AppColors.white : AppColors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height15),
                    GestureDetector(
                      onTap: () {
                        setState(() => selectedOption = "offer");
                        print("Selected: Offer services");
                        Get.toNamed(AppRoutes.vendorRegistrationScreen,arguments: {
                          'isExistingUser': false
                        });
                      },
                      child: Container(
                        width: Dimensions.screenWidth,
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.height20,
                          horizontal: Dimensions.width20,
                        ),
                        decoration: BoxDecoration(
                          color: selectedOption == "offer" ? AppColors.color2 : AppColors.white,
                          borderRadius: BorderRadius.circular(Dimensions.radius15),
                          border: Border.all(
                            color: selectedOption == "offer" ? Colors.transparent : AppColors.color5,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              AppConstants.getPngAsset('offer-icon'),
                              height: Dimensions.height30,
                              width: Dimensions.width30,
                            ),
                            SizedBox(width: Dimensions.width20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Get service Requests',
                                  style: TextStyle(
                                    fontSize: Dimensions.font20 * 0.95,
                                    fontWeight: FontWeight.w600,
                                    color: selectedOption == "offer" ? AppColors.white : AppColors.color2,
                                  ),
                                ),
                                Text(
                                  'Get verified and receive quality leads',
                                  style: TextStyle(
                                    fontSize: Dimensions.font14,
                                    fontWeight: FontWeight.w400,
                                    color: selectedOption == "offer" ? AppColors.white : AppColors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height10),
                    Container(
                      width: Dimensions.screenWidth,
                      padding: EdgeInsetsGeometry.symmetric(
                        vertical: Dimensions.height5,
                      ),
                      decoration: BoxDecoration(color: AppColors.grey1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AppConstants.getPngAsset('info-icon')),
                          SizedBox(width: Dimensions.width5),
                          Text(
                            'You can change this later in settings',
                            style: TextStyle(color: AppColors.grey4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
