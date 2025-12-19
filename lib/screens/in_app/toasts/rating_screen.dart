import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fyndr_ng/routes/routes.dart';
import 'package:get/get.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double _currentRating = 3.0;

  String get _ratingLabel {
    if (_currentRating >= 4.5) return 'Excellent!';
    if (_currentRating >= 4.0) return 'Great!';
    if (_currentRating >= 3.0) return 'Good';
    if (_currentRating >= 2.0) return 'Fair';
    return 'Poor';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(
            Dimensions.width20,
            Dimensions.height100,
            Dimensions.width20,
            Dimensions.height70,
          ),
          width: Dimensions.screenWidth,
          child: Column(
            children: [
              Image.asset(
                AppConstants.getPngAsset('experience-icon'),
                height: Dimensions.height100,
                width: Dimensions.width100,
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                'ABC Plumbing Co.',
                style: TextStyle(
                  fontSize: Dimensions.font20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.color1,
                ),
              ),
              SizedBox(height: Dimensions.height5),
              Text(
                'How was your experience?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Dimensions.font14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey5,
                ),
              ),
              SizedBox(height: Dimensions.height20),

              Text(
                'Overall Rating',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Dimensions.font14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: Dimensions.height10),

              RatingBar.builder(
                initialRating: _currentRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 40,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder:
                    (context, _) => Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  setState(() {
                    _currentRating = rating;
                  });
                },
              ),
              SizedBox(height: Dimensions.height10),

              Text(
                '$_currentRating - $_ratingLabel',
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.color2,
                ),
              ),

              SizedBox(height: Dimensions.height20),
              Divider(color: AppColors.grey2),
              SizedBox(height: Dimensions.height20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'RATE SPECIFIC ASPECT',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: Dimensions.font14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.color1,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10),

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width15,
                  vertical: Dimensions.height20,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey2),
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
                child: Column(
                  children: [
                    _buildSpecificRatingRow('Professionalism'),
                    SizedBox(height: Dimensions.height15),
                    _buildSpecificRatingRow('ABC Plumbing Co.'),
                    SizedBox(height: Dimensions.height15),
                    _buildSpecificRatingRow('Communication'),
                    SizedBox(height: Dimensions.height15),
                    _buildSpecificRatingRow('Value for Money'),
                  ],
                ),
              ),

              SizedBox(height: Dimensions.height20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'WRITE A REVIEW (OPTIONAL)',
                  style: TextStyle(
                    fontSize: Dimensions.font14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.color1,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10),
              CustomTextField(
                hintText: 'Share your experience to help other customers...',
                maxLines: 4,
              ),

              SizedBox(height: Dimensions.height30),

              CustomButton(
                text: 'Submit Rating',
                onPressed: () {
                  Get.toNamed(AppRoutes.thankYouScreen);
                },
              ),
              SizedBox(height: Dimensions.height20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to avoid repeating code for specific rows
  Widget _buildSpecificRatingRow(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: Dimensions.font14,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
        ),
        RatingBar.builder(
          initialRating: 0,
          // Start empty or 5 depending on preference
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: false,
          itemCount: 5,
          itemSize: 20,
          // Smaller stars for sub-categories
          itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: (rating) {
            // You can store these in a map or individual variables if needed
          },
        ),
      ],
    );
  }
}
