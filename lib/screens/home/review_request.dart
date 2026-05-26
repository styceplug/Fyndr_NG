import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyndr_ng/controllers/job_controller.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:get/get.dart';

import '../../controllers/app_controller.dart';
import '../../model/job_model.dart';
import '../../routes/routes.dart';
import '../../utils/dimensions.dart';
import '../../widgets/custom_appbar.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ReviewRequestScreen extends StatefulWidget {
  const ReviewRequestScreen({Key? key}) : super(key: key);

  @override
  State<ReviewRequestScreen> createState() => _ReviewRequestScreenState();
}

class _ReviewRequestScreenState extends State<ReviewRequestScreen> {
  ServiceRequestData? data;
  AppController appController = Get.find<AppController>();
  JobController jobController = Get.find<JobController>();

  @override
  void initState() {
    super.initState();
    if (Get.arguments is ServiceRequestData) {
      data = Get.arguments;
    }
  }

  void _confirmAndSend() {
    if (data == null) return;

    String categorySlug = _getApiCategorySlug(data!.serviceType);
    String apiDate = "${data!.rawDate}T${data!.rawTime}:00Z";

    Map<String, dynamic> apiBody = {
      "category": categorySlug,
      if (data!.subcategory != null && data!.subcategory!.isNotEmpty)
        "subCategory": data!.subcategory!.toLowerCase(),

      // --- LOCATION BLOCK ---
      "location": {
        "state": data!.state ?? "Unknown",
        "lga": data!.city ?? "Unknown",
        "type": "Point",
        "coordinates": [data!.lng ?? 0.0, data!.lat ?? 0.0]
      },

      // --- ADDRESS BLOCK ---
      "address": {
        "street": (data!.street != null && data!.street!.isNotEmpty) ? data!.street : "Nil",
        "houseNumber": (data!.houseNumber != null && data!.houseNumber!.isNotEmpty)
            ? data!.houseNumber
            : "N/A",
        "additionalDirections": "None"
      },

      "date": apiDate,
      "urgency": data!.urgency.toLowerCase(),
      "budget": {
        "min": int.tryParse(data!.minBudget.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
        "max": int.tryParse(data!.maxBudget.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
        "preference": int.tryParse(data!.minBudget.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0
      },
      "description": data!.description,
      "specialRequirements": [],
      "status": {
        "isOpen": true
      }
    };

    jobController.createJob(apiBody, data!.images);
  }

  String _getApiCategorySlug(String uiTitle) {
    String lowerTitle = uiTitle.toLowerCase();

    if (lowerTitle.contains("cleaning")) {
      return "cleaning";
    } else if (lowerTitle.contains("maintenance")) {
      return "home-maintenance";
    } else if (lowerTitle.contains("real estate")) {
      return "real-estate";
    }
    return lowerTitle.replaceAll(' ', '-');
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Scaffold(body: Center(child: Text("No Data Provided")));
    }

    return Scaffold(
      appBar: CustomAppbar(leadingIcon: const BackButton(), title: 'Review Request'),
      body: Container(
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width20,
            vertical: Dimensions.height10
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // --- STEP 0: LOCATION & SERVICE TYPE ---
              if (data!.serviceType.isNotEmpty)
                ReviewCard(
                    'Service type',
                    data!.serviceType,
                    onEdit: () => Get.back(result: 0)
                ),

              if (data!.subcategory != null && data!.subcategory!.isNotEmpty) ...[
                SizedBox(height: Dimensions.height15),
                ReviewCard(
                    'Sub Category',
                    data!.subcategory!,
                    // Subcategory is chosen on the Description screen (Step 3)
                    onEdit: () => Get.back(result: 3)
                ),
              ],

              if (data!.displayLocation.isNotEmpty) ...[
                SizedBox(height: Dimensions.height15),
                ReviewCard(
                    'Location',
                    data!.displayLocation,
                    onEdit: () => Get.back(result: 0)
                ),
              ],

              // --- STEP 1: DATE & TIME / URGENCY ---
              if (data!.displayDate.isNotEmpty) ...[
                SizedBox(height: Dimensions.height15),
                ReviewCard(
                    'Date & Time',
                    data!.displayDate,
                    onEdit: () => Get.back(result: 1)
                ),
              ],

              if (data!.urgency.isNotEmpty) ...[
                SizedBox(height: Dimensions.height15),
                ReviewCard(
                    'Urgency',
                    data!.urgency,
                    onEdit: () => Get.back(result: 1)
                ),
              ],

              // --- STEP 2: BUDGET ---
              if (data!.displayBudget.isNotEmpty) ...[
                SizedBox(height: Dimensions.height15),
                ReviewCard(
                    'Budget range',
                    data!.displayBudget,
                    onEdit: () => Get.back(result: 2)
                ),
              ],

              // --- STEP 3: DESCRIPTION ---
              if (data!.description.isNotEmpty) ...[
                SizedBox(height: Dimensions.height15),
                ReviewCard(
                    'Problem Description',
                    data!.description,
                    onEdit: () => Get.back(result: 3)
                ),
              ],

              SizedBox(height: Dimensions.height20),

              // --- FEE CONTAINER ---
              Container(
                padding: EdgeInsets.all(Dimensions.width20),
                width: Dimensions.screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius10),
                  border: Border.all(color: AppColors.grey4),
                  color: AppColors.color5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Connection Fee',
                        style: TextStyle(
                            fontSize: Dimensions.font16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.color1
                        )
                    ),
                    SizedBox(height: Dimensions.height5),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                            'N 0',
                            style: TextStyle(
                                fontSize: Dimensions.font25,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black
                            )
                        )
                    ),
                    SizedBox(height: Dimensions.height5),
                    Text(
                        'One-time fee to send your requests to verified providers.',
                        style: TextStyle(
                            fontSize: Dimensions.font13,
                            fontWeight: FontWeight.w300,
                            color: AppColors.color1
                        )
                    ),
                  ],
                ),
              ),

              // --- PHOTOS (STEP 3) ---
              if (data!.images != null && data!.images!.isNotEmpty) ...[
                SizedBox(height: Dimensions.height15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "Attached Photos:",
                        style: TextStyle(
                            fontSize: Dimensions.font13,
                            fontWeight: FontWeight.w300
                        )
                    ),
                    InkWell(
                      onTap: () => Get.back(result: 3), // Route back to Step 3 to edit photos
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        child: Text(
                            'Edit',
                            style: TextStyle(
                                color: AppColors.color2,
                                fontWeight: FontWeight.w500
                            )
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: Dimensions.height10),
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: data!.images!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: FileImage(File(data!.images![index].path)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],

              SizedBox(height: Dimensions.height50),

              // --- SUBMIT BUTTON ---
              CustomButton(
                text:'Send Request',
                onPressed: _confirmAndSend,
              ),
              SizedBox(height: Dimensions.height50),

            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGET ---
  Widget ReviewCard(String title, String subtitle, {required VoidCallback onEdit}) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius10),
          border: Border.all(color: AppColors.grey4)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        title,
                        style: TextStyle(
                            fontSize: Dimensions.font13,
                            fontWeight: FontWeight.w300
                        )
                    ),
                    SizedBox(height: Dimensions.height10),
                    Text(
                        subtitle,
                        style: TextStyle(fontSize: Dimensions.font15)
                    ),
                  ]
              )
          ),
          InkWell(
            onTap: onEdit,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
              child: Text(
                  'Edit',
                  style: TextStyle(
                      color: AppColors.color2,
                      fontWeight: FontWeight.w500
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }
}
