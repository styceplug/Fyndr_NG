import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/dimensions.dart';

class LoadingScreenVendors extends StatefulWidget {
  const LoadingScreenVendors({super.key});

  @override
  State<LoadingScreenVendors> createState() => _LoadingScreenVendorsState();
}

class _LoadingScreenVendorsState extends State<LoadingScreenVendors> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () {
        Get.offAllNamed(AppRoutes.vendorRegistrationScreen,arguments: {
          'isExistingUser': true
        });
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height20,
        ),
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppConstants.getPngAsset('genie'),
              height: Dimensions.height100,
              width: Dimensions.width100,
            ),
            SizedBox(height: Dimensions.height20),
            Text(
              'Switching to Vendor',
              style: TextStyle(
                fontSize: Dimensions.font23,
                fontWeight: FontWeight.w600,
                color: AppColors.color1,
              ),
            ),
            SizedBox(height: Dimensions.height10),
            Text('Loading your vendor dashboard...'),
            SizedBox(height: Dimensions.height20),
            LinearProgressIndicator(
              color: AppColors.color2,
              backgroundColor: AppColors.grey2,
              minHeight: Dimensions.height10,
              borderRadius: BorderRadius.circular(Dimensions.radius20),
            ),
            SizedBox(height: Dimensions.height20),
            Text('This will only take a moment'),



          ],
        ),
      ),
    );
  }
}
