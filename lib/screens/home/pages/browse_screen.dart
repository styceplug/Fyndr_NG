import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/widgets/custom_textfield.dart';
import 'package:fyndr_ng/widgets/empty_state_widget.dart';

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
              'Declutter',
              style: TextStyle(
                fontSize: Dimensions.font20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Row(
              children: [
                Text(
                  'Browse',
                  style: TextStyle(
                    fontSize: Dimensions.font18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.color2,
                  ),
                ),
                SizedBox(width: Dimensions.width20),
                Text(
                  'Sell item',
                  style: TextStyle(
                    fontSize: Dimensions.font18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height20),
            CustomTextField(
              prefixIcon: Padding(
                padding: EdgeInsets.only(
                  left: Dimensions.width15,
                  right: Dimensions.width10,
                ),
                child: Image.asset(
                  AppConstants.getPngAsset('search-icon'),
                  scale: 2,
                ),
              ),
              hintText: 'Start Searching',
            ),
            SizedBox(height: Dimensions.height20),
            Expanded(
              child: EmptyState(
                message: 'No Products for sale right now!',
                imageAsset: 'no-sales'
              ),
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
