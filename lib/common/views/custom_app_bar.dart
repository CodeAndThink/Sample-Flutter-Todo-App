import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_app/gen/assets.gen.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, required this.title, required this.action});
  final String title;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    return Container(
      height: screenHeight * 0.15 > 96 ? screenHeight * 0.15 : 96,
      color: Theme.of(context).colorScheme.primary,
      child: Stack(
        children: [
          Positioned(
              right: screenWidth * 0.6,
              top: 0,
              child: Image.asset(Assets.images.circleShapeBig.path)),
          Positioned(
              left: screenWidth * 0.8,
              top: 0,
              child: Image.asset(Assets.images.circleShapeSmall.path)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      height:
                          screenHeight * 0.06 > 48 ? 48 : screenHeight * 0.06,
                      width:
                          screenHeight * 0.06 > 48 ? 48 : screenHeight * 0.06,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(screenHeight * 0.06 / 2)),
                          color: Colors.white),
                      child: IconButton(
                          onPressed: action,
                          icon: SvgPicture.asset(
                            Assets.icons.back,
                            height: screenHeight * 0.015,
                            width: screenHeight * 0.015,
                          )),
                    ),
                    Expanded(
                        child: Center(
                      child: Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Colors.white),
                      ),
                    )),
                    SizedBox(
                      width:
                          screenHeight * 0.06 > 48 ? 48 : screenHeight * 0.06,
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
