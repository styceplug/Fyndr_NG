import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import '../api/api_client.dart';

class JobRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  JobRepo({required this.apiClient, required this.sharedPreferences});


  Future<Response> getMerchantLeads(int page, {int limit = 25}) async {
    return await apiClient.getData('${AppConstants.GET_MERCHANT_LEADS}?page=$page&limit=$limit');
  }

  Future<Response> getJobDetails(String jobId) async {
    return await apiClient.getData(AppConstants.GET_JOB_DETAILS(jobId));
  }

  Future<Response> getJobQuotes(String jobId) async {
    return await apiClient.getData(AppConstants.GET_JOB_QUOTES(jobId));
  }

  Future<Response> getUserJobs() async {
    return await apiClient.getData(AppConstants.GET_USER_JOBS);
  }

  Future<Response> createJob(Map<String, dynamic> jobData) async {
    return await apiClient.postData(AppConstants.POST_NEW_JOB, jobData);
  }

  Future<Response> createJobWithImages(http.MultipartRequest request) async {
    return await apiClient.postMultipartData(AppConstants.POST_NEW_JOB, request);
  }

}
