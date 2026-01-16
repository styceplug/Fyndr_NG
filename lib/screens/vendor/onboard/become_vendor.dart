import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:fyndr_ng/utils/dimensions.dart';
import 'package:fyndr_ng/widgets/custom_appbar.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';

class BecomeVendor extends StatefulWidget {
  const BecomeVendor({super.key});

  @override
  State<BecomeVendor> createState() => _BecomeVendorState();
}

class _BecomeVendorState extends State<BecomeVendor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(leadingIcon: BackButton(), title: 'Become a Vendor'),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height20,
        ),
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                AppConstants.getPngAsset('kite-icon'),
                height: Dimensions.height100,
                width: Dimensions.width100,
              ),
              // SizedBox(height: Dimensions.height20),
              Text(
                'Start Offering Services',
                style: TextStyle(
                  fontSize: Dimensions.font20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.color1,
                ),
              ),
              Text(
                'Join thousands of verified service providers \nearning on Fyndr',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Dimensions.font14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'WHY BECOME A VENDOR',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: Dimensions.font14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.color1,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    AppConstants.getPngAsset('leads-icon'),
                    height: Dimensions.height30,
                    width: Dimensions.width30,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(width: Dimensions.width10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'High-Quality Leads',
                          style: TextStyle(
                            fontSize: Dimensions.font15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Get matched with  customers actively looking for your services',
                          style: TextStyle(
                            fontSize: Dimensions.font13,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    AppConstants.getPngAsset('secure'),
                    height: Dimensions.height30,
                    width: Dimensions.width30,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(width: Dimensions.width10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Secure Payment',
                              style: TextStyle(
                                fontSize: Dimensions.font15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: Dimensions.width20),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.width10,
                                vertical: Dimensions.height5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.color5,
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radius20,
                                ),
                              ),
                              child: Text(
                                'Coming soon',
                                style: TextStyle(
                                  fontSize: Dimensions.font12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.color1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Money held in escrow until job completion',
                          style: TextStyle(
                            fontSize: Dimensions.font13,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    AppConstants.getPngAsset('reputation'),
                    height: Dimensions.height30,
                    width: Dimensions.width30,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(width: Dimensions.width10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Build your Reputation',
                          style: TextStyle(
                            fontSize: Dimensions.font15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Get verified, earn reviews, grow your business',
                          style: TextStyle(
                            fontSize: Dimensions.font13,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    AppConstants.getPngAsset('schedule'),
                    height: Dimensions.height30,
                    width: Dimensions.width30,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(width: Dimensions.width10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Flexible Schedule',
                          style: TextStyle(
                            fontSize: Dimensions.font15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Choose which jobs to accept and when to work',
                          style: TextStyle(
                            fontSize: Dimensions.font13,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height15),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height20,
                ),
                width: Dimensions.screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  border: Border.all(color: AppColors.grey2),
                  color: AppColors.grey3.withOpacity(0.4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What you will need:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: Dimensions.height10),
                    Text(
                      '• Business/service details\n• Valid ID for verification\n• Bank account information\n• Portfolio/past work (optional)',
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height20),
              CustomButton(text: 'Register as a vendor', onPressed: () {
                Get.toNamed(AppRoutes.vendorLoadingScreen);
              }),
              SizedBox(height: Dimensions.height20),
              CustomButton(
                text: 'Maybe Later',
                onPressed: () {
                  Get.back();
                },
                backgroundColor: AppColors.white,
                borderColor: AppColors.color1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
