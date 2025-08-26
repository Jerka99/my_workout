import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonWithTitleBelow extends StatefulWidget {
  final String text;
  final Function() onClick;
  final IconData? icon;

  const ButtonWithTitleBelow({
    super.key,
    required this.text,
    required this.onClick,
    this.icon,
  });

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
              child: Icon(widget.icon ?? Icons.work_outline),
              onPressed: () => widget.onClick(),
            ),
          ),
          SizedBox(height: 30),
          Text(widget.text, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
