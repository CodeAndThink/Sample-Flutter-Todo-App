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
import 'package:todo_app/views/add_new_task/add_new_task_viewmodel.dart';
import 'package:todo_app/views/auth/login/login_screen.dart';
import 'package:todo_app/views/todo/item/note_card.dart';
import 'package:todo_app/views/todo/todo_viewmodel.dart';

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
        bool isTop = _scrollController.position.pixels == 0;
        if (isTop) {
          print("Đang ở đầu danh sách");
        } else {
          print("Đang ở cuối danh sách");
        }
      }
    });
    Provider.of<TodoViewmodel>(context, listen: false).fetchNote();
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
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: screenHeight * 0.11,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Center(
          child: Text(
            formattedDate,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: Colors.white),
          ),
        ),
        leading: IconButton(
            onPressed: () {
              widget.toggleLocale();
            },
            icon: SvgPicture.asset("assets/icons/lang.svg",
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcATop))),
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<TodoViewmodel>(context, listen: false).signout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LoginScreen(toggleLocale: widget.toggleLocale)),
                  (route) => false,
                );
              },
              icon: SvgPicture.asset(
                "assets/icons/signout.svg",
                colorFilter:
                    const ColorFilter.mode(Colors.redAccent, BlendMode.srcATop),
              ))
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: screenHeight * 0.09 < 126 ? 126 : screenHeight * 0.09,
            width: screenWidth,
            color: Theme.of(context).colorScheme.primary,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.todoScreenTitle,
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ]),
          ),
          Column(
            children: [
              SizedBox(
                height: screenHeight * 0.08 < 76 ? 76 : screenHeight * 0.08,
              ),

//MARK: Consumer - Main List

              SizedBox(
                  height: screenHeight * 0.75 - 56,
                  child: Consumer<TodoViewmodel>(builder: (context, vm, child) {
                    if (vm.isLoading) {
                      return const Loading();
                    } else if (vm.error.isEmpty) {
                      return Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: CustomScrollView(
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
                        child: Text(vm.error),
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
                              style: Theme.of(context).textTheme.headlineSmall,
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
                      Provider.of<TodoViewmodel>(context, listen: false);
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
            key: ValueKey(index),
            direction: DismissDirection.horizontal,
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
              } else if (direction == DismissDirection.endToStart) {
                Provider.of<TodoViewmodel>(context, listen: false)
                    .dataDeleteUpdate(inputData[index]);
                Provider.of<TodoViewmodel>(context, listen: false)
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
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: NoteCard(
              data: inputData[index],
              onTap: () {
                final todoViewmodel =
                    Provider.of<TodoViewmodel>(context, listen: false);
                Provider.of<AddNewTaskViewmodel>(context, listen: false)
                    .setData(inputData[index]);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddNewTaskScreen(),
                  ),
                ).then((_) {
                  todoViewmodel.fetchNote();
                });
              },
              checkBoxAction: (value) {
                final newNote = inputData[index];
                newNote.status = !newNote.status;

                Provider.of<TodoViewmodel>(context, listen: false)
                    .updateNote(newNote);
              },
              isTop: isTop,
              isBottom: isBottom,
            ),
          );
        },
        childCount: inputData.length,
      ),
    );
  }

//========================================================
}
