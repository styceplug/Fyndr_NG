import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/widgets/custom_appbar.dart';

import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppbar(leadingIcon: BackButton(), title: 'Notifications'),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
          child: Column(
            children: [
              TabBar(
                indicatorColor: AppColors.color1,
                labelColor: Colors.black,
                unselectedLabelColor: AppColors.grey4,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 4,
                tabs: [
                  Tab(text: 'All'),
                  Tab(text: 'JOBS'),
                  Tab(text: 'MESSAGES'),
                ],
              ),
              SizedBox(height: Dimensions.height20),
              Expanded(
                child: TabBarView(
                  children: [
                    AllNotificationScreen(),
                    JobsNotificationScreen(),
                    MessagesNotificationScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget AllNotificationScreen() {
    return Column(
      children: [
        Align(
          alignment: AlignmentGeometry.centerLeft,
          child: Text(
            'TODAY',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: Dimensions.font14,
              fontWeight: FontWeight.w500,
              color: AppColors.error,
            ),
          ),
        ),
        SizedBox(height: Dimensions.height20),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width15,
            vertical: Dimensions.height15,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            border: Border.all(color: AppColors.grey2),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                AppConstants.getPngAsset('tick-icon'),
                height: Dimensions.height30,
                width: Dimensions.width30,
              ),
              SizedBox(width: Dimensions.width15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Job Completed',
                      style: TextStyle(
                        fontSize: Dimensions.font15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Your plumbing service with ABC Plumbing co has been completed. Please rate your experience.',
                      style: TextStyle(
                        fontSize: Dimensions.font12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(height: Dimensions.height5,),
                    Text(
                      '2 hours ago',
                      style: TextStyle(
                        fontSize: Dimensions.font12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget JobsNotificationScreen() {
    return Column(children: []);
  }

  Widget MessagesNotificationScreen() {
    return Column(children: []);
  }
}
