import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/dimensions.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:get/get.dart';

import '../../routes/routes.dart';
import '../../utils/colors.dart';
import '../../widgets/custom_textfield.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsetsGeometry.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height20,
        ),
        child: Column(
          children: [
            SizedBox(height: Dimensions.height100),
            Text(
              'Let’s verify your phone number',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: Dimensions.font10 * 3.2,
                fontWeight: FontWeight.w700,
                color: AppColors.color1,
              ),
            ),
            Text(
              'Please enter the 4 digit code sent to +234 812 345 6789. Change number',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: Dimensions.font18,
                fontWeight: FontWeight.w400,
                color: AppColors.color1,
              ),
            ),
            SizedBox(height: Dimensions.height40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(width: Dimensions.width70),
                Expanded(
                  child: CustomTextField(
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    hintText: '-',
                  ),
                ),
                SizedBox(width: Dimensions.width20),
                Expanded(
                  child: CustomTextField(
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    hintText: '-',
                  ),
                ),
                SizedBox(width: Dimensions.width20),
                Expanded(
                  child: CustomTextField(
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    hintText: '-',
                  ),
                ),
                SizedBox(width: Dimensions.width20),
                Expanded(
                  child: CustomTextField(
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    hintText: '-',
                  ),
                ),
                SizedBox(width: Dimensions.width70),

              ],
            ),
            SizedBox(height: Dimensions.height40),
            CustomButton(text: 'Verify', onPressed: (){
              Get.toNamed(AppRoutes.verifiedScreen);
            }),
            SizedBox(height: Dimensions.height20),
            Text('Didn’t receive OTP?'),
            Text('Resend code',style: TextStyle(color: AppColors.color2)),
          ],
        ),
      ),
    );
  }
}
