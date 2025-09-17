import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/constants.dart';
import '../../shared/qrcodeimg.dart' show QrCodeImage;

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
