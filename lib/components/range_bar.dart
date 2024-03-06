import 'package:flutter/material.dart';
import 'package:neodocs/services/utils/range_bar_box_painter.dart';

class RangeSection {
  final double min;
  final double max;
  final Color color;
  final String label;

  double get range => max - min;

  const RangeSection({
    required this.min,
    required this.max,
    required this.color,
    required this.label,
  });
}

class BarWidget extends StatelessWidget {
  final List<RangeSection> sections;
  final double userValue;

  const BarWidget({
    super.key,
    required this.sections,
    required this.userValue,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double totalRange = sections.fold(0, (prev, section) => prev + section.range);
        return SizedBox(
          height: 100.0,
          child: CustomPaint(
            painter: BarPainter(
              sections: sections,
              totalWidth: constraints.maxWidth,
              totalRange: totalRange,
              userValue: userValue,
            ),
          ),
        );
      },
    );
  }
}
