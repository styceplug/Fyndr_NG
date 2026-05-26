import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyndr_ng/controllers/app_controller.dart';
import 'package:fyndr_ng/controllers/job_controller.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:fyndr_ng/utils/dimensions.dart';
import 'package:fyndr_ng/widgets/custom_appbar.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:fyndr_ng/widgets/custom_textfield.dart';
import 'package:fyndr_ng/widgets/snackbars.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import '../../helpers/global_loader_controller.dart';
import '../../model/job_model.dart';
import '../../routes/routes.dart';
import '../../widgets/country_state_dropdown.dart';

class RequestForm extends StatefulWidget {
  const RequestForm({super.key});

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  int _currentStep = 0;
  String _serviceTitle = 'Request Service';

  AppController appController = Get.find<AppController>();
  JobController jobController = Get.find<JobController>();

  double? _latitude;
  double? _longitude;
  String? _detectedStreet;
  String? _detectedCity;
  String? _detectedState;

  final locationDisplayController = TextEditingController();
  String? selectedState;
  String? selectedLga;


  final _houseNumController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();

  final _timeController = TextEditingController();
  final _dateController = TextEditingController();
  String _urgency = 'Normal';

  double _budgetSliderValue = 0;
  final _minBudgetController = TextEditingController();
  final _maxBudgetController = TextEditingController();
  final _descController = TextEditingController();

  final List<String> _stages = [
    'LOCATION',
    'DATE & TIME',
    'SET BUDGET',
    'DESCRIPTION'
  ];
  final GlobalLoaderController loader = GlobalLoaderController();
  String? _selectedSubCategory;
  final List<String> _subCategories = [
    'Plumbing',
    'Painting',
    'Carpentry',
    'Electrical'
  ];
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImages = [];



 double _minLimit = 1000;
 double _maxLimit = 1000000;

  RangeValues _currentRangeValues = const RangeValues(5000, 500000);

  String _formatMoney(double value) {
    return value.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},'
    );
  }

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null && Get.arguments is Map) {
      _serviceTitle = Get.arguments['serviceTitle'];
    }
    _minBudgetController.text = _formatMoney(_currentRangeValues.start);
    _maxBudgetController.text = _formatMoney(_currentRangeValues.end);
  }

  @override
  void dispose() {
    _houseNumController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _timeController.dispose();
    _dateController.dispose();
    _minBudgetController.dispose();
    _maxBudgetController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _nextStep() {
    setState(() {
      if (_currentStep < _stages.length - 1) {
        _currentStep++;
      } else {
        _submitForm();
      }
    });
  }

  void _previousStep() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      } else {
        Navigator.pop(context);
      }
    });
  }

  Future<void> getCurrentLocation() async {
    print("📍 START: getCurrentLocation called");
    loader.showLoader();

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      // 1. THIS GETS THE EXACT COORDINATES
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Store Raw Coordinates in your variables
      _latitude = position.latitude;
      _longitude = position.longitude;

      // 👇 ADD THIS LINE TO SEE THE NUMBERS IN CONSOLE
      print("🌎 GPS Coordinates: Lat: $_latitude, Lng: $_longitude");

      // 2. Geocoding (Trying to find a name for those coordinates)
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          print("🔍 Raw Placemark: ${place.toJson()}");

          // Logic to build the best possible address string
          String streetPart = "";
          if (place.thoroughfare != null && place.thoroughfare!.isNotEmpty) {
            streetPart = "${place.subThoroughfare ?? ''} ${place.thoroughfare}".trim();
          } else {
            // Fallback if map data has no street name
            streetPart = place.name ?? "Unnamed Street";
          }

          String cityPart = [
            place.subLocality,
            place.locality ?? place.subAdministrativeArea
          ].where((e) => e != null && e.isNotEmpty).toSet().join(", ");

          _detectedStreet = streetPart;
          _detectedCity = cityPart;
          _detectedState = place.administrativeArea;

          // Construct Final String
          String fullAddress = [
            _detectedStreet,
            _detectedCity,
            _detectedState
          ].where((e) => e != null && e.isNotEmpty).join(", ");

          // Update UI
          jobController.locationController.text = fullAddress;
          print("✅ DETECTED ADDRESS: $fullAddress");
        }
      } catch (e) {
        // If address lookup fails, we still have coordinates!
        print("⚠️ Address lookup failed, using coordinates");
        jobController.locationController.text = "${_latitude}, ${_longitude}";
      }
    } catch (e) {
      print("❌ ERROR: $e");
    } finally {
      loader.hideLoader();
    }
  }



  void _submitForm() {
    String finalHouseNum = "";
    String finalStreet = "";
    String finalCity = "";
    String finalState = "";

    if (_serviceTitle == 'Home Maintenance' && _selectedSubCategory == null) {
      CustomSnackBar.failure(message:"Please select a specific service type (e.g. Plumbing)");
      return;
    }

    double finalLat = _latitude ?? 0.0;
    double finalLng = _longitude ?? 0.0;

    // --- LOGIC FIX START ---
    if (_serviceTitle == 'Real Estate') {
      finalHouseNum = _houseNumController.text;
      finalStreet = _streetController.text;
      finalCity = _cityController.text;
      finalState = _stateController.text;
    } else {
      // For Cleaning/Maintenance
      // 1. Prioritize manually selected location from the picker
      if (selectedLga != null && selectedState != null) {
        finalCity = selectedLga!;
        finalState = selectedState!;
        finalStreet = locationDisplayController.text; // Or just use City, State
      }
      // 2. Fallback to GPS detected location if picker wasn't used
      else if (_detectedCity != null) {
        finalCity = _detectedCity!;
        finalState = _detectedState!;
        finalStreet = _detectedStreet ?? jobController.locationController.text;
      }
      // 3. Fallback to whatever is in the text controller (manual entry?)
      else {
        finalCity = "Unknown";
        finalState = "Unknown";
        finalStreet = jobController.locationController.text;
      }
    }
    // --- LOGIC FIX END ---

    String finalTime = _timeController.text.trim().isEmpty
        ? "00:00"
        : _timeController.text.trim();

    String displayAddr = _serviceTitle == 'Real Estate'
        ? "$finalHouseNum $finalStreet, $finalCity"
        : "$finalCity, $finalState"; // Better display format

    String fullBudget = "N${_minBudgetController.text} - N${_maxBudgetController.text}";

    final requestData = ServiceRequestData(
      serviceType: _serviceTitle,
      displayLocation: displayAddr,
      displayDate: "${_dateController.text} at $finalTime",
      urgency: _urgency,
      displayBudget: fullBudget,
      description: _descController.text,
      houseNumber: finalHouseNum,
      street: finalStreet,
      city: finalCity, // This now holds LGA correctly
      state: finalState, // This now holds State correctly
      lat: finalLat,
      lng: finalLng,
      rawDate: _dateController.text,
      rawTime: finalTime,
      minBudget: _minBudgetController.text,
      maxBudget: _maxBudgetController.text,
      images: _selectedImages,
      subcategory: _serviceTitle == 'Home Maintenance' ? _selectedSubCategory : null,
    );

    Get.toNamed(AppRoutes.reviewRequest, arguments: requestData);
  }

  Future<void> _pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage(
      imageQuality: 50, // Reduce quality to 50%
      maxWidth: 800,    // Resize width to 800px max
      maxHeight: 800,   // Resize height to 800px max
    );

    if (images != null && images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        leadingIcon: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _previousStep,
        ),
        title: 'Request $_serviceTitle',
      ),
      body: Container(
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        padding: EdgeInsets.fromLTRB(
          Dimensions.width20,
          Dimensions.height5,
          Dimensions.width20,
          Dimensions.height10 * 5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepHeader(),

            SizedBox(height: Dimensions.height40),

            Expanded(
              child: SingleChildScrollView(child: _buildCurrentStepContent()),
            ),

            CustomButton(
              text: _currentStep == _stages.length - 1
                  ? 'Submit Request'
                  : _stages[_currentStep + 1] == 'DESCRIPTION'
                  ? 'Describe your Request'
                  : 'Continue to ${_stages[_currentStep + 1]}',
              onPressed: _nextStep,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_stages.length, (index) {
        bool isActive = index == _currentStep;
        bool isCompleted = index < _currentStep;

        return Expanded(
          child: GestureDetector(
            // 🔹 Make the tab tappable
            onTap: () {
              setState(() {
                _currentStep = index;
              });
            },
            // Add HitTestBehavior.opaque so tapping anywhere in the Expanded area triggers the tap
            behavior: HitTestBehavior.opaque,
            child: Column(
              children: [
                Text(
                  _stages[index],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: Dimensions.font12,
                    fontWeight: FontWeight.w500,
                    color:
                    (isActive || isCompleted) ? Colors.black : AppColors.grey3,
                  ),
                ),
                SizedBox(height: Dimensions.height5),
                Container(
                  height: Dimensions.height5,
                  width: Dimensions.width10 * 8,
                  decoration: BoxDecoration(
                    color:
                    (isActive || isCompleted)
                        ? AppColors.color1
                        : AppColors.grey3,
                    borderRadius: BorderRadius.circular(Dimensions.radius10),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildLocationStep();
      case 1:
        return _buildDateTimeStep();
      case 2:
        return _buildBudgetStep();
      case 3:
        return _buildDescriptionStep();
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildLocationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Service Location', style: TextStyle(
            fontSize: Dimensions.font18, fontWeight: FontWeight.w600)),
        SizedBox(height: Dimensions.height10),

        if(_serviceTitle != 'Real Estate') ...[
          Text('SELECT LOCATION', style: TextStyle(fontSize: Dimensions.font13,
              color: AppColors.color1,
              fontWeight: FontWeight.w500)),
          SizedBox(height: Dimensions.height10),
          GestureDetector(
            onTap: getCurrentLocation,
            child: AbsorbPointer(
              child: CustomTextField(
                controller: jobController.locationController,
                // Use AppController's
                hintText: 'Use your Location',
                suffixIcon: Icon(Icons.location_searching),
              ),
            ),
          ),
          SizedBox(height: Dimensions.height20)
        ],

        if(_serviceTitle == 'Real Estate') ...[
          Text('WHERE DO YOU NEED THE PROPERTY?', style: TextStyle(fontSize: Dimensions.font13,
              color: AppColors.color1,
              fontWeight: FontWeight.w500)),
          SizedBox(height: Dimensions.height10),],

        if(_serviceTitle != 'Real Estate') ...[
          Text('WHAT AREA BEST DESCRIBES WHERE YOU ARE?', style: TextStyle(fontSize: Dimensions.font13,
              color: AppColors.color1,
              fontWeight: FontWeight.w500)),
          SizedBox(height: Dimensions.height10),],

          GestureDetector(
            onTap: _openLocationPicker,
            child: AbsorbPointer( // Prevents keyboard from opening
              child: CustomTextField(
                controller: locationDisplayController,
                hintText: "Tap to select location",
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width10),
                  child: Icon(Icons.location_on_outlined, color: AppColors.grey4),
                ),
                suffixIcon: Icon(Icons.arrow_drop_down, color: AppColors.grey4),
              ),
            ),
          ),


      ],
    );
  }

  void _openLocationPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LocationPickerModal(
        enableState: selectedState, // Pass current selection
        enableLga: selectedLga,     // Pass current selection
        onConfirm: (newState, newLga) {
          setState(() {
            // 1. Update State Variables
            selectedState = newState;
            selectedLga = newLga;

            // 2. Update Visual Display (User sees "Ikeja, Lagos")
            locationDisplayController.text = "$newLga, $newState";

            // 3. IMPORTANT: Update Hidden Data Controllers for API
            _cityController.text = newLga;   // Mapping LGA to City field
            _stateController.text = newState; // Mapping State to State field
          });
        },
      ),
    );
  }

  Widget _buildDateTimeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Date & Time',
          style: TextStyle(
            fontSize: Dimensions.font18,
            fontWeight: FontWeight.w600,
          ),
        ),

        // --- TIME PICKER FIELD ---
        if(_serviceTitle != 'Real Estate')...[
          SizedBox(height: Dimensions.height20),
          GestureDetector(
            onTap: () => _selectTime(context),
            child: AbsorbPointer( // Prevents keyboard from opening
              child: CustomTextField(
                hintText: 'Pick a time',
                controller: _timeController,
                // Make sure your CustomTextField accepts readOnly, if not AbsorbPointer handles it
                // readOnly: true,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(
                    left: Dimensions.width20,
                    right: Dimensions.width5,
                  ),
                  child: Icon(Iconsax.clock5, color: AppColors.grey4),
                ),
              ),
            ),
          ),

        ],

        SizedBox(height: Dimensions.height20),

        // --- DATE PICKER FIELD ---
        GestureDetector(
          onTap: () => _selectDate(context),
          child: AbsorbPointer( // Prevents keyboard from opening
            child: CustomTextField(
              hintText: 'Pick a date',
              controller: _dateController,
              // readOnly: true,
              prefixIcon: Padding(
                padding: EdgeInsets.only(
                  left: Dimensions.width20,
                  right: Dimensions.width5,
                ),
                child: Icon(Iconsax.calendar_15, color: AppColors.grey4),
              ),
            ),
          ),
        ),

        SizedBox(height: Dimensions.height20),
        Text(
          'URGENCY',
          style: TextStyle(
            fontSize: Dimensions.font14,
            color: AppColors.color1,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: Dimensions.height10),
        GestureDetector(
          onTap: () => setState(() => _urgency = 'Normal'),
          child: _buildRadioOption(
            'Normal',
            'Can wait for quotes',
            _urgency == 'Normal',
          ),
        ),
        SizedBox(height: Dimensions.height10),
        GestureDetector(
          onTap: () => setState(() => _urgency = 'Urgent'),
          child: _buildRadioOption(
            'Urgent',
            'Needed ASAP',
            _urgency == 'Urgent',
          ),
        ),
      ],
    );
  }

  Widget _buildRadioOption(String title, String subtitle, bool isSelected) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(color: isSelected ? AppColors.color2 : AppColors.white, borderRadius: BorderRadius.circular(Dimensions.radius20), border: Border.all(color: isSelected ? Colors.transparent : AppColors.grey4)),
      child: Row(
        children: [
          Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? AppColors.white : AppColors.grey4),
          SizedBox(width: Dimensions.width10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontSize: Dimensions.font15, fontWeight: FontWeight.w500, color: isSelected ? AppColors.white : AppColors.black)),
            Text(subtitle, style: TextStyle(fontSize: Dimensions.font12, fontWeight: FontWeight.w400, color: isSelected ? AppColors.white : AppColors.black)),
          ]),
        ],
      ),
    );
  }

  Widget _buildBudgetStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Set Budget',
          style: TextStyle(
              fontSize: Dimensions.font18,
              fontWeight: FontWeight.w600
          ),
        ),
        SizedBox(height: Dimensions.height20),

        Align(
          alignment: Alignment.center,
          child: Text(
            'N${_formatMoney(_currentRangeValues.start)} - N${_formatMoney(_currentRangeValues.end)}',
            style: TextStyle(
                fontSize: Dimensions.font22,
                fontWeight: FontWeight.w600
            ),
          ),
        ),

        SizedBox(height: Dimensions.height10),

        // --- RANGE SLIDER ---
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.color1,
            inactiveTrackColor: AppColors.grey3,
            thumbColor: AppColors.white,
            overlayColor: AppColors.color1.withOpacity(0.2),
            valueIndicatorColor: AppColors.color1,
            // Customizing thumb shape to look more like your design if needed
            rangeThumbShape: RoundRangeSliderThumbShape(enabledThumbRadius: 12),
          ),
          child: RangeSlider(
            values: _currentRangeValues,
            min: _minLimit,
            max: _maxLimit,
            divisions: 1000, // Makes it snap nicely
            labels: RangeLabels(
              'N${_formatMoney(_currentRangeValues.start)}',
              'N${_formatMoney(_currentRangeValues.end)}',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeValues = values;
                // Update Text Fields
                _minBudgetController.text = _formatMoney(values.start);
                _maxBudgetController.text = _formatMoney(values.end);
              });
            },
          ),
        ),

        SizedBox(height: Dimensions.height20),
        Divider(color: AppColors.grey3),
        SizedBox(height: Dimensions.height20),

        // --- INPUT FIELDS ---
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'MINIMUM',
                      style: TextStyle(
                          fontSize: Dimensions.font13,
                          color: AppColors.color1,
                          fontWeight: FontWeight.w500
                      )
                  ),
                  SizedBox(height: Dimensions.height10),

                  CustomTextField(
                    hintText: 'N1,000',
                    controller: _minBudgetController,
                    maxLines: 1,

                  ),


                ],
              ),
            ),
            SizedBox(width: Dimensions.width20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'MAXIMUM',
                      style: TextStyle(
                          fontSize: Dimensions.font13,
                          color: AppColors.color1,
                          fontWeight: FontWeight.w500
                      )
                  ),
                  SizedBox(height: Dimensions.height10),
                  CustomTextField(
                    hintText: 'N1,000,000',
                    controller: _maxBudgetController,
                    maxLines: 1,

                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: Dimensions.height50), // Spacing from the inputs

        Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width20,
            vertical: Dimensions.height10,
          ),
          width: Dimensions.screenWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radius10),
            border: Border.all(color: AppColors.grey4),
            color: AppColors.grey1, // Assuming this is your light grey background color
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, size: Dimensions.font16, color: AppColors.grey5),
                  SizedBox(width: Dimensions.width5),
                  Text(
                    'Why set budgets?',
                    style: TextStyle(
                      fontSize: Dimensions.font13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey5,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height5),
              Text(
                'One-time fee to send your requests to verified providers. You will receive quotes within 24 hours',
                style: TextStyle(
                  fontSize: Dimensions.font13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey5,
                  height: 1.4, // Adds a little line spacing for readability
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Problem Description',
          style: TextStyle(fontSize: Dimensions.font18, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: Dimensions.height20),

        if(_serviceTitle == 'Home Maintenance')...[
          Text(
            'SERVICE TYPE',
            style: TextStyle(fontSize: Dimensions.font13, color: AppColors.color1, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: Dimensions.height10),

          Container(
            width: Dimensions.screenWidth,
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey4),
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedSubCategory,
                hint: Text("Select Service", style: TextStyle(color: AppColors.grey4)),
                icon: Icon(Icons.arrow_drop_down, color: AppColors.black),
                isExpanded: true,
                items: _subCategories.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedSubCategory = newValue;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: Dimensions.height20),
        ],


        Text(
          'DESCRIBE THE PROBLEM',
          style: TextStyle(fontSize: Dimensions.font13, color: AppColors.color1, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: Dimensions.height10),
        CustomTextField(
          hintText: 'Tell providers exactly what you need.',
          maxLines: 4,
          controller: _descController,
        ),
        SizedBox(height: Dimensions.height20),


        if(_serviceTitle != 'Real Estate')...[
          Text(
            'ADD PHOTOS',
            style: TextStyle(fontSize: Dimensions.font13, color: AppColors.color1, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: Dimensions.height10),

          // --- DYNAMIC IMAGE LIST ---
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // 1. Show Selected Images
                ...List.generate(_selectedImages.length, (index) {
                  return Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: Dimensions.width15),
                        height: Dimensions.height100,
                        width: Dimensions.width100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radius10),
                          image: DecorationImage(
                            image: FileImage(File(_selectedImages[index].path)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Delete Button (X)
                      Positioned(
                        top: 0,
                        right: 15, // Adjusted for margin
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                            child: Icon(Icons.close, size: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                }),

                // 2. Add Button (Always visible at the end)
                GestureDetector(
                  onTap: _pickImages,
                  child: Container(
                    height: Dimensions.height100,
                    width: Dimensions.width100,
                    decoration: BoxDecoration(
                      color: AppColors.grey2,
                      borderRadius: BorderRadius.circular(Dimensions.radius10),
                      border: Border.all(color: AppColors.grey4, style: BorderStyle.solid),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo, color: AppColors.grey4),
                        SizedBox(height: 5),
                        Text("Add", style: TextStyle(color: AppColors.grey5, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]

      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // User cannot pick a past date
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.color1, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.color1, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        // Format: YYYY-MM-DD
        String formattedDate = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        _dateController.text = formattedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.color1,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.color1,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        // Format: HH:MM (24-hour format)
        String hour = picked.hour.toString().padLeft(2, '0');
        String minute = picked.minute.toString().padLeft(2, '0');
        _timeController.text = "$hour:$minute";
      });
    }
  }
}
