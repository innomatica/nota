import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nota/shared/settings.dart' show defaultTag;
import 'package:url_launcher/url_launcher.dart' show launchUrl;

import '../../shared/constants.dart';
import '../../shared/qrcodeimg.dart' show QrCodeImage;
import 'model.dart' show HomeViewModel;

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
            DropdownMenuItem(value: 0, child: Text(defaultTag.title)),
            ...model.tags.map((e) {
              return DropdownMenuItem<int?>(
                value: e.id,
                child: Text(e.title, style: TextStyle(color: Color(e.color))),
              );
            }),
          ],
          value: model.currentTagId,
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
              return ListTile(
                visualDensity: const VisualDensity(vertical: -4),
                enabled: !item.completed,
                onTap: () => context.go('/item/${item.id}'),
                onLongPress: () => model.deleteItem(item.id),
                // item title
                title: Row(
                  spacing: 6.0,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Alarm badge
                    item.alarm?.isEnabled == true
                        ? Icon(
                            Icons.alarm,
                            size: 16,
                            color: Theme.of(context).colorScheme.error,
                            // color: iconColor,
                          )
                        : const SizedBox(width: 0),
                  ],
                ),
                trailing: IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => model.toggleCompleted(item),
                  icon: Icon(Icons.check_rounded),
                ),
              );
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

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: model,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: _buildTitle(context)),
          body: _buildBody(context),
          drawer: SideBar(),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.edit_outlined),
            onPressed: () {
              // model.createNewItem();
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
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              'About',
              style: TextStyle(
                fontSize: 24,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          ListTile(
            title: Text('App version'),
            subtitle: Text(appVersion),
            onTap: () => launchUrl(Uri.parse(sourceRepository)),
            contentPadding: EdgeInsets.only(left: 16.0, right: 8.0),
            trailing: IconButton(
              onPressed: () {
                if (context.mounted) context.pop();
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        "Download $appName",
                        style: TextStyle(color: Colors.grey),
                      ),
                      backgroundColor: Colors.white,
                      contentPadding: EdgeInsets.all(32.0),
                      content: Column(
                        spacing: 16.0,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          QrCodeImage(data: releaseUrl),
                          Text(
                            releaseUrl,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              icon: Icon(Icons.qr_code_2_rounded, size: 32.0),
            ),
          ),
          ListTile(
            title: Text('Source code repository'),
            subtitle: Text('github'),
            onTap: () => launchUrl(Uri.parse(sourceRepository)),
          ),
          ListTile(
            title: Text('Developer'),
            subtitle: Text('innomatic'),
            onTap: () => launchUrl(Uri.parse(developerWebsite)),
          ),
          ListTile(
            title: Text('Attributions'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  child: Text('Notes icon by Freepik'),
                  onPressed: () => launchUrl(Uri.parse(noteIconUrl)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
