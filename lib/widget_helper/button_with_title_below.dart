import 'package:flutter/material.dart';

class ButtonWithTitleBelow extends StatefulWidget {
  final String text;
  final Function() onClick;
  final IconData? icon;
  final bool enabled;
  final Color enabledColor;

  const ButtonWithTitleBelow({
    super.key,
    required this.text,
    required this.onClick,
    this.icon,
    bool? enabled,
    Color? enabledColor,
  }) : enabled = enabled ?? true,
       enabledColor = enabledColor ?? Colors.green;

  @override
  State<ButtonWithTitleBelow> createState() => _ButtonWithTitleBelowState();
}

class _ButtonWithTitleBelowState extends State<ButtonWithTitleBelow> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    widget.enabled ? widget.enabledColor : Colors.grey,
                padding: EdgeInsets.zero,
              ),
              child: Icon(
                widget.icon ?? Icons.work_outline,
                color: Colors.white,
                size: 33,
              ),
              onPressed: () => widget.enabled ? widget.onClick() : {},
            ),
          ),
          SizedBox(height: 11),
          Text(
            widget.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
