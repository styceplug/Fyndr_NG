import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/dispute_controller.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_textfield.dart';

class DisputeScreen extends StatelessWidget {
  DisputeScreen({super.key});

  final DisputeController ctrl = Get.find<DisputeController>();

  final List<Map<String, String>> categories = const [
    {"value": "unreachable", "label": "Unreachable"},
    {"value": "overcharging", "label": "Overcharging"},
    {"value": "fraud", "label": "Fraud / Scam"},
    {"value": "damage", "label": "Damage"},
    {"value": "poor-quality", "label": "Poor Quality"},
    {"value": "late-arrival", "label": "Late Arrival"},
    {"value": "no-show", "label": "No Show"},
    {"value": "other", "label": "Other"},
  ];

  final List<Map<String, String>> priorities = const [
    {"value": "low", "label": "Low"},
    {"value": "medium", "label": "Medium"},
    {"value": "high", "label": "High"},
  ];

  @override
  Widget build(BuildContext context) {
    ctrl.initFromArgs(Get.arguments);

    return Scaffold(
      appBar: CustomAppbar(
        leadingIcon: const BackButton(),
        title: "Report & Raise Dispute",
      ),
      body: GetBuilder<DisputeController>(
        builder: (_) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width20,
              vertical: Dimensions.height20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(Dimensions.width15),
                  decoration: BoxDecoration(
                    color: AppColors.color5,
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                    border: Border.all(color: AppColors.grey2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "You’re about to report this conversation",
                        style: TextStyle(
                          fontSize: Dimensions.font16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: Dimensions.height5),
                      Text(
                        ctrl.vendorName != null
                            ? "Vendor: ${ctrl.vendorName}"
                            : "Vendor: ${ctrl.vendorId ?? 'Unknown'}",
                        style: TextStyle(
                          fontSize: Dimensions.font12,
                          color: AppColors.grey5,
                        ),
                      ),
                      SizedBox(height: Dimensions.height5),
                      Text(
                        "We’ll review your report and take action if needed.",
                        style: TextStyle(
                          fontSize: Dimensions.font12,
                          color: AppColors.grey5,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: Dimensions.height20),

                Text(
                  "Subject",
                  style: TextStyle(
                    fontSize: Dimensions.font14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: Dimensions.height5),
                CustomTextField(
                  controller: ctrl.subjectCtrl,
                  hintText: "e.g. Vendor overcharged for service",
                  maxLines: 1,
                ),

                SizedBox(height: Dimensions.height15),

                Text(
                  "Category",
                  style: TextStyle(
                    fontSize: Dimensions.font14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: Dimensions.height5),
                _dropdown(
                  value: ctrl.selectedCategory.value,
                  items: categories,
                  onChanged: (v) {
                    if (v == null) return;
                    ctrl.selectedCategory.value = v;
                    ctrl.update();
                  },
                ),

                SizedBox(height: Dimensions.height15),

                Text(
                  "Priority",
                  style: TextStyle(
                    fontSize: Dimensions.font14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: Dimensions.height10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children:
                      priorities.map((p) {
                        final isSelected =
                            ctrl.selectedPriority.value == p['value'];
                        return InkWell(
                          onTap: () {
                            ctrl.selectedPriority.value = p['value']!;
                            ctrl.update();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width15,
                              vertical: Dimensions.height10,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? AppColors.color2 : Colors.white,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? AppColors.color2
                                        : AppColors.grey3,
                              ),
                            ),
                            child: Text(
                              p['label']!,
                              style: TextStyle(
                                fontSize: Dimensions.font12,
                                color:
                                    isSelected ? Colors.white : AppColors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),

                SizedBox(height: Dimensions.height15),

                Text(
                  "Transaction Reference (optional)",
                  style: TextStyle(
                    fontSize: Dimensions.font14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: Dimensions.height5),
                CustomTextField(
                  controller: ctrl.transactionRefCtrl,
                  hintText: "e.g. TXN-2024-001234",
                  maxLines: 1,
                ),

                SizedBox(height: Dimensions.height15),

                Text(
                  "Description",
                  style: TextStyle(
                    fontSize: Dimensions.font14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: Dimensions.height5),
                CustomTextField(
                  controller: ctrl.descriptionCtrl,
                  hintText:
                      "Explain what happened. Add amounts, dates, agreements, etc.",
                  maxLines: 6,
                ),

                SizedBox(height: Dimensions.height20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => ctrl.submitDispute(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.color2,
                      padding: EdgeInsets.symmetric(
                        vertical: Dimensions.height15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                      ),
                    ),
                    child: Text(
                              "Submit Dispute",
                              style: TextStyle(
                                fontSize: Dimensions.font14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),

                SizedBox(height: Dimensions.height10),

                Center(
                  child: Text(
                    "False reports may lead to account restrictions.",
                    style: TextStyle(
                      fontSize: Dimensions.font10,
                      color: AppColors.grey4,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _dropdown({
    required String value,
    required List<Map<String, String>> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey3),
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items:
              items
                  .map(
                    (e) => DropdownMenuItem<String>(
                      value: e['value'],
                      child: Text(e['label'] ?? ''),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
