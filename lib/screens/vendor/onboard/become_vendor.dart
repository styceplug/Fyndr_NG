import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/utils/dimensions.dart';
import 'package:fyndr_ng/widgets/custom_appbar.dart';

class BecomeVendor extends StatefulWidget {
  const BecomeVendor({super.key});

  @override
  State<BecomeVendor> createState() => _BecomeVendorState();
}

class _BecomeVendorState extends State<BecomeVendor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        leadingIcon: BackButton(),
        title: 'Become a Vendor',
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width20,vertical: Dimensions.height20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppConstants.getPngAsset('kite-icon')),
            SizedBox(height: Dimensions.height20),
            Text('Start Offering Services')
          ],
        ),
      ),
    );
  }
}
