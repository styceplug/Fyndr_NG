import 'package:flutter/material.dart';
import 'package:fyndr_ng/controllers/app_controller.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../routes/routes.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';

class ThankYouScreen extends StatefulWidget {
  const ThankYouScreen({super.key});

  @override
  State<ThankYouScreen> createState() => _ThankYouScreenState();
}

class _ThankYouScreenState extends State<ThankYouScreen> {
  AppController appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        padding: EdgeInsets.fromLTRB(
          Dimensions.width20,
          Dimensions.height100,
          Dimensions.width20,
          Dimensions.height70,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppConstants.getPngAsset('genie')),
            SizedBox(height: Dimensions.height10),
            Text(
              'Thank you!',
              style: TextStyle(
                fontSize: Dimensions.font20,
                fontWeight: FontWeight.w600,
                color: AppColors.color1,
              ),
            ),
            SizedBox(height: Dimensions.height5),
            Text(
              'Your rating has been submitted.\nIt helps other customers find great providers!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Dimensions.font14,
                fontWeight: FontWeight.w400,
                color: AppColors.grey5,
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Divider(color: AppColors.grey2),
            SizedBox(height: Dimensions.height20),
            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Text(
                'YOUR RATING',
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
                  Row(
                    children: [
                      Container(
                        height: Dimensions.height70,
                        width: Dimensions.width70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.grey2,
                        ),
                      ),
                      SizedBox(width: Dimensions.width20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ABC Plumbing Co.'),
                          SizedBox(height: Dimensions.height5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.star,
                                color: AppColors.color2,
                                size: Dimensions.iconSize16,
                              ),
                              SizedBox(width: Dimensions.width5),
                              Text(
                                '4.5',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height15),
                  Divider(color: AppColors.grey2),
                  SizedBox(height: Dimensions.height15),
                  Text(
                    '• Pay provider directly in cash or transfer after \n   service completion',
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height20),
            CustomButton(text: 'Back to home', onPressed: () {
              Get.offAllNamed(AppRoutes.homeScreen);
              appController.changeCurrentAppPage(0);
            }),
            SizedBox(height: Dimensions.height20),
            CustomButton(
              text: 'View job history',
              onPressed: () {},
              borderColor: AppColors.black,
              backgroundColor: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }
}
