import 'package:flutter/material.dart';
import 'package:fyndr_ng/routes/routes.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:get/get.dart';

import '../../../utils/dimensions.dart';

class SwitchProfile extends StatefulWidget {
  const SwitchProfile({super.key});

  @override
  State<SwitchProfile> createState() => _SwitchProfileState();
}

class _SwitchProfileState extends State<SwitchProfile> {
  // defaulting to 'customer' so one is active by default
  String selectedOption = 'customer';

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
            Text(
              'You are currently in customer mode',
              style: TextStyle(color: AppColors.grey5),
            ),
            SizedBox(height: Dimensions.height20),

            // --- CUSTOMER CARD ---
            _buildAccountCard(
              name: 'John Doe',
              role: 'Customer',
              value: 'customer', // This ID tracks the selection
              isVerified: true,
            ),

            SizedBox(height: Dimensions.height20),

            // --- VENDOR CARD ---
            _buildAccountCard(
              name: 'ABC Plumbing & Co.',
              role: 'Vendor',
              value: 'vendor', // This ID tracks the selection
              isVerified: true,
            ),

            SizedBox(height: Dimensions.height20),

            // --- ACTION BUTTONS ---
            CustomButton(
              text: 'Switch Account',
              onPressed: () {
                if (selectedOption == 'vendor') {
                  // Navigate to Vendor Home
                  // Get.offAllNamed(AppRoutes.vendorHomeScreen);
                  print("Switching to Vendor...");
                  Get.offAllNamed(AppRoutes.vendorLoadingScreen);
                } else {
                  // Navigate to Customer Home
                  // Get.offAllNamed(AppRoutes.homeScreen);
                  print("Switching to Customer...");
                }
              },
            ),
            SizedBox(height: Dimensions.height20),
            CustomButton(
              text: 'Cancel',
              onPressed: () {
                Get.back();
              },
              backgroundColor: AppColors.white,
              borderColor: AppColors.color1,
            ),
          ],
        ),
      ),
    );
  }

  // --- REUSABLE CARD WIDGET ---
  Widget _buildAccountCard({
    required String name,
    required String role,
    required String value,
    bool isVerified = false,
  }) {
    bool isSelected = selectedOption == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height20,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.color5.withOpacity(0.1) : Colors.transparent, // Optional bg highlight
          borderRadius: BorderRadius.circular(Dimensions.radius20),
          border: Border.all(
            // Change border color if selected
            color: isSelected ? AppColors.color1 : AppColors.grey2,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Placeholder Avatar
            Container(
              height: Dimensions.height70,
              width: Dimensions.width70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.grey2,
              ),
              child: Icon(Icons.person, color: AppColors.grey5),
            ),
            SizedBox(width: Dimensions.width20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: Dimensions.font20,
                          ),
                        ),
                      ),
                      if (isVerified) ...[
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
                      ]
                    ],
                  ),
                  Text(
                    role,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: Dimensions.font14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: Dimensions.width10),

            // Dynamic Selection Icon
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? AppColors.color1 : AppColors.grey3,
              size: Dimensions.iconSize24,
            )
          ],
        ),
      ),
    );
  }
}
