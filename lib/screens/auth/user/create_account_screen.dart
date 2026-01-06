import 'package:flutter/material.dart';
import 'package:fyndr_ng/controllers/auth_controller.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {

  AuthController authController = Get.find<AuthController>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();


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
                'Create an account',
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
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: Dimensions.width15,
                    vertical: Dimensions.height10,
                  ),
                  child: Image.asset(
                    AppConstants.getPngAsset('person-icon'),
                    height: Dimensions.height10 * 2.5,
                    width: Dimensions.width10 * 2.5,
                  ),
                ),
                maxLines: 1,
                keyboardType: TextInputType.name,
                hintText: 'Full name',
                controller: nameController,
              ),
              SizedBox(height: Dimensions.height20),
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
                hintText: 'Phone number',
                controller: phoneController,
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
                controller: passController,
              ),
              SizedBox(height: Dimensions.height20),
              CustomButton(text: 'Create account', onPressed: () {
                Get.toNamed(AppRoutes.phoneVerificationScreen);
              }),
              SizedBox(height: Dimensions.height15),
              InkWell(
                onTap: (){Get.toNamed(AppRoutes.loginScreen);},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?'),
                    Text(
                      ' Log in',
                      style: TextStyle(
                        color: AppColors.color2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
