import 'package:flutter/material.dart';
import 'package:fyndr_ng/controllers/auth_controller.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../controllers/job_controller.dart';
import '../../../model/job_model.dart';
import '../../../model/user_model.dart';
import '../../../routes/routes.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';

class VendorHome extends StatefulWidget {
  const VendorHome({super.key});

  @override
  State<VendorHome> createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  AuthController authController = Get.find<AuthController>();

  UserModel? get user => authController.userModel;
  bool showBanner = true;
  final JobController jobController = Get.find<JobController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      jobController.getMerchantJobs();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? avatarUrl = authController.userModel?.avatar;
    if (avatarUrl != null &&
        avatarUrl.isNotEmpty &&
        !avatarUrl.startsWith('http')) {
      avatarUrl = '${AppConstants.BASE_URL}$avatarUrl';
    }

    String? displayUrl;
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      if (avatarUrl.startsWith('http')) {
        displayUrl = avatarUrl;
      } else {
        displayUrl = '${AppConstants.BASE_URL}$avatarUrl';
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: GetBuilder<AuthController>(
          builder: (authController) {

            bool isAvailable = authController.userModel?.isAvailable ?? true;

            return Container(
              width: Dimensions.screenWidth,
              padding: EdgeInsets.fromLTRB(
                Dimensions.width20,
                Dimensions.height100,
                Dimensions.width20,
                Dimensions.height50,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showBanner) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width20,
                        vertical: Dimensions.height10,
                      ),
                      width: Dimensions.screenWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius10,
                        ),
                        border: Border.all(color: AppColors.grey2),
                        color: AppColors.color2.withOpacity(0.3),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'You are currently in Vendor mode',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.color1,
                              fontSize: Dimensions.font13,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                showBanner = false;
                              });
                            },
                            child: Icon(Icons.cancel, color: AppColors.error),
                          ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: Dimensions.height20),
                  Row(
                    children: [
                      Container(
                        height: Dimensions.height10 * 6,
                        width: Dimensions.width10 * 6,
                        decoration: BoxDecoration(
                          color: AppColors.color3,
                          shape: BoxShape.circle,
                          image:
                              displayUrl != null
                                  ? DecorationImage(
                                    fit: BoxFit.cover,
                                    // 'cover' usually looks better for avatars than 'fill'
                                    image: NetworkImage(displayUrl),
                                  )
                                  : null, // No image decoration if null
                        ),
                        // 3. Fallback Child if no image
                        child:
                            displayUrl == null
                                ? Center(
                                  child: Image.asset(
                                    AppConstants.getPngAsset('head-icon'),
                                    height: Dimensions.height30,
                                    // Adjust size to fit inside circle
                                    width: Dimensions.width30,
                                    fit: BoxFit.contain,
                                  ),
                                )
                                : null,
                      ),
                      SizedBox(width: Dimensions.width20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back',
                              style: TextStyle(
                                fontSize: Dimensions.font13,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              user?.businessDetails?.businessName ??
                                  'Business Name',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: Dimensions.font17,
                                fontWeight: FontWeight.w600,
                                color: AppColors.color1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Switch(
                            value: isAvailable,
                            onChanged: (value) {
                              authController.toggleUserAvailability(value);
                            },
                            activeColor: AppColors.color2,
                            activeTrackColor: AppColors.color3,
                            inactiveThumbColor: AppColors.white,
                          ),
                          Text(
                            'Pause Account',
                            style: TextStyle(fontSize: Dimensions.font10),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height10),
                  Divider(color: AppColors.grey2),
                  SizedBox(height: Dimensions.height10),
                  Text('Today,', style: TextStyle(color: AppColors.grey5)),
                  SizedBox(height: Dimensions.height5),
                  InkWell(
                    onTap: () {
                      Get.toNamed(AppRoutes.vendorEarningsScreen);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'N${user?.todayEarnings ?? '0.'}',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: Dimensions.font25,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                        Text(
                          '00',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: Dimensions.font20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'More info',
                          style: TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: Dimensions.height5),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width20,
                          vertical: Dimensions.height20,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.grey1),
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius20,
                          ),
                          color: AppColors.grey1.withOpacity(0.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Active Jobs',
                                  style: TextStyle(color: AppColors.grey3),
                                ),
                                Text(
                                  '${user?.activeJobs ?? 0}',
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: Dimensions.font17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: Dimensions.width10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Jobs Completed',
                                  style: TextStyle(color: AppColors.grey3),
                                ),
                                Text(
                                  '0',
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: Dimensions.font17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Total Earnings',
                                    style: TextStyle(color: AppColors.grey3),
                                  ),
                                  Text(
                                    'N${user?.totalEarnings ?? '0'}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: Dimensions.font17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height20),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width20,
                      vertical: Dimensions.height20,
                    ),
                    width: Dimensions.screenWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius10),
                      border: Border.all(color: AppColors.color5),
                      color: AppColors.color2.withOpacity(0.2),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${user?.newLeads ?? 0} New Leads',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.color1,
                                fontSize: Dimensions.font13,
                              ),
                            ),
                            Text(
                              '0 plumbing requests nearby',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: AppColors.color1,
                                fontSize: Dimensions.font13,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed(AppRoutes.vendorLeadsScreen);
                          },
                          child: Text(
                            'View all',
                            style: TextStyle(
                              fontSize: Dimensions.font13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.color1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'SCHEDULED JOBS',
                      style: TextStyle(
                        fontSize: Dimensions.font14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.color1,
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height10),
                  GetBuilder<JobController>(
                    builder: (controller) {

                      if (controller.merchantActiveJobs.isEmpty) {
                        return Container(
                          padding: EdgeInsets.all(20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.grey2),
                            borderRadius: BorderRadius.circular(Dimensions.radius20),
                          ),
                          child: Center(
                            child: Text(
                              "No active jobs scheduled.",
                              style: TextStyle(color: AppColors.grey4),
                            ),
                          ),
                        );
                      }

                      // Show up to 3 Active Jobs
                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true, // Vital for nesting in ScrollView
                        physics: NeverScrollableScrollPhysics(), // Scroll handled by parent
                        itemCount: controller.merchantActiveJobs.take(3).length,
                        separatorBuilder: (_, __) => SizedBox(height: Dimensions.height15),
                        itemBuilder: (context, index) {
                          return _buildScheduledJobCard(controller.merchantActiveJobs[index]);
                        },
                      );
                    },
                  ),

                  SizedBox(height: Dimensions.height20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildScheduledJobCard(JobModel job) {
    String time = "N/A";
    if (job.date != null) {
      try {
        time = DateFormat('hh:mm a').format(DateTime.parse(job.date!));
      } catch (e) {
        time = "TBD";
      }
    }

    // Format Price
    final currencyFormatter = NumberFormat.currency(locale: 'en_NG', symbol: 'N');
    String price = currencyFormatter.format(job.budget?.preference ?? 0);

    // Image Logic
    String imageAsset = AppConstants.getPngAsset('kitchen-sink'); // Default
    bool isNetworkImage = false;
    String? networkImgUrl;

    if (job.photos != null && job.photos!.isNotEmpty) {
      isNetworkImage = true;
      String raw = job.photos![0];
      networkImgUrl = raw.startsWith('http') ? raw : '${AppConstants.BASE_URL}$raw';
    }

    return InkWell(
      onTap: () {
        // Navigate to Job Progress
        Get.toNamed(AppRoutes.jobInProgress, arguments: job);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height10,
        ),
        width: Dimensions.screenWidth,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey1),
          borderRadius: BorderRadius.circular(Dimensions.radius20),
          color: Colors.white,
        ),
        child: Row(
          children: [
            // Job Image
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.grey2,
                image: isNetworkImage
                    ? DecorationImage(
                    image: NetworkImage(networkImgUrl!),
                    fit: BoxFit.cover)
                    : DecorationImage(
                    image: AssetImage(imageAsset),
                    fit: BoxFit.cover),
              ),
            ),
            SizedBox(width: Dimensions.width20),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    job.category?.capitalizeFirst ?? 'Service',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.color1,
                      fontSize: Dimensions.font14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${job.address?.street ?? 'Unknown'}, ${job.location?.lga ?? ''}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.grey4,
                      fontSize: Dimensions.font12,
                    ),
                  ),
                  Text(
                    price,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: Dimensions.font13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: Dimensions.width10),

            // Time
            Text(
              time,
              style: TextStyle(
                  color: AppColors.color1,
                  fontSize: Dimensions.font12,
                  fontWeight: FontWeight.w500
              ),
            ),
          ],
        ),
      ),
    );
  }
}
