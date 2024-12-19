import 'package:flutter/material.dart';

class FadeInToOutAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback? onDismiss;

  const FadeInToOutAnimation({
    super.key,
    required this.child,
    this.onDismiss,
  });

  @override
  FadeInToOutAnimationState createState() => FadeInToOutAnimationState();
}

class FadeInToOutAnimationState extends State<FadeInToOutAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000), // Duration: 2 second
      vsync: this,
    );

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1, // 200ms
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0), // Save current state
        weight: 8, // 1.6 giây
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1, // 200ms
      ),
    ]).animate(_controller);

    _controller.forward().whenComplete(() {
      widget.onDismiss?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: widget.child,
    );
  }
}
