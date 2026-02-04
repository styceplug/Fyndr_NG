import 'package:flutter/material.dart';
import 'package:fyndr_ng/controllers/job_controller.dart';
import 'package:fyndr_ng/widgets/custom_textfield.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../controllers/leads_controller.dart';
import '../../../model/job_model.dart';
import '../../../routes/routes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_button.dart';



class VendorLeadDetailsScreen extends StatefulWidget {
  const VendorLeadDetailsScreen({super.key});

  @override
  State<VendorLeadDetailsScreen> createState() =>
      _VendorLeadDetailsScreenState();
}

class _VendorLeadDetailsScreenState extends State<VendorLeadDetailsScreen> {
  final LeadController leadController = Get.find<LeadController>();
  JobController jobController = Get.find<JobController>();
  int _activeImageIndex = 0;
  late JobModel passedJob;

  @override
  void initState() {
    super.initState();

    passedJob = Get.arguments as JobModel;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (passedJob.id != null) {
        jobController.getJobDetailsAndQuotes(passedJob.id!);
      }
    });
  }

  String buildFileUrl(String? path) {
    if (path == null || path.trim().isEmpty) return '';
    if (path.startsWith('http://') || path.startsWith('https://')) return path;

    // Your API base
    const base = "https://api.fyndr.ng";
    return path.startsWith('/') ? '$base$path' : '$base/$path';
  }

  String formatServiceTitle(String? slug) {
    if (slug == null || slug.trim().isEmpty) return 'Service Order';

    final cleaned = slug
        .trim()
        .replaceAll('_', '-')
        .replaceAll(RegExp(r'-+'), '-');

    final words =
        cleaned.split('-').where((w) => w.isNotEmpty).map((w) {
          final lower = w.toLowerCase();
          return lower[0].toUpperCase() + lower.substring(1);
        }).toList();

    return '${words.join(' ')} Order';
  }

  Widget availabilityChip(String label, String value, StateSetter setModalState) {
    final selected = leadController.availability == value;

    return InkWell(
      onTap: () {
        setModalState(() {
          leadController.setAvailability(value);
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width10,
          vertical: Dimensions.height10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(
            color: selected ? AppColors.color2 : AppColors.grey4,
          ),
          color: selected ? AppColors.color2.withOpacity(0.12) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.color2 : AppColors.grey4,
          ),
        ),
      ),
    );
  }

  Widget addonChip(String label, StateSetter setModalState) {
    final selected = leadController.addons.contains(label);

    return InkWell(
      onTap: (){
        setModalState((){
          leadController.toggleAddon(label);
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width10,
          vertical: Dimensions.height10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(
            color: selected ? AppColors.color2 : AppColors.grey4,
          ),
          color: selected ? AppColors.color2.withOpacity(0.12) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.color2 : AppColors.grey4,
          ),
        ),
      ),
    );
  }

  void showRespondModal(BuildContext context) {


    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            void updateState() {
              setModalState(() {});
            }

            leadController.amountCtrl.removeListener(updateState);
            leadController.hoursCtrl.removeListener(updateState);
            leadController.amountCtrl.addListener(updateState);
            leadController.hoursCtrl.addListener(updateState);


            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom:
                      MediaQuery.of(context).viewInsets.bottom +
                      Dimensions.height50,
                ),
                child: Wrap(
                  children: [
                    Container(
                      width: Dimensions.screenWidth,
                      height: Dimensions.screenHeight * 0.7,
                      padding: EdgeInsets.symmetric(
                        vertical: Dimensions.height20 * 1.5,
                        horizontal: Dimensions.width20,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: AlignmentGeometry.center,
                              child: Container(
                                width: Dimensions.width100,
                                height: Dimensions.height5,
                                decoration: BoxDecoration(
                                  color: AppColors.grey2,
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.radius15,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: Dimensions.height30),
                            Text(
                              'Your Quote Amount',
                              style: TextStyle(
                                fontSize: Dimensions.font13,
                                color: AppColors.grey4,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            SizedBox(height: Dimensions.height5),
                            CustomTextField(
                              hintText: 'Enter Amount',
                              controller: leadController.amountCtrl,
                              fillColor: AppColors.grey2,
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: Dimensions.height20),
                            Text(
                              'Estimated Completion time',
                              style: TextStyle(
                                fontSize: Dimensions.font14,
                                color: AppColors.grey4,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            SizedBox(height: Dimensions.height5),
                            CustomTextField(
                              hintText: 'Enter in hours',
                              controller: leadController.hoursCtrl,
                              keyboardType: TextInputType.number,
                              fillColor: AppColors.grey2,
                            ),
                            SizedBox(height: Dimensions.height20),
                            Text(
                              'Your availability',
                              style: TextStyle(
                                fontSize: Dimensions.font14,
                                color: AppColors.grey4,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            SizedBox(height: Dimensions.height5),
                            Row(
                              children: [
                                availabilityChip('Morning', 'morning', setModalState),
                                SizedBox(width: Dimensions.width20),
                                availabilityChip('Afternoon', 'afternoon', setModalState),
                                SizedBox(width: Dimensions.width20),
                                availabilityChip('Flexible', 'flexible', setModalState),
                                SizedBox(width: Dimensions.width20),
                              ],
                            ),
                            SizedBox(height: Dimensions.height20),
                            Text(
                              'What is included (Optional)',
                              style: TextStyle(
                                fontSize: Dimensions.font14,
                                color: AppColors.grey4,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            SizedBox(height: Dimensions.height5),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  addonChip('Full Inspection', setModalState),
                                  SizedBox(width: Dimensions.width20),
                                  addonChip('Leak repair', setModalState),
                                  SizedBox(width: Dimensions.width20),
                                  addonChip('Parts', setModalState),
                                  SizedBox(width: Dimensions.width20),
                                  addonChip('30 days warranty', setModalState),
                                ],
                              ),
                            ),
                            SizedBox(height: Dimensions.height20),
                            Text(
                              'Message to Customer (Optional)',
                              style: TextStyle(
                                fontSize: Dimensions.font14,
                                color: AppColors.grey4,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            SizedBox(height: Dimensions.height5),
                            CustomTextField(
                              hintText:
                                  'Example: Hello! I can fix your kitchen sink leak tomorrow morning. I have over 10 years of experience and carry all necessary tools.',
                              maxLines: 3,
                              controller: leadController.messageCtrl,
                              keyboardType: TextInputType.text,
                              fillColor: AppColors.grey2,
                            ),
                            SizedBox(height: Dimensions.height20),
                            Text(
                              'Attach Image',
                              style: TextStyle(
                                fontSize: Dimensions.font14,
                                color: AppColors.grey4,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            SizedBox(height: Dimensions.height5),
                            Align(
                              alignment: AlignmentGeometry.center,
                              child: InkWell(
                                onTap:
                                    ()async {
                                  await leadController.pickImages();
                                  setModalState((){
                                  });
                                    },
                                child: IntrinsicWidth(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        Dimensions.radius15,
                                      ),
                                      border: Border.all(
                                        color: AppColors.grey4,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Dimensions.width10,
                                      vertical: Dimensions.height10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Iconsax.folder_2,
                                          size: Dimensions.iconSize16,
                                          color: AppColors.grey4,
                                        ),
                                        SizedBox(width: Dimensions.width15),
                                        Text(
                                          leadController.images.isEmpty
                                              ? 'Attach images'
                                              : '${leadController.images.length} image(s) selected',
                                          style: TextStyle(
                                            color: AppColors.grey4,
                                            fontSize: Dimensions.font14,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: Dimensions.height20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: Dimensions.font14,
                                    color: AppColors.grey4,
                                  ),
                                ),
                                Text(
                                  leadController.amountCtrl.text.trim() != ''
                                      ? 'N${leadController.amountCtrl.text.trim()}'
                                      : 'N0',
                                  style: TextStyle(
                                    fontSize: Dimensions.font14,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: Dimensions.height5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Timeline',
                                  style: TextStyle(
                                    fontSize: Dimensions.font14,
                                    color: AppColors.grey4,
                                  ),
                                ),
                                Text(
                                  leadController.hoursCtrl.text.trim().isNotEmpty
                                      ? '${leadController.hoursCtrl.text.trim()} hours'
                                      : 'Not set',
                                  style: TextStyle(
                                    fontSize: Dimensions.font14,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: Dimensions.height5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Availability',
                                  style: TextStyle(
                                    fontSize: Dimensions.font14,
                                    color: AppColors.grey4,
                                  ),
                                ),
                                Text(
                                  leadController.availability.capitalize ?? 'Flexible',
                                  style: TextStyle(
                                    fontSize: Dimensions.font14,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: Dimensions.height20),
                            CustomButton(
                              text: 'Send Quote',
                              onPressed: () {
                                // 1. Unfocus immediately to prevent TextField from trying to update
                                FocusManager.instance.primaryFocus?.unfocus();

                                leadController.submitQuote(
                                  jobId: jobController.singleJob!.id!,
                                  onSuccess: () async {
                                    // 2. Refresh Job Data
                                    jobController.getJobDetailsAndQuotes(
                                      jobController.singleJob!.id!,
                                    );

                                    // 3. Close the Modal Sheet first
                                    Navigator.pop(context);

                                    // 4. Navigate to Success Screen
                                    // Using a small delay ensures the modal animation clears
                                    await Future.delayed(Duration(milliseconds: 100));
                                    Get.toNamed(AppRoutes.quoteSentScreen);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobController>(
      builder: (ctrl) {
        // Use fetched job if available, else fallback to passed job
        final JobModel job = ctrl.singleJob ?? passedJob;

        final currencyFormatter = NumberFormat.currency(
          locale: 'en_NG',
          symbol: 'N',
          decimalDigits: 0,
        );

        final String title = formatServiceTitle(
          job.subcategory ?? job.category,
        );

        final String budgetRange =
            "${currencyFormatter.format(job.budget?.min ?? 0)} - ${currencyFormatter.format(job.budget?.max ?? 0)}";

        final String dateTop =
            job.date != null
                ? DateFormat('MMM dd').format(DateTime.parse(job.date!))
                : "Flexible";

        final bool isHighPriority =
            (job.urgency == 'urgent' || job.urgency == 'high');

        final String imgUrl = buildFileUrl(
          job.photos?.isNotEmpty == true ? job.photos!.first : null,
        );

        String toFullImageUrl(String path) {
          if (path.startsWith('http')) return path;
          return "${AppConstants.BASE_URL}$path";
        }

        String? avatarUrl = job.user?.avatar;
        if (avatarUrl != null && avatarUrl.isNotEmpty) {
          if (avatarUrl.startsWith('http')) {
            avatarUrl = avatarUrl;
          } else {
            avatarUrl = '${AppConstants.BASE_URL}$avatarUrl';
          }
        }


        return Scaffold(
          appBar: CustomAppbar(
            title: 'Leads Details',
            leadingIcon: const BackButton(),
          ),
          body: Container(
            height: Dimensions.screenHeight,
            width: Dimensions.screenWidth,
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width20,
              vertical: Dimensions.height20,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (job.photos == null || job.photos!.isEmpty)
                    const SizedBox.shrink() // 1. Takes no space if empty
                  else
                    Column(
                      children: [
                        Container(
                          height: Dimensions.height20 * 10,
                          decoration: BoxDecoration(
                            color: AppColors.grey2,
                            borderRadius: BorderRadius.circular(Dimensions.radius20),
                          ),
                          child: Stack(
                            children: [
                              // 2. The Slider
                              ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.radius20),
                                child: PageView.builder(
                                  itemCount: job.photos!.length,
                                  onPageChanged: (index) {
                                    // This updates the dot
                                    setState(() {
                                      _activeImageIndex = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    return Image.network(
                                      toFullImageUrl(job.photos![index]),
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Center(
                                          child: Icon(Icons.broken_image,
                                              color: AppColors.grey4),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),

                              // 3. The Indicators (Only show if > 1 image)
                              if (job.photos!.length > 1)
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: Dimensions.height10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(job.photos!.length, (index) {
                                        // Check if this dot is active
                                        bool isActive = _activeImageIndex == index;

                                        return AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          margin: const EdgeInsets.symmetric(horizontal: 3),
                                          height: 8,
                                          // Expands width if active (Pill shape)
                                          width: isActive ? 24 : 8,
                                          decoration: BoxDecoration(
                                            // Active = Color2 (Green/Blue?), Inactive = Grey
                                            color: isActive
                                                ? AppColors.color2
                                                : AppColors.white.withOpacity(0.7),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // Add spacing below image only if it exists
                        SizedBox(height: Dimensions.height20),
                      ],
                    ),
                  SizedBox(height: Dimensions.height20),
                  IntrinsicWidth(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius20,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width10,
                        vertical: Dimensions.height5,
                      ),
                      child: Text(
                        isHighPriority
                            ? 'HIGH PRIORITY'
                            : (job.urgency ?? 'NORMAL').toUpperCase(),
                        style: TextStyle(
                          fontSize: Dimensions.font10,
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height5),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: Dimensions.font22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: Dimensions.height5),
                  Text(
                    budgetRange,
                    style: TextStyle(
                      fontSize: Dimensions.font20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  IntrinsicHeight(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.grey1.withOpacity(0.4),
                        border: Border.all(color: AppColors.grey1),
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius15,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width10,
                        vertical: Dimensions.height15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Iconsax.calendar_25,
                                size: Dimensions.iconSize20,
                                color: AppColors.grey4,
                              ),
                              SizedBox(width: Dimensions.width10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dateTop,
                                    style: TextStyle(
                                      color: AppColors.grey5,
                                      fontSize: Dimensions.font14,
                                    ),
                                  ),
                                  Text(
                                    job.date == null ? 'Flexible' : 'Scheduled',
                                    style: TextStyle(
                                      color: AppColors.grey5,
                                      fontSize: Dimensions.font12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          VerticalDivider(color: AppColors.grey3),
                          Row(
                            children: [
                              Icon(
                                Iconsax.clock5,
                                size: Dimensions.iconSize20,
                                color: AppColors.grey4,
                              ),
                              SizedBox(width: Dimensions.width10),
                              Text(
                                '0:00 am',
                                style: TextStyle(
                                  color: AppColors.grey5,
                                  fontSize: Dimensions.font14,
                                ),
                              ),
                            ],
                          ),
                          VerticalDivider(color: AppColors.grey3),
                          Row(
                            children: [
                              Icon(
                                Iconsax.location5,
                                size: Dimensions.iconSize20,
                                color: AppColors.grey4,
                              ),
                              SizedBox(width: Dimensions.width10),
                              Text(
                                '0 Km away',
                                style: TextStyle(
                                  color: AppColors.grey5,
                                  fontSize: Dimensions.font14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  Text(
                    'PROBLEM DESCRIPTION',
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: Dimensions.font14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: Dimensions.height10),
                  Text(
                    job.description ?? 'No description provided',
                    style: TextStyle(
                      fontSize: Dimensions.font14,
                      fontWeight: FontWeight.w300,
                      color: AppColors.grey5,
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  Text(
                    'CUSTOMER INFORMATION',
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: Dimensions.font14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),

                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: Dimensions.height10,
                      horizontal: Dimensions.width10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      border: Border.all(color: AppColors.grey2),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                      Container(
                      height: Dimensions.height10*6,
                      width: Dimensions.width10*6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                        image:
                        avatarUrl != null
                            ? DecorationImage(
                          image: NetworkImage(avatarUrl),
                          fit: BoxFit.cover,
                        )
                            : DecorationImage(
                          image: AssetImage(
                            AppConstants.getPngAsset('head-icon'),
                          ),
                        ),
                      ),
                    ),
                            SizedBox(width: Dimensions.width10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        job.user?.name ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: AppColors.color1,
                                          fontWeight: FontWeight.w500,
                                          fontSize: Dimensions.font16,
                                        ),
                                      ),
                                      SizedBox(width: Dimensions.width10),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: Dimensions.width5*1.5,
                                          vertical: Dimensions.height5*0.7,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.grey3,
                                          borderRadius: BorderRadius.circular(
                                            Dimensions.radius20,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              size: Dimensions.iconSize16*0.9,
                                              color: AppColors.success,
                                            ),
                                            SizedBox(width: Dimensions.width5),
                                            Text('4.5',style: TextStyle(
                                              fontSize: Dimensions.font12
                                            ),),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '236+ Completed Jobs',
                                    style: TextStyle(
                                      fontSize: Dimensions.font15,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: Dimensions.width10),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: Dimensions.height20),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width20,
                      vertical: Dimensions.height20,
                    ),
                    width: Dimensions.screenWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      border: Border.all(color: AppColors.grey2),
                      color: AppColors.info.withOpacity(0.1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lead Status',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.info,
                          ),
                        ),
                        SizedBox(height: Dimensions.height5),
                        Text(
                          '• Sent to 8 verified vendors\n• 4 vendors have viewed\n• 1 quote already sent\n• Expires in 22 hours',
                          style: TextStyle(
                            color: AppColors.info,
                            fontWeight: FontWeight.w300,
                            fontSize: Dimensions.font13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  CustomButton(
                    text: 'Send your quote',
                    onPressed: () => showRespondModal(context),
                  ),
                  SizedBox(height: Dimensions.height20),
                  CustomButton(
                    text: 'Not interested',
                    onPressed: () {},
                    backgroundColor: AppColors.white,
                    borderColor: AppColors.color1,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
