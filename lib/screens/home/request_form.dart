import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/colors.dart';
import 'package:fyndr_ng/utils/dimensions.dart';
import 'package:fyndr_ng/widgets/custom_appbar.dart';
import 'package:fyndr_ng/widgets/custom_button.dart';
import 'package:fyndr_ng/widgets/custom_textfield.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../model/service_model.dart';
import '../../routes/routes.dart';

class RequestForm extends StatefulWidget {
  const RequestForm({super.key});

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  int _currentStep = 0;
  String _serviceTitle = 'Request Service'; // Default

  final _houseNumController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();

  final _timeController = TextEditingController();
  final _dateController = TextEditingController();
  String _urgency = 'Normal'; // Default urgency

  double _budgetSliderValue = 0;
  final _minBudgetController = TextEditingController();
  final _maxBudgetController = TextEditingController();

  final _descController = TextEditingController();
  final List<String> _stages = [
    'LOCATION',
    'DATE & TIME',
    'SET BUDGET',
    'DESCRIPTION',
  ];

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null && Get.arguments is Map) {
      _serviceTitle = Get.arguments['serviceTitle'];
    }
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
        print("Form Submitted");
        _submitForm();
      }
    });
  }

  void _submitForm() {
    String fullAddress =
        "${_houseNumController.text} ${_streetController.text}, ${_cityController.text}, ${_stateController.text}";
    if (fullAddress.trim() == ", , , ") fullAddress = "No address provided";

    String fullDateTime = "${_dateController.text} - ${_timeController.text}";

    String fullBudget =
        "N${_minBudgetController.text} - N${_maxBudgetController.text}";

    final requestData = ServiceRequestData(
      serviceType: _serviceTitle,
      location: fullAddress,
      dateTime: fullDateTime,
      urgency: _urgency,
      budgetRange: fullBudget,
      description: _descController.text,
    );

    Get.toNamed(AppRoutes.reviewRequest, arguments: requestData);
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
              text:
                  _currentStep == _stages.length - 1
                      ? 'Submit Request'
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

        return Column(
          children: [
            Text(
              _stages[index],
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
        Text(
          'Service Location',
          style: TextStyle(
            fontSize: Dimensions.font18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: Dimensions.height20),
        Text(
          'SELECT LOCATION',
          style: TextStyle(
            fontSize: Dimensions.font13,
            color: AppColors.color1,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: Dimensions.height10),
        CustomTextField(
          prefixIcon: Padding(
            padding: EdgeInsetsGeometry.only(
              left: Dimensions.width15,
              right: Dimensions.width5,
            ),
            child: Icon(Iconsax.location5, color: AppColors.grey4),
          ),
          hintText: 'Pick a location',
        ),
        SizedBox(height: Dimensions.height20),
        Text(
          'INPUT ADDRESS',
          style: TextStyle(
            fontSize: Dimensions.font13,
            color: AppColors.color1,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: Dimensions.height10),
        CustomTextField(
          hintText: 'House Number',
          controller: _houseNumController,
        ),
        SizedBox(height: Dimensions.height10),
        CustomTextField(
          hintText: 'Street address',
          controller: _streetController,
        ),
        SizedBox(height: Dimensions.height10),
        CustomTextField(hintText: 'City', controller: _cityController),
        SizedBox(height: Dimensions.height10),
        CustomTextField(
          hintText: 'Local Gov Area',
          controller: _cityController,
        ),
        SizedBox(height: Dimensions.height10),
        CustomTextField(hintText: 'State', controller: _stateController),
      ],
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
        SizedBox(height: Dimensions.height20),
        Text(
          'SELECT TIME',
          style: TextStyle(
            fontSize: Dimensions.font13,
            color: AppColors.color1,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: Dimensions.height10),
        CustomTextField(
          hintText: 'Pick a time',
          controller: _timeController,
          prefixIcon: Padding(
            padding: EdgeInsetsGeometry.only(
              left: Dimensions.width15,
              right: Dimensions.width5,
            ),
            child: Icon(Iconsax.clock5, color: AppColors.grey4),
          ),
        ),
        SizedBox(height: Dimensions.height20),
        Text(
          'SELECT DATE',
          style: TextStyle(
            fontSize: Dimensions.font13,
            color: AppColors.color1,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: Dimensions.height10),
        CustomTextField(
          hintText: 'Pick a date',
          controller: _dateController,
          prefixIcon: Padding(
            padding: EdgeInsetsGeometry.only(
              left: Dimensions.width15,
              right: Dimensions.width5,
            ),
            child: Icon(Iconsax.calendar_15, color: AppColors.grey4),
          ),
        ),

        SizedBox(height: Dimensions.height50),
        Text(
          'URGENCY',
          style: TextStyle(
            fontSize: Dimensions.font14,
            color: AppColors.color1,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: Dimensions.height20),
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
      decoration: BoxDecoration(
        color: isSelected ? AppColors.color2 : AppColors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(
          color: isSelected ? Colors.transparent : AppColors.grey4,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: isSelected ? AppColors.white : AppColors.grey4,
          ),
          SizedBox(width: Dimensions.width10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: Dimensions.font15,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? AppColors.white : AppColors.black,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: Dimensions.font12,
                  fontWeight: FontWeight.w400,
                  color: isSelected ? AppColors.white : AppColors.black,
                ),
              ),
            ],
          ),
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
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: Dimensions.height20),
        Text(
          'CHOOSE BUDGET',
          style: TextStyle(
            fontSize: Dimensions.font13,
            color: AppColors.color1,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: Dimensions.height20),
        Align(
          alignment: AlignmentGeometry.center,
          child: Text(
            'N0 - N1,000,000',
            style: TextStyle(
              fontSize: Dimensions.font22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: Dimensions.height20),
        CupertinoSlider(
          value: _budgetSliderValue,
          min: 0,
          max: 10000000,
          onChanged: (value) {
            setState(() {
              _budgetSliderValue = value;
              // Update text fields automatically based on slider if desired
              _maxBudgetController.text = value.toStringAsFixed(0);
            });
          },
          activeColor: AppColors.color1,
        ),
        SizedBox(height: Dimensions.height20),
        Divider(color: AppColors.grey3),
        SizedBox(height: Dimensions.height20),
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: Dimensions.height10),
                  CustomTextField(hintText: 'N100',controller:  _minBudgetController,),
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: Dimensions.height10),
                  CustomTextField(hintText: 'N1,000,000',controller:  _maxBudgetController,),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: Dimensions.height50 * 2),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width20,
            vertical: Dimensions.height10,
          ),
          width: Dimensions.screenWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radius10),
            border: Border.all(color: AppColors.grey4),
            color: AppColors.grey1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Why set budgets?',
                style: TextStyle(
                  fontSize: Dimensions.font13,
                  color: AppColors.grey5,
                ),
              ),
              SizedBox(height: Dimensions.height5),
              Text(
                'One-time fee to send your requests to verified providers. You will receive quotes within 24 hours',
                style: TextStyle(
                  fontSize: Dimensions.font13,
                  color: AppColors.grey5,
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
          style: TextStyle(
            fontSize: Dimensions.font18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: Dimensions.height20),
        Text(
          'DESCRIBE THE PROBLEM',
          style: TextStyle(
            fontSize: Dimensions.font13,
            color: AppColors.color1,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: Dimensions.height5),
        CustomTextField(hintText: 'Describe your request here...', maxLines: 2,controller: _descController,),
        SizedBox(height: Dimensions.height20),
        Text(
          'ADD PHOTOS',
          style: TextStyle(
            fontSize: Dimensions.font13,
            color: AppColors.color1,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: Dimensions.height10),
        Row(
          children: [
            Container(
              height: Dimensions.height100,
              width: Dimensions.width100,
              decoration: BoxDecoration(
                color: AppColors.grey2,
                borderRadius: BorderRadius.circular(Dimensions.radius10),
              ),
              child: Icon(Icons.image),
            ),
            SizedBox(width: Dimensions.width20),
            Container(
              height: Dimensions.height100,
              width: Dimensions.width100,
              decoration: BoxDecoration(
                color: AppColors.grey2,
                borderRadius: BorderRadius.circular(Dimensions.radius10),
              ),
              child: Icon(Icons.image),
            ),
          ],
        ),
      ],
    );
  }
}
