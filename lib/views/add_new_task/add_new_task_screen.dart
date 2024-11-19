import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/configs/circle_button.dart';
import 'package:todo_app/configs/configs.dart';
import 'package:todo_app/configs/custom_text_box.dart';

import '../../configs/main_bottom_button.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _taskTitle = TextEditingController();
  int _selectedCategory = 0;
  final TextEditingController _date = TextEditingController();
  final TextEditingController _time = TextEditingController();
  final TextEditingController _content = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = DateTime(2101);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != initialDate) {
      setState(() {
        _date.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay initialTime = TimeOfDay.now();

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null && picked != initialTime) {
      setState(() {
        _time.text = picked.format(context);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.11,
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
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 80,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 24,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.taskTitleLabel,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomTextBox(
                            controller: _taskTitle,
                            hintText: AppLocalizations.of(context)!.taskHint,
                            lineNumber: 1)
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.categoryLabel,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        CircleButton(
                          onTap: () {
                            setState(() {
                              _selectedCategory = 0;
                            });
                          },
                          backgroundColor: Configs.noteCategoryBackgroundColor,
                          iconPath: "assets/icons/note.svg",
                          isSetAlpha: _selectedCategory != 0,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        CircleButton(
                            onTap: () {
                              setState(() {
                                _selectedCategory = 1;
                              });
                            },
                            backgroundColor:
                                Configs.calendarCategoryBackgroundColor,
                            iconPath: "assets/icons/calendar.svg",
                            isSetAlpha: _selectedCategory != 1),
                        const SizedBox(
                          width: 16,
                        ),
                        CircleButton(
                            onTap: () {
                              setState(() {
                                _selectedCategory = 2;
                              });
                            },
                            backgroundColor:
                                Configs.celeCategoryBackgroundColor,
                            iconPath: "assets/icons/cele.svg",
                            isSetAlpha: _selectedCategory != 2)
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.dateLabel,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              _dateTimeText(
                                  _date,
                                  AppLocalizations.of(context)!.dateHint,
                                  "assets/icons/selectDate.svg",
                                  0)
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.timeLabel,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              _dateTimeText(
                                  _time,
                                  AppLocalizations.of(context)!.timeHint,
                                  "assets/icons/selectTime.svg",
                                  1)
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.notesLabel,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomTextBox(
                            controller: _content,
                            hintText: AppLocalizations.of(context)!.notesHint,
                            lineNumber: 6),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 24,
                height: 56,
                width: screenWidth - 32,
                child: MainBottomButton(
                  ontap: () {},
                  buttonLabel: AppLocalizations.of(context)!.saveButtonTitle,
                ))
          ],
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

  Widget _dateTimeText(TextEditingController controller, String hintText,
      String iconPath, int type) {
    return ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, child) {
          return TextField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle: Theme.of(context).textTheme.bodyMedium,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Color(0xFFE0E0E0),
                    width: 2.0,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: SvgPicture.asset(iconPath),
                  onPressed: () async {
                    if (type == 0) {
                      _selectDate(context);
                    } else {
                      _selectTime(context);
                    }
                  },
                )),
          );
        });
  }
}
