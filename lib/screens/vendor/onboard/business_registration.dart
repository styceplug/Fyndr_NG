import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:fyndr_ng/widgets/custom_appbar.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:fyndr_ng/widgets/custom_textfield.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';
import '../../../utils/dimensions.dart';

class BusinessRegistration extends StatefulWidget {
  const BusinessRegistration({super.key});

  @override
  State<BusinessRegistration> createState() => _BusinessRegistrationState();
}

class _BusinessRegistrationState extends State<BusinessRegistration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        leadingIcon: BackButton(),
        title: 'Business Registration',
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height20,
        ),
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                AppConstants.getPngAsset('approved'),
                height: Dimensions.height12 * 10,
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                'Register your business',
                style: TextStyle(
                  fontSize: Dimensions.font22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.color1,
                ),
              ),
              Text(
                'Join verified service providers on Fynder',
                style: TextStyle(
                  fontSize: Dimensions.font14,
                  fontWeight: FontWeight.w300,
                  color: AppColors.grey5,
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  'Business Information',
                  style: TextStyle(
                    fontSize: Dimensions.font18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10),
              CustomTextField(
                hintText: 'Business name',
                fillColor: AppColors.grey3.withOpacity(0.3),
              ),
              SizedBox(height: Dimensions.height20),
              CustomTextField(
                hintText: 'Business Reg. Number (Optional)',
                fillColor: AppColors.grey3.withOpacity(0.3),
              ),
              SizedBox(height: Dimensions.height20),
              CustomTextField(
                hintText: 'Business type',
                fillColor: AppColors.grey3.withOpacity(0.3),
              ),
              SizedBox(height: Dimensions.height20),
              CustomTextField(
                hintText: 'Year Established',
                fillColor: AppColors.grey3.withOpacity(0.3),
              ),
              SizedBox(height: Dimensions.height20),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  'Owner Information',
                  style: TextStyle(
                    fontSize: Dimensions.font18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10),
              CustomTextField(
                hintText: 'Full name',
                fillColor: AppColors.grey3.withOpacity(0.3),
              ),
              SizedBox(height: Dimensions.height20),
              CustomTextField(
                hintText: 'Phone number',
                fillColor: AppColors.grey3.withOpacity(0.3),
              ),
              SizedBox(height: Dimensions.height20),
              CustomTextField(
                hintText: 'Email address',
                fillColor: AppColors.grey3.withOpacity(0.3),
              ),
              SizedBox(height: Dimensions.height20),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  'Service Offered',
                  style: TextStyle(
                    fontSize: Dimensions.font18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height100),
              SizedBox(height: Dimensions.height20),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  'Business Location',
                  style: TextStyle(
                    fontSize: Dimensions.font18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10),
              CustomTextField(
                hintText: 'Street address',
                fillColor: AppColors.grey3.withOpacity(0.3),
              ),
              SizedBox(height: Dimensions.height20),
              CustomTextField(
                hintText: 'City/State',
                fillColor: AppColors.grey3.withOpacity(0.3),
              ),
              SizedBox(height: Dimensions.height20),
              CustomTextField(
                hintText: 'Local Govt. Area',
                fillColor: AppColors.grey3.withOpacity(0.3),
              ),
              SizedBox(height: Dimensions.height20),
              CustomButton(text: 'Continue to verification', onPressed: (){
                Get.toNamed(AppRoutes.vendorGetVerifiedScreen);
              }),
              SizedBox(height: Dimensions.height100),


            ],
          ),
        ),
      ),
    );
  }
}
