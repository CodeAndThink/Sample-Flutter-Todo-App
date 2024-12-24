import 'package:flutter/material.dart';
import 'package:todo_app/common/views/custom_separated_part_title.dart';
import 'package:todo_app/models/note_model.dart';
import 'package:todo_app/views/history/item/history_item.dart';

class HistorySection extends StatelessWidget {
  const HistorySection({super.key, required this.data});
  final List<NoteModel> data;

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Column(
        children: [
          CustomSeparatedPartTitle(title: data.first.date),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return HistoryItem(note: data[index]);
              }),
        ],
      ),
    ]);
  }
}
