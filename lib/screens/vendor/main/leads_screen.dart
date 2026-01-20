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
    leadController.getLeads();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(leadingIcon: BackButton(), title: 'New Leads'),
      body: GetBuilder<LeadController>(builder: (ctrl){
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
      }),
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

  Widget _buildLeadCard(var job) {
    // Format Budget (N5,000 - N20,000)
    final currencyFormatter = NumberFormat.currency(locale: 'en_NG', symbol: 'N', decimalDigits: 0);
    String budgetRange = "${currencyFormatter.format(job.budget?.min ?? 0)} - ${currencyFormatter.format(job.budget?.max ?? 0)}";

    // Construct Address
    String address = "${job.address?.street ?? ''}, ${job.location?.lga ?? ''}";
    if (address.trim() == ",") address = "Location Hidden";

    // Urgency Badge Logic
    bool isHighUrgency = job.urgency == 'high';

    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.height15),
      child: InkWell(
        onTap: () {
          // Pass the specific job object to the details screen
          Get.toNamed(AppRoutes.vendorLeadDetailsScreen, arguments: {'job': job});
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Handling
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: (job.photos != null && job.photos!.isNotEmpty)
                    ? Image.network(
                  job.photos![0],
                  width: Dimensions.width50,
                  height: Dimensions.width50,
                  fit: BoxFit.cover,
                  errorBuilder: (_,__,___) => Image.asset(AppConstants.getPngAsset('kitchen-sink'), width: Dimensions.width50),
                )
                    : Image.asset(
                  AppConstants.getPngAsset('kitchen-sink'), // Fallback asset
                  width: Dimensions.width50,
                ),
              ),

              SizedBox(width: Dimensions.width20),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Title (SubCategory or Description)
                    Text(
                      job.subCategory?.toUpperCase() ?? job.category ?? 'Service',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.color1,
                        fontSize: Dimensions.font16,
                        fontWeight: FontWeight.bold,
                      ),
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
                          ? DateFormat('MMM dd, yyyy').format(DateTime.parse(job.date!))
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
                    style: TextStyle(color: AppColors.white, fontSize: Dimensions.font12),
                  ),
                ),

              SizedBox(width: Dimensions.width5),
              Icon(Icons.more_vert, color: AppColors.grey4)
            ],
          ),
        ),
      ),
    );
  }
}
