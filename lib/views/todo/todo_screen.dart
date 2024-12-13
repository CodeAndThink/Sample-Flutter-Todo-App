import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/views/custom_tool_tip_card.dart';
import 'package:todo_app/common/views/loading.dart';
import 'package:todo_app/common/views/main_bottom_button.dart';
import 'package:todo_app/configs/configs.dart';
import 'package:todo_app/gen/assets.gen.dart';
import 'package:todo_app/models/note_model.dart';
import 'package:todo_app/utilities/capitalize.dart';
import 'package:todo_app/views/add_new_task/add_new_task_screen.dart';
import 'package:todo_app/views/auth/login/login_screen.dart';
import 'package:todo_app/views/todo/item/note_card.dart';
import 'package:todo_app/views/todo/todo_view_model.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key, required this.toggleLocale});
  final VoidCallback toggleLocale;

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey widgetKey = GlobalKey();
  late Size screenSize;
  Color? _textColor;

  @override
  void initState() {
    super.initState();

    Provider.of<TodoViewModel>(context, listen: false).fetchNote();
  }

  //Function format the date time on header of screen
  String formatDate(DateTime date) {
    final locale = Localizations.localeOf(context).toString();
    String result = "";
    setState(() {
      if (locale == 'en_US') {
        String formattedDate =
            DateFormat(Configs.longEnDate, locale).format(date);
        result = '${formattedDate.capitalizeFirstLetter}, ${date.year}';
      } else {
        result = Configs.formatLongVnDate(date);
      }
    });

    return result;
  }

  //Function change color of text based on the position of it
  void _changeTitleColorBasedOnPosition() {
    RenderBox? renderBox =
        widgetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      Offset position = renderBox.localToGlobal(Offset.zero);

      if (position.dy < max(222, screenSize.height * 0.26)) {
        if (_textColor != Colors.white) {
          setState(() {
            _textColor = Colors.white;
          });
        }
      } else {
        if (MediaQuery.of(context).platformBrightness == Brightness.light) {
          if (_textColor != Colors.black) {
            setState(() {
              _textColor = Colors.black;
            });
          }
        } else {
          if (_textColor != Colors.white) {
            setState(() {
              _textColor = Colors.white;
            });
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_changeTitleColorBasedOnPosition);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final currentDate = DateTime.now();
    final formattedDate = formatDate(currentDate);

    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            Container(
              height: screenHeight * 0.26 < 222 ? 222 : screenHeight * 0.26,
              width: screenWidth,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Stack(
                children: [
                  Positioned(
                      right: screenWidth * 0.6,
                      top: screenWidth * 0.2,
                      child: Image.asset(Assets.images.circleShapeBig.path)),
                  Positioned(
                      left: screenWidth * 0.8,
                      top: 0,
                      child: Image.asset(Assets.images.circleShapeSmall.path)),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: screenHeight > screenWidth ? 44 : 24,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Row(
                            children: [
//MARK: Change Language Button

                              Tooltip(
                                message: AppLocalizations.of(context)!
                                    .changeLanguageTip,
                                child: IconButton(
                                    onPressed: () {
                                      widget.toggleLocale();
                                    },
                                    icon: SvgPicture.asset(Assets.icons.lang,
                                        colorFilter: const ColorFilter.mode(
                                            Colors.white, BlendMode.srcATop))),
                              ),

//========================================================

//MARK: Local Date

                              Expanded(
                                child: Text(
                                  formattedDate,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),

//========================================================

//MARK: Logout Button

                              Tooltip(
                                message:
                                    AppLocalizations.of(context)!.logoutTip,
                                child: IconButton(
                                    onPressed: () {
                                      Provider.of<TodoViewModel>(context,
                                              listen: false)
                                          .signout();
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginScreen(
                                                toggleLocale:
                                                    widget.toggleLocale)),
                                        (route) => false,
                                      );
                                    },
                                    icon: SvgPicture.asset(
                                      Assets.icons.signout,
                                      colorFilter: const ColorFilter.mode(
                                          Colors.redAccent, BlendMode.srcATop),
                                    )),
                              )

//========================================================
                            ],
                          ),
                        ),
                      ]),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context)!.todoScreenTitle,
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height:
                      screenHeight * 0.185 < 158 ? 158 : screenHeight * 0.185,
                ),

//MARK: Consumer - Main List

                SizedBox(
                    height: screenHeight > screenWidth
                        ? screenHeight * (0.82 - 96 / screenHeight)
                        : screenHeight * (0.61 - 96 / screenHeight),
                    child:
                        Consumer<TodoViewModel>(builder: (context, vm, child) {
                      if (vm.isLoading) {
                        return const Loading();
                      } else if (vm.error.isEmpty) {
                        if (vm.doneData.isNotEmpty || vm.todoData.isNotEmpty) {
                          return Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: RefreshIndicator(
                                onRefresh: vm.fetchNote,
                                child: CustomScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  controller: _scrollController,
                                  slivers: [
                                    _listViewSection(vm.todoData),
                                    SliverToBoxAdapter(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 24,
                                        ),
                                        Text(
                                            key: widgetKey,
                                            AppLocalizations.of(context)!
                                                .completed,
                                            style: vm.todoData.isEmpty
                                                ? Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall
                                                    ?.copyWith(
                                                      color: Colors.white,
                                                    )
                                                : Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall
                                                    ?.copyWith(
                                                        color: _textColor)),
                                        const SizedBox(
                                          height: 24,
                                        )
                                      ],
                                    )),
                                    _listViewSection(vm.doneData),
                                    const SliverToBoxAdapter(
                                      child: SizedBox(
                                        height: 30,
                                      ),
                                    )
                                  ],
                                ),
                              ));
                        }
                        return Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                Assets.images.logo.path,
                                height: 100,
                                width: 100,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                AppLocalizations.of(context)!.textHolder,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              )
                            ],
                          ),
                        );
                      } else if (vm.error.isNotEmpty) {
                        return Center(
                          child: SizedBox(
                            height: screenHeight * 0.3,
                            width: screenWidth * 0.8,
                            child: Column(
                              children: [
                                Text(
                                  vm.error,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      Provider.of<TodoViewModel>(context,
                                              listen: false)
                                          .fetchNote();
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)!.reload))
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Center(
                          child: Column(
                            children: [
                              Image.asset(
                                Assets.images.logo.path,
                                height: 48,
                                width: 48,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                AppLocalizations.of(context)!.textHolder,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              )
                            ],
                          ),
                        );
                      }
                    }))
              ],
            ),

//========================================================

//MARK: Add New Task Button

            Positioned(
                left: 16,
                right: 16,
                bottom: 24,
                height: 56,
                child: MainBottomButton(
                  ontap: () {
                    final todoViewmodel =
                        Provider.of<TodoViewModel>(context, listen: false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddNewTaskScreen()),
                    ).then((_) {
                      todoViewmodel.fetchNote();
                    });
                  },
                  buttonLabel:
                      AppLocalizations.of(context)!.addNewTaskButtonTitle,
                ))

//========================================================
          ],
        ),
      ),
    );
  }

//MARK: Listview

  Widget _listViewSection(List<NoteModel> inputData) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          bool isTop = index == 0;
          bool isBottom = index == inputData.length - 1;

          return Dismissible(
            key: ValueKey(inputData[index].id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
                Provider.of<TodoViewModel>(context, listen: false).fetchNote();
              } else if (direction == DismissDirection.endToStart) {
                Provider.of<TodoViewModel>(context, listen: false)
                    .deleteNote(inputData[index]);
              }
            },
            background: Container(
              color: Colors.green,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.save, color: Colors.white),
            ),
            secondaryBackground: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.delete,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.surface),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Icon(Icons.delete,
                        color: Theme.of(context).colorScheme.surface),
                  ],
                )),
            child: CustomTooltipCard(
              tooltipContent: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.content,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.white),
                  ),
                  Text(
                    inputData[index].content!.isEmpty
                        ? AppLocalizations.of(context)!.emptyContent
                        : inputData[index].content!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: inputData[index].content!.isEmpty
                            ? Colors.grey
                            : Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              child: NoteCard(
                  data: inputData[index],
                  onTap: () {
                    final todoViewmodel =
                        Provider.of<TodoViewModel>(context, listen: false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddNewTaskScreen(
                          noteData: inputData[index],
                        ),
                      ),
                    ).then((_) {
                      if (context.mounted) {
                        todoViewmodel.fetchNote();
                      }
                    });
                  },
                  checkBoxAction: (value) {
                    Provider.of<TodoViewModel>(context, listen: false)
                        .updateNote(inputData[index]);
                  },
                  isTop: isTop,
                  isBottom: isBottom),
            ),
          );
        },
        childCount: inputData.length,
      ),
    );
  }

//========================================================
}
