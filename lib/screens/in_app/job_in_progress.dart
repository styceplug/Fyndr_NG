import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:fyndr_ng/utils/dimensions.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:iconsax/iconsax.dart';

import '../../widgets/custom_appbar.dart';

class JobInProgress extends StatefulWidget {
  const JobInProgress({super.key});

  @override
  State<JobInProgress> createState() => _JobInProgressState();
}

class _JobInProgressState extends State<JobInProgress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Job Details', leadingIcon: BackButton()),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width15,
                  vertical: Dimensions.height15,
                ),
                decoration: BoxDecoration(
                  color: Color(0XFFEDF9FB),
                  borderRadius: BorderRadius.circular(Dimensions.radius10),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      AppConstants.getPngAsset('info-icon'),
                      color: Color(0XFF2583FF),
                      fit: BoxFit.fill,
                      height: Dimensions.height10 * 3.5,
                      width: Dimensions.width10 * 3.5,
                    ),
                    SizedBox(width: Dimensions.width10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Job in progress',
                          style: TextStyle(
                            color: Color(0XFF2583FF),
                            fontWeight: FontWeight.w500,
                            fontSize: Dimensions.font14,
                          ),
                        ),
                        Text(
                          'Provider is on the way',
                          style: TextStyle(
                            color: Color(0XFF6BABFF),
                            fontSize: Dimensions.font13,
                          ),
                        ),
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  border: Border.all(color: AppColors.grey2),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: Dimensions.height10 * 8,
                          width: Dimensions.width10 * 8,
                          decoration: BoxDecoration(
                            color: AppColors.grey2,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: Dimensions.width20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ABC Plumbing Co.'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Iconsax.star1,
                                  color: Colors.orange,
                                  size: Dimensions.iconSize20,
                                ),
                                Icon(
                                  Iconsax.star1,
                                  color: Colors.orange,
                                  size: Dimensions.iconSize20,
                                ),
                                Icon(
                                  Iconsax.star1,
                                  color: Colors.orange,
                                  size: Dimensions.iconSize20,
                                ),
                                Icon(
                                  Iconsax.star1,
                                  color: Colors.orange,
                                  size: Dimensions.iconSize20,
                                ),
                                Icon(
                                  Iconsax.star1,
                                  color: Colors.orange,
                                  size: Dimensions.iconSize20,
                                ),
                                SizedBox(width: Dimensions.width10),
                                Text('4.5'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Iconsax.calendar_25,
                                  color: Colors.grey,
                                  size: Dimensions.iconSize20,
                                ),
                                SizedBox(width: Dimensions.width5),
                                Text('+234 xxx xxx 1234'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.width20),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Call',
                            onPressed: () {},
                            backgroundColor: Color(0XFF2C2738),
                          ),
                        ),
                        SizedBox(width: Dimensions.width20),
                        Expanded(
                          child: CustomButton(
                            text: 'Chat',
                            onPressed: () {},
                            backgroundColor: AppColors.white,
                            borderColor: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  'SERVICE DETAILS',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.error,
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
                  border: Border.all(color: AppColors.grey2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Iconsax.location,
                          size: Dimensions.iconSize20,
                          color: AppColors.grey2,
                        ),
                        SizedBox(width: Dimensions.width10),
                        Text('Plumbing Repair'),
                      ],
                    ),
                    SizedBox(height: Dimensions.height10),
                    Row(
                      children: [
                        Icon(
                          Iconsax.location,
                          size: Dimensions.iconSize20,
                          color: AppColors.grey2,
                        ),
                        SizedBox(width: Dimensions.width10),
                        Text('Plumbing Repair'),
                      ],
                    ),
                    SizedBox(height: Dimensions.height10),
                    Row(
                      children: [
                        Icon(
                          Iconsax.location,
                          size: Dimensions.iconSize20,
                          color: AppColors.grey2,
                        ),
                        SizedBox(width: Dimensions.width10),
                        Text('Plumbing Repair'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  'JOB PROGRESS',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.error,
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
                  border: Border.all(color: AppColors.grey2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          size: Dimensions.iconSize20,
                          color: AppColors.color2,
                        ),
                        SizedBox(width: Dimensions.width10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Booking Confirmed'),
                            Text(
                              'Today at 10:30 AM',
                              style: TextStyle(
                                fontSize: Dimensions.font12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          size: Dimensions.iconSize20,
                          color: AppColors.color2,
                        ),
                        SizedBox(width: Dimensions.width10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Provider Accepted'),
                            Text(
                              'Today at 10:30 AM',
                              style: TextStyle(
                                fontSize: Dimensions.font12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          size: Dimensions.iconSize20,
                          color: CupertinoColors.activeBlue,
                        ),
                        SizedBox(width: Dimensions.width10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('On the way'),
                            Text(
                              'Arriving in 15 mins',
                              style: TextStyle(
                                fontSize: Dimensions.font12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          size: Dimensions.iconSize20,
                          color: AppColors.grey2,
                        ),
                        SizedBox(width: Dimensions.width10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Service Started'),
                            Text(
                              'Pending',
                              style: TextStyle(
                                fontSize: Dimensions.font12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          size: Dimensions.iconSize20,
                          color: AppColors.grey2,
                        ),
                        SizedBox(width: Dimensions.width10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Service Completed'),
                            Text(
                              'Pending',
                              style: TextStyle(
                                fontSize: Dimensions.font12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  'PAYMENT',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.error,
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
                  border: Border.all(color: AppColors.grey2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Service Amount',
                          style: TextStyle(
                            fontSize: Dimensions.font15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'N12,000',
                          style: TextStyle(
                            fontSize: Dimensions.font15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height10),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimensions.height10,
                        horizontal: Dimensions.width10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                        border: Border.all(
                          color: AppColors.black.withOpacity(0.7),
                          width: 0.5,
                        ),
                        color: AppColors.grey1
                      ),
                      child: Text('• Pay provider directly in cash or transfer after \n   service completion'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height100)
            ],
          ),
        ),
      ),
    );
  }
}
