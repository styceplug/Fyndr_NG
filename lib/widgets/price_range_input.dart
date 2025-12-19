import 'package:flutter/material.dart';

class PriceRangeInput extends StatefulWidget {
  final int? min;
  final int? max;
  final ValueChanged<RangeValues> onChanged;

  const PriceRangeInput({
    super.key,
    this.min,
    this.max,
    required this.onChanged,
  });

  @override
  State<PriceRangeInput> createState() => _PriceRangeInputState();
}

class _PriceRangeInputState extends State<PriceRangeInput> {
  late RangeValues _range;
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _range = RangeValues((widget.min ?? 0).toDouble(), (widget.max ?? 500000000).toDouble());
    _minController.text = _range.start.toInt().toString();
    _maxController.text = _range.end.toInt().toString();
  }

  void _updateControllers(RangeValues values) {
    _minController.text = values.start.toInt().toString();
    _maxController.text = values.end.toInt().toString();
  }

  void _onSliderChanged(RangeValues values) {
    setState(() => _range = values);
    _updateControllers(values);
    widget.onChanged(values);
  }

  void _onManualInputChanged() {
    final min = int.tryParse(_minController.text) ?? 0;
    final max = int.tryParse(_maxController.text) ?? 500000000;
    if (min <= max) {
      final newRange = RangeValues(min.toDouble(), max.toDouble());
      setState(() => _range = newRange);
      widget.onChanged(newRange);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Price Range", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.green,   // rod (active part)
            inactiveTrackColor: Colors.grey,  // rod (inactive part)
            thumbColor: Colors.brown,          // slider handle
            overlayColor: Colors.blue.withOpacity(0.2), // ripple around handle
            rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 8),
            trackHeight: 4, // thickness of rod
          ),
          child: RangeSlider(
            values: _range,
            min: 0,
            max: 500000000,
            divisions: 10000,
            labels: RangeLabels(
              '₦${_range.start.toInt()}',
              '₦${_range.end.toInt()}',
            ),
            onChanged: _onSliderChanged,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _minController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Min Price (₦)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => _onManualInputChanged(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _maxController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Max Price (₦)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => _onManualInputChanged(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}