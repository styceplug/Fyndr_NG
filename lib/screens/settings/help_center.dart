import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/utils/dimensions.dart';
import 'package:fyndr_ng/widgets/custom_appbar.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:fyndr_ng/widgets/custom_textfield.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../routes/routes.dart';
import '../../utils/colors.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Help & Support', leadingIcon: BackButton()),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                prefixIcon: Padding(
                  padding: EdgeInsets.fromLTRB(
                    Dimensions.width10,
                    0,
                    Dimensions.width10,
                    0,
                  ),
                  child: Icon(Icons.search),
                ),
                hintText: 'Search for help...',
              ),
              SizedBox(height: Dimensions.height20),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  'NEED HELP?',
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
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  border: Border.all(color: AppColors.grey1),
                ),
                child: Column(
                  children: [
                    OptionCard(
                      'help-icon',
                      'Chat with Support',
                      'Get instant help from our team',
                    ),
                    Divider(color: AppColors.grey2),
                    OptionCard(
                      'call-icon',
                      'Call Support',
                      '+234 xxx xxx xxxx',
                    ),
                    Divider(color: AppColors.grey2),
                    OptionCard(
                      'mail-icon',
                      'Email Support',
                      'support@fyndr.com',
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  'POPULAR TOPICS',
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
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  border: Border.all(color: AppColors.grey1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          AppConstants.getPngAsset('payment-icon'),
                          height: Dimensions.height20,
                          width: Dimensions.width20,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(width: Dimensions.width5),
                        Text('Payment & Pricing'),
                      ],
                    ),
                    SizedBox(height: Dimensions.height10),
                    Text('• How does the connection fee work?'),
                    Text('• When do I pay the vendor?'),
                    Text('• Are there any hidden fees?'),
                    Text('• How to get a refund?'),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  border: Border.all(color: AppColors.grey1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          AppConstants.getPngAsset('veri-tick'),
                          height: Dimensions.height20,
                          width: Dimensions.width20,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(width: Dimensions.width5),
                        Text('Verification & Safety'),
                      ],
                    ),
                    SizedBox(height: Dimensions.height10),
                    Text('• What is RheelTech Verification?'),
                    Text('• Are vendors background checked?'),
                    Text('• How to report a safety issue?'),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  border: Border.all(color: AppColors.grey1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          AppConstants.getPngAsset('using-icon'),
                          height: Dimensions.height20,
                          width: Dimensions.width20,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(width: Dimensions.width5),
                        Text('Using Fyndr'),
                      ],
                    ),
                    SizedBox(height: Dimensions.height10),
                    Text('• How to use Genie AI?'),
                    Text('• How to compare quotes?'),
                    Text('• How to cancel a booking?'),
                    Text('• How to leave a review?'),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  border: Border.all(color: AppColors.grey1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          AppConstants.getPngAsset('acct-mgmt'),
                          height: Dimensions.height20,
                          width: Dimensions.width20,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(width: Dimensions.width5),
                        Text('Account Management'),
                      ],
                    ),
                    SizedBox(height: Dimensions.height10),
                    Text('• How to switch between a customer & vendor?'),
                    Text('• How to update my profile?'),
                    Text('• How to delete my account?'),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height20),
              CustomButton(text: 'View all FAQs', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget OptionCard(
    String image,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(
        bottom: Dimensions.height5,
        top: Dimensions.height5,
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Image.asset(
              AppConstants.getPngAsset(image),
              height: Dimensions.height10 * 2.3,
              width: Dimensions.width10 * 2.3,
            ),
            SizedBox(width: Dimensions.width15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: AppColors.grey4,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
