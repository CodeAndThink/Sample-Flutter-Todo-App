import 'package:flutter/material.dart';

class SwipeToDismissCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onDismiss;

  const SwipeToDismissCard({super.key, required this.child, required this.onDismiss});

  @override
  SwipeToDismissCardState createState() => SwipeToDismissCardState();
}

class SwipeToDismissCardState extends State<SwipeToDismissCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.0, 0.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _dismiss() {
    _controller.forward().then((_) {
      widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
          _dismiss();
        } else if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
          _dismiss();
        }
      },
      child: SlideTransition(
        position: _offsetAnimation,
        child: widget.child,
      ),
    );
  }
}