import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/views/circle_button.dart';
import 'package:todo_app/common/views/custom_app_bar.dart';
import 'package:todo_app/common/views/date_time_picker.dart';
import 'package:todo_app/common/views/date_time_text_box.dart';
import 'package:todo_app/common/views/loading.dart';
import 'package:todo_app/common/views/main_bottom_button.dart';
import 'package:todo_app/configs/configs.dart';
import 'package:todo_app/common/views/custom_text_box.dart';
import 'package:todo_app/gen/assets.gen.dart';
import 'package:todo_app/models/note_model.dart';
import 'package:todo_app/network/api_provider.dart';
import 'package:todo_app/utils/show_alert_dialog.dart';
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
  bool isInitData = false;
  late Size screenSize;

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

    if (!isInitData) {
      _vm.setInitialData(context);
      isInitData = true;
    }
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
    screenSize = MediaQuery.of(context).size;

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
//MARK: App Bar
                        _appBar(),

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
//MARK: Task Title Text Box
                                      _taskTitleTextBox()
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 24,
                                  ),

//MARK: Category Buttons
                                  _categoruButtons(),

                                  const SizedBox(
                                    height: 24,
                                  ),

//MARK: Date & Time Text Box
                                  _dateAndTimeTextBox(),

                                  const SizedBox(
                                    height: 24,
                                  ),

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
//MARK: Note's Content Text Box
                                      _contentTextBox()
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

//MARK: Save button
                        _saveButton()
                      ],
                    ),

//MARK: Loading Animation
                    _loadingAnimation()
                  ],
                ),
              ));
        });
  }

//MARK: App Bar

  Widget _appBar() {
    return CustomAppBar(
        title: AppLocalizations.of(context)!.addNewTaskScreenTitle,
        action: () {
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
        });
  }

//========================================================

//MARK: Task Title Text Box

  Widget _taskTitleTextBox() {
    return Selector<AddNewTaskViewModel, dartz.Tuple2<String, String?>>(
      selector: (context, viewmodel) =>
          dartz.Tuple2(viewmodel.taskTitle, viewmodel.errorTaskTitleText),
      builder: (context, data, child) {
        _taskTitleController.text = data.value1;
        return CustomTextBox(
          controller: _taskTitleController,
          hintText: AppLocalizations.of(context)!.taskHint,
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
    );
  }

//========================================================

//MARK: Category Buttons

  Widget _categoruButtons() {
    return Row(
      children: [
        Text(
          AppLocalizations.of(context)!.categoryLabel,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(
          width: 24,
        ),
        Selector<AddNewTaskViewModel, bool>(
          builder: (context, isSetAlpha, child) {
            return Tooltip(
              message: AppLocalizations.of(context)!.noteCategoryTip,
              child: CircleButton(
                onTap: () {
                  _vm.setCategory(0);
                },
                backgroundColor: Configs.noteCategoryBackgroundColor,
                iconPath: Assets.icons.note,
                isSetAlpha: isSetAlpha,
              ),
            );
          },
          selector: (context, viewmodel) => viewmodel.category != 0,
        ),
        const SizedBox(
          width: 16,
        ),
        Selector<AddNewTaskViewModel, bool>(
          builder: (context, isSetAlpha, child) {
            return Tooltip(
              message: AppLocalizations.of(context)!.calendarCategoryTip,
              child: CircleButton(
                onTap: () {
                  _vm.setCategory(1);
                },
                backgroundColor: Configs.calendarCategoryBackgroundColor,
                iconPath: Assets.icons.calendar,
                isSetAlpha: isSetAlpha,
              ),
            );
          },
          selector: (context, viewmodel) => viewmodel.category != 1,
        ),
        const SizedBox(
          width: 16,
        ),
        Selector<AddNewTaskViewModel, bool>(
          builder: (context, isSetAlpha, child) {
            return Tooltip(
              message: AppLocalizations.of(context)!.celebratedCategoryTip,
              child: CircleButton(
                onTap: () {
                  _vm.setCategory(2);
                },
                backgroundColor: Configs.celeCategoryBackgroundColor,
                iconPath: Assets.icons.cele,
                isSetAlpha: isSetAlpha,
              ),
            );
          },
          selector: (context, viewmodel) => viewmodel.category != 2,
        ),
      ],
    );
  }

//========================================================

//MARK: Date & Time Text Box

  Widget _dateAndTimeTextBox() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.dateLabel,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                height: 8,
              ),
//MARK: Date Text Box
              _dateTextBox()
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
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                height: 8,
              ),
//MARK: Time Text Box
              _timeTextBox()
            ],
          ),
        ),
      ],
    );
  }

//========================================================

//MARK: Date Text Box

  Widget _dateTextBox() {
    return Selector<AddNewTaskViewModel, dartz.Tuple2<String, String?>>(
        builder: (context, data, child) {
          return DateTimeTextBox(
            controller: TextEditingController(text: data.value1),
            hintText: AppLocalizations.of(context)!.dateHint,
            iconPath: Assets.icons.selectDate,
            action: _selectDate,
            errorText: data.value2,
          );
        },
        selector: (context, viewmodel) =>
            dartz.Tuple2(viewmodel.date, viewmodel.errorDateText));
  }

//========================================================

//MARK: Time Text Box

  Widget _timeTextBox() {
    return Selector<AddNewTaskViewModel, String>(
        builder: (context, selectTime, child) {
          return DateTimeTextBox(
            controller: TextEditingController(text: selectTime),
            hintText: AppLocalizations.of(context)!.timeHint,
            iconPath: Assets.icons.selectTime,
            action: _selectTime,
            errorText: null,
          );
        },
        selector: (context, viewmodel) => viewmodel.time);
  }

//========================================================

//MARK: Note's Content Text Box

  Widget _contentTextBox() {
    return Selector<AddNewTaskViewModel, String>(
        builder: (context, content, child) {
          _contentController.text = content;
          return CustomTextBox(
            controller: _contentController,
            hintText: AppLocalizations.of(context)!.notesHint,
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
        selector: (context, viewmodel) => viewmodel.content);
  }

//========================================================

//Save Button

  Widget _saveButton() {
    return Container(
        color: Colors.transparent,
        margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
        height: 56,
        width: screenSize.width - 32,
        child: MainBottomButton(
            ontap: () {
              _vm.prepareNewNote(context);
            },
            buttonLabel: widget.noteData == null
                ? AppLocalizations.of(context)!.saveButtonTitle
                : AppLocalizations.of(context)!.updateButtonTitle));
  }

//========================================================

//MARK: Loading

  Widget _loadingAnimation() {
    return Selector<AddNewTaskViewModel, bool>(
        builder: (context, isLoading, child) {
          if (isLoading) {
            return const Loading();
          }
          return Container();
        },
        selector: (context, viewmodel) => viewmodel.isLoading);
  }

//========================================================
}
