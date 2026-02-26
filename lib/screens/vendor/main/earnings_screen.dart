import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:fyndr_ng/widgets/custom_appbar.dart';

import '../../../controllers/earning_controller.dart';
import '../../../model/earning_model.dart';
import '../../../utils/dimensions.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VendorEarningScreen extends StatefulWidget {
  const VendorEarningScreen({super.key});

  @override
  State<VendorEarningScreen> createState() => _VendorEarningScreenState();
}

class _VendorEarningScreenState extends State<VendorEarningScreen> {
  EarningController earningController = Get.find<EarningController>();

  @override
  void initState() {
    earningController.fetchEarningData();
    super.initState();
  }

  String _formatAmount(num amount) {
    if (amount >= 1000000) {
      return 'N${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return 'N${(amount / 1000).toStringAsFixed(1)}K';
    }
    return 'N${amount.toStringAsFixed(0)}';
  }

  String _formatFullAmount(num amount) {
    // Format with commas e.g. 1,232,889.00
    final formatted = amount.toStringAsFixed(2);
    final parts = formatted.split('.');
    final intPart = parts[0];
    final decPart = parts[1];
    final buffer = StringBuffer();
    int count = 0;
    for (int i = intPart.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write(',');
      buffer.write(intPart[i]);
      count++;
    }
    return 'N${buffer.toString().split('').reversed.join()}.$decPart';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(leadingIcon: BackButton(), title: 'Earnings'),
      body: GetBuilder<EarningController>(
        builder: (controller) {
          if (controller.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.error!,
                    style: TextStyle(color: AppColors.grey3),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Dimensions.height20),
                  ElevatedButton(
                    onPressed: controller.fetchEarningData,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final data = controller.earningModel?.data;

          return RefreshIndicator(
            onRefresh: controller.fetchEarningData,
            child: Container(
              height: Dimensions.screenHeight,
              width: Dimensions.screenWidth,
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width20,
                vertical: Dimensions.height20,
              ),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // ── Total Earnings Banner ──────────────────────────────
                    Container(
                      child: Stack(
                        children: [
                          Container(
                            height: Dimensions.height100 * 1.8,
                            width: Dimensions.screenWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Dimensions.radius20,
                              ),
                              gradient: LinearGradient(
                                colors: [AppColors.color2, AppColors.color3],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Image.asset(
                              AppConstants.getPngAsset('balance-bg'),
                            ),
                          ),
                          Positioned(
                            bottom: Dimensions.height15,
                            left: Dimensions.width20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Earning (All time)',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: Dimensions.font15,
                                  ),
                                ),
                                Text(
                                  _formatFullAmount(data?.totalEarnings ?? 0),
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: Dimensions.font30,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: Dimensions.height20),

                    // ── Filter Tabs ────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _FilterTab(
                          label: 'THIS MONTH',
                          isSelected:
                              controller.selectedFilter ==
                              EarningFilter.thisMonth,
                          onTap:
                              () =>
                                  controller.setFilter(EarningFilter.thisMonth),
                        ),
                        SizedBox(width: Dimensions.width20),
                        _FilterTab(
                          label: 'LAST MONTH',
                          isSelected:
                              controller.selectedFilter ==
                              EarningFilter.lastMonth,
                          onTap:
                              () =>
                                  controller.setFilter(EarningFilter.lastMonth),
                        ),
                        SizedBox(width: Dimensions.width20),
                        _FilterTab(
                          label: 'ALL TIME',
                          isSelected:
                              controller.selectedFilter ==
                              EarningFilter.allTime,
                          onTap:
                              () => controller.setFilter(EarningFilter.allTime),
                        ),
                      ],
                    ),

                    SizedBox(height: Dimensions.height20),

                    // ── Stats Card ─────────────────────────────────────────
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width20,
                        vertical: Dimensions.height20,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grey1),
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius20,
                        ),
                        color: AppColors.grey1.withOpacity(0.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _StatColumn(
                            label: _filterLabel(controller.selectedFilter),
                            value: _formatAmount(controller.displayEarnings),
                          ),
                          _StatColumn(
                            label: 'Jobs Done',
                            value: '${controller.displayJobsDone}',
                          ),
                          _StatColumn(
                            label: 'Avg/Job',
                            value: _formatAmount(
                              controller.displayAveragePerJob,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: Dimensions.height20),

                    // ── Pending Payments ───────────────────────────────────
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'PENDING PAYMENT',
                        style: TextStyle(
                          fontSize: Dimensions.font14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.color1,
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height20),

                    _PendingList(
                      payments: data?.pendingPayments ?? [],
                    ),

                    SizedBox(height: Dimensions.height10),

                    // ── Payment Note ───────────────────────────────────────
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width20,
                        vertical: Dimensions.height20,
                      ),
                      width: Dimensions.screenWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius20,
                        ),
                        border: Border.all(color: AppColors.grey2),
                        color: AppColors.info.withOpacity(0.3),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment notes',
                            style: TextStyle(
                              color: AppColors.info,
                              fontWeight: FontWeight.w500,
                              fontSize: Dimensions.font14,
                            ),
                          ),
                          Text(
                            'Customers pay you directly after service completion. '
                            'The amounts above are awaiting customer payment confirmation',
                            style: TextStyle(
                              color: AppColors.info,
                              fontWeight: FontWeight.w400,
                              fontSize: Dimensions.font14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: Dimensions.height20),

                    // ── Recent Earnings ────────────────────────────────────
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'RECENT EARNINGS',
                        style: TextStyle(
                          fontSize: Dimensions.font14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.color1,
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height20),

                    _RecentList(
                      earnings: data?.recentEarnings ?? [],
                    ),

                    SizedBox(height: Dimensions.height20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _filterLabel(EarningFilter filter) {
    switch (filter) {
      case EarningFilter.thisMonth:
        return 'This Month';
      case EarningFilter.lastMonth:
        return 'Last Month';
      case EarningFilter.allTime:
        return 'All Time';
    }
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width15,
            vertical: Dimensions.height10,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.color2 : AppColors.grey2,
            borderRadius: BorderRadius.circular(Dimensions.radius15),
          ),
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.grey5,
                fontSize: Dimensions.font13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;

  const _StatColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: AppColors.grey3)),
        SizedBox(height: Dimensions.height5),
        Text(
          value,
          style: TextStyle(
            color: AppColors.black,
            fontSize: Dimensions.font17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _PendingList extends StatelessWidget {
  final List<PendingPayment> payments;

  const _PendingList({required this.payments});

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return _EmptyCard(message: 'No pending payments');
    }
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width20,
        vertical: Dimensions.height20,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey2),
        borderRadius: BorderRadius.circular(Dimensions.radius20),
      ),
      child: Column(
        children: List.generate(payments.length, (index) {
          final p = payments[index];
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      p.jobDescription,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: Dimensions.width10),
                  Text(
                    'N${p.agreedAmount.toStringAsFixed(0)}',
                    style: TextStyle(color: AppColors.color2),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    p.userName,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: AppColors.grey3,
                    ),
                  ),
                  Text(
                    p.jobCategory.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.grey3,
                      fontSize: Dimensions.font12,
                    ),
                  ),
                ],
              ),
              if (index < payments.length - 1) Divider(color: AppColors.grey2),
            ],
          );
        }),
      ),
    );
  }
}

class _RecentList extends StatelessWidget {
  final List<RecentEarning> earnings;

  const _RecentList({required this.earnings});

  @override
  Widget build(BuildContext context) {
    if (earnings.isEmpty) {
      return _EmptyCard(message: 'No recent earnings');
    }
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width20,
        vertical: Dimensions.height20,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey2),
        borderRadius: BorderRadius.circular(Dimensions.radius20),
      ),
      child: Column(
        children: List.generate(earnings.length, (index) {
          final e = earnings[index];
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      e.jobDescription,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: Dimensions.width10),
                  Text(
                    'N${e.amount.toStringAsFixed(0)}',
                    style: TextStyle(color: AppColors.color2),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    e.userName,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: AppColors.grey3,
                    ),
                  ),
                  Text(
                    e.jobCategory.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.grey3,
                      fontSize: Dimensions.font12,
                    ),
                  ),
                ],
              ),
              if (index < earnings.length - 1) Divider(color: AppColors.grey2),
            ],
          );
        }),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String message;

  const _EmptyCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width20,
        vertical: Dimensions.height20,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey2),
        borderRadius: BorderRadius.circular(Dimensions.radius20),
      ),
      child: Center(
        child: Text(message, style: TextStyle(color: AppColors.grey3)),
      ),
    );
  }
}
