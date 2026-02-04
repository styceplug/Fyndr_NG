import 'package:flutter/material.dart';
import 'package:fyndr_ng/controllers/job_controller.dart';
import 'package:fyndr_ng/widgets/custom_appbar.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:fyndr_ng/widgets/custom_textfield.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/chat_controller.dart';
import '../../model/job_model.dart';
import '../../routes/routes.dart';
import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/snackbars.dart';

class QuoteDetailScreen extends StatefulWidget {
  const QuoteDetailScreen({super.key});

  @override
  State<QuoteDetailScreen> createState() => _QuoteDetailScreenState();
}

class _QuoteDetailScreenState extends State<QuoteDetailScreen> {
  String selectedResponseOption = '';
  JobController jobController = Get.find<JobController>();
  final TextEditingController _declineCommentCtrl = TextEditingController();
  final TextEditingController _counterAmountCtrl = TextEditingController();

  String _selectedDeclineReason = '';
  String _selectedCounterReason = '';


  @override
  void initState() {
    super.initState();
    String quoteId = Get.arguments['quoteId'];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      jobController.getQuoteDetails(quoteId);
    });
  }

  @override
  void dispose() {
    _declineCommentCtrl.dispose();
    _counterAmountCtrl.dispose();
    super.dispose();
  }


  String getFullImageUrl(String? path) {
    if (path == null || path.isEmpty) return "";
    if (path.startsWith("http")) return path; // Already full URL
    return "${AppConstants.BASE_URL}$path"; // Prepend Base URL
  }

  Future<void> _refreshData() async {
    if (jobController.quote?.id != null) {
      await jobController.getQuoteDetails(jobController.quote!.id!);
    }
  }

  void showDeclineModal() {
    _selectedDeclineReason = '';
    _declineCommentCtrl.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom,
              ),
              child: Container(
                width: Dimensions.screenWidth,
                padding: EdgeInsets.symmetric(
                  vertical: Dimensions.height10,
                  horizontal: Dimensions.width20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          height: Dimensions.height5,
                          width: Dimensions.width70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius20,
                            ),
                            color: AppColors.grey2,
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.height20 * 2),
                      Image.asset(
                        AppConstants.getPngAsset('cancel-icon'),
                        height: Dimensions.height100,
                        width: Dimensions.width100,
                      ),
                      SizedBox(height: Dimensions.height20),
                      Text(
                        'Decline Quote',
                        style: TextStyle(
                          fontSize: Dimensions.font22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.error,
                        ),
                      ),

                      Text(
                        'Let us know why you are declining',
                        style: TextStyle(
                          fontSize: Dimensions.font15,
                          fontWeight: FontWeight.w300,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: Dimensions.height20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'REASON FOR DECLINING',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: Dimensions.font12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.error,
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
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius20,
                          ),
                          border: Border.all(color: AppColors.grey2),
                        ),
                        child: Column(
                          children: [
                            _buildRadioRow(
                              'Price too high',
                              _selectedDeclineReason,
                                  (val) =>
                                  setModalState(
                                        () => _selectedDeclineReason = val,
                                  ),
                            ),
                            SizedBox(height: 10),
                            _buildRadioRow(
                              'Accepted another quote',
                              _selectedDeclineReason,
                                  (val) =>
                                  setModalState(
                                        () => _selectedDeclineReason = val,
                                  ),
                            ),
                            SizedBox(height: 10),
                            _buildRadioRow(
                              'Timeline doesn’t work',
                              _selectedDeclineReason,
                                  (val) =>
                                  setModalState(
                                        () => _selectedDeclineReason = val,
                                  ),
                            ),
                            SizedBox(height: 10),
                            _buildRadioRow(
                              'Changed my mind',
                              _selectedDeclineReason,
                                  (val) =>
                                  setModalState(
                                        () => _selectedDeclineReason = val,
                                  ),
                            ),
                            SizedBox(height: 10),
                            _buildRadioRow(
                              'Other reason',
                              _selectedDeclineReason,
                                  (val) =>
                                  setModalState(
                                        () => _selectedDeclineReason = val,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Dimensions.height20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'ADDITIONAL COMMENT',
                          style: TextStyle(
                            fontSize: Dimensions.font15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.height10),
                      CustomTextField(
                        hintText:
                        'The kitchen sink is linking from under the cabinet...',
                        maxLines: 3,
                        controller: _declineCommentCtrl,
                      ),
                      SizedBox(height: Dimensions.height20),
                      CustomButton(
                        text: 'Confirm Decline',
                        onPressed: () async {
                          if (_selectedDeclineReason.isEmpty) {
                            CustomSnackBar.failure(
                              message: "Please select a reason",
                            );
                            return;
                          }

                          if (jobController.quote?.id != null) {
                            Get.back();
                            await jobController.declineQuoteAction(
                              jobController.quote!.id!,
                              _selectedDeclineReason,
                              _declineCommentCtrl.text,
                            );
                            _refreshData();
                          }
                        },
                        backgroundColor: AppColors.error,
                      ),
                      SizedBox(height: Dimensions.height10),
                      CustomButton(
                        text: 'Cancel',
                        onPressed: () => Get.back(),
                        backgroundColor: AppColors.white,
                        borderColor: AppColors.error,
                      ),
                      SizedBox(height: Dimensions.height40),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showCounterModal() {
    _selectedCounterReason = '';
    _counterAmountCtrl.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom,
              ),
              child: Container(
                width: Dimensions.screenWidth,
                height: Dimensions.screenHeight * 0.8,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Dimensions.radius20),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: Dimensions.height10,
                  horizontal: Dimensions.width20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          height: Dimensions.height5,
                          width: Dimensions.width70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius20,
                            ),
                            color: AppColors.grey2,
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.height20 * 2),
                      Text(
                        'Counter Offer',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: Dimensions.font23,
                          fontWeight: FontWeight.w700,
                          color: AppColors.error,
                        ),
                      ),
                      SizedBox(height: Dimensions.height20),
                      Text(
                        'ENTER COUNTER OFFER',
                        style: TextStyle(
                          fontSize: Dimensions.font12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.error,
                        ),
                      ),
                      SizedBox(height: Dimensions.height5),
                      CustomTextField(
                        hintText: 'Enter amount',
                        fillColor: Color(0XFFEFF1F3),
                        controller: _counterAmountCtrl,
                      ),
                      SizedBox(height: Dimensions.height20),
                      Text(
                        'REASON FOR COUNTER OFFER',
                        style: TextStyle(
                          fontSize: Dimensions.font12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.error,
                        ),
                      ),
                      SizedBox(height: Dimensions.height10),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width20,
                          vertical: Dimensions.height20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius20,
                          ),
                          border: Border.all(color: AppColors.grey2),
                        ),
                        child: Column(
                          children: [
                            _buildRadioRow(
                              'Price too high',
                              _selectedCounterReason,
                                  (val) =>
                                  setModalState(
                                        () => _selectedCounterReason = val,
                                  ),
                            ),
                            SizedBox(height: 10),
                            _buildRadioRow(
                              'Budget constraints',
                              _selectedCounterReason,
                                  (val) =>
                                  setModalState(
                                        () => _selectedCounterReason = val,
                                  ),
                            ),
                            SizedBox(height: 10),
                            _buildRadioRow(
                              'Better offer elsewhere',
                              _selectedCounterReason,
                                  (val) =>
                                  setModalState(
                                        () => _selectedCounterReason = val,
                                  ),
                            ),
                            SizedBox(height: 10),
                            _buildRadioRow(
                              'Other reason',
                              _selectedCounterReason,
                                  (val) =>
                                  setModalState(
                                        () => _selectedCounterReason = val,
                                  ),
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
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius20,
                          ),
                          border: Border.all(color: AppColors.grey2),
                          color: AppColors.color5.withOpacity(0.4),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Negotiation Tips',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: Dimensions.height10),
                            Text(
                              '• Be reasonable with your counter offer\n• Explain your reason clearly\n• Providers may accept or decline\n• Good communication helps reach agreement',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Dimensions.height20),
                      CustomButton(
                        text: 'Send Counter Offer',
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius20,
                        ),
                        onPressed: () async {
                          if (_counterAmountCtrl.text.isEmpty ||
                              _selectedCounterReason.isEmpty) {
                            CustomSnackBar.failure(
                              message: "Please fill all fields",
                            );
                            return;
                          }
                          int? amount = int.tryParse(_counterAmountCtrl.text);
                          if (amount == null) {
                            CustomSnackBar.failure(message: "Invalid amount");
                            return;
                          }

                          if (jobController.quote?.id != null) {
                            jobController.counterQuoteAction(
                              jobController.quote!.id!,
                              amount,
                              _selectedCounterReason,
                            );
                            _refreshData();
                          }
                        },
                        backgroundColor: AppColors.color2,
                      ),
                      SizedBox(height: Dimensions.height10),
                      CustomButton(
                        text: 'Cancel',
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius20,
                        ),
                        onPressed: () => Get.back(),
                        backgroundColor: AppColors.white,
                        borderColor: AppColors.error,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showRespondModal() {
    selectedResponseOption = '';

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              width: Dimensions.screenWidth,
              height: Dimensions.screenHeight / 1.7,
              padding: EdgeInsets.symmetric(
                vertical: Dimensions.height20 * 1.5,
                horizontal: Dimensions.width20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'I want to',
                    style: TextStyle(
                      fontSize: Dimensions.font22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),

                  _buildOptionCard(
                    title: 'Accept Offer',
                    subtitle: 'Agree to pay quoted amount',
                    value: 'accept',
                    groupValue: selectedResponseOption,
                    iconAsset: 'accept-icon',
                    activeColor: AppColors.color2,
                    onTap: () {
                      setModalState(() => selectedResponseOption = 'accept');
                    },
                  ),

                  SizedBox(height: Dimensions.height15),

                  _buildOptionCard(
                    title: 'Send Counter Offer',
                    subtitle: 'Reject the price and send an offer',
                    value: 'counter',
                    groupValue: selectedResponseOption,
                    iconAsset: 'counter-icon',
                    activeColor: AppColors.color2,
                    onTap: () {
                      setModalState(() => selectedResponseOption = 'counter');
                    },
                  ),

                  SizedBox(height: Dimensions.height15),

                  _buildOptionCard(
                    title: 'Reject Offer',
                    subtitle: 'Decline the offer',
                    value: 'decline',
                    groupValue: selectedResponseOption,
                    iconAsset: 'reject-icon',
                    activeColor: AppColors.error,
                    onTap: () {
                      setModalState(() => selectedResponseOption = 'decline');
                    },
                  ),

                  Spacer(),

                  CustomButton(
                    text: 'Continue',
                    backgroundColor:
                    selectedResponseOption.isEmpty
                        ? AppColors.grey3
                        : AppColors.color2,
                    onPressed: () async {
                      if (selectedResponseOption.isEmpty) return;
                      Get.back();

                      if (selectedResponseOption == 'accept') {
                        if (jobController.quote?.id != null) {
                          jobController.acceptQuoteAction(
                            jobController.quote!.id!,
                          );
                          _refreshData();
                        }
                      } else if (selectedResponseOption == 'counter') {
                        showCounterModal();
                      } else if (selectedResponseOption == 'decline') {
                        showDeclineModal();
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String subtitle,
    required String value,
    required String groupValue,
    required String iconAsset,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    bool isSelected = value == groupValue;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(Dimensions.radius20),
          border: Border.all(
            color: isSelected ? activeColor : AppColors.color2.withOpacity(0.5),
            width: 1,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height20,
        ),
        child: Row(
          children: [
            Image.asset(
              AppConstants.getPngAsset(iconAsset),
              height: Dimensions.height30,
              width: Dimensions.width30,
            ),
            SizedBox(width: Dimensions.width20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: Dimensions.font20,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.white : AppColors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Dimensions.font16,
                      fontWeight: FontWeight.w400,
                      color:
                      isSelected
                          ? AppColors.white.withOpacity(0.9)
                          : AppColors.grey5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: Dimensions.width10),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? AppColors.white : AppColors.grey3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioRow(String text,
      String groupValue,
      Function(String) onTap,) {
    bool isSelected = groupValue == text;
    return GestureDetector(
      onTap: () => onTap(text),
      child: Container(
        color: Colors.transparent, // expand tap area
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: Dimensions.iconSize16,
              color: isSelected ? AppColors.color2 : AppColors.grey5,
            ),
            SizedBox(width: Dimensions.width10),
            Expanded(child: Text(text, overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(leadingIcon: BackButton()),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: GetBuilder<JobController>(
          builder: (ctrl) {
            if (ctrl.quote == null) {
              return Center(child: Text("Quote not found"));
            }

            final quote = ctrl.quote!;
            final merchant = quote.merchant;
            final business = merchant?.businessDetails;

            final currentRole = Get
                .find<AuthController>()
                .userModel
                ?.currentRole
                ?.toLowerCase() ?? '';

            final lastSender = quote.sender?.toLowerCase() ?? 'merchant';

            bool isMyTurn = false;
            if (quote.status == 'pending') {
              isMyTurn = currentRole == 'user' || currentRole == 'customer';
            } else {
              isMyTurn = (currentRole != lastSender);
            }

            final currencyFormatter = NumberFormat.currency(
              locale: 'en_NG',
              symbol: 'N',
              decimalDigits: 0,
            );


            String? rawPath =
            (currentRole == 'vendor')
                ? quote.user?.avatar
                : quote.merchant?.avatar;

            String? displayName =
            (currentRole == 'vendor')
                ? quote.user?.name
                : quote.merchant?.businessDetails?.businessName;

            String? avatarUrl = quote.user?.avatar;
            if (rawPath != null && rawPath.isNotEmpty) {
              if (rawPath.startsWith('http')) {
                avatarUrl = rawPath;
              } else {
                avatarUrl = '${AppConstants.BASE_URL}$rawPath';
              }
            }

            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width20,
                    vertical: Dimensions.height20,
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: Dimensions.screenWidth,
                          decoration: BoxDecoration(
                            color: AppColors.color5.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(Dimensions
                                .radius20),
                          ),
                          padding: EdgeInsets.only(bottom: Dimensions.height20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: Dimensions.height20),
                              Container(
                                height: Dimensions.height100,
                                width: Dimensions.width100,
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

                              SizedBox(height: Dimensions.height10),
                              Text(
                                displayName ?? '',
                                style: TextStyle(
                                  fontSize: Dimensions.font18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: Dimensions.height10),

                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.width20,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildChip(
                                      icon: Icons.star,
                                      text: '4.5',
                                      color: AppColors.error,
                                    ),
                                    SizedBox(width: Dimensions.width10),
                                    _buildChip(
                                      icon: Icons.bookmark,
                                      text: '420',
                                      color: AppColors.color3,
                                    ),
                                    SizedBox(width: Dimensions.width10),
                                    _buildChip(
                                      icon: Icons.location_pin,
                                      text: business?.businessLocation?.lga ??
                                          '',
                                      color: AppColors.color3,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: Dimensions.height15),
                        if (quote.status == 'countered')
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 15),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: isMyTurn
                                    ? AppColors.color2.withOpacity(0.1)
                                    : AppColors.grey2.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: isMyTurn
                                        ? AppColors.color2
                                        : AppColors.grey5)
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline,
                                    color: isMyTurn
                                        ? AppColors.color2
                                        : AppColors.grey5),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    isMyTurn
                                        ? "Action Required: You received a counter offer."
                                        : "Waiting for ${displayName}'s response.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        SizedBox(height: Dimensions.height15),


                        //if Countered show new and old prices
                        _buildSectionContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                quote.status == 'countered'
                                    ? 'New Proposed Price'
                                    : 'Quoted Amount',
                                style: TextStyle(fontSize: Dimensions.font12,
                                    color: AppColors.grey5),
                              ),
                              SizedBox(height: Dimensions.height5),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    currencyFormatter.format(quote.amount),
                                    style: TextStyle(
                                      fontSize: Dimensions.font23,
                                      fontWeight: FontWeight.w700,
                                      color: quote.status == 'countered'
                                          ? AppColors.color2
                                          : AppColors.black,
                                    ),
                                  ),

                                  // Show Previous Amount strike-through if countered
                                  if(quote.status == 'countered' &&
                                      quote.previousAmount != null) ...[
                                    SizedBox(width: 10),
                                    Text(
                                      currencyFormatter.format(
                                          quote.previousAmount),
                                      style: TextStyle(
                                        fontSize: Dimensions.font14,
                                        decoration: TextDecoration.lineThrough,
                                        color: AppColors.grey5,
                                      ),
                                    ),
                                  ]
                                ],
                              ),

                              // Show Reason if countered
                              if (quote.status == 'countered' &&
                                  quote.responseReason != null) ...[
                                SizedBox(height: 10),
                                Divider(),
                                Text("Reason for counter:", style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.grey5)),
                                Text(
                                    quote.responseReason!,
                                    style: TextStyle(fontSize: 14,
                                        fontStyle: FontStyle.italic)
                                ),
                              ]
                            ],
                          ),
                        ),

                        SizedBox(height: Dimensions.height15),

                        _buildSectionContainer(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  _buildDetailItem(
                                    'Completion time',
                                    quote.estimatedCompletionTime != null
                                        ? DateFormat('MMM dd').format(
                                      DateTime.parse(
                                        quote.estimatedCompletionTime!,
                                      ),
                                    )
                                        : "N/A",
                                  ),
                                  Spacer(),
                                  _buildDetailItem(
                                    'Availability',
                                    quote.availability?.capitalizeFirst ?? '',
                                  ),
                                ],
                              ),
                              SizedBox(height: Dimensions.height20),
                              Row(
                                children: [
                                  _buildDetailItem(
                                    'Status',
                                    quote.status?.capitalizeFirst ?? '',
                                  ),
                                  Spacer(),
                                  _buildDetailItem('Experience', '5 Years'),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: Dimensions.height15),

                        _buildSectionContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Message to Client',
                                style: TextStyle(
                                  fontSize: Dimensions.font14,
                                  color: AppColors.grey5,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                quote.message ?? 'No message provided',
                                style: TextStyle(
                                  fontSize: Dimensions.font16,
                                  fontWeight: FontWeight.w300,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Dimensions.height15),


                        if (quote.photos != null &&
                            quote.photos!.isNotEmpty) ...[
                          _buildSectionContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Photos',
                                  style: TextStyle(color: AppColors.grey5),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children:
                                  quote.photos!
                                      .map(
                                        (url) =>
                                        Container(
                                          margin: EdgeInsets.only(right: 10),
                                          height: 60,
                                          width: 60,
                                          child: Image.network(
                                            getFullImageUrl(url),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                  )
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ],

                        SizedBox(height: Dimensions.height15),

                        _buildSectionContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Job Description',
                                style: TextStyle(
                                  fontSize: Dimensions.font14,
                                  color: AppColors.grey5,
                                ),
                              ),
                              SizedBox(height: Dimensions.height5),
                              Text(
                                quote.job?.description ?? '',
                                style: TextStyle(
                                  fontSize: Dimensions.font16,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: Dimensions.height30),

                        if (quote.status == 'accepted')
                          CustomButton(
                            text: 'Start Chat',
                            onPressed: () => _handleStartChat(quote),
                          )

                          else if (quote.status == 'pending' || quote.status == 'countered')

                  if (isMyTurn)
              CustomButton(
            text: quote.status == 'countered' ?
            'Review & Respond' :
              "Respond to Quote",
              backgroundColor: AppColors.color2, // Green/Brand color
              onPressed: () => showRespondModal(),
            )

            // It is NOT my turn (Waiting)
            else
            Column(
            children: [
            Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            width: double.infinity,
            decoration: BoxDecoration(
            color: AppColors.grey2,
            borderRadius: BorderRadius.circular(Dimensions.radius15)
            ),
            child: Center(
            child: Text(
            "Waiting for response...",
            style: TextStyle(color: AppColors.grey5, fontWeight: FontWeight.bold),
            ),
            ),
            ),
            SizedBox(height: 10),
            // Optional: Allow them to withdraw or chat if needed, but usually we just wait
            ],
            ),

            // CASE 3: End States
            if (quote.status == 'declined' || quote.status == 'rejected')
            Center(child: Text("This quote has been declined.", style: TextStyle(color: AppColors.error))),

            SizedBox(height: Dimensions.height40),
            ],
            ),
            ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleStartChat(QuoteModel quote) async {
    if (quote.job?.id == null || quote.user?.id == null ||
        quote.merchant?.id == null) return;

    final chatController = Get.put(
        ChatController(chatRepo: Get.find(), socketService: Get.find()));

    // Show loading
    await chatController.initiateChat(
      quote.job!.id!,
      quote.user!.id!,
      quote.merchant!.id!,
    );

    if (chatController.currentChat != null) {
      Get.toNamed(AppRoutes.chatScreen);
    }
  }

  Widget _buildSectionContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: AppColors.grey3),
      ),
      width: Dimensions.screenWidth,
      padding: EdgeInsets.all(Dimensions.width10),
      child: child,
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: Dimensions.font12,
              color: AppColors.grey5,
            ),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: Dimensions.font18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width15,
        vertical: Dimensions.height5,
      ),
      child: Row(
        children: [
          Icon(icon, size: Dimensions.iconSize16, color: AppColors.white),
          SizedBox(width: Dimensions.width5),
          Text(
            text,
            style: TextStyle(
              fontSize: Dimensions.font10,
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
