import 'package:flutter/material.dart';
import 'package:fyndr_ng/controllers/auth_controller.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:fyndr_ng/utils/dimensions.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

AuthController authController = Get.find<AuthController>();

final user = authController.userModel;

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(
          Dimensions.width20,
          Dimensions.height10*8,
          Dimensions.width20,
          Dimensions.bottomNavIconHeight + Dimensions.height50,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  AppConstants.getPngAsset('user-icon'),
                  height: Dimensions.height10*9,
                  width: Dimensions.width10*9,
                  fit: BoxFit.cover,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Day',
                        style: TextStyle(fontSize: Dimensions.font17),
                      ),
                      Text(
                        user?.name ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: Dimensions.font22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.color1,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: Dimensions.width20),
                InkWell(
                  onTap: (){
                    Get.toNamed(AppRoutes.notificationScreen);
                  },
                  child: Container(
                    height: Dimensions.height10 * 7,
                    width: Dimensions.width10 * 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.color5,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width15,
                      vertical: Dimensions.height15,
                    ),
                    child: Image.asset(
                      AppConstants.getPngAsset('bell-icon'),
                      height: Dimensions.height50,
                      width: Dimensions.width50,
                      scale: 1.5,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height10),

            ///FIX THIS
            if(user?.email == '' || user?.name == '' || user?.location == null)
            Container(
              padding: EdgeInsets.symmetric(
                vertical: Dimensions.height10,
                horizontal: Dimensions.width10,
              ),
              decoration: BoxDecoration(
                color: AppColors.color5,
                borderRadius: BorderRadius.circular(Dimensions.radius10),
              ),
              child: Row(
                children: [
                  Image.asset(
                    AppConstants.getPngAsset('info-icon'),
                    color: AppColors.color2,
                  ),
                  SizedBox(width: Dimensions.width10),
                  Text(
                    'Complete your profile in settings',
                    style: TextStyle(color: AppColors.color2),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Image.asset(AppConstants.getPngAsset('banner'),width: Dimensions.screenWidth,),
            SizedBox(height: Dimensions.height20),
            Text(
              'RECENT REQUESTS',
              style: TextStyle(
                fontSize: Dimensions.font15,
                fontWeight: FontWeight.w600,
                color: AppColors.color1,
              ),
            ),
            SizedBox(height: Dimensions.height20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  RequestCard('Ongoing','Plumbing Services','3'),
                  RequestCard('Ongoing','Construction','3'),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Text(
              'POPULAR SERVICES',
              style: TextStyle(
                fontSize: Dimensions.font15,
                fontWeight: FontWeight.w600,
                color: AppColors.color1,
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ServiceCard('real-estate', 'Real \nEstate'),
                ServiceCard('cleaning', 'Cleaning Service'),
                ServiceCard('recruitment', 'Home Maintenance'),
              ],
            ),
            SizedBox(height: Dimensions.height20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget ServiceCard(String image, String title) {
    return InkWell(
      onTap: (){
        Get.toNamed(AppRoutes.requestForm,arguments: {'serviceTitle': title});
      },
      child: Container(
        height: Dimensions.height10 * 11,
        width: Dimensions.width10 * 12,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.color5),
          borderRadius: BorderRadius.circular(Dimensions.radius10),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height15,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              AppConstants.getPngAsset(image),
              // height: Dimensions.height50,
              // width: Dimensions.width50,
              scale: 2.2,
            ),
            Spacer(),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: Dimensions.font13),
            ),
          ],
        ),
      ),
    );
  }
  Widget RequestCard(String status, String service, String quotes){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius10),
        border: Border.all(color: AppColors.color1),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width20,
        vertical: Dimensions.height10,
      ),
      margin: EdgeInsets.only(right: Dimensions.width15),
      child: Row(
        children: [
          Container(
            width: Dimensions.width5,
            height: Dimensions.height10 * 6.5,
            color: AppColors.color4,
          ),
          SizedBox(width: Dimensions.width15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status,
                style: TextStyle(
                  fontSize: Dimensions.font13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                service,
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.color1,
                ),
              ),
              Text(
                '$quotes quotes',
                style: TextStyle(color: AppColors.grey4,fontSize: Dimensions.font13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
