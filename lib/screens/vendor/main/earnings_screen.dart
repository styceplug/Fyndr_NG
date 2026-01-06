import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:fyndr_ng/widgets/custom_appbar.dart';

import '../../../utils/dimensions.dart';

class VendorEarningScreen extends StatefulWidget {
  const VendorEarningScreen({super.key});

  @override
  State<VendorEarningScreen> createState() => _VendorEarningScreenState();
}

class _VendorEarningScreenState extends State<VendorEarningScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(leadingIcon: BackButton(), title: 'Earnings'),
      body: Container(
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Stack(
                  children: [
                    Container(
                      height: Dimensions.height100 * 1.8,
                      width: Dimensions.screenWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                        gradient: LinearGradient(
                          colors: [AppColors.color2, AppColors.color3],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Image.asset(AppConstants.getPngAsset('balance-bg')),
                    ),
                    Positioned(
                      bottom: Dimensions.height15,
                      left: Dimensions.width20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Earning (All time)',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: Dimensions.font15,
                            ),
                          ),
                          Text(
                            'N1,232,889.00',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: Dimensions.font30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      'THIS MONTH',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: Dimensions.font13,
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
                      'LAST MONTH',
                      style: TextStyle(
                        color: AppColors.grey5,
                        fontSize: Dimensions.font13,
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
                      'ALL TIME',
                      style: TextStyle(
                        color: AppColors.grey5,
                        fontSize: Dimensions.font13,
                      ),
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
                          'This Month',
                          style: TextStyle(color: AppColors.grey3),
                        ),
                        SizedBox(height: Dimensions.height5),
                        Text(
                          'N186K',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: Dimensions.font17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jobs Done',
                          style: TextStyle(color: AppColors.grey3),
                        ),
                        SizedBox(height: Dimensions.height5),
                        Text(
                          '23',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: Dimensions.font17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Avg/Job', style: TextStyle(color: AppColors.grey3)),
                        SizedBox(height: Dimensions.height5),
                        Text(
                          'N186.5K',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: Dimensions.font17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'PENDING PAYMENT',
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
                  vertical: Dimensions.height20,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey2),
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Kitchen Sink Repair'),
                        Text(
                          'N18,500',
                          style: TextStyle(color: AppColors.color2),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('John Doe',style: TextStyle(fontWeight: FontWeight.w300,color: AppColors.grey3),),
                        Text(
                          'Pending',
                          style: TextStyle(color: AppColors.grey3),
                        ),
                      ],
                    ),
                    Divider(color: AppColors.grey2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Pipe Installation'),
                        Text(
                          'N18,500',
                          style: TextStyle(color: AppColors.color2),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('John Doe',style: TextStyle(fontWeight: FontWeight.w300,color: AppColors.grey3),),
                        Text(
                          'Pending',
                          style: TextStyle(color: AppColors.grey3),
                        ),
                      ],
                    ),
          
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height20,
                ),
                width: Dimensions.screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  border: Border.all(color: AppColors.grey2),
                  color: AppColors.info.withOpacity(0.3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment notes',
                      style: TextStyle(
                        color: AppColors.info,
                        fontWeight: FontWeight.w500,
                        fontSize: Dimensions.font14,
                      ),
                    ),
          
                    Text(
                      'Customers pay you directly after service completion. The amounts above are awaiting customer payment confirmation',
                      style: TextStyle(
                        color: AppColors.info,
                        fontWeight: FontWeight.w400,
                        fontSize: Dimensions.font14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'RECENT EARNINGS',
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
                  vertical: Dimensions.height20,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey2),
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Kitchen Sink Repair'),
                        Text(
                          'N18,500',
                          style: TextStyle(color: AppColors.color2),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('John Doe',style: TextStyle(fontWeight: FontWeight.w300,color: AppColors.grey3),),
                        Text(
                          'Pending',
                          style: TextStyle(color: AppColors.grey3),
                        ),
                      ],
                    ),
                    Divider(color: AppColors.grey2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Pipe Installation'),
                        Text(
                          'N18,500',
                          style: TextStyle(color: AppColors.color2),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('John Doe',style: TextStyle(fontWeight: FontWeight.w300,color: AppColors.grey3),),
                        Text(
                          'Pending',
                          style: TextStyle(color: AppColors.grey3),
                        ),
                      ],
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
