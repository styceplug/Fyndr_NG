import 'package:fyndr_ng/helpers/global_loader_controller.dart';
import 'package:get/get.dart';
import 'package:fyndr_ng/data/repo/job_repo.dart';
import 'package:fyndr_ng/controllers/auth_controller.dart';

import '../model/job_model.dart';
import '../widgets/snackbars.dart';

class LeadController extends GetxController {
  final JobRepo jobRepo;
  LeadController({required this.jobRepo});



  List<JobModel> _allLeads = [];
  List<JobModel> _filteredLeads = [];
  List<JobModel> get leads => _filteredLeads;

  GlobalLoaderController loader = Get.find<GlobalLoaderController>();

  // Tabs: 0 = All, 1 = High Priority, 2 = Nearby
  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  @override
  void onInit() {
    super.onInit();
    getLeads();
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
      _filteredLeads = _allLeads.where((job) => job.urgency == 'high').toList();
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