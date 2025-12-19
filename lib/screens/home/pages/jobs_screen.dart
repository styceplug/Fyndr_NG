import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/utils/dimensions.dart';
import 'package:fyndr_ng/widgets/custom_appbar.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:fyndr_ng/widgets/job_card.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';
import '../../../utils/colors.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
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
                        JobCard(
                          imageAsset: 'beauty',
                          title: 'Beauty Service',
                          location: 'Banana Island',
                          distance: '4.5km',
                          date: '12 Nov 2025',
                          dayTime: 'Morning',
                          timeAgo: '2h ago',
                          onTap: () {
                            Get.toNamed(AppRoutes.jobDetailsScreen);
                          },
                          quote: '4',
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        JobCard(
                          imageAsset: 'beauty',
                          title: 'Beauty Service',
                          location: 'Banana Island',
                          distance: '4.5km',
                          date: '12 Nov 2025',
                          dayTime: 'Morning',
                          timeAgo: '2h ago',
                          onTap: () {
                            Get.toNamed(AppRoutes.serviceCompletedScreen);
                          },
                          quote: '4',
                        ),
                      ],
                    ),
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
