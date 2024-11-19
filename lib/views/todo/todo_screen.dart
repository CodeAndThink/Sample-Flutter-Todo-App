import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/configs/configs.dart';
import 'package:todo_app/models/note_model.dart';
import 'package:todo_app/views/add_new_task/add_new_task_screen.dart';
import 'package:todo_app/views/todo/item/note_card.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final ScrollController _listViewController = ScrollController();

  @override
  void initState() {
    super.initState();

    _listViewController.addListener(() {
      if (_listViewController.position.atEdge) {
        bool isTop = _listViewController.position.pixels == 0;
        if (isTop) {
          print("Đang ở đầu danh sách");
        } else {
          print("Đang ở cuối danh sách");
        }
      }
    });
  }

  @override
  void dispose() {
    _listViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: screenHeight * 0.2,
              width: screenWidth,
              color: Theme.of(context).colorScheme.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 36,
                  ),
                  Text(
                    "Date and Time",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.surface),
                  ),
                  const SizedBox(
                    height: 42,
                  ),
                  Text(
                    AppLocalizations.of(context)!.todoScreenTitle,
                    style: Theme.of(context).textTheme.headlineLarge,
                  )
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.15,
                ),
                SizedBox(
                  height: screenHeight * 0.6,
                    child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: CustomScrollView(
                    slivers: [
                      _buildSection('lo', Configs.demoNotes),
                      _buildSection('Completed', Configs.demoNotes),
                    ],
                  ),
                  // ListView.builder(
                  //   controller: _listViewController,
                  //   itemCount: Configs.demoNotes.length,
                  //   itemBuilder: (data, index) {
                  //     return NoteCard(
                  //         data: Configs.demoNotes[index], onTap: () {});
                  //   },
                  // ),
                ))
              ],
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddNewTaskScreen()));
                },
                style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    )),
                    backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.primary)),
                child: Text(
                  AppLocalizations.of(context)!.addNewTaskButtonTitle,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.surface),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  SliverList _buildSection(String? sectionTitle, List<NoteModel> data) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                sectionTitle ?? "",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            );
          } else {
            return ListView.builder(
              controller: _listViewController,
              itemCount: Configs.demoNotes.length,
              itemBuilder: (data, index) {
                return NoteCard(data: Configs.demoNotes[index], onTap: () {});
              },
            );
          }
        },
        childCount: data.length + 1,
      ),
    );
  }
}
