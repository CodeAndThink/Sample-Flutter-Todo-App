import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/views/loading.dart';
import 'package:todo_app/common/views/main_bottom_button.dart';
import 'package:todo_app/models/note_model.dart';
import 'package:todo_app/utilis/capitalize.dart';
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

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        bool isTop = _scrollController.position.pixels == 100;
        if (isTop) {
          Provider.of<TodoViewModel>(context, listen: false).fetchNote();
        }
      }
    });

    Provider.of<TodoViewModel>(context, listen: false).fetchNote();
  }

  String formatDate(DateTime date) {
    final locale = Localizations.localeOf(context).toString();
    String formattedDate = "";
    String result = "";
    final year = date.year;
    setState(() {
      if (locale == 'en_US') {
        formattedDate = DateFormat('MMMM d', locale).format(date);
        result = '${formattedDate.capitalizeFirstLetter}, $year';
      } else {
        result = 'Ngày ${date.day} tháng ${date.month} năm ${date.year}';
      }
    });

    return result;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
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
                      child: Image.asset('assets/images/circle_shape_big.png')),
                  Positioned(
                      left: screenWidth * 0.8,
                      top: 0,
                      child:
                          Image.asset('assets/images/circle_shape_small.png')),
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
                              IconButton(
                                  onPressed: () {
                                    widget.toggleLocale();
                                  },
                                  icon: SvgPicture.asset(
                                      "assets/icons/lang.svg",
                                      colorFilter: const ColorFilter.mode(
                                          Colors.white, BlendMode.srcATop))),
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
                              IconButton(
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
                                    "assets/icons/signout.svg",
                                    colorFilter: const ColorFilter.mode(
                                        Colors.redAccent, BlendMode.srcATop),
                                  ))
                            ],
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.todoScreenTitle,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(color: Colors.white),
                        ),
                      ]),
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
                        ? screenHeight * 0.82 - 96
                        : screenHeight * 0.61 - 96,
                    child:
                        Consumer<TodoViewModel>(builder: (context, vm, child) {
                      if (vm.isLoading) {
                        return const Loading();
                      } else if (vm.error.isEmpty) {
                        return Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: CustomScrollView(
                              physics: const BouncingScrollPhysics(),
                              controller: _scrollController,
                              slivers: [
                                _listViewSection(vm.todoData),
                                SliverToBoxAdapter(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.completed,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    )
                                  ],
                                )),
                                _listViewSection(vm.doneData)
                              ],
                            ));
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
                                "assets/images/logo.png",
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
                child: Icon(Icons.delete,
                    color: Theme.of(context).colorScheme.surface)),
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
          );
        },
        childCount: inputData.length,
      ),
    );
  }

//========================================================

//MARK: Bottom Notification

  void bottomNotification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.endScrollNotification),
      ),
    );
  }

//========================================================
}
