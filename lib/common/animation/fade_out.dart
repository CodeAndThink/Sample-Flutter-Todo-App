import 'package:flutter/material.dart';

class CustomAnimatedCard extends StatefulWidget {
  final Widget child;
  final bool fadeOut;
  final VoidCallback? onDismiss;

  const CustomAnimatedCard({
    super.key,
    required this.child,
    this.fadeOut = true,
    this.onDismiss,
  });

  @override
  CustomAnimatedCardState createState() => CustomAnimatedCardState();
}

class CustomAnimatedCardState extends State<CustomAnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
            begin: widget.fadeOut ? 1.0 : 0.0, end: widget.fadeOut ? 0.0 : 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: widget.fadeOut
          ? Offset.zero
          : const Offset(1.0, 0.0),
      end: widget.fadeOut
          ? const Offset(1.0, 0.0)
          : Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (!widget.fadeOut) {
      _controller.forward();
    }
  }

  void dismiss() {
    if (widget.fadeOut) {
      _controller.forward().then((_) {
        widget.onDismiss?.call();
      });
    }
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
      child: SlideTransition(
        position: _slideAnimation,
        child: GestureDetector(
          onHorizontalDragStart: (details) {
            if (widget.fadeOut) {
              dismiss();
            }
          },
          child: widget.child,
        ),
      ),
    );
  }
}
