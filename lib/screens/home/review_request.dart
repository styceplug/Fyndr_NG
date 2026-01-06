import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:get/get.dart';

import '../../model/service_model.dart';
import '../../utils/dimensions.dart';
import '../../widgets/custom_appbar.dart';

class ReviewRequestScreen extends StatefulWidget {
  const ReviewRequestScreen({super.key});

  @override
  State<ReviewRequestScreen> createState() => _ReviewRequestScreenState();
}

class _ReviewRequestScreenState extends State<ReviewRequestScreen> {

  ServiceRequestData? data;

  @override
  void initState() {
    super.initState();
    if (Get.arguments is ServiceRequestData) {
      data = Get.arguments;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) return Scaffold(body: Center(child: Text("No Data Provided")));
    return Scaffold(
      appBar: CustomAppbar(leadingIcon: BackButton(), title: 'Review Request'),
      body: Container(
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        padding: EdgeInsets.fromLTRB(
          Dimensions.width20,
          Dimensions.height5,
          Dimensions.width20,
          Dimensions.height10 * 5,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReviewCard('Service type', data!.serviceType),
              SizedBox(height: Dimensions.height15),
              ReviewCard('Location', data!.location),
              SizedBox(height: Dimensions.height15),
              ReviewCard('Date & Time', data!.dateTime),
              SizedBox(height: Dimensions.height15),
              ReviewCard('Urgency', data!.urgency),
              SizedBox(height: Dimensions.height15),
              ReviewCard('Budget range', data!.budgetRange),
              SizedBox(height: Dimensions.height15),
              ReviewCard('Problem Description', data!.description),
              SizedBox(height: Dimensions.height20,),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height10,
                ),
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
                        color: AppColors.color1,
                      ),
                    ),
                    SizedBox(height: Dimensions.height5),
                    Align(
                      alignment: AlignmentGeometry.center,
                      child: Text(
                        'N 0',
                        style: TextStyle(
                          fontSize: Dimensions.font25,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height5),
                    Text(
                      'One-time fee to send your requests to verified providers. You will receive quotes within 24 hours',
                      style: TextStyle(
                        fontSize: Dimensions.font13,
                        fontWeight: FontWeight.w300,
                        color: AppColors.color1,
                      ),
                    ),
          
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height50),
              CustomButton(text: 'Pay N0 & Send Request', onPressed: (){})
          
            ],
          ),
        ),
      ),
    );
  }

  Widget ReviewCard(String title, String subtitle) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width10,
        vertical: Dimensions.height10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius10),
        border: Border.all(color: AppColors.grey4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: Dimensions.font13,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: Dimensions.height10),
                Text(subtitle, style: TextStyle(fontSize: Dimensions.font15,overflow: TextOverflow.ellipsis,)),
              ],
            ),
          ),
          Text('Edit', style: TextStyle(color: AppColors.color2)),
        ],
      ),
    );
  }
}
