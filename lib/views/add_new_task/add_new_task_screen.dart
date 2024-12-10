import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/views/circle_button.dart';
import 'package:todo_app/common/views/date_time_picker.dart';
import 'package:todo_app/common/views/date_time_text_box.dart';
import 'package:todo_app/common/views/loading.dart';
import 'package:todo_app/common/views/main_bottom_button.dart';
import 'package:todo_app/configs/configs.dart';
import 'package:todo_app/common/views/custom_text_box.dart';
import 'package:todo_app/models/note_model.dart';
import 'package:todo_app/network/api_provider.dart';
import 'package:todo_app/utilis/show_alert_dialog.dart';
import 'package:todo_app/views/add_new_task/add_new_task_view_model.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key, this.noteData});
  final NoteModel? noteData;

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  late AddNewTaskViewModel _vm;

  @override
  void initState() {
    super.initState();

    _vm = AddNewTaskViewModel(ApiProvider.shared, widget.noteData);

//MARK: Event Listener

    _vm.error.addListener(() {
      if (_vm.error.value.isNotEmpty) {
        showAlert(
            context,
            AppLocalizations.of(context)!.error,
            widget.noteData != null
                ? AppLocalizations.of(context)!.updateNoteError
                : AppLocalizations.of(context)!.createNewNoteError, () {
          Navigator.pop(context);
        }, AppLocalizations.of(context)!.ok, null, null);
      }
    });

    _vm.isSuccess.addListener(() {
      if (_vm.isSuccess.value) {
        showAlert(
            context,
            AppLocalizations.of(context)!.success,
            widget.noteData != null
                ? AppLocalizations.of(context)!.updateNoteSuccess
                : AppLocalizations.of(context)!.createNewNoteSuccess, () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }, AppLocalizations.of(context)!.ok, null, null);
      }
    });

//========================================================
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _vm.setInitialData(context);
  }

  //MARK: Select Date Function

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await selectDate(context);

    if (context.mounted && picked != null) {
      _vm.resetErrorText();
      _vm.setDate(context, picked);
    }
  }

  //MARK: Select Time Function

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await selectTime(context);

    if (context.mounted && picked != null) {
      _vm.setTime(context, picked);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _vm.isSuccess.dispose();
    _vm.error.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return ChangeNotifierProvider(
        create: (context) => _vm,
        builder: (context, child) {
          return Scaffold(
              resizeToAvoidBottomInset: true,
              body: SafeArea(
                top: false,
                bottom: false,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        _customAppBar(context),

                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 80),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .taskTitleLabel,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),

                                      //MARK: Task Title
                                      Selector<AddNewTaskViewModel,
                                          dartz.Tuple2<String, String?>>(
                                        selector: (context, viewmodel) =>
                                            dartz.Tuple2(viewmodel.taskTitle,
                                                viewmodel.errorTaskTitleText),
                                        builder: (context, data, child) {
                                          _taskTitleController.text =
                                              data.value1;
                                          return CustomTextBox(
                                            controller: _taskTitleController,
                                            hintText:
                                                AppLocalizations.of(context)!
                                                    .taskHint,
                                            lineNumber: 1,
                                            textError: data.value2,
                                            onTap: () {
                                              _vm.resetErrorText();
                                            },
                                            textChangeAction: (value) {
                                              if (value.isNotEmpty) {
                                                _vm.resetErrorText();
                                                _vm.setTaskTitle(value);
                                              }
                                            },
                                            cleanAction: () {
                                              _vm.setTaskTitle("");
                                            },
                                          );
                                        },
                                      ),

                                      //========================================================
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 24,
                                  ),

                                  //MARK: Category

                                  Row(
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .categoryLabel,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                      const SizedBox(
                                        width: 24,
                                      ),
                                      Selector<AddNewTaskViewModel, bool>(
                                        builder: (context, isSetAlpha, child) {
                                          return Tooltip(
                                            message:
                                                AppLocalizations.of(context)!
                                                    .noteCategoryTip,
                                            child: CircleButton(
                                              onTap: () {
                                                _vm.setCategory(0);
                                              },
                                              backgroundColor: Configs
                                                  .noteCategoryBackgroundColor,
                                              iconPath: "assets/icons/note.svg",
                                              isSetAlpha: isSetAlpha,
                                            ),
                                          );
                                        },
                                        selector: (context, viewmodel) =>
                                            viewmodel.category != 0,
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Selector<AddNewTaskViewModel, bool>(
                                        builder: (context, isSetAlpha, child) {
                                          return Tooltip(
                                            message:
                                                AppLocalizations.of(context)!
                                                    .calendarCategoryTip,
                                            child: CircleButton(
                                              onTap: () {
                                                _vm.setCategory(1);
                                              },
                                              backgroundColor: Configs
                                                  .calendarCategoryBackgroundColor,
                                              iconPath:
                                                  "assets/icons/calendar.svg",
                                              isSetAlpha: isSetAlpha,
                                            ),
                                          );
                                        },
                                        selector: (context, viewmodel) =>
                                            viewmodel.category != 1,
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Selector<AddNewTaskViewModel, bool>(
                                        builder: (context, isSetAlpha, child) {
                                          return Tooltip(
                                            message:
                                                AppLocalizations.of(context)!
                                                    .celebratedCategoryTip,
                                            child: CircleButton(
                                              onTap: () {
                                                _vm.setCategory(2);
                                              },
                                              backgroundColor: Configs
                                                  .celeCategoryBackgroundColor,
                                              iconPath: "assets/icons/cele.svg",
                                              isSetAlpha: isSetAlpha,
                                            ),
                                          );
                                        },
                                        selector: (context, viewmodel) =>
                                            viewmodel.category != 2,
                                      ),
                                    ],
                                  ),

                                  //========================================================

                                  const SizedBox(
                                    height: 24,
                                  ),

                                  //MARK: Date & Time

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .dateLabel,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall,
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Selector<
                                                    AddNewTaskViewModel,
                                                    dartz
                                                    .Tuple2<String, String?>>(
                                                builder:
                                                    (context, data, child) {
                                                  return DateTimeTextBox(
                                                    controller:
                                                        TextEditingController(
                                                            text: data.value1),
                                                    hintText:
                                                        AppLocalizations.of(
                                                                context)!
                                                            .dateHint,
                                                    iconPath:
                                                        "assets/icons/selectDate.svg",
                                                    action: _selectDate,
                                                    errorText: data.value2,
                                                  );
                                                },
                                                selector:
                                                    (context, viewmodel) =>
                                                        dartz.Tuple2(
                                                            viewmodel.date,
                                                            viewmodel
                                                                .errorDateText))
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .timeLabel,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall,
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Selector<AddNewTaskViewModel,
                                                    String>(
                                                builder: (context, selectTime,
                                                    child) {
                                                  return DateTimeTextBox(
                                                    controller:
                                                        TextEditingController(
                                                            text: selectTime),
                                                    hintText:
                                                        AppLocalizations.of(
                                                                context)!
                                                            .timeHint,
                                                    iconPath:
                                                        "assets/icons/selectTime.svg",
                                                    action: _selectTime,
                                                    errorText: null,
                                                  );
                                                },
                                                selector:
                                                    (context, viewmodel) =>
                                                        viewmodel.time)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  //========================================================

                                  const SizedBox(
                                    height: 24,
                                  ),

                                  //MARK: Note's Content

                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .notesLabel,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Selector<AddNewTaskViewModel, String>(
                                          builder: (context, content, child) {
                                            _contentController.text = content;
                                            return CustomTextBox(
                                              controller: _contentController,
                                              hintText:
                                                  AppLocalizations.of(context)!
                                                      .notesHint,
                                              lineNumber: 6,
                                              onTap: () {},
                                              textChangeAction: (value) {
                                                _vm.setContent(value);
                                              },
                                              cleanAction: () {
                                                _vm.setContent("");
                                              },
                                            );
                                          },
                                          selector: (context, viewmodel) =>
                                              viewmodel.content),
                                    ],
                                  ),

                                  //========================================================
                                ],
                              ),
                            ),
                          ),
                        ),

                        //MARK: Save button
                        Container(
                            color: Colors.transparent,
                            margin: const EdgeInsets.only(
                                bottom: 24, left: 16, right: 16),
                            height: 56,
                            width: screenSize.width - 32,
                            child: MainBottomButton(
                                ontap: () {
                                  _vm.prepareNewNote(context);
                                },
                                buttonLabel: widget.noteData == null
                                    ? AppLocalizations.of(context)!
                                        .saveButtonTitle
                                    : AppLocalizations.of(context)!
                                        .updateButtonTitle)),
                      ],
                    ),

                    //MARK: Loading

                    Selector<AddNewTaskViewModel, bool>(
                        builder: (context, isLoading, child) {
                          if (isLoading) {
                            return const Loading();
                          }
                          return Container();
                        },
                        selector: (context, viewmodel) => viewmodel.isLoading)

                    //========================================================
                  ],
                ),
              ));
        });
  }

  //MARK: Custom app bar

  Widget _customAppBar(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    return Container(
      constraints: BoxConstraints(
        minHeight: 96,
        maxHeight: screenHeight * 0.15,
      ),
      color: Theme.of(context).colorScheme.primary,
      child: Stack(
        children: [
          Positioned(
              right: screenWidth * 0.6,
              top: 0,
              child: Image.asset('assets/images/circle_shape_big.png')),
          Positioned(
              left: screenWidth * 0.8,
              top: 0,
              child: Image.asset('assets/images/circle_shape_small.png')),
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
                          onPressed: () {
                            if (_vm.isDataChange(context)) {
                              showAlert(
                                  context,
                                  AppLocalizations.of(context)!.warning,
                                  AppLocalizations.of(context)!.exitWarning,
                                  () {
                                    Navigator.popUntil(
                                      context,
                                      (route) => route.isFirst,
                                    );
                                  },
                                  AppLocalizations.of(context)!.ok,
                                  () {
                                    Navigator.pop(context);
                                  },
                                  AppLocalizations.of(context)!.cancel);
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          icon: SvgPicture.asset(
                            "assets/icons/back.svg",
                            height: screenHeight * 0.015,
                            width: screenHeight * 0.015,
                          )),
                    ),
                    Expanded(
                        child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.addNewTaskScreenTitle,
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
