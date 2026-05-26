import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import 'custom_button.dart';
import 'custom_textfield.dart';

class RatingDialog extends StatefulWidget {
  final String targetName;
  final Function(int rating, String review) onSubmit;

  const RatingDialog({Key? key, required this.targetName, required this.onSubmit}) : super(key: key);

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _selectedRating = 0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius20)),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.width20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Rate ${widget.targetName}",
              style: TextStyle(fontSize: Dimensions.font18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: Dimensions.height20),

            // --- STAR SELECTOR ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _selectedRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 35,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedRating = index + 1;
                    });
                  },
                );
              }),
            ),
            SizedBox(height: Dimensions.height10),

            // --- REVIEW TEXT FIELD ---
            CustomTextField(
              controller: _reviewController,
              hintText: "Write a review (optional)...",
              maxLines: 3,
            ),
            SizedBox(height: Dimensions.height20),

            // --- SUBMIT BUTTON ---
            CustomButton(
              text: "Submit Rating",
              isDisabled: _selectedRating == 0, // Must pick at least 1 star
              onPressed: () {
                Get.back(); // Close dialog
                widget.onSubmit(_selectedRating, _reviewController.text.trim());
              },
            ),
          ],
        ),
      ),
    );
  }
}