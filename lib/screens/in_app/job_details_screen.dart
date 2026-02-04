import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/job_controller.dart';
import '../../data/api/api_client.dart';
import '../../model/job_model.dart';
import '../../routes/routes.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/job_card.dart';

class JobDetailsScreen extends StatefulWidget {
  const JobDetailsScreen({Key? key}) : super(key: key);

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  String? jobId;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();

    print("🛠️ JobDetailsScreen Init. Arguments: ${Get.arguments}");

    JobModel? passedJob;

    // 1. Parse Arguments
    if (Get.arguments is JobModel) {
      passedJob = Get.arguments as JobModel;
      jobId = passedJob.id;
    } else if (Get.arguments is String) {
      jobId = Get.arguments;
    }

    // 2. Logic to run AFTER the screen builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<JobController>();

      // A. Set Initial Data (Optimistic UI)
      if (passedJob != null) {
        print("✅ Setting Initial Job Data: ${passedJob.id}");
        controller.setInitialJob(passedJob);
      }

      // B. Fetch Fresh Data (Quotes, etc.)
      if (jobId != null) {
        controller.getJobDetailsAndQuotes(jobId!);
      } else {
        print("❌ Error: Job ID is NULL.");
      }
    });
  }

  String formatMoney(int? amount) {
    if (amount == null) return "0";
    final formatter = NumberFormat("#,##0", "en_US");
    return formatter.format(amount);
  }

  String formatDate(String? dateString) {
    if (dateString == null) return "N/A";
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat("dd MMM yyyy - hh:mm a").format(date);
    } catch (e) {
      return dateString;
    }
  }

  String timeAgo(String? dateString) {
    if (dateString == null) return "Just now";
    try {
      DateTime created = DateTime.parse(dateString);
      Duration diff = DateTime.now().difference(created);
      if (diff.inDays > 0) return "${diff.inDays}d";
      if (diff.inHours > 0) return "${diff.inHours}h";
      return "${diff.inMinutes}m";
    } catch (e) {
      return "";
    }
  }

  String getFullImageUrl(String? path) {
    if (path == null || path.isEmpty) return "";
    if (path.startsWith("http")) return path; // Already full URL
    return "${AppConstants.BASE_URL}$path"; // Prepend Base URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Job Details', leadingIcon: BackButton()),
      body: GetBuilder<JobController>(
        builder: (controller) {
          if (controller.singleJob == null) {
            return Center(child: Text("Could not load job details."));
          }

          JobModel job = controller.singleJob!;
          List<QuoteModel> quotes = controller.quotesList;

          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width20,
              vertical: Dimensions.height20,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- IMAGE CAROUSEL ---
                  _buildImageSection(job),

                  SizedBox(height: Dimensions.height20),

                  // --- TITLE ---
                  Text(
                    formatServiceTitle(job.category ?? 'Service'),
                    style: TextStyle(
                      fontSize: Dimensions.font20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: Dimensions.height5),

                  // --- QUOTES BADGE ---
                  IntrinsicWidth(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.color3,
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius20,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width10,
                        vertical: Dimensions.height5,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.bookmark,
                            size: Dimensions.iconSize16 * 0.8,
                            color: Colors.white,
                          ),
                          SizedBox(width: Dimensions.width5),
                          Text(
                            '${quotes.length} quotes received',
                            style: TextStyle(
                              fontSize: Dimensions.font10,
                              color: AppColors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: Dimensions.height20),

                  // --- DETAILS ROW 1 ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailItem(
                        'Service type',
                        formatServiceTitle(job.category ?? "General"),
                      ),
                      _buildDetailItem('Date', formatDate(job.date)),
                    ],
                  ),

                  SizedBox(height: Dimensions.height20),

                  // --- DETAILS ROW 2 ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailItem(
                        'Location',
                        "${job.location?.lga ?? ''}, ${job.location?.state ?? ''}",
                      ),
                      _buildDetailItem(
                        'Budget',
                        "N${formatMoney(job.budget!.min?.toInt())} - N${formatMoney(job.budget!.max?.toInt())}",
                      ),
                    ],
                  ),

                  SizedBox(height: Dimensions.height20),

                  // --- DESCRIPTION ---
                  Text(
                    'Problem description',
                    style: TextStyle(
                      color: AppColors.grey5,
                      fontSize: Dimensions.font14,
                    ),
                  ),
                  SizedBox(height: Dimensions.height5),
                  Text(
                    job.description ?? "No description provided.",
                    style: TextStyle(
                      fontSize: Dimensions.font16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                  ),

                  SizedBox(height: Dimensions.height20),
                  Divider(color: AppColors.grey3),
                  SizedBox(height: Dimensions.height20),

                  // --- QUOTES LIST SECTION ---
                  Text(
                    'QUOTES RECEIVED',
                    style: TextStyle(
                      fontSize: Dimensions.font15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.color1,
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),

                  if (quotes.isEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "Waiting for merchants to bid...",
                          style: TextStyle(
                            color: AppColors.grey3,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    )
                  else
                    // Render the list of quotes
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: quotes.length,
                      itemBuilder: (context, index) {
                        QuoteModel quote = quotes[index];

                        // 1. Safely extract location (LGA, State)
                        String locationText = "Unknown Location";
                        final location =
                            quote.merchant?.businessDetails?.businessLocation;
                        if (location != null) {
                          // Joins LGA and State, filtering out nulls so you don't get ", "
                          locationText = [
                            location.lga,
                            location.state,
                          ].where((e) => e != null && e.isNotEmpty).join(", ");
                        }

                        String? imageUrl;
                        if (quote.merchant?.avatar != null && quote.merchant!.avatar!.isNotEmpty) {
                          imageUrl = getFullImageUrl(quote.merchant?.avatar);
                        }


                        return QuotesCard(
                          imageAsset: imageUrl ?? 'head-icon',
                          isNetworkImage: imageUrl !=null,
                          title: quote.merchant?.businessDetails?.businessName ?? "Unknown Merchant",
                          price: formatMoney(quote.amount?.toInt() ?? 0),
                          location: locationText,
                          distance: '',
                          timeAgo: quote.createdAt != null
                                  ? timeAgo(quote.createdAt!)
                                  : "Just now",
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.quoteDetailsScreen,
                              arguments: {'quoteId': quote.id},
                            );
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- HELPERS ---
  Widget _buildDetailItem(String title, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.grey5,
              fontSize: Dimensions.font14,
            ),
          ),
          SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: Dimensions.font16,
              fontWeight: FontWeight.w400,
              color: AppColors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(JobModel job) {
    bool hasImages = job.photos != null && job.photos!.isNotEmpty;

    return Column(
      children: [
        Container(
          height: Dimensions.height20 * 10,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.grey2,
            borderRadius: BorderRadius.circular(Dimensions.radius20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radius20),
            child:
                hasImages
                    ? PageView.builder(
                      itemCount: job.photos!.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                      // Inside _buildImageSection
                      itemBuilder: (context, index) {
                        String imgString = job.photos![index];

                        // 1. Handle Base64 (Optimization for local preview, if used)
                        if (imgString.startsWith('data:image')) {
                          String cleanBase64 = imgString.split(',').last;
                          return Image.memory(
                            base64Decode(cleanBase64),
                            fit: BoxFit.cover,
                          );
                        }
                        // 2. Handle Full URL
                        else if (imgString.startsWith('http')) {
                          return Image.network(imgString, fit: BoxFit.cover);
                        }
                        // 3. Handle Relative Path (The Fix for your new API response)
                        else {
                          // Prepend your Base URL
                          String fullUrl =
                              "${Get.find<ApiClient>().appBaseUrl}$imgString";
                          return Image.network(fullUrl, fit: BoxFit.cover);
                        }
                      },
                    )
                    : Center(
                      child: Image.asset(AppConstants.getGifAsset('frame')),
                    ),
          ),
        ),
        if (hasImages && job.photos!.length > 1)
          Padding(
            padding: EdgeInsets.only(top: Dimensions.height10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(job.photos!.length, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _currentImageIndex == index
                            ? AppColors.color2
                            : AppColors.grey5,
                  ),
                );
              }),
            ),
          ),
      ],
    );
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
}
