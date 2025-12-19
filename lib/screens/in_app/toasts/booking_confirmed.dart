import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:fyndr_ng/utils/dimensions.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../routes/routes.dart';

class BookingConfirmed extends StatefulWidget {
  const BookingConfirmed({super.key});

  @override
  State<BookingConfirmed> createState() => _BookingConfirmedState();
}

class _BookingConfirmedState extends State<BookingConfirmed> {
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppConstants.getPngAsset('calendar-icon'),
              height: Dimensions.height100,
              width: Dimensions.width100,
            ),
            SizedBox(height: Dimensions.height20),
            Text(
              'Booking Confirmed',
              style: TextStyle(
                fontSize: Dimensions.font20,
                fontWeight: FontWeight.w600,
                color: AppColors.color1,
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Text('Your service is confirmed with'),
            Text(
              'ABC Plumbing Co.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: Dimensions.height20),
            Divider(color: AppColors.grey2),
            SizedBox(height: Dimensions.height20),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width20,
                vertical: Dimensions.height20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                border: Border.all(color: AppColors.grey2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Job Details',
                    style: TextStyle(
                      fontSize: Dimensions.font16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.color1,
                    ),
                  ),
                  SizedBox(height: Dimensions.height10),
                  Divider(color: AppColors.grey2),
                  SizedBox(height: Dimensions.height10),
                  Text(
                    'Plumbing Service',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions.font15,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Iconsax.location,
                        size: Dimensions.iconSize16,
                        color: AppColors.grey5,
                      ),
                      SizedBox(width: Dimensions.width5),
                      Text(
                        'Lekki Phase 1, Lagos',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: Dimensions.font14,
                          color: AppColors.grey5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height5),
                  Row(
                    children: [
                      Icon(
                        Iconsax.calendar,
                        size: Dimensions.iconSize16,
                        color: AppColors.grey5,
                      ),
                      SizedBox(width: Dimensions.width5),
                      Text(
                        'Tue, Nov 16 - Afternoon',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: Dimensions.font14,
                          color: AppColors.grey5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Service Amount',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Dimensions.font15,
                        ),
                      ),
                      Text(
                        'N12,000',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Dimensions.font15,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height20),
                  Text(
                    'Pay provider directly after service completion',
                    style: TextStyle(
                      color: AppColors.grey3,
                      fontSize: Dimensions.font12,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height20),
            CustomButton(text: 'Chat with Provider', onPressed: () {}),
            SizedBox(height: Dimensions.height20),
            CustomButton(
              text: 'View Job Details',
              onPressed: () {
                Get.toNamed(AppRoutes.jobInProgress);

              },
              backgroundColor: AppColors.white,
              borderColor: AppColors.color2,
            ),
            SizedBox(height: Dimensions.height20),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width20,
                vertical: Dimensions.height10,
              ),
              width: Dimensions.screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius10),
                border: Border.all(color: AppColors.color2),
                color: AppColors.color5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• Confirmation sent to your phone',
                    style: TextStyle(
                      fontSize: Dimensions.font13,
                      color: AppColors.color1,
                    ),
                  ),
                  SizedBox(height: Dimensions.height5),
                  Text(
                    '• You can now chat with the provider',
                    style: TextStyle(
                      fontSize: Dimensions.font13,
                      color: AppColors.color1,
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
}
