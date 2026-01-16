import 'package:flutter/material.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:get/get.dart';

import '../../../controllers/vendor_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/custom_appbar.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class GetVerifiedVendors extends StatefulWidget {
  const GetVerifiedVendors({Key? key}) : super(key: key);

  @override
  State<GetVerifiedVendors> createState() => _GetVerifiedVendorsState();
}

class _GetVerifiedVendorsState extends State<GetVerifiedVendors> {
  final VendorController controller = Get.find<VendorController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(leadingIcon: BackButton(), title: 'Get Verified'),
      body: GetBuilder<VendorController>(builder: (ctrl) {

        var businessStatus = ctrl.businessDoc != null
            ? VerificationStatus.completed
            : VerificationStatus.active;

        // Step 2 is active only if Step 1 is done
        var ownerStatus = ctrl.businessDoc == null
            ? VerificationStatus.pending
            : (ctrl.ownerIdDoc != null ? VerificationStatus.completed : VerificationStatus.active);

        // Step 3 is active only if Step 2 is done
        var locStatus = ctrl.ownerIdDoc == null
            ? VerificationStatus.pending
            : (ctrl.locationDoc != null ? VerificationStatus.completed : VerificationStatus.active);

        // Submit Button is enabled only if all 3 are done
        bool canSubmit = ctrl.businessDoc != null && ctrl.ownerIdDoc != null && ctrl.locationDoc != null;

        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width20, vertical: Dimensions.height20),
            width: Dimensions.screenWidth,
            child: Column(
              children: [
                // ... Header Image & Text (Same as before) ...
                Image.asset(AppConstants.getPngAsset('rheel-verif'), height: Dimensions.height12 * 10),
                SizedBox(height: Dimensions.height10),
                Text('RheelTech Verification', style: TextStyle(fontSize: Dimensions.font22, fontWeight: FontWeight.w600, color: AppColors.color1)),
                // ...

                SizedBox(height: Dimensions.height20),
                Align(alignment: Alignment.centerLeft, child: Text('REQUIRED DOCUMENTS', style: TextStyle(fontSize: Dimensions.font14, fontWeight: FontWeight.w600, color: AppColors.color1))),
                SizedBox(height: Dimensions.height10),

                // --- 1. BUSINESS DOC ---
                _buildVerificationCard(
                  title: 'Business Documents',
                  subtitle: ctrl.businessDoc != null ? 'File selected' : 'CAC, Business License, or Tax ID',
                  iconAsset: 'doc-icon',
                  status: businessStatus,
                  onButtonPressed: () => ctrl.pickDocument('business'),
                ),
                SizedBox(height: Dimensions.height10),

                // --- 2. OWNER ID ---
                _buildVerificationCard(
                  title: 'Owner ID Verification',
                  subtitle: ctrl.ownerIdDoc != null ? 'File selected' : 'Government issued ID card',
                  iconAsset: 'veri-tick',
                  status: ownerStatus,
                  onButtonPressed: () => ctrl.pickDocument('owner'),
                ),
                SizedBox(height: Dimensions.height10),

                // --- 3. ADDRESS PROOF ---
                _buildVerificationCard(
                  title: 'Physical Address',
                  subtitle: ctrl.locationDoc != null ? 'File selected' : 'Utility bill or lease agreement',
                  iconAsset: 'address',
                  status: locStatus,
                  onButtonPressed: () => ctrl.pickDocument('location'),
                ),
                SizedBox(height: Dimensions.height10),

                // --- 4. SCREENING (Automated) ---
                _buildVerificationCard(
                  title: 'Background Screening',
                  subtitle: 'Automated verification process',
                  iconAsset: 'screening',
                  status: VerificationStatus.pending, // Always pending until submitted
                  hideButton: true, // No upload needed
                ),

                SizedBox(height: Dimensions.height20),

                // ... Info Box (Same as before) ...

                SizedBox(height: Dimensions.height20),

                // --- SUBMIT BUTTON ---
                ctrl.isSubmitting
                    ? CircularProgressIndicator(color: AppColors.color1)
                    : CustomButton(
                    text: 'Submit for Verification',
                    isDisabled: !canSubmit, // Grey out if files missing
                    onPressed: () {
                      ctrl.submitVendorRegistration();
                    }
                ),

                SizedBox(height: Dimensions.height10),
                // ... Disclaimer Text ...
                SizedBox(height: Dimensions.height30),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildVerificationCard({
    required String title,
    required String subtitle,
    required String iconAsset,
    required VerificationStatus status,
    VoidCallback? onButtonPressed,
    bool hideButton = false,
  }) {
    final bool isActive = status == VerificationStatus.active;
    final bool isCompleted = status == VerificationStatus.completed;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20, vertical: Dimensions.height20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(
          color: isActive ? AppColors.color1 : AppColors.grey2,
          width: isActive ? 1.5 : 1,
        ),
        color: isCompleted ? AppColors.color1.withOpacity(0.05) : Colors.transparent, // Slight tint if done
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                AppConstants.getPngAsset(iconAsset),
                height: Dimensions.height30, width: Dimensions.width30, fit: BoxFit.contain,
                color: status == VerificationStatus.pending ? AppColors.grey4 : null,
              ),
              SizedBox(width: Dimensions.width10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w500, fontSize: Dimensions.font16)),
                    Text(subtitle, style: TextStyle(fontWeight: FontWeight.w300, fontSize: Dimensions.font12, color: AppColors.grey5)),
                  ],
                ),
              ),
              if (isCompleted) Icon(Icons.check_circle, color: AppColors.color2)
              else if (isActive) Icon(Icons.circle_outlined, color: AppColors.color1)
              else Icon(Icons.circle_outlined, color: AppColors.grey4),
            ],
          ),
          if (isActive && !hideButton) ...[
            SizedBox(height: Dimensions.height20),
            CustomButton(
              text: 'Upload Document',
              onPressed: onButtonPressed ?? () {},
              backgroundColor: AppColors.black,
             
            ),
          ]
        ],
      ),
    );
  }
}

enum VerificationStatus {
  pending,
  active,
  completed,
}