import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../routes/routes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_button.dart';

class CongratulationsVendors extends StatefulWidget {
  const CongratulationsVendors({super.key});

  @override
  State<CongratulationsVendors> createState() => _CongratulationsVendorsState();
}

class _CongratulationsVendorsState extends State<CongratulationsVendors> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(leadingIcon: BackButton(), title: 'Get Verified'),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height20,
        ),
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        child: Column(
          children: [
            Image.asset(
              AppConstants.getPngAsset('genie'),
              height: Dimensions.height12 * 10,
            ),
            SizedBox(height: Dimensions.height10),
            Text(
              'Congratulations',
              style: TextStyle(
                fontSize: Dimensions.font23,
                fontWeight: FontWeight.w700,
                color: AppColors.color1,
              ),
            ),
            SizedBox(height: Dimensions.height5),
            Text(
              'You’re now a RheelTech verified vendors! You can start receiving high-quality leads.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Dimensions.font14,
                fontWeight: FontWeight.w300,
                color: AppColors.grey5,
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'WHATS\'S NEXT',
                style: TextStyle(
                  fontSize: Dimensions.font14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.color1,
                ),
              ),
            ),
            SizedBox(height: Dimensions.height10),
            Row(
              children: [
                Icon(
                  Iconsax.profile_tick5,
                  color: AppColors.grey5,
                  size: Dimensions.iconSize30,
                ),
                SizedBox(width: Dimensions.width10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Complete your profile',
                      style: TextStyle(
                        fontSize: Dimensions.font15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey5,
                      ),
                    ),
                    Text(
                      'Add photos, services, and pricing',
                      style: TextStyle(
                        fontSize: Dimensions.font13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: Dimensions.height15),
            Row(
              children: [
                Icon(
                  Iconsax.verify5,
                  color: AppColors.grey5,
                  size: Dimensions.iconSize30,
                ),
                SizedBox(width: Dimensions.width10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Set your availability',
                      style: TextStyle(
                        fontSize: Dimensions.font15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey5,
                      ),
                    ),
                    Text(
                      'Let customers know when you’re free',
                      style: TextStyle(
                        fontSize: Dimensions.font13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: Dimensions.height15),
            Row(
              children: [
                Image.asset(
                  AppConstants.getPngAsset('reputation'),
                  color: AppColors.grey5,
                  height: Dimensions.height30,
                  width: Dimensions.width30,
                ),
                SizedBox(width: Dimensions.width10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start receiving leads',
                      style: TextStyle(
                        fontSize: Dimensions.font15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey5,
                      ),
                    ),
                    Text(
                      'High quality requests from real customers',
                      style: TextStyle(
                        fontSize: Dimensions.font13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: Dimensions.height20),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Iconsax.information, color: AppColors.info),
                  SizedBox(width: Dimensions.width10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pro Tip',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.info,
                            fontSize: Dimensions.font14,
                          ),
                        ),
                        Text(
                          'Vendors with complete profiles receive 3x more leads!',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.info,
                            fontSize: Dimensions.font13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height20),
            CustomButton(text: 'Complete Profile', onPressed: () {}),
            SizedBox(height: Dimensions.height20),
            CustomButton(
              text: 'Go to Dashboard',
              onPressed: () {
                Get.toNamed(AppRoutes.vendorHomePage);
              },
              backgroundColor: AppColors.white,
              borderColor: AppColors.error,
            ),
          ],
        ),
      ),
    );
  }
}
