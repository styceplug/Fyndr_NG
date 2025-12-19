import 'package:flutter/material.dart';

import '../../utils/app_constants.dart';
import '../../utils/dimensions.dart';
import '../../widgets/custom_button.dart';


class UpdateAppScreen extends StatefulWidget {
  const UpdateAppScreen({super.key});

  @override
  State<UpdateAppScreen> createState() => _UpdateAppScreenState();
}

class _UpdateAppScreenState extends State<UpdateAppScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              height: Dimensions.height10 * 30,
              width: Dimensions.screenWidth,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppConstants.getPngAsset('alien')),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Text(
              'Time to Update!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: Dimensions.font25 + Dimensions.font12,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).textTheme.headlineSmall?.color,
              ),
            ),
            SizedBox(height: Dimensions.height10),
            Text(
              'We added lots of new features and fixed some bugs to make your experience as smooth as possible',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: Dimensions.font16,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const Spacer(),
            CustomButton(
              text: 'UPDATE APP',
              onPressed: () {},
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: Dimensions.height30),
          ],
        ),
      ),
    );  }
}
