import 'package:flutter/material.dart';

import '../../models/notatag.dart' show ItemLayout;
import 'itemtiles.dart';
import 'model.dart' show HomeViewModel;
import 'sidebar.dart';

class HomeView extends StatelessWidget {
  final HomeViewModel model;
  const HomeView({super.key, required this.model});

  Widget _buildTitle(BuildContext context) {
    return Row(
      spacing: 8.0,
      children: [
        // tag selection
        DropdownButton<int?>(
          items: [
            ...model.tags.map((e) {
              return DropdownMenuItem<int?>(
                value: e.id,
                child: Text(e.title, style: TextStyle(color: Color(e.color))),
              );
            }),
          ],
          value: model.currentTag.id,
          onChanged: (value) => model.setCurrentTagId(value),
          underline: const SizedBox(height: 0),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return model.items.isNotEmpty
        ? ListView.separated(
            itemCount: model.items.length,
            itemBuilder: (context, index) {
              final item = model.items[index];
              switch (model.currentTag.layout) {
                case ItemLayout.menu:
                case ItemLayout.recipe:
                  return ExtendedTile(item: item, model: model);
                default:
                  return SimpleTile(item: item, model: model);
              }
            },
            separatorBuilder: (context, index) {
              return Divider(
                indent: 8.0,
                endIndent: 8.0,
                color: Theme.of(context).colorScheme.secondary.withAlpha(50),
              );
            },
          )
        : Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 4.0,
              children: [
                Text('Click '),
                Icon(
                  Icons.edit_outlined,
                  size: 32.0,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                Text(' to create a note'),
              ],
            ),
          );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.edit_outlined),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            String title = "";
            return AlertDialog(
              content: TextField(
                onChanged: (value) => title = value,
                decoration: InputDecoration(
                  labelText: "Title",
                  hintText: "enter title for new item",
                  suffix: IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      Navigator.of(context).pop(title);
                    },
                  ),
                ),
              ),
            );
          },
        ).then((value) => model.createNewItem(value));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: model,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: _buildTitle(context)),
          body: _buildBody(context),
          drawer: SideBar(),
          floatingActionButton: _buildFab(context),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}
