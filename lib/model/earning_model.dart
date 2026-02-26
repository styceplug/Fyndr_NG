import '../utils/app_constants.dart';

class EarningModel {
  final bool success;
  final String message;
  final EarningData data;

  EarningModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory EarningModel.fromJson(Map<String, dynamic> json) {
    return EarningModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: EarningData.fromJson(json['data'] ?? {}),
    );
  }
}

class EarningData {
  final num totalEarnings;
  final num thisMonthEarnings;
  final num lastMonthEarnings;
  final AllTimeEarnings allTimeEarnings;
  final List<PendingPayment> pendingPayments;
  final List<RecentEarning> recentEarnings;

  EarningData({
    required this.totalEarnings,
    required this.thisMonthEarnings,
    required this.lastMonthEarnings,
    required this.allTimeEarnings,
    required this.pendingPayments,
    required this.recentEarnings,
  });

  factory EarningData.fromJson(Map<String, dynamic> json) {
    return EarningData(
      totalEarnings: json['totalEarnings'] ?? 0,
      thisMonthEarnings: json['thisMonthEarnings'] ?? 0,
      lastMonthEarnings: json['lastMonthEarnings'] ?? 0,
      allTimeEarnings: AllTimeEarnings.fromJson(json['allTimeEarnings'] ?? {}),
      pendingPayments:
          (json['pendingPayments'] as List? ?? [])
              .map((e) => PendingPayment.fromJson(e))
              .toList(),
      recentEarnings:
          (json['recentEarnings'] as List? ?? [])
              .map((e) => RecentEarning.fromJson(e))
              .toList(),
    );
  }
}

class AllTimeEarnings {
  final num total;
  final int jobsDone;
  final num averagePerJob;

  AllTimeEarnings({
    required this.total,
    required this.jobsDone,
    required this.averagePerJob,
  });

  factory AllTimeEarnings.fromJson(Map<String, dynamic> json) {
    return AllTimeEarnings(
      total: json['total'] ?? 0,
      jobsDone: json['jobsDone'] ?? 0,
      averagePerJob: json['averagePerJob'] ?? 0,
    );
  }
}

class PendingPayment {
  final String jobId;
  final String jobDescription;
  final String jobCategory;
  final String userName;
  final num agreedAmount;

  PendingPayment({
    required this.jobId,
    required this.jobDescription,
    required this.jobCategory,
    required this.userName,
    required this.agreedAmount,
  });

  factory PendingPayment.fromJson(Map<String, dynamic> json) {
    return PendingPayment(
      jobId: json['jobId'] ?? '',
      jobDescription: json['jobDescription'] ?? '',
      jobCategory: json['jobCategory'] ?? '',
      userName: json['userName'] ?? '',
      agreedAmount: json['agreedAmount'] ?? 0,
    );
  }
}

class RecentEarning {
  final String quoteId;
  final String jobId;
  final String jobDescription;
  final String jobCategory;
  final String userName;
  final String? userAvatar;
  final num amount;
  final String date;

  RecentEarning({
    required this.quoteId,
    required this.jobId,
    required this.jobDescription,
    required this.jobCategory,
    required this.userName,
    this.userAvatar,
    required this.amount,
    required this.date,
  });

  factory RecentEarning.fromJson(Map<String, dynamic> json) {
    return RecentEarning(
      quoteId: json['quoteId'] ?? '',
      jobId: json['jobId'] ?? '',
      jobDescription: json['jobDescription'] ?? '',
      jobCategory: json['jobCategory'] ?? '',
      userName: json['userName'] ?? '',
      userAvatar: json['userAvatar'],
      amount: json['amount'] ?? 0,
      date: json['date'] ?? '',
    );
  }

  String? get avatarUrl {
    if (userAvatar == null || userAvatar!.isEmpty) return null;
    if (userAvatar!.startsWith('http')) return userAvatar;
    return '${AppConstants.BASE_URL}$userAvatar';
  }
}
