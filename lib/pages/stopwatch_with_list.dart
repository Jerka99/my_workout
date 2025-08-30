import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wear_os_plugin/wear_os_scroll_view.dart';

class StopwatchWithList extends StatefulWidget {
  final Widget stopwatch;
  final Widget list;

  const StopwatchWithList({
    super.key,
    required this.stopwatch,
    required this.list,
  });

  @override
  State<StopwatchWithList> createState() => _StopwatchWithListState();
}

class _StopwatchWithListState extends State<StopwatchWithList> with RouteAware {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: WearOsScrollView(
        controller: _scrollController,
        child: ListView(
          controller: _scrollController,
          children: [
            widget.stopwatch,
            const SizedBox(height: 22),
            Padding(padding: const EdgeInsets.all(12.0), child: widget.list),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
