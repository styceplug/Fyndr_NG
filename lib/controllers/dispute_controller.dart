import 'package:flutter/material.dart';
import 'package:fyndr_ng/data/repo/chat_repo.dart';
import 'package:fyndr_ng/helpers/global_loader_controller.dart';
import 'package:get/get.dart';
import '../data/api/api_checker.dart';
import '../model/dispute_model.dart';
import '../widgets/snackbars.dart';

class DisputeController extends GetxController {
  final ChatRepo disputeRepo;
  DisputeController({required this.disputeRepo});

  // form controllers
  final subjectCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final transactionRefCtrl = TextEditingController();

  // final isSubmitting = false.obs;
  GlobalLoaderController loader = Get.find<GlobalLoaderController>();

  // selections
  final selectedPriority = 'high'.obs;
  final selectedCategory = 'overcharging'.obs;

  // injected context from chat
  String? vendorId;
  String? chatId;
  String? vendorName;

  void initFromArgs(dynamic args) {
    if (args is Map) {
      vendorId = args['vendorId']?.toString();
      chatId = args['chatId']?.toString();
      vendorName = args['vendorName']?.toString();

      final trx = args['transactionRef']?.toString();
      if (trx != null && trx.isNotEmpty) transactionRefCtrl.text = trx;
    }
  }

  bool _validate() {
    if (vendorId == null || chatId == null) {
      CustomSnackBar.failure(message: "Missing chat/vendor data.");
      return false;
    }

    if (subjectCtrl.text.trim().length < 5) {
      CustomSnackBar.failure(message: "Subject is too short.");
      return false;
    }

    if (descriptionCtrl.text.trim().length < 10) {
      CustomSnackBar.failure(message: "Please describe the issue clearly.");
      return false;
    }

    return true;
  }

  Future<void> submitDispute() async {
    if (!_validate()) return;

    loader.showLoader();
    update();

    final payload = CreateDisputeRequest(
      vendor: vendorId!,
      chat: chatId!,
      subject: subjectCtrl.text.trim(),
      description: descriptionCtrl.text.trim(),
      transactionRef: transactionRefCtrl.text.trim().isEmpty
          ? null
          : transactionRefCtrl.text.trim(),
      priority: selectedPriority.value,
      category: selectedCategory.value,
    );

    final res = await disputeRepo.createDispute(payload);

    loader.hideLoader();
    update();

    if (res.statusCode == 201 || res.statusCode == 200) {
      CustomSnackBar.success(message: res.body?['message'] ?? "Dispute created.");
      Get.back(); // close page
      return;
    }

    // your ApiChecker handles common errors
    ApiChecker.checkApi(res);
  }

  @override
  void onClose() {
    subjectCtrl.dispose();
    descriptionCtrl.dispose();
    transactionRefCtrl.dispose();
    super.onClose();
  }
}

