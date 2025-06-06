import 'package:flutter/material.dart';
import 'package:parki_dog/core/utils/values_manager.dart';

class ZigzagAnimation extends StatefulWidget {
  const ZigzagAnimation({super.key});

  @override
  State<ZigzagAnimation> createState() => _ZigzagAnimationState();
}

class _ZigzagAnimationState extends State<ZigzagAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: AppInt.i4),
      vsync: this,
    );
    _animation = Tween<double>(begin: AppDouble.d0, end: AppDouble.d1)
        .animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    // Generate zigzag points with bigger breaks dynamically from bottom-left to top-right
    final List<Offset> points = generateZigzagPath(screenSize);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // CustomPaint to draw the pet icon traces
          CustomPaint(
            size: Size.infinite,
            painter: TracePainter(points, _animation.value),
          ),
          // Animated positioned pet icon
          Positioned(
            left:
                _calculatePosition(_animation.value, points).dx - AppDouble.d25,
            top:
                _calculatePosition(_animation.value, points).dy - AppDouble.d25,
            child: Icon(Icons.pets,
                size: AppDouble.d50,
                color: Colors.grey.withOpacity(AppDouble.d0_5)),
          ),
        ],
      ),
    );
  }

  // Generate zigzag path with bigger breaks
  List<Offset> generateZigzagPath(Size screenSize) {
    List<Offset> points = [];
    double stepX = screenSize.width / AppDouble.d8; // Bigger step horizontally
    double stepY = screenSize.height / AppDouble.d8; // Bigger step vertically

    for (int i = AppInt.i0; i < AppInt.i16; i++) {
      double x = stepX * (i / AppDouble.d2); // Spread horizontally
      double y = screenSize.height - (stepY * (i / AppDouble.d2));

      // Alternate y-position to create bigger zigzag effect
      if (i % AppInt.i2 == AppInt.i0) {
        y -= stepY;
      }

      points.add(Offset(x, y));
    }
    return points;
  }

  // Calculate the current position of the pet based on the animation value
  Offset _calculatePosition(double t, List<Offset> points) {
    int traceIndex = (t * (points.length - AppInt.i1)).floor();
    double localT = (t * (points.length - AppInt.i1)) - traceIndex;

    if (traceIndex == points.length - AppInt.i1) return points.last;

    Offset start = points[traceIndex];
    Offset end = points[traceIndex + AppInt.i1];

    return Offset.lerp(start, end, localT)!;
  }
}

class TracePainter extends CustomPainter {
  final List<Offset> points;
  final double progress;

  TracePainter(this.points, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    // Use pet icon instead of circle for trace
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.pets.codePoint),
        style: TextStyle(
          fontSize: AppDouble.d40, // Size of the pet icon
          fontFamily: Icons.pets.fontFamily,
          color:
              Colors.grey.withOpacity(AppDouble.d0_5), // Pet icon trace color
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    int traceCount = (progress * (points.length - AppInt.i1)).floor();

    // Draw pet icon traces at each point up to the current progress
    for (int i = AppInt.i0; i <= traceCount; i++) {
      textPainter.layout();
      textPainter.paint(
          canvas,
          points[i] -
              const Offset(AppDouble.d20, AppDouble.d20)); // Center the icon
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
