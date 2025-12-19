import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:fyndr_ng/widgets/custom_appbar.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';
import '../../../utils/dimensions.dart';

class ServiceCompleted extends StatefulWidget {
  const ServiceCompleted({super.key});

  @override
  State<ServiceCompleted> createState() => _ServiceCompletedState();
}

class _ServiceCompletedState extends State<ServiceCompleted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(leadingIcon: BackButton(), title: 'Job Details'),
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
              AppConstants.getPngAsset('service-complete'),
              height: Dimensions.height100,
              width: Dimensions.width100,
            ),
            SizedBox(height: Dimensions.height10),
            Text(
              'Service Completed?',
              style: TextStyle(
                fontSize: Dimensions.font20,
                fontWeight: FontWeight.w600,
                color: AppColors.color1,
              ),
            ),
            SizedBox(height: Dimensions.height5),
            Text(
              'Confirm the Plumbing service has been \ncompleted to your satisfaction',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Dimensions.font14,
                fontWeight: FontWeight.w400,
                color: AppColors.grey5,
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Text(
                'PAYMENT DUE',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: Dimensions.font14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.color1,
                ),
              ),
            ),
            SizedBox(height: Dimensions.height10),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width20,
                vertical: Dimensions.height20,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey2),
                borderRadius: BorderRadius.circular(Dimensions.radius15),
              ),
              child: Column(
                children: [
                  Text(
                    'N12,000',
                    style: TextStyle(
                      fontSize: Dimensions.font30,
                      fontWeight: FontWeight.w600,
                      color: AppColors.color1,
                    ),
                  ),
                  SizedBox(height: Dimensions.height5),
                  Text(
                    'Pay provider directly',
                    style: TextStyle(
                      fontSize: Dimensions.font13,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: Dimensions.height10),
                  Divider(color: AppColors.grey2),
                  SizedBox(height: Dimensions.height10),
                  Text(
                    'Pay provider directly in cash or transfer after service completion',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Dimensions.font13,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height20),
            CustomButton(text: 'Confirm completion & Rate', onPressed: () {
              Get.toNamed(AppRoutes.ratingScreen);
            }),
            SizedBox(height: Dimensions.height20),
            CustomButton(
              text: 'Report an issue',
              onPressed: () {},
              backgroundColor: AppColors.white,
              borderColor: AppColors.black,
            ),
          ],
        ),
      ),
    );
  }
}
