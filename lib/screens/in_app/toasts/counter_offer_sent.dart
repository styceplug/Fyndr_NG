import 'package:flutter/material.dart';
import 'package:fyndr_ng/controllers/chat_controller.dart';
import 'package:fyndr_ng/controllers/job_controller.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:fyndr_ng/utils/dimensions.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../routes/routes.dart';

class CounterOfferSent extends StatefulWidget {
  const CounterOfferSent({super.key});

  @override
  State<CounterOfferSent> createState() => _CounterOfferSentState();
}

class _CounterOfferSentState extends State<CounterOfferSent> {
  JobController jobController = Get.find<JobController>();
  ChatController chatController = Get.find<ChatController>();

  @override
  void initState() {
    super.initState();
    String quoteId = Get.arguments['quoteId'];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      jobController.getQuoteDetails(quoteId);
    });
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

  String formatDate(String? dateString) {
    if (dateString == null) return "N/A";
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat("dd MMM yyyy - hh:mm a").format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<JobController>(
        builder: (ctrl) {
          if (ctrl.quote == null) {
            return Center(child: Text("Quote not found"));
          }

          final quote = ctrl.quote!;
          final merchant = quote.merchant;
          final business = merchant?.businessDetails;

          final currencyFormatter = NumberFormat.currency(
            locale: 'en_NG',
            symbol: 'N',
            decimalDigits: 0,
          );

          return Container(
            height: Dimensions.screenHeight,
            width: Dimensions.screenWidth,
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width20,
              vertical: Dimensions.height20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AppConstants.getPngAsset('counter'),
                  height: Dimensions.height100,
                ),
                SizedBox(height: Dimensions.height20),
                Text(
                  'Counter Offer Sent',
                  style: TextStyle(
                    fontSize: Dimensions.font22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.color1,
                  ),
                ),
                SizedBox(height: Dimensions.height20),
                Text(
                  'Your counter offer of ${currencyFormatter.format(quote.amount)} has been sent to ${quote.merchant?.businessDetails?.businessName?.capitalize}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Dimensions.font15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: Dimensions.height20),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width20,
                    vertical: Dimensions.height20,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.color1),
                    borderRadius: BorderRadius.circular(Dimensions.radius10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WHAT HAPPENS NEXT?',
                        style: TextStyle(
                          fontSize: Dimensions.font15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.color1,
                        ),
                      ),
                      SizedBox(height: Dimensions.height20),
                      Row(
                        children: [
                          Image.asset(
                            AppConstants.getPngAsset('tick-icon'),
                            height: Dimensions.height30,
                            width: Dimensions.width30,
                          ),
                          SizedBox(width: Dimensions.width20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Counter Offer Sent',
                                style: TextStyle(
                                  fontSize: Dimensions.font17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Waiting for provider response',
                                style: TextStyle(
                                  fontSize: Dimensions.font14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.height10),
                      Divider(color: AppColors.grey3),
                      SizedBox(height: Dimensions.height10),
                      Text(
                        'The provider can:',
                        style: TextStyle(
                          fontSize: Dimensions.font14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: Dimensions.height5),
                      Padding(
                        padding: EdgeInsets.only(left: Dimensions.width20),
                        child: Text(
                          '• Accept your counter offer (${currencyFormatter.format(quote.amount)}) \n• Decline and keep original (${currencyFormatter.format(quote.amount)}) \n• Send a new counter offer',
                          style: TextStyle(
                            height: 1.5,
                            fontSize: Dimensions.font14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.height5),
                      Text(
                        'You’ll be notified of their response.',
                        style: TextStyle(
                          fontSize: Dimensions.font14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Dimensions.height20),
                /*CustomButton(
                  text: 'Chat with provider',
                  onPressed: () async {
                    if (quote.job?.id == null ||
                        quote.user?.id == null ||
                        quote.merchant?.id == null)
                      return;

                    final chatController = Get.put(
                      ChatController(
                        chatRepo: Get.find(),
                        socketService: Get.find(),
                      ),
                    );

                    await chatController.initiateChat(
                      quote.job!.id!,
                      quote.user!.id!,
                      quote.merchant!.id!,
                    );

                    if (chatController.currentChat != null) {
                      Get.toNamed(AppRoutes.chatScreen);
                    }
                  },
                ),
                SizedBox(height: Dimensions.height20),*/
                CustomButton(
                  text: 'View job details',
                  onPressed: () {
                    Get.toNamed(AppRoutes.quoteDetailsScreen,arguments: {
                      'quoteId':quote.id

                    });
                  },
                  // backgroundColor: AppColors.white,
                  borderColor: AppColors.color1,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
