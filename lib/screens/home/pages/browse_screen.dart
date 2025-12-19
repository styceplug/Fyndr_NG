import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/widgets/custom_textfield.dart';

import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Browse Services',
              style: TextStyle(
                fontSize: Dimensions.font20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: Dimensions.height20),
            CustomTextField(
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: Dimensions.width15,right: Dimensions.width10),
                child: Image.asset(
                  AppConstants.getPngAsset('search-icon'),
                  scale: 1.8,
                ),
              ),
              hintText: 'Start Searching',
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
                ServiceCard('autos', 'Auto Parts'),
                ServiceCard('beauty', 'Beauty & Wellness'),
                ServiceCard('cleaning', 'Cleaning Service'),
              ],
            ),
            SizedBox(height: Dimensions.height20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ServiceCard('real-estate', 'Real Estate'),
                ServiceCard('recruitment', 'Recruitment'),
                ServiceCard('painting-icon', 'Painting'),

              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget ServiceCard(String image, String title) {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            AppConstants.getPngAsset(image),
            // height: Dimensions.height50,
            // width: Dimensions.width50,
            scale: 2.2,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: Dimensions.font13),
          ),
        ],
      ),
    );
  }

}
