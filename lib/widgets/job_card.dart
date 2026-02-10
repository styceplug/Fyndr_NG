import 'package:flutter/material.dart';
import 'package:fyndr_ng/routes/routes.dart';
import 'package:get/get.dart';

import '../utils/app_constants.dart';
import '../utils/colors.dart';
import '../utils/dimensions.dart';
import 'custom_button.dart';

class JobCard extends StatelessWidget {
  String imageAsset;
  String title;
  String location;
  String distance;
  String date;
  String dayTime;
  String timeAgo;
  String quote;
  VoidCallback onTap;

  JobCard({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.location,
    required this.distance,
    required this.date,
    required this.dayTime,
    required this.timeAgo,
    required this.onTap,
    required this.quote,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.height20,
          horizontal: Dimensions.width10,
        ),
        margin: EdgeInsets.only(bottom: Dimensions.height15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius20),
          border: Border.all(color: AppColors.grey2),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  AppConstants.getPngAsset(imageAsset),
                  height: Dimensions.height10 * 5,
                  width: Dimensions.width10 * 5,
                ),
                SizedBox(width: Dimensions.width20),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${title} Service',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: AppColors.color1,
                                fontWeight: FontWeight.w500,
                                fontSize: Dimensions.font15,
                              ),
                            ),
                            Text(
                              '${location}  ${distance}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.grey3,
                                fontSize: Dimensions.font14,
                              ),
                            ),
                            Text(
                              '${date}   ${dayTime}',
                              style: TextStyle(
                                color: AppColors.grey3,
                                fontSize: Dimensions.font14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomButton(
                        text: '${quote} QUOTES',
                        onPressed: () {},
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width10,
                          vertical: Dimensions.height5,
                        ),
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius30,
                        ),
                        textStyle: TextStyle(
                          fontSize: Dimensions.font12,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: Dimensions.width20),
                      Padding(
                        padding: EdgeInsets.only(top: Dimensions.height5 / 2),
                        child: Icon(
                          Icons.more_vert,
                          color: AppColors.grey5,
                          size: Dimensions.iconSize24,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(color: AppColors.grey2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Submitted ${timeAgo}',
                  style: TextStyle(
                    fontSize: Dimensions.font12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  'View quote',
                  style: TextStyle(
                    fontSize: Dimensions.font12,
                    fontWeight: FontWeight.w300,
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

class QuotesCard extends StatelessWidget {
  String imageAsset;
  bool isNetworkImage;
  String title;
  String price;
  String location;
  String distance;
  String timeAgo;
  VoidCallback? onTap;
  String status;

  QuotesCard({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.price,
    required this.location,
    required this.distance,
    required this.timeAgo,
    this.isNetworkImage = false,
    this.onTap,
    required this.status
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.height10,
          horizontal: Dimensions.width10,
        ),
        margin: EdgeInsets.only(bottom: Dimensions.height10),
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
                    borderRadius: BorderRadius.circular(Dimensions.radius10),
                  ),
                  child:
                      isNetworkImage
                          ? Image.network(
                            imageAsset,
                            height: Dimensions.height10 * 6,
                            width: Dimensions.width10 * 6,
                          )
                          : Image.asset(
                            AppConstants.getPngAsset(imageAsset),
                            height: Dimensions.height10 * 6,
                            width: Dimensions.width10 * 6,
                          ),
                ),
                SizedBox(width: Dimensions.width10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: AppColors.color1,
                          fontWeight: FontWeight.w500,
                          fontSize: Dimensions.font16,
                        ),
                      ),
                      Text(
                        '${location}  ${distance} . ${timeAgo}hrs ago',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.grey3,
                          fontSize: Dimensions.font12,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: Dimensions.width10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'NGN ${price}',
                      style: TextStyle(
                        fontSize: Dimensions.font14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width10,vertical: Dimensions.height5
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.grey3,
                        borderRadius: BorderRadius.circular(Dimensions.radius10)
                      ),
                      child: Text(
                        status.capitalizeFirst ?? '',
                        style: TextStyle(
                          fontSize: Dimensions.font10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
