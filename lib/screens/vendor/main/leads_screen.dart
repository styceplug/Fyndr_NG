import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:fyndr_ng/utils/dimensions.dart';
import 'package:fyndr_ng/widgets/custom_appbar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/leads_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/app_constants.dart';

class VendorLeadScreen extends StatefulWidget {
  const VendorLeadScreen({super.key});

  @override
  State<VendorLeadScreen> createState() => _VendorLeadScreenState();
}

class _VendorLeadScreenState extends State<VendorLeadScreen> {
  LeadController leadController = Get.find<LeadController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      leadController.getLeads();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        leadingIcon: BackButton(),
        title: 'New Leads',
        actionIcon: InkWell(
          onTap: () {
            Get.toNamed(AppRoutes.vendorQuotesScreen);
          },
          child: Text(
            'Quotes',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.color1,
            ),
          ),
        ),
      ),
      body: GetBuilder<LeadController>(
        builder: (ctrl) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width20,
              vertical: Dimensions.height20,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildFilterTab(ctrl, 0, 'ALL'),
                    SizedBox(width: Dimensions.width20),
                    _buildFilterTab(ctrl, 1, 'HIGH PRIORITY'),
                    SizedBox(width: Dimensions.width20),
                    _buildFilterTab(ctrl, 2, 'NEARBY'),
                  ],
                ),
                SizedBox(height: Dimensions.height20),

                ctrl.leads.isEmpty
                    ? Expanded(child: Center(child: Text("No leads found")))
                    : Expanded(
                      child: ListView.builder(
                        itemCount: ctrl.leads.length,
                        itemBuilder: (context, index) {
                          return _buildLeadCard(ctrl.leads[index]);
                        },
                      ),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterTab(LeadController ctrl, int index, String title) {
    bool isSelected = ctrl.selectedTabIndex == index;
    return InkWell(
      onTap: () => ctrl.setFilterTab(index),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.color2 : AppColors.grey2,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.grey5,
            fontSize: Dimensions.font15,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
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

  Widget _buildLeadCard(var job) {
    // Format Budget (N5,000 - N20,000)
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_NG',
      symbol: 'N',
      decimalDigits: 0,
    );
    String budgetRange =
        "${currencyFormatter.format(job.budget?.min ?? 0)} - ${currencyFormatter.format(job.budget?.max ?? 0)}";

    // Construct Address
    String address = "${job.location?.lga ?? ''}, ${job.location?.state ?? ''}";
    if (address.trim() == ",") address = "Location Hidden";

    // Urgency Badge Logic
    bool isHighUrgency = job.urgency == 'high';

    String getImageForCategory(String? category) {
      String cat = (category ?? "").toLowerCase();
      if (cat.contains("real-estate"))
        return "real-estate"; // Ensure these match asset names
      if (cat.contains("cleaning")) return "cleaning";
      if (cat.contains("home-maintenance")) return "home-maintenance";
      return "beauty"; // Default asset
    }

    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.height15),
      child: InkWell(
        onTap: () {
          // Pass the specific job object to the details screen
          Get.toNamed(AppRoutes.vendorLeadDetailsScreen, arguments: job);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width10,
            vertical: Dimensions.height20,
          ),
          width: Dimensions.screenWidth,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey1),
            borderRadius: BorderRadius.circular(Dimensions.radius20),
            color: AppColors.grey1.withOpacity(0.2),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image Handling
              Container(
                height: Dimensions.height70,
                width: Dimensions.width70,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      AppConstants.getPngAsset(
                        getImageForCategory(job.category),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: Dimensions.width20),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Title (SubCategory or Description)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatServiceTitle(job.subcategory ?? job.category),

                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.color1,
                            fontSize: Dimensions.font16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width5,
                            vertical: Dimensions.height5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radius10*0.5),
                            color:
                            (job.urgency == 'normal')
                                ? AppColors.color2
                                : AppColors.error,
                          ),
                          child: Text(
                            job.urgency.toString().capitalizeFirst ?? '',
                            style: TextStyle(
                              fontSize: Dimensions.font10,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                      ],
                    ),
                    SizedBox(height: 4),
                    // Address
                    Text(
                      address,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.grey4,
                        fontSize: Dimensions.font12,
                      ),
                    ),
                    SizedBox(height: 4),
                    // Budget
                    Text(
                      budgetRange,
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: Dimensions.font15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    // Date
                    Text(
                      job.date != null
                          ? DateFormat(
                            'MMM dd, yyyy',
                          ).format(DateTime.parse(job.date!))
                          : "Flexible",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.grey4,
                        fontSize: Dimensions.font12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: Dimensions.width10),

              // Status / Urgency Badge
              if (isHighUrgency)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width15,
                    vertical: Dimensions.height5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.color2,
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                  ),
                  child: Text(
                    'HIGH',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: Dimensions.font12,
                    ),
                  ),
                ),

              SizedBox(width: Dimensions.width5),
              Icon(Icons.more_vert, color: AppColors.grey4),
            ],
          ),
        ),
      ),
    );
  }
}
