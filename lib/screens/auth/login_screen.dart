import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/utils/dimensions.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:fyndr_ng/widgets/custom_textfield.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../routes/routes.dart';
import '../../utils/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsetsGeometry.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height134,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: Dimensions.font10 * 3.2,
                  fontWeight: FontWeight.w700,
                  color: AppColors.color1,
                ),
              ),
              Text(
                'You can login back into your account using your phone number',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: Dimensions.font18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.color1,
                ),
              ),
              SizedBox(height: Dimensions.height40),
              CustomTextField(
                prefixIcon: Padding(
                  padding: EdgeInsets.zero,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: Dimensions.width15),
                      Image.asset(
                        AppConstants.getPngAsset('9ja-flag'),
                        height: Dimensions.height10 * 2.5,
                        width: Dimensions.width10 * 2.5,
                      ),
                      SizedBox(width: Dimensions.width15),
                      Text(
                        '+234',
                        style: TextStyle(
                          color: AppColors.grey4,
                          fontSize: Dimensions.font18,
                        ),
                      ),
                      SizedBox(width: Dimensions.width15),
                      Image.asset(
                        AppConstants.getPngAsset('drop-icon'),
                        width: Dimensions.width15,
                      ),
                      SizedBox(width: Dimensions.width15),
                    ],
                  ),
                ),
                suffixIcon: Icon(Icons.cancel_outlined, color: AppColors.grey4),
                maxLines: 1,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: Dimensions.height20),
              CustomTextField(
                prefixIcon: Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: Dimensions.width15,
                    vertical: Dimensions.height10,
                  ),
                  child: Image.asset(
                    AppConstants.getPngAsset('lock-icon'),
                    height: Dimensions.height10 * 2.5,
                    width: Dimensions.width10 * 2.5,
                  ),
                ),
                suffixIcon: Icon(Icons.visibility, color: AppColors.grey4),
                maxLines: 1,
                hintText: 'Password',
              ),
              SizedBox(height: Dimensions.height15),
              InkWell(
                onTap: (){Get.toNamed(AppRoutes.forgottenPassScreen);},
                child: Text(
                  'Forgot password?',
                  style: TextStyle(color: AppColors.color2),
                ),
              ),
              SizedBox(height: Dimensions.height15),
              CustomButton(text: 'Login', onPressed: (){
                Get.toNamed(AppRoutes.phoneVerificationScreen);
              }),
              SizedBox(height: Dimensions.height15),
              Center(
                child: InkWell(
                  onTap: (){
                    Get.toNamed(AppRoutes.createAccountScreen);
                  },
                  child: Text(
                    'Sign up instead',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.color2),
                  ),
                ),
              ),

              
            ],
          ),
        ),
      ),
    );
  }
}
