import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.12,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: _customAppBar(),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 16),
            height: screenHeight * 0.06,
            width: screenHeight * 0.06,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Center(
              child: SvgPicture.asset(
                "assets/icons/back.svg",
                height: screenHeight * 0.015,
                width: screenHeight * 0.015,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(),
        ),
      ),
    );
  }

  Widget _customAppBar() {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Center(
        child: Text(
          AppLocalizations.of(context)!.todoScreenTitle,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: Theme.of(context).colorScheme.surface),
        ),
      ),
    );
  }
}
