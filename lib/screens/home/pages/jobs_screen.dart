import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/utils/dimensions.dart';
import 'package:fyndr_ng/widgets/custom_appbar.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:fyndr_ng/widgets/job_card.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/job_controller.dart';
import '../../../model/job_model.dart';
import '../../../routes/routes.dart';
import '../../../utils/colors.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}


class _JobsScreenState extends State<JobsScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<JobController>().getUserJobs();
    });
  }

  // Helper to calculate "2h ago", "3 days ago"
  String timeAgo(String? dateString) {
    if (dateString == null) return "Just now";
    try {
      DateTime created = DateTime.parse(dateString);
      Duration diff = DateTime.now().difference(created);
      if (diff.inDays > 1) return "${diff.inDays} days ago";
      if (diff.inHours > 1) return "${diff.inHours}h ago";
      if (diff.inMinutes > 1) return "${diff.inMinutes}m ago";
      return "Just now";
    } catch (e) {
      return "Recently";
    }
  }

  // Helper to format display date "12 Nov 2025"
  String formatDate(String? dateString) {
    if (dateString == null) return "N/A";
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat("dd MMM yyyy").format(date);
    } catch (e) {
      return dateString;
    }
  }

  // Helper to choose image based on category
  String getImageForCategory(String? category) {
    String cat = (category ?? "").toLowerCase();
    if (cat.contains("real-estate")) return "real-estate"; // Ensure these match asset names
    if (cat.contains("cleaning")) return "cleaning";
    if (cat.contains("home-maintenance")) return "home-maintenance";
    return "beauty"; // Default asset
  }

  String formatServiceTitle(String? slug) {
    if (slug == null || slug.isEmpty) return 'Service Order';

    return slug
        .split('-') // ["real", "estate"]
        .map(
          (word) =>
      word.isNotEmpty
          ? word[0].toUpperCase() + word.substring(1)
          : '',
    )
        .join(' ') // "Real Estate"
        .trim() +
        ' Order'; // "Real Estate Order"
  }
  

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppbar(title: 'My Jobs'),
        body: GetBuilder<JobController>(builder: (jobController) {

          return Container(
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
                      // --- ACTIVE JOBS TAB ---
                      _buildJobList(jobController.activeJobs, "No active jobs"),

                      // --- COMPLETED JOBS TAB ---
                      _buildJobList(jobController.completedJobs, "No completed jobs"),

                      // --- CANCELLED JOBS TAB ---
                      _buildJobList(jobController.cancelledJobs, "No cancelled jobs"),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildJobList(List<JobModel> jobs, String emptyMessage) {
    if (jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work_off_outlined, size: 50, color: AppColors.grey3),
            SizedBox(height: 10),
            Text(emptyMessage, style: TextStyle(color: AppColors.grey3)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        JobModel job = jobs[index];
        int quoteCount = job.quotes?.length ?? 0;
        String quoteText = quoteCount == 1 ? "1" : "$quoteCount";
        return JobCard(
          imageAsset: getImageForCategory(job.category),
          title: formatServiceTitle(job.category),
          location: "${job.location?.lga ?? ''}, ${job.location?.state ?? ''}",
          distance: job.location?.state ?? "NG", // API doesn't give distance, showing State
          date: formatDate(job.date),
          dayTime: job.urgency?.capitalizeFirst ?? "Normal", // Using urgency as tag
          timeAgo: timeAgo(job.createdAt),
          quote: quoteText,
          onTap: () {
            Get.toNamed(AppRoutes.jobDetailsScreen, arguments: job);
          },
        );
      },
    );
  }
}
