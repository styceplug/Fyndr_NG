import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fyndr_ng/helpers/global_loader_controller.dart';
import 'package:get/get.dart';
import 'package:fyndr_ng/data/repo/job_repo.dart';
import 'package:fyndr_ng/controllers/auth_controller.dart';
import 'package:image_picker/image_picker.dart';

import '../model/job_model.dart';
import '../widgets/snackbars.dart';

class LeadController extends GetxController {
  final JobRepo jobRepo;
  LeadController({required this.jobRepo});


  late TextEditingController amountCtrl;
  late TextEditingController hoursCtrl;
  late TextEditingController messageCtrl;

  String _availability = "flexible";
  String get availability => _availability;

  final List<String> _addons = [];
  List<String> get addons => _addons;

  final List<XFile> _images = [];
  List<XFile> get images => _images;


  List<JobModel> _allLeads = [];
  List<JobModel> _filteredLeads = [];
  List<JobModel> get leads => _filteredLeads;

  GlobalLoaderController loader = Get.find<GlobalLoaderController>();


  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  @override
  void onInit() {
    super.onInit();
    // 2. Initialize controllers here
    amountCtrl = TextEditingController();
    hoursCtrl = TextEditingController();
    messageCtrl = TextEditingController();
  }

  @override
  void onClose() {
    amountCtrl.dispose();
    hoursCtrl.dispose();
    messageCtrl.dispose();
    super.onClose();
  }

  void clearQuoteForm() {
    amountCtrl.clear();
    hoursCtrl.clear();
    messageCtrl.clear();
    _availability = "flexible";
    _addons.clear();
    _images.clear();
    update();
  }


  Future<void> submitQuote({
    required String jobId,
    required VoidCallback onSuccess,
  }) async {
    print('🎯 Starting quote submission for job: $jobId');

    // Validate amount
    final amountText = amountCtrl.text.trim();
    print('💰 Amount text: "$amountText"');

    final amount = int.tryParse(amountText);
    if (amount == null || amount <= 0) {
      print('❌ Invalid amount: $amount');
      CustomSnackBar.failure(message: "Enter a valid amount");
      return;
    }
    print('✅ Valid amount: $amount');

    // Compute estimated completion time
    final hoursText = hoursCtrl.text.trim();
    print('⏰ Hours text: "$hoursText"');

    final estimated = _computeEstimatedCompletionTimeFromHours(hoursText);
    print('✅ Estimated completion: $estimated');

    // Check availability
    print('📅 Availability: $_availability');

    // Check addons
    print('➕ Addons (${_addons.length}): $_addons');

    // Check message
    final messageText = messageCtrl.text.trim();
    print('💬 Message: "${messageText.isEmpty ? '(empty)' : messageText.substring(0, messageText.length > 50 ? 50 : messageText.length)}..."');

    // Check images
    print('🖼️ Images (${_images.length}): ${_images.map((img) => img.name).toList()}');

    final body = SubmitQuoteBody(
      jobId: jobId,
      amount: amount,
      estimatedCompletionTime: estimated,
      availability: _availability,
      message: messageText,
      addons: _addons,
      images: _images,
    );

    print('📦 Quote body created');
    print('   Fields: ${body.toFields()}');

    loader.showLoader();
    try {
      print('🔄 Calling API...');
      final res = await jobRepo.submitQuoteMultipart(
        fields: body.toFields(),
        images: body.images,
      );

      print('📬 API Response - Status: ${res.statusCode}');
      print('📬 API Response - Body: ${res.body}');

      if (res.statusCode == 201 || res.statusCode == 200) {
        print('✅ Quote submitted successfully');
        CustomSnackBar.success(message: res.body?['message'] ?? "Quote sent");
        clearQuoteForm();
        onSuccess();
      } else {
        print('❌ Quote submission failed');
        CustomSnackBar.failure(
          message: res.body?['message'] ?? "Unable to submit quote",
        );
      }
    } catch (e, stackTrace) {
      print('❌ Exception during quote submission: $e');
      print('❌ Stack trace: $stackTrace');
      CustomSnackBar.failure(message: "An error occurred: $e");
    } finally {
      loader.hideLoader();
      print('🏁 Quote submission process completed');
    }
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(imageQuality: 85);
    if (picked.isNotEmpty) {
      _images
        ..clear()
        ..addAll(picked.take(10));
      update();
    }
  }

  DateTime _computeEstimatedCompletionTimeFromHours(String hoursText) {
    final hours = int.tryParse(hoursText.trim()) ?? 0;
    final validHours = hours <= 0 ? 1 : hours;

    print('⏰ Computing estimated time: $hoursText → $hours hours → using $validHours hours');

    final now = DateTime.now();
    final estimated = now.add(Duration(hours: validHours));

    print('⏰ Current time: $now');
    print('⏰ Estimated completion: $estimated');

    return estimated;
  }

  void toggleAddon(String value) {
    if (_addons.contains(value)) {
      _addons.remove(value);
    } else {
      _addons.add(value);
    }
    update();
  }

  void setAvailability(String value) {
    _availability = value;
    update();
  }

  Future<void> getLeads() async {
    loader.showLoader();
    update();

    Response response = await jobRepo.getMerchantLeads(1);
    if (response.statusCode == 200) {
      _allLeads = [];
      _filteredLeads = [];

      List<dynamic> data = response.body['data'];
      _allLeads = data.map((e) => JobModel.fromJson(e)).toList();

      _applyFilter();

    } else {
      CustomSnackBar.failure(message: response.statusText ?? "Failed to load leads");
    }

    loader.hideLoader();
    update();
  }

  void setFilterTab(int index) {
    _selectedTabIndex = index;
    _applyFilter();
    update();
  }

  void _applyFilter() {
    if (_selectedTabIndex == 0) {
      // ALL
      _filteredLeads = List.from(_allLeads);
    } else if (_selectedTabIndex == 1) {
      _filteredLeads = _allLeads.where((job) => job.urgency == 'urgent').toList();
    } else if (_selectedTabIndex == 2) {

      String? myLga = Get.find<AuthController>().userModel?.location?.lga;
      if (myLga != null) {
        _filteredLeads = _allLeads.where((job) => job.location?.lga == myLga).toList();
      } else {
        _filteredLeads = List.from(_allLeads);
      }
    }
  }
}