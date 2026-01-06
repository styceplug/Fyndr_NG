import 'package:flutter/material.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/custom_appbar.dart';

class GetVerifiedVendors extends StatefulWidget {
  const GetVerifiedVendors({super.key});

  @override
  State<GetVerifiedVendors> createState() => _GetVerifiedVendorsState();
}


class _GetVerifiedVendorsState extends State<GetVerifiedVendors> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(leadingIcon: BackButton(), title: 'Get Verified'),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width20,
            vertical: Dimensions.height20,
          ),
          // REMOVED: height: Dimensions.screenHeight (This prevents scrolling on small screens)
          width: Dimensions.screenWidth,
          child: Column(
            children: [
              // --- HEADER IMAGE ---
              Image.asset(
                AppConstants.getPngAsset('rheel-verif'),
                height: Dimensions.height12 * 10,
              ),
              SizedBox(height: Dimensions.height10),

              // --- HEADER TEXT ---
              Text(
                'RheelTech Verification',
                style: TextStyle(
                  fontSize: Dimensions.font22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.color1,
                ),
              ),
              SizedBox(height: Dimensions.height5),
              Text(
                'Get verified to receive high-quality leads and \nbuild trust with customers',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Dimensions.font14,
                  fontWeight: FontWeight.w300,
                  color: AppColors.grey5,
                ),
              ),
              SizedBox(height: Dimensions.height20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'REQUIRED DOCUMENTS',
                  style: TextStyle(
                    fontSize: Dimensions.font14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.color1,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10),

              // --- 1. COMPLETED STEP ---
              _buildVerificationCard(
                title: 'Business Documents',
                subtitle: 'CAC, Business License, or Tax ID',
                iconAsset: 'doc-icon',
                status: VerificationStatus.completed,
              ),
              SizedBox(height: Dimensions.height10),

              // --- 2. ACTIVE STEP (Expanded) ---
              _buildVerificationCard(
                title: 'Owner ID Verification',
                subtitle: 'Government issued ID card',
                iconAsset: 'veri-tick',
                status: VerificationStatus.active,
                onButtonPressed: () {
                  // Handle Upload Logic
                  print("Upload ID Clicked");
                },
              ),
              SizedBox(height: Dimensions.height10),

              // --- 3. PENDING STEP ---
              _buildVerificationCard(
                title: 'Physical Address',
                subtitle: 'Utility bill or lease agreement',
                iconAsset: 'address',
                status: VerificationStatus.pending,
              ),
              SizedBox(height: Dimensions.height10),

              // --- 4. LOCKED/AUTOMATED STEP ---
              _buildVerificationCard(
                title: 'Background Screening',
                subtitle: 'Automated verification process',
                iconAsset: 'screening',
                status: VerificationStatus.pending, // Or create a 'locked' status
              ),
              SizedBox(height: Dimensions.height20),

              // --- INFO BOX ---
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height20,
                ),
                width: Dimensions.screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  border: Border.all(color: AppColors.grey2),
                  color: const Color(0XFFEDF9Fb),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verification Timeline',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color(0XFF6BABFF),
                      ),
                    ),
                    SizedBox(height: Dimensions.height10),
                    Text(
                      '• Document review: 24-48 hours\n• Background check: 2 -3 days\n• Total: 3 - 5 business days',
                      style: TextStyle(
                        color: const Color(0XFF6BABFF),
                        height: 1.5, // Better spacing for list
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: Dimensions.height20),

              // --- SUBMIT BUTTON ---
              CustomButton(
                  text: 'Submit for Verification',
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.vendorVerificationInProgressScreen);
                  }
              ),

              SizedBox(height: Dimensions.height10),

              // --- BOTTOM DISCLAIMER ---
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height20,
                ),
                width: Dimensions.screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  border: Border.all(color: AppColors.grey2),
                  color: AppColors.grey2.withOpacity(0.3),
                ),
                child: Text(
                  'You’ll be notified via SMS and email when verification is complete',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey5,
                    fontSize: Dimensions.font12,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height30), // Padding at bottom for scrolling
            ],
          ),
        ),
      ),
    );
  }

  // --- REUSABLE WIDGET FOR VERIFICATION ITEMS ---
  Widget _buildVerificationCard({
    required String title,
    required String subtitle,
    required String iconAsset,
    required VerificationStatus status,
    VoidCallback? onButtonPressed,
  }) {
    // Determine colors based on status
    final bool isActive = status == VerificationStatus.active;
    final bool isCompleted = status == VerificationStatus.completed;

    final Color textColor = (isActive || isCompleted) ? AppColors.black : AppColors.grey4;
    final Color iconColor = (isActive || isCompleted) ? Colors.transparent : AppColors.grey4; // Transparent if using original asset colors

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width20,
        vertical: Dimensions.height20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(
          color: isActive ? AppColors.color1 : AppColors.grey2, // Highlight border if active
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Icon
              Image.asset(
                AppConstants.getPngAsset(iconAsset),
                height: Dimensions.height30,
                width: Dimensions.width30,
                fit: BoxFit.contain,
                // Apply grey color filter only if pending
                color: status == VerificationStatus.pending ? AppColors.grey4 : null,
              ),
              SizedBox(width: Dimensions.width10),

              // Text Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w500,
                          fontSize: Dimensions.font16
                      ),
                    ),
                    Text(
                      subtitle,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: Dimensions.font12,
                        color: isActive ? AppColors.grey5 : AppColors.grey4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: Dimensions.width10),

              // Status Indicator Icon
              if (isCompleted)
                Icon(Icons.check_circle, color: AppColors.color2)
              else if (isActive)
                Icon(Icons.circle_outlined, color: AppColors.color1)
              else
                Icon(Icons.circle_outlined, color: AppColors.grey4),
            ],
          ),

          // Show Button only if Active
          if (isActive) ...[
            SizedBox(height: Dimensions.height20),
            CustomButton(
              text: 'Upload ID',
              onPressed: onButtonPressed ?? () {},
              backgroundColor: AppColors.black,
              padding: EdgeInsets.symmetric(
                vertical: Dimensions.height10,
              ),
            ),
          ]
        ],
      ),
    );
  }
}

// Simple Enum to manage logic
enum VerificationStatus {
  pending,
  active,
  completed,
}