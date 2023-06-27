import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/notalogic.dart';
import 'instruction.dart';
import 'tagdetails.dart';

class TagListPage extends StatefulWidget {
  const TagListPage({super.key});

  @override
  State<TagListPage> createState() => _TagListPageState();
}

class _TagListPageState extends State<TagListPage> {
  //
  // FAB
  //
  Widget _buildFab() {
    final logic = context.read<NotaLogic>();
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TagDetailsPage(tag: logic.newTag),
        ));
      },
      child: const Icon(Icons.new_label_outlined),
    );
  }

  //
  // Tag List
  //
  Widget _buildTagList() {
    final logic = context.watch<NotaLogic>();
    final tags = logic.tags;
    return tags.isEmpty
        ? const TagInstruction()
        : ListView.builder(
            itemCount: tags.length,
            itemBuilder: (context, index) => ListTile(
              // tag title
              title: Row(
                children: [
                  Text(tags[index].title,
                      style: TextStyle(color: Color(tags[index].color))),
                  const SizedBox(width: 6),
                  tags[index].alarm.isEnabled
                      ? Icon(
                          Icons.alarm,
                          size: 16,
                          color: Theme.of(context).colorScheme.error,
                        )
                      : const SizedBox(width: 0),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TagDetailsPage(tag: tags[index]),
                ));
              },
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tags')),
      body: _buildTagList(),
      floatingActionButton: _buildFab(),
    );
  }
}
