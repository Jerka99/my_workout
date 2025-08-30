import 'package:flutter/material.dart';
import 'package:rotary_scrollbar/widgets/rotary_scrollbar.dart';

class NumberPickerPage extends StatefulWidget {
  final String label;
  final int? initialValue;

  const NumberPickerPage({super.key, required this.label, this.initialValue});

  @override
  State<NumberPickerPage> createState() => _NumberPickerPageState();
}

class _NumberPickerPageState extends State<NumberPickerPage> {
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(
      initialItem: (widget.initialValue != null ? widget.initialValue! : 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Select ${widget.label}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: RotaryScrollbar(
            controller: _controller,
            child: ListWheelScrollView.useDelegate(
              controller: _controller,
              itemExtent: 40,
              physics: const FixedExtentScrollPhysics(),
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: 51,
                builder: (context, index) {
                  final value = index;
                  return Center(
                    child: Text(
                      "$value",
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final selectedValue =
                _controller.selectedItem == 0 ? null : _controller.selectedItem;
            Navigator.of(context).pop(selectedValue);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text("OK"),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
