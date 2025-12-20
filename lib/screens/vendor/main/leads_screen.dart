import 'package:flutter/material.dart';
import 'package:fyndr_ng/widgets/custom_appbar.dart';

class VendorLeadScreen extends StatefulWidget {
  const VendorLeadScreen({super.key});

  @override
  State<VendorLeadScreen> createState() => _VendorLeadScreenState();
}

class _VendorLeadScreenState extends State<VendorLeadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        leadingIcon: BackButton(),
        title: 'New Leads',
      ),
    );
  }
}
