import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/views/alert.dart';
import 'package:todo_app/common/views/circle_button.dart';
import 'package:todo_app/common/views/date_time_text_box.dart';
import 'package:todo_app/common/views/loading.dart';
import 'package:todo_app/common/views/main_bottom_button.dart';
import 'package:todo_app/configs/configs.dart';
import 'package:todo_app/common/views/custom_text_box.dart';
import 'package:todo_app/models/note_model.dart';
import 'package:todo_app/utilis/converse_time.dart';
import 'package:todo_app/views/add_new_task/add_new_task_view_model.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _taskTitle = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _time = TextEditingController();
  final TextEditingController _content = TextEditingController();
  int _categorySelected = 0;
  String? _errorTaskTitleText;
  String? _errorDateText;
  NoteModel? data;
  late AddNewTaskViewModel _vm;
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();

    _vm = Provider.of<AddNewTaskViewModel>(context, listen: false);

    _listener = () {
      _stateHandling();
    };

    _vm.addListener(_listener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    data = Provider.of<AddNewTaskViewModel>(context, listen: false).data;

    if (data != null) {
      _setInitialData(data!, context);
    }
  }

  void _stateHandling() {
    if (_vm.isLoading) {
      const Loading();
    } else if (_vm.error.isNotEmpty) {
      _vm.resetAlert();

      _showAlert(
          context,
          AppLocalizations.of(context)!.error,
          data != null
              ? AppLocalizations.of(context)!.updateNoteError
              : AppLocalizations.of(context)!.createNewNoteError, () {
        Navigator.pop(context);
      }, AppLocalizations.of(context)!.ok, null, null);
    } else if (_vm.isSuccess) {
      _vm.resetAlert();

      _showAlert(
          context,
          AppLocalizations.of(context)!.success,
          data != null
              ? AppLocalizations.of(context)!.updateNoteSuccess
              : AppLocalizations.of(context)!.createNewNoteSuccess, () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }, AppLocalizations.of(context)!.ok, null, null);
    } else {
      Expanded(child: Container());
    }
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

    if (picked != null) {
      setState(() {
        _time.text = ConverseTime().timeFormat(picked, context);
      });
    }
  }

  void _setInitialData(NoteModel inputData, BuildContext context) {
    setState(() {
      _taskTitle.text = inputData.taskTitle;
      _date.text = inputData.date;
      _time.text = inputData.time != null
          ? ConverseTime().timeFormat(inputData.time!, context)
          : "";
      _content.text = inputData.content ?? "";
      _categorySelected = inputData.category;
    });
  }

  void _resetErrorText() {
    _errorDateText = null;
    _errorTaskTitleText = null;
  }

  void _validateInput() {
    if (_taskTitle.text.isEmpty) {
      setState(() {
        _errorTaskTitleText =
            AppLocalizations.of(context)!.taskTitleEmptyWarning;
      });
    } else {
      setState(() {
        _errorTaskTitleText = null;
      });
    }

    if (_date.text.isEmpty) {
      setState(() {
        _errorDateText = AppLocalizations.of(context)!.dateEmptyWarning;
      });
    } else {
      setState(() {
        _errorDateText = null;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _vm.removeListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;

    return Scaffold(
        body: SafeArea(
      top: false,
      bottom: false,
      child: Column(
        children: [
          _customAppBar(context),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  
                  //MARK: Task title
          
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
          
                      //MARK: Task Title
          
                      CustomTextBox(
                        controller: _taskTitle,
                        hintText: AppLocalizations.of(context)!.taskHint,
                        lineNumber: 1,
                        textError: _errorTaskTitleText,
                        onTap: _resetErrorText,
                      )
          
                      //========================================================
                    ],
                  ),
                  
                  //========================================================
                  
                  const SizedBox(
                    height: 24,
                  ),
          
                  //MARK: Category
          
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
                            _categorySelected = 0;
                          });
                        },
                        backgroundColor: Configs.noteCategoryBackgroundColor,
                        iconPath: "assets/icons/note.svg",
                        isSetAlpha: _categorySelected != 0,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      CircleButton(
                          onTap: () {
                            setState(() {
                              _categorySelected = 1;
                            });
                          },
                          backgroundColor:
                              Configs.calendarCategoryBackgroundColor,
                          iconPath: "assets/icons/calendar.svg",
                          isSetAlpha: _categorySelected != 1),
                      const SizedBox(
                        width: 16,
                      ),
                      CircleButton(
                          onTap: () {
                            setState(() {
                              _categorySelected = 2;
                            });
                          },
                          backgroundColor:
                              Configs.celeCategoryBackgroundColor,
                          iconPath: "assets/icons/cele.svg",
                          isSetAlpha: _categorySelected != 2)
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
                            DateTimeTextBox(
                              controller: _date,
                              hintText:
                                  AppLocalizations.of(context)!.dateHint,
                              iconPath: "assets/icons/selectDate.svg",
                              action: _selectDate,
                              errorText: _errorDateText,
                            )
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
                            DateTimeTextBox(
                              controller: _time,
                              hintText:
                                  AppLocalizations.of(context)!.timeHint,
                              iconPath: "assets/icons/selectTime.svg",
                              action: _selectTime,
                              errorText: null,
                            )
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
                        lineNumber: 6,
                        onTap: () {},
                      ),
                    ],
                  ),
          
                  //========================================================
                ],
              ),
            ),
          ),

          //MARK: Save button
          const Spacer(),
          Container(
              margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
              height: 56,
              width: screenSize.width - 32,
              child: MainBottomButton(
                ontap: () {
                  if (_date.text.isNotEmpty && _taskTitle.text.isNotEmpty) {
                    Provider.of<AddNewTaskViewModel>(context, listen: false)
                        .prepareNewNote(
                            _taskTitle.text,
                            _categorySelected,
                            _content.text,
                            _date.text,
                            _time.text,
                            data != null ? false : true);
                  } else {
                    _validateInput();
                  }
                },
                buttonLabel: AppLocalizations.of(context)!.saveButtonTitle,
              )),

          //========================================================

          //MARK: Consumer

          // Center(
          //   child: Consumer<AddNewTaskViewModel>(
          //     builder: (context, vm, child) {
          //       if (vm.isLoading) {
          //         return const Loading();
          //       } else if (vm.error.isNotEmpty) {
          //         vm.resetAlert();
          //         WidgetsBinding.instance.addPostFrameCallback(
          //           (_) {
          //             _showAlert(
          //                 context,
          //                 AppLocalizations.of(context)!.error,
          //                 data != null
          //                     ? AppLocalizations.of(context)!.updateNoteError
          //                     : AppLocalizations.of(context)!
          //                         .createNewNoteError, () {
          //               Navigator.pop(context);
          //             }, AppLocalizations.of(context)!.ok, null, null);
          //           },
          //         );
          //       } else if (vm.isSuccess) {
          //         vm.resetAlert();
          //         WidgetsBinding.instance.addPostFrameCallback(
          //           (_) {
          //             _showAlert(
          //                 context,
          //                 AppLocalizations.of(context)!.success,
          //                 data != null
          //                     ? AppLocalizations.of(context)!.updateNoteSuccess
          //                     : AppLocalizations.of(context)!
          //                         .createNewNoteSuccess, () {
          //               Navigator.of(context)
          //                   .popUntil((route) => route.isFirst);
          //             }, AppLocalizations.of(context)!.ok, null, null);
          //           },
          //         );
          //       }
          //       return Container();
          //     },
          //   ),
          // )

          //========================================================
        ],
      ),
    ));
  }

  void _showAlert(
      BuildContext context,
      String title,
      String content,
      Function() mainAction,
      String mainActionLabel,
      Function()? subAction,
      String? subActionLabel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Alert(
          title: title,
          content: content,
          mainAction: mainAction,
          mainActionLabel: mainActionLabel,
          subAction: subAction,
          subActionLabel: subActionLabel,
        );
      },
    );
  }

  Widget _customAppBar(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    return Container(
      height: screenHeight * 0.15 < 96 ? 96 : screenHeight * 0.15,
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
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight > screenWidth ? 55 : 30,
                ),
                Row(
                  children: [
                    Container(
                      height: screenHeight * 0.06,
                      width: screenHeight * 0.06,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(screenHeight * 0.06 / 2)),
                          color: Colors.white),
                      child: IconButton(
                          onPressed: () {
                            _showAlert(
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
                      width: screenHeight * 0.06,
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
