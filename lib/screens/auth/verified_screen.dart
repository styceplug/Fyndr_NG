import 'package:flutter/material.dart';
import 'package:fyndr_ng/controllers/auth_controller.dart';
import 'package:fyndr_ng/routes/routes.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:fyndr_ng/utils/dimensions.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:get/get.dart';

class VerifiedScreen extends StatefulWidget {
  const VerifiedScreen({super.key});

  @override
  State<VerifiedScreen> createState() => _VerifiedScreenState();
}

class _VerifiedScreenState extends State<VerifiedScreen> {

  AuthController authController = Get.find<AuthController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        padding: EdgeInsetsGeometry.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: Dimensions.height100),
            Image.asset(
              AppConstants.getPngAsset('verified-icon'),
              height: Dimensions.height100 * 2.5,
            ),
            SizedBox(height: Dimensions.height30),
            Text(
              'Account verified',
              style: TextStyle(
                fontSize: Dimensions.font30,
                fontWeight: FontWeight.w700,
                color: AppColors.color2,
              ),
            ),
            SizedBox(height: Dimensions.height10),
            Text(
              'Congratulations. Let’s get you started!',
              style: TextStyle(fontSize: Dimensions.font16),
            ),
            Spacer(),
            Container(
              width: Dimensions.screenWidth,
              padding: EdgeInsets.symmetric(
                vertical: Dimensions.height20,
                horizontal: Dimensions.width20,
              ),
              decoration: BoxDecoration(
                color: AppColors.color5,
                borderRadius: BorderRadius.circular(Dimensions.radius10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Next steps',
                    style: TextStyle(
                      fontSize: Dimensions.font16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.color2,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: Dimensions.iconSize16 * 0.6,
                        color: AppColors.color2,
                      ),
                      SizedBox(width: Dimensions.width5),
                      Text(
                        'Complete your profile,',
                        style: TextStyle(
                          fontSize: Dimensions.font16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.color2,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: Dimensions.iconSize16 * 0.6,
                        color: AppColors.color2,
                      ),
                      SizedBox(width: Dimensions.width5),
                      Text(
                        'Start requesting services',
                        style: TextStyle(
                          fontSize: Dimensions.font16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.color2,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: Dimensions.iconSize16 * 0.6,
                        color: AppColors.color2,
                      ),
                      SizedBox(width: Dimensions.width5),
                      Text(
                        'Get verified quotes instantly',
                        style: TextStyle(
                          fontSize: Dimensions.font16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.color2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height20),
            CustomButton(text: 'Continue', onPressed: () {
              authController.getUserProfile();
            }),
          ],
        ),
      ),
    );
  }
}
