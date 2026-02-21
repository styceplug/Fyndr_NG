import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:fyndr_ng/utils/dimensions.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/chat_controller.dart';
import '../../model/job_model.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/snackbars.dart';

class JobInProgress extends StatefulWidget {
  const JobInProgress({super.key});

  @override
  State<JobInProgress> createState() => _JobInProgressState();
}

class _JobInProgressState extends State<JobInProgress> {
  late JobModel job;
  final ChatController chatController = Get.find<ChatController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null && Get.arguments is JobModel) {
      job = Get.arguments as JobModel;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.back();
        CustomSnackBar.failure(message: "Error loading job details");
      });
    }
  }

  // Helper for Price Formatting
  String _formatPrice(double? price) {
    final currencyFormatter = NumberFormat.currency(locale: 'en_NG', symbol: 'N');
    return currencyFormatter.format(price ?? 0);
  }

  // Helper for Date Formatting
  String _formatDate(String? dateStr) {
    if (dateStr == null) return "N/A";
    try {
      DateTime date = DateTime.parse(dateStr);
      return DateFormat('dd MMM HH:mm').format(date); // e.g., 12 Feb 14:30
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Safety check in case init failed
    if (!mounted) return SizedBox();

    // Determine Status Text & Color
    String statusText = "Pending";
    Color statusColor = AppColors.grey4;

    // Check Booking Progress to determine current state
    if (job.status?.isCompleted == true) {
      statusText = "Completed";
      statusColor = Colors.green;
    } else if (job.status?.isCancelled == true) {
      statusText = "Cancelled";
      statusColor = Colors.red;
    } else if (job.status?.isInProgress == true) {
      statusText = "In Progress";
      statusColor = Color(0XFF2583FF);
    } else {
      statusText = "Pending";
    }

    return Scaffold(
      appBar: CustomAppbar(title: 'Job Details', leadingIcon: BackButton()),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // --- STATUS BANNER ---
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width15,
                  vertical: Dimensions.height15,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1), // Dynamic bg color
                  borderRadius: BorderRadius.circular(Dimensions.radius10),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      AppConstants.getPngAsset('info-icon'),
                      color: statusColor,
                      fit: BoxFit.fill,
                      height: Dimensions.height10 * 3.5,
                      width: Dimensions.width10 * 3.5,
                    ),
                    SizedBox(width: Dimensions.width10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Job Status: $statusText',
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w500,
                            fontSize: Dimensions.font14,
                          ),
                        ),
                        Text(
                          job.status?.isInProgress == true ? 'Provider is working' : 'Update status below',
                          style: TextStyle(
                            color: statusColor.withOpacity(0.7),
                            fontSize: Dimensions.font13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: Dimensions.height20),

              // --- CUSTOMER CARD (For Vendor View) ---
              // Since this is "My Jobs" for a Vendor, we show the Customer info here
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  border: Border.all(color: AppColors.grey2),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Customer Avatar
                        Container(
                          height: Dimensions.height10 * 8,
                          width: Dimensions.width10 * 8,
                          decoration: BoxDecoration(
                            color: AppColors.grey2,
                            shape: BoxShape.circle,
                            image: (job.user?.avatar != null && job.user!.avatar!.isNotEmpty)
                                ? DecorationImage(
                              image: NetworkImage('${AppConstants.BASE_URL}${job.user!.avatar}'),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                          child: (job.user?.avatar == null || job.user!.avatar!.isEmpty)
                              ? Icon(Icons.person, color: AppColors.grey4)
                              : null,
                        ),
                        SizedBox(width: Dimensions.width20),

                        // Customer Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job.user?.businessDetails?.businessName ?? job.user?.name ?? "Unknown Customer",
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              // Rating (Hardcoded for now as it's not in JobModel user object usually)
                              Row(
                                children: [
                                  Icon(Iconsax.star1, color: Colors.orange, size: 16),
                                  SizedBox(width: 5),
                                  Text('4.5', style: TextStyle(fontWeight: FontWeight.w500)),
                                ],
                              ),
                              SizedBox(height: 5),
                              // Phone
                              Row(
                                children: [
                                  Icon(Iconsax.call, color: Colors.grey, size: 16),
                                  SizedBox(width: 5),
                                  Text(job.user?.number ?? job.user?.businessDetails?.businessRegNumber ?? "No Number"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.width20),

                    // --- ACTION BUTTONS ---
                    Row(
                      children: [
                        // Call Button
                        Expanded(
                          child: CustomButton(
                            text: 'Call',
                            onPressed: () {
                              if (job.user?.number != null) {
                                launchUrl(Uri.parse("tel:${job.user!.number}"));
                              }
                            },
                            backgroundColor: Color(0XFF2C2738),
                          ),
                        ),
                        SizedBox(width: Dimensions.width20),

                        // Chat Button
                        Expanded(
                          child: CustomButton(
                            text: 'Chat',
                            onPressed: () {
                              chatController.initiateChat(
                                job.id!,
                                job.user!.id!,
                                authController.userModel!.id!,
                              );
                            },
                            backgroundColor: AppColors.white,
                            borderColor: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: Dimensions.height20),

              // --- SERVICE DETAILS SECTION ---
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  'SERVICE DETAILS',
                  style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey4, // Changed from error color for better UI
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  border: Border.all(color: AppColors.grey2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(Iconsax.category, job.category?.toUpperCase() ?? "SERVICE"),
                    if (job.subcategory != null) ...[
                      SizedBox(height: 10),
                      _buildDetailRow(Iconsax.task_square, job.subcategory!),
                    ],
                    SizedBox(height: 10),
                    _buildDetailRow(Iconsax.note_text, job.description ?? "No description"),
                    SizedBox(height: 10),
                    _buildDetailRow(Iconsax.location, "${job.address?.street ?? ''}, ${job.location?.lga ?? ''}"),
                  ],
                ),
              ),

              SizedBox(height: Dimensions.height20),

              // --- JOB PROGRESS TIMELINE ---
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  'JOB PROGRESS',
                  style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey4,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  border: Border.all(color: AppColors.grey2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Render Timeline based on 'bookingProgress' list
                    if (job.bookingProgress != null && job.bookingProgress!.isNotEmpty)
                      ...job.bookingProgress!.map((progress) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: _buildProgressStep(
                              progress.status ?? "Update",
                              _formatDate(progress.timestamp),
                              true, // Assuming it's done if it's in the list
                              Colors.green
                          ),
                        );
                      }).toList()
                    else
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(child: Text("No progress updates yet")),
                      ),
                  ],
                ),
              ),

              SizedBox(height: Dimensions.height20),

              // --- PAYMENT SECTION ---
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  'PAYMENT',
                  style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey4,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  border: Border.all(color: AppColors.grey2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Service Amount',
                          style: TextStyle(
                            fontSize: Dimensions.font15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _formatPrice(job.budget?.preference?.toDouble()),
                          style: TextStyle(
                              fontSize: Dimensions.font15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.color1
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height10),
                    Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radius15),
                        border: Border.all(color: AppColors.black.withOpacity(0.1)),
                        color: AppColors.grey1,
                      ),
                      child: Text(
                        '• Pay provider directly in cash or transfer after service completion',
                        style: TextStyle(fontSize: 12, color: AppColors.grey5),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height100)
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget for Detail Rows
  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.grey4),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: AppColors.black),
          ),
        ),
      ],
    );
  }

  // Helper Widget for Timeline Steps
  Widget _buildProgressStep(String title, String time, bool isActive, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.circle,
          size: 14,
          color: isActive ? color : AppColors.grey2,
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
            Text(
              time,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: AppColors.grey4,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
