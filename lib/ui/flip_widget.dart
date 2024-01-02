import 'dart:math';

import 'package:flutter/widgets.dart';

class FlipWidget extends StatefulWidget {
  const FlipWidget({super.key, required this.front, required this.back, required this.animationController});

  final Widget front;
  final Widget back;
  final AnimationController animationController;

  @override
  State<FlipWidget> createState() => _FlipWidgetState();
}

class _FlipWidgetState extends State<FlipWidget> {
  @override
  Widget build(BuildContext context) {
    final animation = Tween<double>(begin: 0, end: pi).animate(widget.animationController);
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? widget) {
        final bool isOverHalfwayPoint = animation.value > pi / 2;
        final currentWidget =
            isOverHalfwayPoint ? Transform.flip(flipY: true, child: this.widget.back) : this.widget.front;
        Matrix4 transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(animation.value);
        return Transform(transform: transform, alignment: Alignment.center, child: currentWidget);
      },
    );
  }
}
