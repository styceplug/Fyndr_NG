import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:fyndr_ng/utils/dimensions.dart';
import 'package:fyndr_ng/widgets/custom_appbar.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';
import '../../../utils/app_constants.dart';

class VendorLeadScreen extends StatefulWidget {
  const VendorLeadScreen({super.key});

  @override
  State<VendorLeadScreen> createState() => _VendorLeadScreenState();
}

class _VendorLeadScreenState extends State<VendorLeadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(leadingIcon: BackButton(), title: 'New Leads'),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height20,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width15,
                    vertical: Dimensions.height10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.color2,
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                  ),
                  child: Text(
                    'ALL',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: Dimensions.font15,
                    ),
                  ),
                ),
                SizedBox(width: Dimensions.width20),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width15,
                    vertical: Dimensions.height10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.grey2,
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                  ),
                  child: Text(
                    'HIGH PRIORITY',
                    style: TextStyle(
                      color: AppColors.grey5,
                      fontSize: Dimensions.font15,
                    ),
                  ),
                ),
                SizedBox(width: Dimensions.width20),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width15,
                    vertical: Dimensions.height10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.grey2,
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                  ),
                  child: Text(
                    'NEARBY',
                    style: TextStyle(
                      color: AppColors.grey5,
                      fontSize: Dimensions.font15,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height20),
            InkWell(
              onTap: (){
                Get.toNamed(AppRoutes.vendorLeadDetailsScreen);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width10,
                  vertical: Dimensions.height20,
                ),
                width: Dimensions.screenWidth,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey1),
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: AppColors.grey1.withOpacity(0.2)
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      AppConstants.getPngAsset('kitchen-sink'),
                      width: Dimensions.width50,
                    ),
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
                              fontSize: Dimensions.font16,
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
                            'N12,000 - N15,000',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: Dimensions.font15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Next week Flexible',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.grey4,
                              fontSize: Dimensions.font12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: Dimensions.width20),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width15,
                        vertical: Dimensions.height5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.color2,
                        borderRadius: BorderRadius.circular(Dimensions.radius20)
                      ),
                      child: Text('HIGH',style: TextStyle(color: AppColors.white,fontSize: Dimensions.font12),),
                    ),
                    SizedBox(width: Dimensions.width10),
                    Icon(Icons.more_vert)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
