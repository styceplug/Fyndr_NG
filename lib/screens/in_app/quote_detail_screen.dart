import 'package:flutter/material.dart';
import 'package:fyndr_ng/widgets/custom_appbar.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:fyndr_ng/widgets/custom_textfield.dart';
import 'package:get/get.dart';

import '../../routes/routes.dart';
import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class QuoteDetailScreen extends StatefulWidget {
  const QuoteDetailScreen({super.key});

  @override
  State<QuoteDetailScreen> createState() => _QuoteDetailScreenState();
}

class _QuoteDetailScreenState extends State<QuoteDetailScreen> {
  String selectedResponseOption = '';

  void showDeclineModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
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
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      border: Border.all(color: AppColors.grey2),
                    ),
                    child: Column(
                      children: [
                        _buildRadioRow('Price too high'),
                        SizedBox(height: Dimensions.height10),
                        _buildRadioRow('Accepted another quote'),
                        SizedBox(height: Dimensions.height10),
                        _buildRadioRow('Timeline doesn’t work'),
                        SizedBox(height: Dimensions.height10),
                        _buildRadioRow('Changed my mind'),
                        SizedBox(height: Dimensions.height10),
                        _buildRadioRow('Other reason'),
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
                  ),
                  SizedBox(height: Dimensions.height20),
                  CustomButton(
                    text: 'Confirm Decline',
                    onPressed: () {
                      Get.toNamed(AppRoutes.homeScreen);
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
  }

  void showCounterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
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
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      border: Border.all(color: AppColors.grey2),
                    ),
                    child: Column(
                      children: [
                        _buildRadioRow('Price too high'),
                        SizedBox(height: Dimensions.height10),
                        _buildRadioRow('Accepted another quote'),
                        SizedBox(height: Dimensions.height10),
                        _buildRadioRow('Timeline doesn’t work'),
                        SizedBox(height: Dimensions.height10),
                        _buildRadioRow('Changed my mind'),
                        SizedBox(height: Dimensions.height10),
                        _buildRadioRow('Other reason'),
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
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
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
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                    onPressed: () {
                      Get.back();
                      Get.toNamed(AppRoutes.counterOfferScreen);
                    },
                    backgroundColor: AppColors.color2,
                  ),
                  SizedBox(height: Dimensions.height10),
                  CustomButton(
                    text: 'Cancel',
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
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
                    subtitle: 'Agree to pay N140,000',
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
                    onPressed: () {
                      if (selectedResponseOption.isEmpty) return;

                      Get.back();

                      if (selectedResponseOption == 'accept') {
                        Get.toNamed(AppRoutes.bookingConfirmedScreen);
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

  Widget _buildRadioRow(String text) {
    return Row(
      children: [
        Icon(
          Icons.circle_outlined,
          size: Dimensions.iconSize16,
          color: AppColors.grey5,
        ),
        SizedBox(width: Dimensions.width10),
        Expanded(child: Text(text, overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(leadingIcon: BackButton()),
      body: SingleChildScrollView(
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
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                ),
                padding: EdgeInsets.only(bottom: Dimensions.height20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: Dimensions.height20),
                    Container(
                      decoration: BoxDecoration(color: AppColors.color3),
                      child: Image.asset(
                        AppConstants.getPngAsset('head-icon'),
                        height: Dimensions.height10 * 6,
                        width: Dimensions.width10 * 6,
                      ),
                    ),
                    SizedBox(height: Dimensions.height10),
                    Text(
                      'ABC Co Plumber',
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
                            text: 'Lekki',
                            color: AppColors.color3,
                          ),
                        ],
                      ),
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
                      'Quoted',
                      style: TextStyle(
                        fontSize: Dimensions.font12,
                        color: AppColors.grey5,
                      ),
                    ),
                    SizedBox(height: Dimensions.height5),
                    Text(
                      'N140,000',
                      style: TextStyle(
                        fontSize: Dimensions.font23,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: Dimensions.height15),

              _buildSectionContainer(
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildDetailItem('Completion time', '1 day'),
                        Spacer(),
                        _buildDetailItem('Availability', 'Flexible'),
                      ],
                    ),
                    SizedBox(height: Dimensions.height20),
                    Row(
                      children: [
                        _buildDetailItem('Warranty', '3 Months'),
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
                      'Photos',
                      style: TextStyle(
                        fontSize: Dimensions.font16,
                        color: AppColors.grey5,
                      ),
                    ),
                    SizedBox(height: Dimensions.height10),
                    Row(
                      children: List.generate(
                        3,
                        (index) => Padding(
                          padding: EdgeInsets.only(right: Dimensions.width10),
                          child: Container(
                            padding: EdgeInsets.all(Dimensions.width15),
                            decoration: BoxDecoration(
                              color: AppColors.grey3.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(
                                Dimensions.radius5,
                              ),
                            ),
                            child: Icon(Icons.photo, color: AppColors.grey5),
                          ),
                        ),
                      ),
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
                      'Description',
                      style: TextStyle(
                        fontSize: Dimensions.font14,
                        color: AppColors.grey5,
                      ),
                    ),
                    SizedBox(height: Dimensions.height5),
                    Text(
                      'Water is leaking from under the kitchen sink. It started after some dirt piled up...',
                      style: TextStyle(
                        fontSize: Dimensions.font16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: Dimensions.height30),

              CustomButton(
                text: 'Respond',
                onPressed: () => showRespondModal(),
              ),
              SizedBox(height: Dimensions.height20),
            ],
          ),
        ),
      ),
    );
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
