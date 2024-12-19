import 'package:flutter/material.dart';
import 'package:todo_app/common/animation/fade_in_to_out_animation.dart';
import 'package:todo_app/common/views/gif_overlay_widget.dart';

void showOverlay(BuildContext context, String gifUrl) {
  final overlay = Overlay.of(context);
  final entry = OverlayEntry(
    builder: (context) => Align(
      alignment: Alignment.center,
      child: FadeInToOutAnimation(
        child: GifOverlayWidget(
          gifAssetPath: gifUrl,
        ),
      ),
    ),
  );

  overlay.insert(entry);

  Future.delayed(const Duration(seconds: 2), () {
    entry.remove();
  });
}
