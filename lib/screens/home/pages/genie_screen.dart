import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:fyndr_ng/utils/dimensions.dart';
import 'package:fyndr_ng/widgets/custom_appbar.dart';
import 'package:fyndr_ng/widgets/custom_textfield.dart';

class GenieScreen extends StatefulWidget {
  const GenieScreen({super.key});

  @override
  State<GenieScreen> createState() => _GenieScreenState();
}

class _GenieScreenState extends State<GenieScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height70,
        ),
        child: Column(
          children: [
            Text(
              'Genie AI',
              style: TextStyle(
                fontSize: Dimensions.font20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: Dimensions.height5),
            Text(
              'I’ll help you get quotes from verified providers',
              style: TextStyle(
                fontSize: Dimensions.font12,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: Dimensions.height10),
            Container(
              height: 1,
              width: Dimensions.screenWidth,
              color: AppColors.grey3,
            ),
            SizedBox(height: Dimensions.height30),
            //chat card
            /*Align(
              alignment: AlignmentGeometry.centerRight,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 7,
                    right: 0,
                    child: Image.asset(
                      AppConstants.getPngAsset('caret'),
                      height: Dimensions.height30,

                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width10,
                      vertical: Dimensions.height10,
                    ),
                    margin: EdgeInsets.only(bottom: Dimensions.height20),
                    decoration: BoxDecoration(
                      color: AppColors.color2,
                      borderRadius: BorderRadius.circular(Dimensions.radius10),
                    ),
                    child: Text(
                      'Painting',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),*/
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width50),
              child: Text(
                'Hi John Doe, what are you looking for today?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Dimensions.font18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Spacer(),
            CustomTextField(
              maxLines: 3,
              suffixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    AppConstants.getPngAsset('mic-icon'),
                    height: Dimensions.height40,
                    width: Dimensions.width40,
                  ),
                  SizedBox(width: Dimensions.width10),
                  Image.asset(
                    AppConstants.getPngAsset('send-icon'),
                    height: Dimensions.height40,
                    width: Dimensions.width40,
                  ),
                  SizedBox(width: Dimensions.width10),
                ],
              ),
              hintText: 'Type Something',
            ),
          ],
        ),
      ),
    );
  }
}
