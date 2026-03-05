class DisputeModel {
  String? id;
  String? user;
  String? vendor;
  String? chat;
  String? subject;
  String? description;
  String? transactionRef;
  String? priority;
  String? category;
  String? progress;
  String? createdAt;
  String? updatedAt;

  DisputeModel({
    this.id,
    this.user,
    this.vendor,
    this.chat,
    this.subject,
    this.description,
    this.transactionRef,
    this.priority,
    this.category,
    this.progress,
    this.createdAt,
    this.updatedAt,
  });

  factory DisputeModel.fromJson(Map<String, dynamic> json) {
    return DisputeModel(
      id: json['id'] ?? json['_id'],
      user: json['user']?.toString(),
      vendor: json['vendor']?.toString(),
      chat: json['chat']?.toString(),
      subject: json['subject']?.toString(),
      description: json['description']?.toString(),
      transactionRef: json['transactionRef']?.toString(),
      priority: json['priority']?.toString(),
      category: json['category']?.toString(),
      progress: json['progress']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }
}

class CreateDisputeRequest {
  final String vendor;
  final String chat;
  final String subject;
  final String description;
  final String? transactionRef;
  final String priority; // low|medium|high
  final String category; // overcharging|fraud|harassment|...

  CreateDisputeRequest({
    required this.vendor,
    required this.chat,
    required this.subject,
    required this.description,
    this.transactionRef,
    required this.priority,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      "vendor": vendor,
      "chat": chat,
      "subject": subject,
      "description": description,
      "transactionRef": transactionRef,
      "priority": priority,
      "category": category,
    }..removeWhere((k, v) => v == null || (v is String && v.trim().isEmpty));
  }
}