import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/notalogic.dart';

import '../../shared/constants.dart';
import '../about/about.dart';
import '../notaitem/itemlist.dart';
import '../notaitem/itemtags.dart';
import '../notaitem/itemtitle.dart';
import '../notatag.dart/taglist.dart';
import '../settings/settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //
  // Scaffold Title and Tag List
  //
  Widget _buildTitle() {
    final logic = context.watch<NotaLogic>();
    final tags = logic.tags;
    final items = tags
        .map((e) => DropdownMenuItem<int?>(
              value: e.id,
              child: Text(e.title, style: TextStyle(color: Color(e.color))),
            ))
        .toList();
    items.add(const DropdownMenuItem(value: null, child: Text('All Items')));

    return Row(
      children: [
        // title
        const Text(appName),
        const SizedBox(width: 20.0),
        // tags
        DropdownButton<int?>(
          onChanged: (value) => logic.setCurrentTagId(value),
          value: logic.currentTagId,
          items: items,
          underline: const SizedBox(height: 0),
        ),
      ],
    );
  }

  //
  // Scaffold Menu Button
  //
  Widget _buildMenuButton() {
    return PopupMenuButton<String>(onSelected: (value) {
      switch (value) {
        case 'tags':
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const TagListPage()));
          break;
        case 'settings':
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SettingsPage()));
          break;
        case 'about':
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const AboutPage()));
          break;
        default:
          break;
      }
    }, itemBuilder: (context) {
      return <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          value: 'tags',
          child: Row(children: [
            Icon(Icons.label_rounded,
                color: Theme.of(context).colorScheme.primary),
            const Text('  Tags'),
          ]),
        ),
        // PopupMenuItem<String>(
        //   value: 'settings',
        //   child: Row(children: [
        //     Icon(Icons.settings, color: Theme.of(context).colorScheme.primary),
        //     const Text('  Settings'),
        //   ]),
        // ),
        PopupMenuItem<String>(
          value: 'about',
          child: Row(children: [
            Icon(Icons.info, color: Theme.of(context).colorScheme.primary),
            const Text('  About'),
          ]),
        ),
      ];
    });
  }

  //
  // Scaffold Floating Action Button
  //
  Widget? _buildFab() {
    final logic = context.read<NotaLogic>();
    return FloatingActionButton(
      onPressed: () {
        // create a new Item
        final item = logic.newItem;
        // attach a tag if desired
        item.tagIds = logic.currentTagId != null ? [logic.currentTagId!] : [];
        showModalBottomSheet(
          context: context,
          isScrollControlled: true, // required to escape from keyboard
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          builder: (context) => Padding(
            padding: MediaQuery.of(context)
                .viewInsets
                .copyWith(left: 8, right: 8, top: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ItemTitle(item: item, showCheckButton: true),
                ItemTags(item: item),
              ],
            ),
          ),
          // return ItemContents(item: item);
        ).whenComplete(() async {
          if (item.title.isNotEmpty) {
            if (item.title.contains(',')) {
              final titles = item.title.split(',');
              for (final title in titles) {
                await logic.updateNotaItem(item.copyWith(title.trim()));
              }
            } else {
              await logic.updateNotaItem(item);
            }
          }
        });
      },
      child: const Icon(Icons.edit_outlined),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _buildTitle(),
          actions: [_buildMenuButton()],
        ),
        body: const ItemList(),
        floatingActionButton: _buildFab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
