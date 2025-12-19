import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:fyndr_ng/utils/dimensions.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';

class CounterOfferSent extends StatefulWidget {
  const CounterOfferSent({super.key});

  @override
  State<CounterOfferSent> createState() => _CounterOfferSentState();
}

class _CounterOfferSentState extends State<CounterOfferSent> {
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
              AppConstants.getPngAsset('counter'),
              height: Dimensions.height100,
            ),
            SizedBox(height: Dimensions.height20),
            Text(
              'Counter Offer Sent',
              style: TextStyle(
                fontSize: Dimensions.font22,
                fontWeight: FontWeight.w600,
                color: AppColors.color1,
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Text(
              'Your counter offer of N10,000 has been sent to ABC Plumbing Co.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Dimensions.font15,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width20,
                vertical: Dimensions.height20,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.color1),
                borderRadius: BorderRadius.circular(Dimensions.radius10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WHAT HAPPENS NEXT?',
                    style: TextStyle(
                      fontSize: Dimensions.font15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.color1,
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  Row(
                    children: [
                      Image.asset(
                        AppConstants.getPngAsset('tick-icon'),
                        height: Dimensions.height30,
                        width: Dimensions.width30,
                      ),
                      SizedBox(width: Dimensions.width20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Counter Offer Sent',
                            style: TextStyle(
                              fontSize: Dimensions.font17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Waiting for provider response',
                            style: TextStyle(
                              fontSize: Dimensions.font14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height10),
                  Divider(color: AppColors.grey3),
                  SizedBox(height: Dimensions.height10),
                  Text(
                    'The provider can:',
                    style: TextStyle(
                      fontSize: Dimensions.font14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: Dimensions.height5),
                  Padding(
                    padding: EdgeInsets.only(left: Dimensions.width20),
                    child: Text(
                      '• Accept your counter offer (N10,000) \n• Decline and keep original (N12,000) \n• Send a new counter offer',
                      style: TextStyle(
                        height: 1.5,
                        fontSize: Dimensions.font14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height5),
                  Text(
                    'You’ll be notified of their response.',
                    style: TextStyle(
                      fontSize: Dimensions.font14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height20),
            CustomButton(text: 'Chat with provider', onPressed: () {}),
            SizedBox(height: Dimensions.height20),
            CustomButton(
              text: 'View job details',
              onPressed: () {
                Get.toNamed(AppRoutes.jobInProgress);
              },
              backgroundColor: AppColors.white,
              borderColor: AppColors.color1,
            ),
          ],
        ),
      ),
    );
  }
}
