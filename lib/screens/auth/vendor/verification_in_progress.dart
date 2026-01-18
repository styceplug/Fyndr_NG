import 'package:flutter/material.dart';
import 'package:fyndr_ng/controllers/auth_controller.dart';
import 'package:fyndr_ng/helpers/global_loader_controller.dart';
import 'package:fyndr_ng/widgets/custom_appbar.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../routes/routes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';

class VerificationInProgress extends StatefulWidget {
  const VerificationInProgress({super.key});

  @override
  State<VerificationInProgress> createState() => _VerificationInProgressState();
}

class _VerificationInProgressState extends State<VerificationInProgress> {


  GlobalLoaderController loaderController = Get.find<GlobalLoaderController>();
  AuthController authController = Get.find<AuthController>();

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
              AppConstants.getPngAsset('progress'),
              height: Dimensions.height12 * 10,
            ),
            SizedBox(height: Dimensions.height10),
            Text(
              'Verification in progress',
              style: TextStyle(
                fontSize: Dimensions.font23,
                fontWeight: FontWeight.w700,
                color: AppColors.color1,
              ),
            ),
            SizedBox(height: Dimensions.height5),
            Text(
              'We’re reviewing your documents and running background checks. This usually takes 3 - 5 business days',
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
                'VERIFICATION STATUS',
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
                Icon(Iconsax.document_download5, color: AppColors.color2,size: Dimensions.iconSize30),
                SizedBox(width: Dimensions.width10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Documents received',
                      style: TextStyle(
                        fontSize: Dimensions.font15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.color1,
                      ),
                    ),
                    Text(
                      'November 14, 2025',
                      style: TextStyle(
                        fontSize: Dimensions.font13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: Dimensions.height15),
            Row(
              children: [
                Icon(Iconsax.folder_25, color: AppColors.color2,size: Dimensions.iconSize30),
                SizedBox(width: Dimensions.width10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Documents review',
                      style: TextStyle(
                        fontSize: Dimensions.font15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.color2,
                      ),
                    ),
                    Text(
                      'In Progress...',
                      style: TextStyle(
                        fontSize: Dimensions.font13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: Dimensions.height15),
            Row(
              children: [
                Icon(Iconsax.finger_scan4, color: AppColors.grey4,size: Dimensions.iconSize30),
                SizedBox(width: Dimensions.width10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Background check',
                      style: TextStyle(
                        fontSize: Dimensions.font15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey4,
                      ),
                    ),
                    Text(
                      'Pending',
                      style: TextStyle(
                        fontSize: Dimensions.font13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: Dimensions.height15),
            Row(
              children: [
                Image.asset(AppConstants.getPngAsset('reputation'), color: AppColors.grey4,height: Dimensions.height30,width: Dimensions.width30),
                SizedBox(width: Dimensions.width10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Final Appeal',
                      style: TextStyle(
                        fontSize: Dimensions.font15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey4,
                      ),
                    ),
                    Text(
                      'Pending',
                      style: TextStyle(
                        fontSize: Dimensions.font13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey4,
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
                color: AppColors.grey2.withOpacity(0.3),
              ),
              child: Text(
                'We’ll notify you via email and SMS when your verification is complete',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey5,
                  fontSize: Dimensions.font12,
                ),
              ),
            ),
            SizedBox(height: Dimensions.height20),
            CustomButton(text: 'Check Status', onPressed: ()async{
              loaderController.showLoader();
              await authController.getUserProfile();
              loaderController.hideLoader();
              if(authController.userModel != null)
              Get.toNamed(AppRoutes.vendorCongratulationsScreen);
            }),
            SizedBox(height: Dimensions.height20),
            CustomButton(text: 'Contact Support', onPressed: (){},
              backgroundColor: AppColors.white,
              borderColor: AppColors.error,),

          ],
        ),
      ),
    );
  }
}
