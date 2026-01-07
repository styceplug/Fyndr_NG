import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';
import 'custom_button.dart';


class LocationService {
  // Singleton pattern (Optional, but good for caching)
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  List<NigerianState>? _cachedStates;

  Future<List<NigerianState>> loadStates() async {
    if (_cachedStates != null) return _cachedStates!;

    try {
      final jsonStr = await rootBundle.loadString('assets/nigeria_states_lgas.json');
      final dynamic decoded = json.decode(jsonStr); // Use dynamic first


      print(decoded.runtimeType);
      print(decoded);

      List<dynamic> listData;

      // Check if it's a Map (Object) or List (Array)
      if (decoded is Map<String, dynamic>) {
        // If it's a Map, try to find the list inside a common key like 'data', 'states', or just values
        // Adjust 'states' below to whatever key wraps your list in the JSON file
        listData = decoded['states'] ?? decoded['data'] ?? [];
      } else {
        // If it's already a List, just use it
        listData = decoded;
      }

      _cachedStates = listData.map((e) => NigerianState.fromJson(e)).toList();
      return _cachedStates!;

    } catch (e) {
      print("❌ Error loading states: $e");
      return [];
    }
  }
}


class LocationPickerModal extends StatefulWidget {
  final String? enableState;
  final String? enableLga;
  final Function(String state, String lga) onConfirm;

  const LocationPickerModal({
    Key? key,
    this.enableState,
    this.enableLga,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<LocationPickerModal> createState() => _LocationPickerModalState();
}

class _LocationPickerModalState extends State<LocationPickerModal> {
  final _locationService = LocationService();
  late Future<List<NigerianState>> _dataFuture;

  String? selectedState;
  String? selectedLga;
  List<String> availableLgas = [];

  @override
  void initState() {
    super.initState();
    _dataFuture = _locationService.loadStates();
    selectedState = widget.enableState;
    selectedLga = widget.enableLga;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.radius20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle Bar
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: Dimensions.height20),

          Text(
            "Select Location",
            style: TextStyle(
              fontSize: Dimensions.font20,
              fontWeight: FontWeight.w700,
              color: AppColors.color1,
            ),
          ),
          SizedBox(height: Dimensions.height20),

          FutureBuilder<List<NigerianState>>(
            future: _dataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    "Unable to load locations.\nCheck assets/nigeria_states_lgas.json",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }

              final statesList = snapshot.data!;

              // Logic to populate LGAs if a State is pre-selected (e.g. from Edit Profile)
              if (selectedState != null && availableLgas.isEmpty) {
                try {
                  final stateObj = statesList.firstWhere((e) => e.stateName == selectedState);
                  availableLgas = stateObj.lgas;
                  // If the pre-selected LGA isn't in this state's list, clear it
                  if (!availableLgas.contains(selectedLga)) {
                    selectedLga = null;
                  }
                } catch (e) {
                  // State name might not match exactly
                }
              }

              return Column(
                children: [
                  // --- STATE DROPDOWN ---
                  DropdownButtonFormField<String>(
                    value: selectedState,
                    isExpanded: true, // Prevents overflow
                    decoration: _inputDecoration("State"),
                    items: statesList.map((s) {
                      return DropdownMenuItem(value: s.stateName, child: Text(s.stateName));
                    }).toList(),
                    onChanged: (val) {
                      if (val == null) return;
                      setState(() {
                        selectedState = val;
                        selectedLga = null; // Reset LGA
                        // Update available LGAs based on selection
                        availableLgas = statesList.firstWhere((e) => e.stateName == val).lgas;
                      });
                    },
                  ),
                  SizedBox(height: Dimensions.height20),

                  // --- LGA DROPDOWN ---
                  DropdownButtonFormField<String>(
                    value: selectedLga,
                    isExpanded: true,
                    decoration: _inputDecoration("LGA"),
                    items: availableLgas.map((lgaName) {
                      return DropdownMenuItem(value: lgaName, child: Text(lgaName));
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedLga = val;
                      });
                    },
                    hint: Text(selectedState == null ? "Select State first" : "Select LGA"),
                  ),
                ],
              );
            },
          ),

          SizedBox(height: Dimensions.height40),

          // Confirm Button
          CustomButton(
            text: "Confirm Location",
            onPressed: () {
              if (selectedState != null && selectedLga != null) {
                widget.onConfirm(selectedState!, selectedLga!);
                Get.back(); // Close Modal
              }
            },
            isDisabled: selectedState == null || selectedLga == null,
          ),
          SizedBox(height: Dimensions.height20),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.radius15)),
      contentPadding: EdgeInsets.symmetric(horizontal: Dimensions.width20, vertical: Dimensions.height15),
    );
  }
}

class NigerianState {
  final String stateName;
  final List<String> lgas;

  NigerianState({required this.stateName, required this.lgas});

  factory NigerianState.fromJson(Map<String, dynamic> json) {
    return NigerianState(
      // The JSON key is "state"
      stateName: json['state'] ?? '',
      // The JSON key is "lgas"
      lgas: List<String>.from(json['lgas'] ?? []),
    );
  }
}