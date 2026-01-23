import 'package:flutter/material.dart';
import 'package:fyndr_ng/controllers/auth_controller.dart';
import 'package:fyndr_ng/controllers/job_controller.dart';
import 'package:fyndr_ng/model/user_model.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:fyndr_ng/utils/dimensions.dart';
import 'package:get/get.dart';

import '../../../model/job_model.dart';
import '../../../routes/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthController authController = Get.find<AuthController>();
  JobController jobController = Get.find<JobController>();

  UserModel? get user => authController.userModel;

  // Controllers
  late final PageController pageController;
  late final List<String> pages; // Typed as List<String> for safety
  var currentPageIndex = 0.obs;

  @override
  void initState() {
    super.initState();

    // 1. Initialize List & Controller IMMEDIATELY
    pages = [
      AppConstants.getPngAsset('slider1'),
      AppConstants.getPngAsset('slider2'),
      AppConstants.getPngAsset('slider3'),
      AppConstants.getPngAsset('slider4'),
      AppConstants.getPngAsset('slider5'),
    ];
    pageController = PageController();

    // 2. Start API Calls & Auto Scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<JobController>().getUserJobs();
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    // 3. Clean up controller to prevent memory leaks
    pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      // Check 'mounted' to ensure widget still exists before animating
      if (mounted && pageController.hasClients) {
        int nextPageIndex = (currentPageIndex.value + 1) % pages.length;

        pageController.animateToPage(
          nextPageIndex,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
        );

        // Recursive call
        _startAutoScroll();
      }
    });
  }

  void onPageChanged(int index) {
    currentPageIndex.value = index;
  }

  final EdgeInsets _screenPadding = EdgeInsets.symmetric(
    horizontal: Dimensions.width20,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: Dimensions.bottomNavIconHeight + Dimensions.height50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Dimensions.height10 * 8),

            // --- HEADER ---
            Padding(
              padding: _screenPadding,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radius20 * 5),
                    child: Image.asset(
                      AppConstants.getPngAsset('user-icon'),
                      height: Dimensions.height10 * 6,
                      width: Dimensions.width10 * 6,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: Dimensions.width15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good Day',
                          style: TextStyle(fontSize: Dimensions.font17),
                        ),
                        Text(
                          user?.name ?? 'User',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: Dimensions.font22,
                            fontWeight: FontWeight.w600,
                            color: AppColors.color1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => Get.toNamed(AppRoutes.notificationScreen),
                    child: Container(
                      padding: EdgeInsets.all(Dimensions.width10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.color5,
                      ),
                      child: Image.asset(
                        AppConstants.getPngAsset('bell-icon'),
                        height: Dimensions.height20,
                        width: Dimensions.width20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: Dimensions.height10),

            // --- PROFILE WARNING ---
            if (user != null && !user!.isProfileComplete)
              Padding(
                padding: _screenPadding,
                child: InkWell(
                  onTap: () => Get.toNamed(AppRoutes.editProfile),
                  child: Container(
                    margin: EdgeInsets.only(top: Dimensions.height10),
                    padding: EdgeInsets.all(Dimensions.height10),
                    decoration: BoxDecoration(
                      color: AppColors.color5,
                      borderRadius: BorderRadius.circular(Dimensions.radius10),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          AppConstants.getPngAsset('info-icon'),
                          color: AppColors.color2,
                          height: 20,
                        ),
                        SizedBox(width: Dimensions.width10),
                        Expanded(
                          child: Text(
                            'Complete your profile in settings',
                            style: TextStyle(color: AppColors.color2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            SizedBox(height: Dimensions.height10),

            // --- BANNER ---
            Padding(
              padding: _screenPadding,
              child: Image.asset(
                AppConstants.getPngAsset('banner'),
                width: Dimensions.screenWidth,
                fit: BoxFit.fitWidth,
              ),
            ),

            SizedBox(height: Dimensions.height10),

            // --- RECENT REQUESTS ---
            Padding(
              padding: _screenPadding,
              child: Text(
                'RECENT REQUESTS',
                style: TextStyle(
                  fontSize: Dimensions.font15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.color1,
                ),
              ),
            ),
            SizedBox(height: Dimensions.height10),

            GetBuilder<JobController>(
              builder: (controller) {
                if (controller.jobLoading) {
                  return Center(
                    child: LinearProgressIndicator(color: AppColors.color1),
                  );
                }
                var recentJobs = controller.activeJobs.take(3).toList();

                if (recentJobs.isEmpty) {
                  return Padding(
                    padding: _screenPadding,
                    child: Center(
                      child: Text(
                        "No recent requests found.",
                        style: TextStyle(color: AppColors.grey4),
                      ),
                    ),
                  );
                }

                return SizedBox(
                  height: Dimensions.height10 * 9,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width20,
                    ),
                    itemCount: recentJobs.length,
                    itemBuilder: (context, index) {
                      var job = recentJobs[index];
                      return RequestCard(job);
                    },
                  ),
                );
              },
            ),

            SizedBox(height: Dimensions.height10),

            // --- POPULAR SERVICES ---
            Padding(
              padding: _screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'POPULAR SERVICES',
                    style: TextStyle(
                      fontSize: Dimensions.font15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.color1,
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ServiceCard('real-estate', 'Real Estate'),
                      ServiceCard('cleaning', 'Cleaning Service'),
                      ServiceCard('home-maintenance', 'Home Maintenance'),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: Dimensions.height10),


            SizedBox(
              height: Dimensions.height100 * 2.1,
              width: double.infinity,
              child: PageView.builder(
                controller: pageController,
                itemCount: pages.length,
                onPageChanged: onPageChanged,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: Dimensions.width10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage(pages[index]),
                      ),
                      border: Border.all(color: AppColors.grey4)
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: Dimensions.height20),
          ],
        ),
      ),
    );
  }

  // ... (Your ServiceCard and RequestCard widgets remain the same)
  Widget ServiceCard(String image, String title) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.requestForm, arguments: {'serviceTitle': title});
      },
      child: Container(
        height: Dimensions.height10 * 11.5,
        width: Dimensions.width10 * 12,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.color5),
          borderRadius: BorderRadius.circular(Dimensions.radius10),
        ),
        padding: EdgeInsets.all(Dimensions.width10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppConstants.getPngAsset(image), height: 40, width: 40),
            SizedBox(height: 10),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Dimensions.font13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget RequestCard(JobModel job) {
    String status = "Pending";
    if (job.status?.isOpen == true) status = "Open";
    if (job.status?.isInProgress == true) status = "Ongoing";
    if (job.status?.isCompleted == true) status = "Completed";

    return Container(
      width: Dimensions.screenWidth * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius10),
        border: Border.all(color: AppColors.color1.withOpacity(0.3)),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width15,
        vertical: Dimensions.height10,
      ),
      margin: EdgeInsets.only(right: Dimensions.width15),
      child: Row(
        children: [
          Container(
            width: Dimensions.width5,
            height: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.color4,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: Dimensions.width15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    fontSize: Dimensions.font12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey5,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  job.category?.toUpperCase() ?? 'SERVICE',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: Dimensions.font16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.color1,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '0 quotes',
                  style: TextStyle(
                    color: AppColors.grey4,
                    fontSize: Dimensions.font13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
