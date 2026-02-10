import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyndr_ng/data/repo/job_repo.dart';
import 'package:fyndr_ng/helpers/global_loader_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import '../data/api/api_client.dart';
import '../model/job_model.dart';
import '../routes/routes.dart';
import '../utils/app_constants.dart';
import '../utils/colors.dart';
import '../widgets/snackbars.dart';

class JobController extends GetxController {
  final JobRepo jobRepo;
  final ApiClient apiClient;

  JobController({required this.jobRepo, required this.apiClient});

  GlobalLoaderController loader = Get.find<GlobalLoaderController>();
  TextEditingController locationController = TextEditingController();
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  List<JobModel> _jobList = [];
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;
  List<QuoteModel> _quotes = [];
  List<QuoteModel> get quotes => _quotes;
  bool jobLoading = false;
  JobModel? _singleJob;
  List<QuoteModel> _quotesList = [];
  JobModel? get singleJob => _singleJob;
  List<QuoteModel> get quotesList => _quotesList;
  QuoteModel? _quote;
  QuoteModel? get quote => _quote;
  List<JobModel> merchantActiveJobs = [];
  List<JobModel> merchantCompletedJobs = [];
  List<JobModel> merchantCancelledJobs = [];


  Future<void> markJobAsCompleted(String jobId) async {

    bool confirm = await Get.dialog(
      AlertDialog(
        title: Text("Complete Job"),
        content: Text("Are you sure you want to mark this job as completed? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text("Yes, Complete", style: TextStyle(color: AppColors.color1, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ) ?? false;

    if (!confirm) return;

    loader.showLoader();
    update();

    try {
      Response response = await jobRepo.markJobAsCompleted(jobId);

      if (response.statusCode == 200) {
        CustomSnackBar.success(message: "Job marked as completed successfully!");

        await getUserJobs();
        Get.back();

      } else {
        String errorMsg = response.body['message'] ?? response.body['error'] ?? "Failed to complete job";
        CustomSnackBar.failure(message: errorMsg);
      }
    } catch (e) {
      print("Error completing job: $e");
      CustomSnackBar.failure(message: "An error occurred. Please try again.");
    } finally {
      loader.hideLoader();
      update();
    }
  }

  Future<void> getMerchantJobs() async {
    loader.showLoader();
    update();

    try {
      Response response = await jobRepo.getMerchantAcceptedJobs();

      if (response.statusCode == 200) {
        List<dynamic> rawData = response.body['data'];

        // Clear previous lists
        merchantActiveJobs.clear();
        merchantCompletedJobs.clear();
        merchantCancelledJobs.clear();

        for (var item in rawData) {
          JobModel job = JobModel.fromJson(item);

          // Categorize based on status flags
          if (job.status?.isCancelled == true) {
            merchantCancelledJobs.add(job);
          } else if (job.status?.isCompleted == true) {
            merchantCompletedJobs.add(job);
          } else {
            merchantActiveJobs.add(job);
          }
        }
      } else {
        print("Error fetching merchant jobs: ${response.body}");
      }
    } catch (e) {
      print("Exception fetching merchant jobs: $e");
    } finally {
      loader.hideLoader();
      update();
    }
  }

  Future<void> counterQuoteAction(String quoteId, int amount, String reason) async {
    loader.showLoader();

    Map<String, dynamic> body = {
      "amount": amount,
      "reason": reason,
      "comment": ""
    };

    Response response = await jobRepo.counterQuote(quoteId, body);

    loader.hideLoader();
    if (response.statusCode == 200) {
      CustomSnackBar.success(message: "Counter offer sent!");
      Get.back();
      Get.toNamed(AppRoutes.counterOfferScreen,
      arguments: {
        'quoteId' : quoteId
      });
    } else {
      CustomSnackBar.failure(message: response.body['message'] ?? "Failed to send counter offer");
    }
  }

  Future<void> declineQuoteAction(String quoteId, String reason, String comment) async {
    loader.showLoader();

    Map<String, dynamic> body = {
      "reason": reason,
      "comment": comment
    };

    Response response = await jobRepo.rejectQuote(quoteId, body);

    loader.hideLoader();
    if (response.statusCode == 200) {
      CustomSnackBar.success(message: "Quote declined");
      Get.back();
    } else {
      CustomSnackBar.failure(message: response.body['message'] ?? "Failed to decline quote");
    }
  }

  Future<void> acceptQuoteAction(String quoteId) async {
    loader.showLoader();
    update();

    Response response = await jobRepo.acceptQuote(quoteId);

    loader.hideLoader();
    if (response.statusCode == 200) {
      CustomSnackBar.success(message: "Quote accepted successfully!");
      Get.offNamed(AppRoutes.bookingConfirmedScreen,arguments: {
        'quoteId':quoteId
      });
    } else {
      CustomSnackBar.failure(message: response.body['message'] ?? "Failed to accept quote");
    }
    update();
  }

  Future<void> getQuoteDetails(String quoteId) async {
    loader.showLoader();
    update();

    Response response = await jobRepo.getQuoteDetails(quoteId);

    if (response.statusCode == 200) {
      _quote = QuoteModel.fromJson(response.body['data']);
    } else {
      CustomSnackBar.failure(
        message: response.statusText ?? "Failed to load quote details",
      );
    }

    loader.hideLoader();
    update();
  }

  Future<void> getQuotes() async {
    loader.showLoader();
    update();

    Response response = await jobRepo.getMerchantQuotes(1);

    if (response.statusCode == 200) {
      _quotes = [];
      List<dynamic> data = response.body['data'];
      _quotes = data.map((e) => QuoteModel.fromJson(e)).toList();
    } else {
      CustomSnackBar.failure(message: response.statusText ?? "Failed to load quotes");
    }

   loader.hideLoader();
    update();
  }

  Future<void> getJobDetailsAndQuotes(String jobId) async {
    loader.showLoader();
    _singleJob = null;
    _quotesList = [];
    update();

    try {
      Response jobResponse = await jobRepo.getJobDetails(jobId);
      if (jobResponse.statusCode == 200) {
        _singleJob = JobModel.fromJson(jobResponse.body['data']);
      }

      Response quoteResponse = await jobRepo.getJobQuotes(jobId);
      if (quoteResponse.statusCode == 200) {
        List<dynamic> data = quoteResponse.body['data'];
        _quotesList = data.map((e) => QuoteModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error fetching job details: $e");
    } finally {
      loader.hideLoader();
      update();
    }
  }

  void setInitialJob(JobModel job) {
    _singleJob = job;
    _quotesList = [];
    loader.hideLoader();
    update();
  }

  List<JobModel> get activeJobs =>
      _jobList
          .where(
            (job) =>
                (job.status?.isOpen == true ||
                    job.status?.isInProgress == true) &&
                job.status?.isCancelled == false,
          )
          .toList();

  List<JobModel> get completedJobs =>
      _jobList.where((job) => job.status?.isCompleted == true).toList();

  List<JobModel> get cancelledJobs =>
      _jobList.where((job) => job.status?.isCancelled == true).toList();

  Future<void> getUserJobs() async {
    loader.showLoader();
    jobLoading = true;
    try {
      Response response = await jobRepo.getUserJobs();

      if (response.statusCode == 200) {
        _jobList = [];
        List<dynamic> data = response.body['data'];
        _jobList.addAll(data.map((e) => JobModel.fromJson(e)).toList());
        _isLoaded = true;
      } else {
        print("Error getting jobs: ${response.statusText}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      loader.hideLoader();
      jobLoading = false;
      update();
    }
  }

  Future<void> createJob(
    Map<String, dynamic> apiBody,
    List<XFile>? images,
  ) async {
    loader.showLoader();
    update();

    try {
      // --- SCENARIO: Use Multipart (FormData) ---
      print(
        "📸 Preparing FormData Request with ${images?.length ?? 0} images...",
      );

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '${jobRepo.apiClient.appBaseUrl}${AppConstants.POST_NEW_JOB}',
        ),
      );

      // 1. Add Headers (Important for Auth)
      request.headers.addAll({
        'Authorization': 'Bearer ${jobRepo.apiClient.token}',
        'Content-Type': 'multipart/form-data',
        // Though MultipartRequest sets this automatically, sometimes explicit helps
      });

      // 2. Add Text Fields
      // iterate through your apiBody.
      // If it's a Map (like location, budget), we JSON Encode it.
      apiBody.forEach((key, value) {
        if (key == 'images') return; // Skip photos key from the body map

        if (value is String) {
          request.fields[key] = value;
        } else if (value is Map || value is List) {
          // ⚠️ KEY FIX: Convert nested objects to JSON Strings
          request.fields[key] = jsonEncode(value);
        } else {
          request.fields[key] = value.toString();
        }
      });

      // 3. Add Files
      if (images != null && images.isNotEmpty) {
        for (var image in images) {
          // Determine Mime Type based on extension
          String? mimeType;
          if (image.path.toLowerCase().endsWith('.jpg') ||
              image.path.toLowerCase().endsWith('.jpeg')) {
            mimeType = 'image/jpeg';
          } else if (image.path.toLowerCase().endsWith('.png')) {
            mimeType = 'image/png';
          } else {
            mimeType = 'image/jpeg'; // Fallback
          }

          var file = await http.MultipartFile.fromPath(
            'images', // Field name
            image.path,
            contentType: MediaType.parse(
              mimeType,
            ), // <--- THIS FIXES THE 415 ERROR
          );
          request.files.add(file);
        }
      }

      print("🧾 Fields being sent: ${request.fields}");
      print("🧾 Files count: ${request.files.length}");

      // 4. Send Request
      Response response = await jobRepo.createJobWithImages(request);

      // 5. Handle Response
      loader.hideLoader();
      update();

      if (response.statusCode == 201 || response.statusCode == 200) {
        CustomSnackBar.success(
          message: "Service request created successfully!",
        );
        Get.offAllNamed(AppRoutes.homeScreen);
      } else {
        String errorMsg = "Failed to create request";
        if (response.body != null &&
            response.body is Map &&
            response.body['error'] != null) {
          errorMsg = response.body['error'];
        } else if (response.statusText != null) {
          errorMsg = response.statusText!;
        }
        print("❌ Error Response: ${response.body}");
        CustomSnackBar.failure(message: errorMsg);
      }
    } catch (e) {
      loader.hideLoader();
      update();
      print("❌ CREATE JOB ERROR: $e");
      CustomSnackBar.failure(message: "An error occurred. Check connection.");
    }
  }
}
