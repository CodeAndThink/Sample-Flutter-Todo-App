import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.iconPath,
    required this.title,
    required this.value,
    required this.action,
    this.activeThumbImage,
    this.activeTrackColor,
    this.inactiveThumbImage,
    this.inactiveTrackColor,
  });

  final String iconPath;
  final String title;
  final bool value;
  final VoidCallback action;
  final AssetImage? activeThumbImage;
  final Color? activeTrackColor;
  final AssetImage? inactiveThumbImage;
  final Color? inactiveTrackColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        iconPath,
        height: 24,
        width: 24,
      ),
      title: Text(
        title,
      ),
      trailing: Switch(
        activeThumbImage: activeThumbImage,
        activeTrackColor: activeTrackColor,
        inactiveThumbImage: inactiveThumbImage,
        inactiveTrackColor: inactiveTrackColor,
        value: value,
        onChanged: (bool value) {
          action();
        },
      ),
    );
  }
}
