import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';

import '../../../utils/dimensions.dart';

class SwitchProfile extends StatefulWidget {
  const SwitchProfile({super.key});

  @override
  State<SwitchProfile> createState() => _SwitchProfileState();
}

class _SwitchProfileState extends State<SwitchProfile> {

  String selectedOption = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height20,
        ),
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Switch Account',
              style: TextStyle(
                fontSize: Dimensions.font22,
                fontWeight: FontWeight.w600,
                color: AppColors.color1,
              ),
            ),
            SizedBox(height: Dimensions.height5),
            Text('You are currently in customer mode'),
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
              child: Row(
                children: [
                  Container(
                    height: Dimensions.height70,
                    width: Dimensions.width70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.grey2,
                    ),
                  ),
                  SizedBox(width: Dimensions.width20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'John Doe',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: Dimensions.font20,
                              ),
                            ),
                            SizedBox(width: Dimensions.width10),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.width10,
                                vertical: Dimensions.height5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.color5,
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radius10,
                                ),
                              ),
                              child: Text(
                                'Verified',
                                style: TextStyle(
                                  fontSize: Dimensions.font12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.color1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Customer',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: Dimensions.font14,
                          ),
                        ),
                    
                      ],
                    ),
                  ),
                  Icon(Icons.circle_outlined,color: AppColors.color1,)
                  
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
              child: Row(
                children: [
                  Container(
                    height: Dimensions.height70,
                    width: Dimensions.width70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.grey2,
                    ),
                  ),
                  SizedBox(width: Dimensions.width20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'ABC Plumbing & Co.',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: Dimensions.font20,
                                ),
                              ),
                            ),
                            SizedBox(width: Dimensions.width10),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.width10,
                                vertical: Dimensions.height5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.color5,
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radius10,
                                ),
                              ),
                              child: Text(
                                'Verified',
                                style: TextStyle(
                                  fontSize: Dimensions.font12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.color1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Vendor',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: Dimensions.font14,
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(width: Dimensions.width20),
                  Icon(Icons.check_circle,color: AppColors.color1,size: Dimensions.iconSize24)

                ],
              ),
            ),
            SizedBox(height: Dimensions.height20,),
            CustomButton(text: 'Switch Account', onPressed: (){}),
            SizedBox(height: Dimensions.height20,),
            CustomButton(text: 'Cancel', onPressed: (){},
            backgroundColor: AppColors.white,
            borderColor: AppColors.color1,),
          ],
        ),
      ),
    );
  }
}
