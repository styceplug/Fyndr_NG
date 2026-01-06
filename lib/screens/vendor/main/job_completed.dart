import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../routes/routes.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/custom_button.dart';

class JobCompleted extends StatefulWidget {
  const JobCompleted({super.key});

  @override
  State<JobCompleted> createState() => _JobCompletedState();
}

class _JobCompletedState extends State<JobCompleted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Image.asset(
              AppConstants.getPngAsset('experience-icon'),
              height: Dimensions.height100,
              width: Dimensions.width100,
            ),
            SizedBox(height: Dimensions.height10),
            Text(
              'Quote Sent',
              style: TextStyle(
                fontSize: Dimensions.font23,
                fontWeight: FontWeight.w700,
                color: AppColors.color1,
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width20,
                vertical: Dimensions.height20,
              ),
              width: Dimensions.screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                border: Border.all(color: AppColors.grey2),
                color: AppColors.info.withOpacity(0.3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Why add to portfolio',
                    style: TextStyle(
                      color: AppColors.info,
                      fontWeight: FontWeight.w400,
                      fontSize: Dimensions.font14,
                    ),
                  ),

                  Text(
                    '• Show potential customers your work\n• Attach to future quotes\n• Build credibility & trust\n• Win more jobs (3x higher success)',
                    style: TextStyle(
                      color: AppColors.info,
                      fontWeight: FontWeight.w400,
                      fontSize: Dimensions.font13,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height20),
            CustomButton(text: 'Add to Portfolio', onPressed: () {
              Get.toNamed(AppRoutes.vendorHomePage);
            }),
            SizedBox(height: Dimensions.height20),
            CustomButton(
              text: 'Skip for me',
              onPressed: () {
                Get.toNamed(AppRoutes.vendorHomePage);
              },
              backgroundColor: AppColors.white,
              borderColor: AppColors.error,
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
