import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonWithTitleBelow extends StatefulWidget {
  final String text;
  final Function() onClick;
  final IconData? icon;
  final String? svgAsset;
  final bool enabled;
  final Color enabledColor;
  final Color? textColor;

  const ButtonWithTitleBelow({
    super.key,
    required this.text,
    required this.onClick,
    this.svgAsset,
    this.icon,
    bool? enabled,
    Color? enabledColor,
    this.textColor,
  }) : enabled = enabled ?? true,
       enabledColor = enabledColor ?? Colors.green;

  @override
  State<ButtonWithTitleBelow> createState() => _ButtonWithTitleBelowState();
}

class _ButtonWithTitleBelowState extends State<ButtonWithTitleBelow> {
  bool svgExists = false;

  @override
  void initState() {
    super.initState();
    _checkSvg();
  }

  Future<void> _checkSvg() async {
    if (widget.svgAsset == null) return;

    try {
      await rootBundle.load(widget.svgAsset!);
      setState(() {
        svgExists = true;
      });
    } catch (_) {
      setState(() {
        svgExists = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonChild =
        svgExists
            ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: SvgPicture.asset(widget.svgAsset!, color: Colors.white),
              ),
            )
            : Icon(
              widget.icon ?? Icons.work_outline,
              color: Colors.white,
              size: 33,
            );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.enabledColor,
                padding: EdgeInsets.zero,
                disabledBackgroundColor: Colors.grey,
              ),
              onPressed: widget.enabled ? widget.onClick : null,
              child: buttonChild,
            ),
          ),
          SizedBox(height: 11),
          Text(
            widget.text,
            style: TextStyle(
              color: widget.textColor ?? Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
