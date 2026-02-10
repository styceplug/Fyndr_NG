import 'package:flutter/material.dart';
import 'package:fyndr_ng/controllers/job_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fyndr_ng/utils/dimensions.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/widgets/custom_appbar.dart';

import '../../model/job_model.dart';
import '../../routes/routes.dart';
import '../../utils/colors.dart';
import '../../widgets/job_card.dart';


class MerchantQuotesScreen extends StatefulWidget {
  const MerchantQuotesScreen({Key? key}) : super(key: key);

  @override
  State<MerchantQuotesScreen> createState() => _MerchantQuotesScreenState();
}

class _MerchantQuotesScreenState extends State<MerchantQuotesScreen> {

  final JobController jobController = Get.find<JobController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      jobController.getQuotes();
    });
  }

  String getFullImageUrl(String? path) {
    if (path == null || path.isEmpty) return "";
    if (path.startsWith("http")) return path; // Already full URL
    return "${AppConstants.BASE_URL}$path"; // Prepend Base URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        leadingIcon: BackButton(),
        title: "My Quotes",
      ),
      body: RefreshIndicator(
        onRefresh: () async {

          await jobController.getQuotes();
        },
        color: AppColors.color1,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width20,
              vertical: Dimensions.height20,
            ),
            child: GetBuilder<JobController>(
              builder: (ctrl) {

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'QUOTES SUBMITTED',
                      style: TextStyle(
                        fontSize: Dimensions.font15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.color1,
                      ),
                    ),
                    SizedBox(height: Dimensions.height20),

                    if (ctrl.quotes.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: Dimensions.height100),
                          child: Column(
                            children: [
                              Icon(
                                Icons.description_outlined,
                                size: 60,
                                color: AppColors.grey3,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "You haven't submitted any quotes yet.",
                                style: TextStyle(
                                  color: AppColors.grey3,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: ctrl.quotes.length,
                        itemBuilder: (context, index) {
                          QuoteModel quote = ctrl.quotes[index];

                          // Format Price
                          String price = quote.amount.toString();

                          String locationText = "Unknown Location";
                          final location = quote.job?.location;
                          if (location != null) {
                            locationText = [
                              location.lga,
                              location.state,
                            ].where((e) => e != null && e.isNotEmpty).join(", ");
                          }

                          // Time logic
                          String timeText = quote.createdAt != null
                              ? DateFormat('MMM dd').format(DateTime.parse(quote.createdAt!))
                              : "N/A";

                          String? imageUrl;
                          if (quote.user?.avatar != null && quote.user!.avatar!.isNotEmpty) {
                            imageUrl = getFullImageUrl(quote.user?.avatar ?? '');
                          }

                          return Padding(
                            padding: EdgeInsets.only(bottom: Dimensions.height15),
                            child: QuotesCard(
                              imageAsset: imageUrl ?? 'head-icon',
                              isNetworkImage: imageUrl !=null,
                              title: quote.job?.category?.toUpperCase().replaceAll("-", " ") ?? "JOB REQUEST",
                              price: price,
                              location: locationText,
                              distance: quote.status?.toUpperCase() ?? 'PENDING',
                              timeAgo: timeText,
                              onTap: () {
                                Get.toNamed(
                                  AppRoutes.quoteDetailsScreen,
                                  arguments: {'quoteId': quote.id},
                                );
                              },
                              status: quote.status ?? '',
                            ),
                          );
                        },
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}