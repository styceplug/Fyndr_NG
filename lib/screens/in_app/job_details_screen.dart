import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:fyndr_ng/utils/dimensions.dart';
import 'package:fyndr_ng/widgets/custom_appbar.dart';
import 'package:fyndr_ng/widgets/job_card.dart';

class JobDetailsScreen extends StatefulWidget {
  const JobDetailsScreen({super.key});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Job Details', leadingIcon: BackButton()),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height20,
        ),
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
            Text(
              'Kitchen Sink Repair',
              style: TextStyle(
                fontSize: Dimensions.font20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: Dimensions.height5),
            IntrinsicWidth(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.color3,
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width10,
                  vertical: Dimensions.height5,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.bookmark,
                      size: Dimensions.iconSize16 * 0.8,
                      color: Colors.white,
                    ),
                    SizedBox(width: Dimensions.width5),
                    Text(
                      '3 quotes received',
                      style: TextStyle(
                        fontSize: Dimensions.font10,
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Service type',
                      style: TextStyle(
                        color: AppColors.grey5,
                        fontSize: Dimensions.font14,
                      ),
                    ),
                    Text(
                      'Plumbing Service',
                      style: TextStyle(
                        fontSize: Dimensions.font16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date',
                      style: TextStyle(
                        color: AppColors.grey5,
                        fontSize: Dimensions.font14,
                      ),
                    ),
                    Text(
                      '13 Nov 2025 - 09:30am',
                      style: TextStyle(
                        fontSize: Dimensions.font16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: Dimensions.height20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location',
                      style: TextStyle(
                        color: AppColors.grey5,
                        fontSize: Dimensions.font14,
                      ),
                    ),
                    Text(
                      'Banana Island',
                      style: TextStyle(
                        fontSize: Dimensions.font16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Budget',
                      style: TextStyle(
                        color: AppColors.grey5,
                        fontSize: Dimensions.font14,
                      ),
                    ),
                    Text(
                      'N100,000 - N150,000',
                      style: TextStyle(
                        fontSize: Dimensions.font16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: Dimensions.height20),
            Text(
              'Problem description',
              style: TextStyle(
                color: AppColors.grey5,
                fontSize: Dimensions.font14,
              ),
            ),
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
              'QUOTES RECEIVED',
              style: TextStyle(
                fontSize: Dimensions.font15,
                fontWeight: FontWeight.w600,
                color: AppColors.color1,
              ),
            ),
            SizedBox(height: Dimensions.height20),
            QuotesCard(
              imageAsset: 'head-icon',
              title: 'ABC Co Plumber',
              price: '50,000',
              location: 'Egbeda, Lagos',
              distance: '30KM',
              timeAgo: '6',
            ),
          ],
        ),
      ),
    );
  }
}
