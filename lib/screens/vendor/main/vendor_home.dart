import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../routes/routes.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';

class VendorHome extends StatefulWidget {
  const VendorHome({super.key});

  @override
  State<VendorHome> createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        padding: EdgeInsets.fromLTRB(
          Dimensions.width20,
          Dimensions.height100,
          Dimensions.width20,
          Dimensions.height50,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width20,
                vertical: Dimensions.height20,
              ),
              width: Dimensions.screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius10),
                border: Border.all(color: AppColors.grey2),
                color: AppColors.color2.withOpacity(0.3),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'You have switched to Vendor mode',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: AppColors.color1,
                      fontSize: Dimensions.font13,
                    ),
                  ),
                  Icon(Icons.cancel, color: AppColors.error),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Row(
              children: [
                Container(
                  height: Dimensions.height10 * 6,
                  width: Dimensions.width10 * 6,
                  decoration: BoxDecoration(
                    color: AppColors.color3,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(AppConstants.getPngAsset('head-icon')),
                    ),
                  ),
                ),
                SizedBox(width: Dimensions.width20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: Dimensions.font13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        'ABC Plumbing',
                        style: TextStyle(
                          fontSize: Dimensions.font17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.color1,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Switch(
                      value: true,
                      onChanged: (value) {},
                      activeColor: AppColors.color2,
                      activeTrackColor: AppColors.color3,
                      inactiveThumbColor: AppColors.white,
                    ),
                    Text('Pause Account',style: TextStyle(fontSize: Dimensions.font10),)
                  ],
                ),
              ],
            ),
            SizedBox(height: Dimensions.height10),
            Divider(color: AppColors.grey2),
            SizedBox(height: Dimensions.height10),
            Text('Today,', style: TextStyle(color: AppColors.grey5)),
            SizedBox(height: Dimensions.height5),
            InkWell(
              onTap: (){Get.toNamed(AppRoutes.vendorEarningsScreen);},
              child:
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'N20,400.',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: Dimensions.font25,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    '00',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: Dimensions.font20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(height: Dimensions.height5),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width20,
                    vertical: Dimensions.height20,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey1),
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                    color: AppColors.grey1.withOpacity(0.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Active Jobs',
                            style: TextStyle(color: AppColors.grey3),
                          ),
                          Text(
                            '3',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: Dimensions.font17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jobs Completed',
                            style: TextStyle(color: AppColors.grey3),
                          ),
                          Text(
                            '23',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: Dimensions.font17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Earnings',
                            style: TextStyle(color: AppColors.grey3),
                          ),
                          Text(
                            'N186,500',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: Dimensions.font17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
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
              width: Dimensions.screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius10),
                border: Border.all(color: AppColors.color5),
                color: AppColors.color2.withOpacity(0.2),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '8 New Leads',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.color1,
                          fontSize: Dimensions.font13,
                        ),
                      ),
                      Text(
                        '5 plumbing requests nearby',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.color1,
                          fontSize: Dimensions.font13,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: (){Get.toNamed(AppRoutes.vendorLeadsScreen);},
                    child: Text(
                      'View all',
                      style: TextStyle(
                        fontSize: Dimensions.font13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.color1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'SCHEDULED JOBS',
                style: TextStyle(
                  fontSize: Dimensions.font14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.color1,
                ),
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width20,
                vertical: Dimensions.height10,
              ),
              width: Dimensions.screenWidth,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey1),
                borderRadius: BorderRadius.circular(Dimensions.radius20),
              ),
              child: Row(
                children: [
                  Image.asset(AppConstants.getPngAsset('kitchen-sink')),
                  SizedBox(width: Dimensions.width20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Kitchen Sink Repair',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.color1,
                            fontSize: Dimensions.font14,
                          ),
                        ),
                        Text(
                          'Adekunle A. Lekki Phase 1',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.grey4,
                            fontSize: Dimensions.font12,
                          ),
                        ),
                        Text(
                          'N12,000',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: Dimensions.font13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: Dimensions.width20),
                  Text('12:00pm'),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width20,
                vertical: Dimensions.height10,
              ),
              width: Dimensions.screenWidth,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey1),
                borderRadius: BorderRadius.circular(Dimensions.radius20),
              ),
              child: Row(
                children: [
                  Image.asset(AppConstants.getPngAsset('kitchen-sink')),
                  SizedBox(width: Dimensions.width20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Kitchen Sink Repair',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.color1,
                            fontSize: Dimensions.font14,
                          ),
                        ),
                        Text(
                          'Adekunle A. Lekki Phase 1',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.grey4,
                            fontSize: Dimensions.font12,
                          ),
                        ),
                        Text(
                          'N12,000',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: Dimensions.font13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: Dimensions.width20),
                  Text('12:00pm'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
