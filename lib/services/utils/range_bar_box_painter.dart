import 'package:flutter/material.dart';
import 'package:neodocs/components/range_bar.dart';

class BarPainter extends CustomPainter {
  final List<RangeSection> sections;
  final double totalWidth;
  final double totalRange;
  final double userValue;

  BarPainter({
    required this.sections,
    required this.totalWidth,
    required this.totalRange,
    required this.userValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double currentPosition = 0.0; // Track current position for drawing
    double? previousMax;

    int numberOfGaps = 0;
    // Calculate the number of gaps between sections
    for (var i = 1; i < sections.length; i++) {
      if (sections[i].min > sections[i - 1].max) {
        numberOfGaps++;
      }
    }

    final double sectionWidth = totalWidth / (sections.length + numberOfGaps);

    for (var i = 0; i < sections.length; i++) {
      var section = sections[i];
      final paint = Paint()..color = section.color;

      // Draw gap between sections if necessary
      if (previousMax != null && section.min > previousMax) {
        final gapWidth = sectionWidth;
        final gapPaint = Paint()..color = Colors.grey;
        final gapRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(currentPosition, 0.0, gapWidth, size.height),
          const Radius.circular(0.0),
        );
        canvas.drawRRect(gapRect, gapPaint);
        currentPosition += gapWidth; // Update current position
      }

      // Draw the section
      final rRect = section == sections.first
          ? RRect.fromRectAndCorners(
        Rect.fromLTWH(currentPosition, 0.0, sectionWidth, size.height),
        topLeft: const Radius.circular(10.0),
        bottomLeft: const Radius.circular(10.0),
      )
          : section == sections.last
          ? RRect.fromRectAndCorners(
        Rect.fromLTWH(currentPosition, 0.0, sectionWidth, size.height),
        topRight: const Radius.circular(10.0),
        bottomRight: const Radius.circular(10.0),
      )
          : RRect.fromRectAndCorners(
        Rect.fromLTWH(currentPosition, 0.0, sectionWidth, size.height),
      );
      canvas.drawRRect(rRect, paint);

      // Draw min and max text
      const textStyle = TextStyle(color: Colors.black, fontSize: 12.0);

      // Draw min text only if it's not the same as the max of the previous section
      // or if it's the start of a new range
      if (i == 0 || previousMax == null || section.min != previousMax || section.min > previousMax) {
        final minTextSpan = TextSpan(text: section.min.toStringAsFixed(0), style: textStyle);
        final minTextPainter = TextPainter(text: minTextSpan, textDirection: TextDirection.ltr);
        minTextPainter.layout();
        final minTextOffset = Offset(currentPosition, i % 2 == 0 ? size.height + 8 : size.height - 32);
        minTextPainter.paint(canvas, minTextOffset);
      }

      final maxTextSpan = TextSpan(text: section.max.toStringAsFixed(0), style: textStyle);
      final maxTextPainter = TextPainter(text: maxTextSpan, textDirection: TextDirection.ltr);
      maxTextPainter.layout();
      final maxTextOffset = Offset(currentPosition + sectionWidth - maxTextPainter.width,
          i % 2 == 0 ? size.height - 32 : size.height + 15);
      maxTextPainter.paint(canvas, maxTextOffset);

      currentPosition += sectionWidth;
      previousMax = section.max; // Update the max value of the previous section
    }

    // Draw the arrow
    final arrowPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;
    final arrowPath = Path();
    final arrowPosition = (userValue / totalRange) * totalWidth;
    arrowPath.moveTo(arrowPosition, size.height);
    arrowPath.lineTo(arrowPosition - 10, size.height + 20);
    arrowPath.lineTo(arrowPosition + 10, size.height + 20);
    arrowPath.close();
    canvas.drawPath(arrowPath, arrowPaint);

    // Draw user value text
    final textSpan = TextSpan(
      text: userValue.toStringAsFixed(0),
      style: const TextStyle(color: Colors.black, fontSize: 14.0),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: double.infinity,
    );
    final textOffset = Offset(arrowPosition - textPainter.width / 2, size.height + 30);
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(BarPainter oldDelegate) =>
      oldDelegate.sections != sections ||
          oldDelegate.totalWidth != totalWidth ||
          oldDelegate.totalRange != totalRange ||
          oldDelegate.userValue != userValue;
}
