import 'package:flutter/material.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/chat_controller.dart';
import '../../../controllers/job_controller.dart';
import '../../../model/job_model.dart';
import '../../../routes/routes.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/job_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/snackbars.dart';


class VendorJobs extends StatefulWidget {
  const VendorJobs({Key? key}) : super(key: key);

  @override
  State<VendorJobs> createState() => _VendorJobsState();
}

class _VendorJobsState extends State<VendorJobs> {
  final JobController jobController = Get.find<JobController>();
  final ChatController chatController = Get.find<ChatController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      jobController.getMerchantJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppbar(
            leadingIcon: BackButton(),
            title: 'My Jobs'
        ),
        body: GetBuilder<JobController>(
          builder: (ctrl) {

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
                    tabs: [
                      Text('ACTIVE (${ctrl.merchantActiveJobs.length})'),
                      Text('COMPLETED (${ctrl.merchantCompletedJobs.length})'),
                      Text('CANCELLED (${ctrl.merchantCancelledJobs.length})')
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildJobList(ctrl.merchantActiveJobs, isActive: true),
                        _buildJobList(ctrl.merchantCompletedJobs, isActive: false),
                        _buildJobList(ctrl.merchantCancelledJobs, isActive: false),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildJobList(List<JobModel> jobs, {required bool isActive}) {
    if (jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work_off_outlined, size: 50, color: AppColors.grey3),
            SizedBox(height: 10),
            Text("No jobs found", style: TextStyle(color: AppColors.grey4)),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: jobs.length,
      separatorBuilder: (_, __) => SizedBox(height: Dimensions.height20),
      itemBuilder: (context, index) {
        return _buildJobCard(jobs[index], isActive);
      },
    );
  }

  Widget _buildJobCard(JobModel job, bool isActive) {
    // Format Date
    String dateStr = job.date != null
        ? DateFormat('dd MMM HH:mm').format(DateTime.parse(job.date!))
        : "N/A";

    // Format Price
    final currencyFormatter = NumberFormat.currency(locale: 'en_NG', symbol: 'N');
    String price = currencyFormatter.format(job.budget?.preference ?? 0);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.height20,
        horizontal: Dimensions.width20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: AppColors.grey2),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Date & Status Tag
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateStr,
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
                  color: isActive ? AppColors.color5 : AppColors.grey2,
                  borderRadius: BorderRadius.circular(Dimensions.radius10),
                ),
                child: Text(
                  isActive ? 'Ongoing' : (job.status?.isCancelled == true ? 'Cancelled' : 'Completed'),
                  style: TextStyle(
                    fontSize: Dimensions.font13,
                    color: isActive ? AppColors.color2 : AppColors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height10),

          // Job Title (Description snippet)
          Text(
            job.description ?? "Service Request",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: Dimensions.font18,
              color: AppColors.color2,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: Dimensions.height10),

          // Location & Customer Info
          Row(
            children: [
              Icon(Icons.location_on, size: 14, color: AppColors.grey4),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  "${job.location?.lga ?? ''}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: Dimensions.font14, color: AppColors.grey4),
                ),
              ),
              SizedBox(width: Dimensions.width20),

              Icon(Icons.person, size: 14, color: AppColors.grey4),
              SizedBox(width: 4),
              Text(
                job.user?.name ?? 'Customer',
                style: TextStyle(fontSize: Dimensions.font14, color: AppColors.grey4),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height10),

          // Price
          Text(
            price,
            style: TextStyle(
              fontSize: Dimensions.font15,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: Dimensions.height10),
          Divider(color: AppColors.grey2),
          SizedBox(height: Dimensions.height10),

          // Action Buttons (Only show actions if Active)
          if (isActive) ...[
            Row(
              children: [
                // CALL
                Expanded(
                  child: CustomButton(
                    text: 'Call',
                    onPressed: () {
                      if (job.user?.number != null) {
                        launchUrl(Uri.parse("tel:${job.user!.number}"));
                      } else {
                        CustomSnackBar.failure(message: "No phone number available");
                      }
                    },
                    backgroundColor: AppColors.black,
                    icon: Icon(Iconsax.call, color: AppColors.white, size: 18),

                  ),
                ),
                SizedBox(width: 10),

                // CHAT
                Expanded(
                  child: CustomButton(
                    text: 'Chat',
                    onPressed: () {
                      // Initiate Chat: Job ID, Customer ID (from job), Vendor ID (me)
                      chatController.initiateChat(
                        job.id!,
                        job.user!.id!, // Customer
                        Get.find<AuthController>().userModel!.id!, // Me (Vendor)
                      );
                      // Navigation handled inside initiateChat
                    },
                    backgroundColor: AppColors.white,
                    icon: Icon(Iconsax.message, color: AppColors.black, size: 18),
                    borderColor: AppColors.black,

                  ),
                ),
                SizedBox(width: 10),

                // MAP (Location)
                InkWell(
                  onTap: () {
                    // Open Maps Logic
                    if (job.location?.coordinates != null) {
                      final lat = job.location!.coordinates![1];
                      final lng = job.location!.coordinates![0];
                      launchUrl(Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng"));
                    }
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                      color: AppColors.black,
                    ),
                    child: Icon(Iconsax.location5, color: AppColors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height10),

            // COMPLETE BUTTON
            CustomButton(
              text: 'Mark as completed',
              onPressed: () => jobController.completeJob(job.id!),
              backgroundColor: AppColors.color2,
            ),
          ],
        ],
      ),
    );
  }
}
