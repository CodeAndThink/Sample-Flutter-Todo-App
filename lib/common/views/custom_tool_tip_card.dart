import 'package:flutter/material.dart';

class CustomTooltipCard extends StatefulWidget {
  final Widget child;
  final Widget tooltipContent;

  const CustomTooltipCard({
    required this.child,
    required this.tooltipContent,
    super.key,
  });

  @override
  CustomTooltipCardState createState() => CustomTooltipCardState();
}

class CustomTooltipCardState extends State<CustomTooltipCard> {
  OverlayEntry? _overlayEntry;
  final GlobalKey _tooltipKey = GlobalKey();

  void _showTooltip() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top:
            MediaQuery.of(context).size.height - (offset.dy + size.height + 8) >
                    80
                ? offset.dy + size.height + 8
                : offset.dy - 16 - 60,
        child: Material(
          color: Colors.transparent,
          child: Container(
            key: _tooltipKey,
            width: size.width,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SizedBox(height: 60, child: widget.tooltipContent),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onLongPressStart: (details) => _showTooltip(),
        onLongPressEnd: (details) => _hideTooltip(),
        child: widget.child);
  }
}
