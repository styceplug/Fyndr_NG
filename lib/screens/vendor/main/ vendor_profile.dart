import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../routes/routes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';

class VendorProfileScreen extends StatefulWidget {
  const VendorProfileScreen({super.key});

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(
          Dimensions.width20,
          Dimensions.height10 * 8,
          Dimensions.width20,
          Dimensions.bottomNavIconHeight + Dimensions.height50,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: Dimensions.font20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: (){Get.toNamed(AppRoutes.notificationScreen);},
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width10,
                        vertical: Dimensions.height10,
                      ),
                      height: Dimensions.height50,
                      width: Dimensions.width50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.color5,
                      ),
                      child: Image.asset(AppConstants.getPngAsset('bell-icon')),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height20),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height20,
                ),
                decoration: BoxDecoration(color: AppColors.color4),
                child: Image.asset(
                  AppConstants.getPngAsset('head-icon'),
                  height: Dimensions.height30,
                  width: Dimensions.width30,
                ),
              ),
              SizedBox(height: Dimensions.height5),
              Text('John Doe', style: TextStyle(fontSize: Dimensions.font20)),
              SizedBox(height: Dimensions.height5),
              IntrinsicWidth(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width10,
                    vertical: Dimensions.height5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.color3,
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Iconsax.location,
                        color: Colors.white,
                        size: Dimensions.iconSize16 * 0.9,
                      ),
                      SizedBox(width: Dimensions.width10),
                      Text(
                        'Lekki, Lagos',
                        style: TextStyle(
                          fontSize: Dimensions.font12 * 0.9,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Iconsax.star1, color: AppColors.color4),
                  Icon(Iconsax.star1, color: AppColors.color4),
                  Icon(Iconsax.star1, color: AppColors.color4),
                  Icon(Iconsax.star1, color: AppColors.color4),
                  Icon(Iconsax.star1, color: AppColors.color4),
                  SizedBox(width: Dimensions.width5),
                  Text(
                    '5.0',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: Dimensions.font16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height20),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width10,
                  vertical: Dimensions.height20,
                ),
                decoration: BoxDecoration(
                  color: AppColors.grey1.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DataCard('156', 'Jobs Done'),
                    DataCard('98%', 'On-time'),
                    DataCard('2 yrs', 'Member'),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  'ACCOUNT',
                  style: TextStyle(
                    fontSize: Dimensions.font16,
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
                    OptionCard('edit-profile', 'Edit Profile'),
                    Divider(color: AppColors.grey2),
                    OptionCard('switch-icon', 'Switch Account',onTap: (){
                      Get.toNamed(AppRoutes.becomeVendorScreen);
                    }),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  'SETTINGS',
                  style: TextStyle(
                    fontSize: Dimensions.font16,
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
                    OptionCard('bell-icon', 'Notifications'),
                    Divider(color: AppColors.grey2),
                    OptionCard('pin-icon', 'Location Services'),
                    Divider(color: AppColors.grey2),
                    OptionCard('payment-icon', 'Payment Method'),
                    Divider(color: AppColors.grey2),
                    OptionCard('log-out', 'Logout'),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  'SUPPORT',
                  style: TextStyle(
                    fontSize: Dimensions.font16,
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
                    OptionCard('help-icon', 'Help Center',onTap: (){
                      Get.toNamed(AppRoutes.helpCenter);
                    }),
                    Divider(color: AppColors.grey2),
                    OptionCard('terms', 'Terms and condition'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget DataCard(String value, String title) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width15,
        vertical: Dimensions.height10,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey2),
        borderRadius: BorderRadius.circular(Dimensions.radius10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: Dimensions.font20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: Dimensions.height5),
          Text(
            title,
            style: TextStyle(
              fontSize: Dimensions.font13,
              fontWeight: FontWeight.w300,
              color: AppColors.grey4,
            ),
          ),
        ],
      ),
    );
  }

  Widget OptionCard(String image, String title, {VoidCallback? onTap}) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.height5,top: Dimensions.height5),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Image.asset(
              AppConstants.getPngAsset(image),
              height: Dimensions.height10 * 2.5,
              width: Dimensions.width10 * 2.5,
            ),
            SizedBox(width: Dimensions.width10),
            Text(title),
          ],
        ),
      ),
    );
  }
}
