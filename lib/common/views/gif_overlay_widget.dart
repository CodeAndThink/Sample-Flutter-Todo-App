import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

class GifOverlayWidget extends StatefulWidget {
  const GifOverlayWidget({super.key, required this.gifAssetPath});

  final String gifAssetPath;

  @override
  GifOverlayWidgetState createState() => GifOverlayWidgetState();
}

class GifOverlayWidgetState extends State<GifOverlayWidget>
    with SingleTickerProviderStateMixin {
  late GifController _gifController;

  @override
  void initState() {
    super.initState();
    _gifController = GifController(vsync: this);
    _playGif();
  }

  void _playGif() {
    _gifController.reset();
    _gifController.repeat(
      min: 0,
      period: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    return Material(
      color: Colors.transparent,
      child: Container(
        height:
            screenHeight > screenWidth ? screenWidth * 0.5 : screenHeight * 0.5,
        width:
            screenHeight > screenWidth ? screenWidth * 0.5 : screenHeight * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Gif(
          controller: _gifController,
          image: AssetImage(widget.gifAssetPath),
        ),
      ),
    );
  }
}
