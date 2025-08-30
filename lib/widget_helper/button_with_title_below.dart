import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonWithTitleBelow extends StatefulWidget {
  final String text;
  final Function() onClick;
  final IconData? icon;
  final String? svgAsset;
  final bool enabled;
  final Color enabledColor;

  const ButtonWithTitleBelow({
    super.key,
    required this.text,
    required this.onClick,
    this.svgAsset,
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
  void initState() {
    print(widget.svgAsset);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonChild;

    if (widget.svgAsset != null) {
      buttonChild = Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: SvgPicture.asset(
            widget.svgAsset!,
            // width: 33,
            // height: 33,
          ),
        ),
      );
    } else {
      buttonChild = Icon(widget.icon, color: Colors.white, size: 33);
    }
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
              child: buttonChild,
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
