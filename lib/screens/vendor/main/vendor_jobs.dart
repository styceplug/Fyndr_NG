import 'package:flutter/material.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../routes/routes.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/job_card.dart';

class VendorJobs extends StatefulWidget {
  const VendorJobs({super.key});

  @override
  State<VendorJobs> createState() => _VendorJobsState();
}

class _VendorJobsState extends State<VendorJobs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppbar(title: 'My Jobs'),
        body: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width20,
            vertical: Dimensions.height20,
          ),
          child: Column(
            children: [
              TabBar(
                indicatorColor: AppColors.color1,
                labelColor: AppColors.color1,
                unselectedLabelColor: AppColors.grey2,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                padding: EdgeInsets.only(bottom: Dimensions.height20),
                labelPadding: EdgeInsets.only(bottom: Dimensions.height10),
                indicatorWeight: 4,
                tabs: [Text('ACTIVE'), Text('COMPLETED'), Text('CANCELLED')],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: Dimensions.height20,
                            horizontal: Dimensions.width20,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius20,
                            ),
                            border: Border.all(color: AppColors.grey2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '23 Nov 18:50',
                                    style: TextStyle(
                                      fontSize: Dimensions.font13,
                                      color: AppColors.grey3,
                                    ),
                                  ),
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
                                      'Ongoing',
                                      style: TextStyle(
                                        fontSize: Dimensions.font13,
                                        color: AppColors.color2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: Dimensions.height10),
                              Text(
                                'Kitchen Sink repair',
                                style: TextStyle(
                                  fontSize: Dimensions.font18,
                                  color: AppColors.color2,
                                ),
                              ),
                              SizedBox(height: Dimensions.height10),
                              Row(
                                children: [
                                  Text(
                                    'Lekki Phase 1',
                                    style: TextStyle(
                                      fontSize: Dimensions.font14,
                                      color: AppColors.grey4,
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.width20),
                                  Text(
                                    '1.2km',
                                    style: TextStyle(
                                      fontSize: Dimensions.font14,
                                      color: AppColors.grey4,
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.width20),
                                  Text(
                                    'John Doe',
                                    style: TextStyle(
                                      fontSize: Dimensions.font14,
                                      color: AppColors.grey4,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: Dimensions.height10),
                              Text(
                                'N140,000',
                                style: TextStyle(
                                  fontSize: Dimensions.font15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: Dimensions.height10),
                              Divider(color: AppColors.grey2),
                              SizedBox(height: Dimensions.height10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomButton(
                                    text: 'Call',
                                    onPressed: () {},
                                    backgroundColor: AppColors.black,
                                    icon: Icon(
                                      Iconsax.call,
                                      color: AppColors.white,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Dimensions.width20,
                                      vertical: Dimensions.height10,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.radius15,
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.width20),
                                  CustomButton(
                                    text: 'Chat',
                                    onPressed: () {},
                                    backgroundColor: AppColors.white,
                                    icon: Icon(
                                      Iconsax.message,
                                      color: AppColors.black,
                                    ),
                                    borderColor: AppColors.black,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Dimensions.width20,
                                      vertical: Dimensions.height10,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.radius15,
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.width20),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Dimensions.width20,
                                      vertical: Dimensions.height10,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        Dimensions.radius15,
                                      ),
                                      border: Border.all(
                                        color: AppColors.black,
                                      ),
                                      color: AppColors.black,
                                    ),
                                    child: Icon(
                                      Iconsax.location5,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: Dimensions.height10),
                              CustomButton(
                                text: 'Mark as completed',
                                onPressed: () {},
                                backgroundColor: AppColors.color2,
                                padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.width20,
                                  vertical: Dimensions.height10,
                                ),
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radius15,
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                    Center(child: Text('COMPLETED')),
                    Center(child: Text('CANCELLED')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
