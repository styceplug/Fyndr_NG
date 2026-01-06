import 'package:flutter/material.dart';
import 'package:fyndr_ng/widgets/custom_textfield.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../routes/routes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/job_card.dart';

class VendorLeadDetailsScreen extends StatefulWidget {
  const VendorLeadDetailsScreen({super.key});

  @override
  State<VendorLeadDetailsScreen> createState() =>
      _VendorLeadDetailsScreenState();
}

class _VendorLeadDetailsScreenState extends State<VendorLeadDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    void showRespondModal() {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Dimensions.radius20),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                width: Dimensions.screenWidth,
                height: Dimensions.screenHeight * 0.9,
                padding: EdgeInsets.symmetric(
                  vertical: Dimensions.height20 * 1.5,
                  horizontal: Dimensions.width20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Your Quote Amount',
                        style: TextStyle(
                          fontSize: Dimensions.font14,
                          color: AppColors.grey4,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: Dimensions.height5),
                      CustomTextField(
                        hintText: 'Enter Amount',
                        fillColor: AppColors.grey2,
                      ),
                      SizedBox(height: Dimensions.height20),
                      Text(
                        'Estimated Completion time',
                        style: TextStyle(
                          fontSize: Dimensions.font14,
                          color: AppColors.grey4,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: Dimensions.height5),
                      CustomTextField(
                        hintText: 'Enter in hours',
                        fillColor: AppColors.grey2,
                      ),
                      SizedBox(height: Dimensions.height20),
                      Text(
                        'Your availability',
                        style: TextStyle(
                          fontSize: Dimensions.font14,
                          color: AppColors.grey4,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: Dimensions.height5),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width10,
                              vertical: Dimensions.height10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Dimensions.radius15,
                              ),
                              border: Border.all(color: AppColors.grey4),
                            ),
                            child: Text('Morning'),
                          ),
                          SizedBox(width: Dimensions.width20),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width10,
                              vertical: Dimensions.height10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Dimensions.radius15,
                              ),
                              border: Border.all(color: AppColors.grey4),
                            ),
                            child: Text('Afternoon'),
                          ),
                          SizedBox(width: Dimensions.width20),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width10,
                              vertical: Dimensions.height10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Dimensions.radius15,
                              ),
                              border: Border.all(color: AppColors.grey4),
                            ),
                            child: Text('Flexible'),
                          ),
                          SizedBox(width: Dimensions.width20),
                        ],
                      ),
                      SizedBox(height: Dimensions.height20),
                      Text(
                        'What is included (Optional)',
                        style: TextStyle(
                          fontSize: Dimensions.font14,
                          color: AppColors.grey4,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: Dimensions.height5),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width10,
                              vertical: Dimensions.height10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Dimensions.radius15,
                              ),
                              border: Border.all(color: AppColors.grey4),
                            ),
                            child: Text('Full inspection'),
                          ),
                          SizedBox(width: Dimensions.width20),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width10,
                              vertical: Dimensions.height10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Dimensions.radius15,
                              ),
                              border: Border.all(color: AppColors.grey4),
                            ),
                            child: Text('Leak repair'),
                          ),
                          SizedBox(width: Dimensions.width20),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width10,
                              vertical: Dimensions.height10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Dimensions.radius15,
                              ),
                              border: Border.all(color: AppColors.grey4),
                            ),
                            child: Text('Parts'),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.height10),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width10,
                          vertical: Dimensions.height10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius15,
                          ),
                          border: Border.all(color: AppColors.grey4),
                        ),
                        child: Text('30 days warranty'),
                      ),
                      SizedBox(height: Dimensions.height20),
                      Text(
                        'Message to Customer (Optional)',
                        style: TextStyle(
                          fontSize: Dimensions.font14,
                          color: AppColors.grey4,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: Dimensions.height5),
                      CustomTextField(
                        hintText:
                            'Example: Hello! I can fix your kitchen sink leak tomorrow morning. I have over 10 years of experience and carry all necessary tools.',
                        maxLines: 3,
                        fillColor: AppColors.grey2,
                      ),
                      SizedBox(height: Dimensions.height20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: Dimensions.font14,
                              color: AppColors.grey4,
                            ),
                          ),
                          Text(
                            'N100,000',
                            style: TextStyle(
                              fontSize: Dimensions.font14,
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.height5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Timeline',
                            style: TextStyle(
                              fontSize: Dimensions.font14,
                              color: AppColors.grey4,
                            ),
                          ),
                          Text(
                            'N100,000',
                            style: TextStyle(
                              fontSize: Dimensions.font14,
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.height5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Availability',
                            style: TextStyle(
                              fontSize: Dimensions.font14,
                              color: AppColors.grey4,
                            ),
                          ),
                          Text(
                            'Nov 14 - Morning',
                            style: TextStyle(
                              fontSize: Dimensions.font14,
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.height20),
                      CustomButton(text: 'Send Quote', onPressed: () {
                        Get.toNamed(AppRoutes.vendorJobCompleted);
                      }),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }

    return Scaffold(
      appBar: CustomAppbar(title: 'Leads Details', leadingIcon: BackButton()),
      body: Container(
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: Dimensions.height20 * 10,
                decoration: BoxDecoration(
                  color: AppColors.grey2,
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                ),
                child: Align(
                  alignment: AlignmentGeometry.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: Dimensions.height10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.circle,
                          size: Dimensions.iconSize16 * 0.7,
                          color: AppColors.color2,
                        ),
                        SizedBox(width: Dimensions.width10 * 0.7),
                        Icon(
                          Icons.circle,
                          size: Dimensions.iconSize16 * 0.7,
                          color: AppColors.grey5,
                        ),
                        SizedBox(width: Dimensions.width10 * 0.7),
                        Icon(
                          Icons.circle,
                          size: Dimensions.iconSize16 * 0.7,
                          color: AppColors.grey5,
                        ),
                        SizedBox(width: Dimensions.width10 * 0.7),
                        Icon(
                          Icons.circle,
                          size: Dimensions.iconSize16 * 0.7,
                          color: AppColors.grey5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height20),
              IntrinsicWidth(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width10,
                    vertical: Dimensions.height5,
                  ),
                  child: Text(
                    'HIGH PRIORITY',
                    style: TextStyle(
                      fontSize: Dimensions.font10,
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height5),
              Text(
                'Kitchen Sink Repair',
                style: TextStyle(
                  fontSize: Dimensions.font20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: Dimensions.height5),
              Text(
                'N100,000 - N150,000',
                style: TextStyle(
                  fontSize: Dimensions.font20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
              SizedBox(height: Dimensions.height20),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Iconsax.calendar_1,
                          size: Dimensions.iconSize20,
                          color: AppColors.grey5,
                        ),
                        SizedBox(width: Dimensions.width10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nov 13',
                              style: TextStyle(
                                color: AppColors.grey5,
                                fontSize: Dimensions.font14,
                              ),
                            ),
                            Text(
                              'Flexible',
                              style: TextStyle(
                                color: AppColors.grey5,
                                fontSize: Dimensions.font14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    VerticalDivider(color: AppColors.grey3),
                    Row(
                      children: [
                        Icon(
                          Iconsax.clock,
                          size: Dimensions.iconSize20,
                          color: AppColors.grey5,
                        ),
                        SizedBox(width: Dimensions.width10),
                        Text(
                          '9:00 am',
                          style: TextStyle(
                            color: AppColors.grey5,
                            fontSize: Dimensions.font14,
                          ),
                        ),
                      ],
                    ),
                    VerticalDivider(color: AppColors.grey3),
                    Row(
                      children: [
                        Icon(
                          Iconsax.location,
                          size: Dimensions.iconSize20,
                          color: AppColors.grey5,
                        ),
                        SizedBox(width: Dimensions.width10),

                        Text(
                          '12 Km',
                          style: TextStyle(
                            color: AppColors.grey5,
                            fontSize: Dimensions.font14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Text(
                'PROBLEM DESCRIPTION',
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: Dimensions.font14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                'Water is leaking from under the kitchen sink. It started after some dirt piled up and would not go down the drain. I have changed ...read more',
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Text(
                'CUSTOMER INFORMATION',
                style: TextStyle(
                  fontSize: Dimensions.font15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.color1,
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: Dimensions.height10,
                  horizontal: Dimensions.width10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  border: Border.all(color: AppColors.grey2),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.color3,
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius10,
                            ),
                          ),
                          child: Image.asset(
                            AppConstants.getPngAsset('head-icon'),
                            height: Dimensions.height10 * 6,
                            width: Dimensions.width10 * 6,
                          ),
                        ),
                        SizedBox(width: Dimensions.width10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'John Doe',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: AppColors.color1,
                                      fontWeight: FontWeight.w500,
                                      fontSize: Dimensions.font16,
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.width10),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Dimensions.width5,
                                      vertical: Dimensions.height5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.grey3,
                                      borderRadius: BorderRadius.circular(
                                        Dimensions.radius20,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: Dimensions.iconSize16,
                                          color: AppColors.success,
                                        ),
                                        Text('4.5'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '236+ Completed Jobs',
                                style: TextStyle(
                                  fontSize: Dimensions.font15,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: Dimensions.width10),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height20,
                ),
                width: Dimensions.screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  border: Border.all(color: AppColors.grey2),
                  color: AppColors.info.withOpacity(0.1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lead Status',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.info,
                      ),
                    ),
                    SizedBox(height: Dimensions.height5),
                    Text(
                      '• Sent to 8 verified vendors\n• 4 vendors have viewed\n• 1 quote already sent\n• Expires in 22 hours',
                      style: TextStyle(
                        color: AppColors.info,
                        fontWeight: FontWeight.w300,
                        fontSize: Dimensions.font13,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height20),
              CustomButton(
                text: 'Send your quote',
                onPressed: showRespondModal,
              ),
              SizedBox(height: Dimensions.height20),
              CustomButton(
                text: 'Not interested',
                onPressed: () {},
                backgroundColor: AppColors.white,
                borderColor: AppColors.color1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
