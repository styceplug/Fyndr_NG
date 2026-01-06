import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/app_constants.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';


class AppLoadingOverlay extends StatefulWidget {
  const AppLoadingOverlay({super.key});

  @override
  State<AppLoadingOverlay> createState() => _AppLoadingOverlayState();
}

class _AppLoadingOverlayState extends State<AppLoadingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.4),
      child: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            height: Dimensions.height100,
            width: Dimensions.width100,
            padding: EdgeInsets.all(Dimensions.height15),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.color1.withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
              shape: BoxShape.circle
            ),
            child: Image.asset(AppConstants.getPngAsset('logo')),
          ),
        ),
      ),
    );
  }
}
