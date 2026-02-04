import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/custom_button.dart';

class QuoteSentScreen extends StatefulWidget {
  const QuoteSentScreen({super.key});

  @override
  State<QuoteSentScreen> createState() => _QuoteSentScreenState();
}

class _QuoteSentScreenState extends State<QuoteSentScreen> {
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
              'Quote Sent Successfully',
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
                    'What happens next?',
                    style: TextStyle(
                      color: AppColors.info,
                      fontWeight: FontWeight.w400,
                      fontSize: Dimensions.font14,
                    ),
                  ),
                  SizedBox(height: 8), // Added for spacing
                  Text(
                    '• Customer reviews your quote & portfolio\n• They contact you to discuss details\n• You negotiate & finalize terms\n• Complete the job successfully\n• Get paid & rated',
                    style: TextStyle(
                      color: AppColors.info,
                      fontWeight: FontWeight.w400,
                      fontSize: Dimensions.font13,
                      height: 1.5, // Improves readability for multi-line text
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height20),
            CustomButton(
              text: 'Go Home',
              onPressed: () {

                FocusManager.instance.primaryFocus?.unfocus();

                Get.offAllNamed(AppRoutes.vendorHomePage);
              },
            ),

            Spacer(),
          ],
        ),
      ),
    );

  }
}
