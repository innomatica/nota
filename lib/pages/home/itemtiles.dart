import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/notaitem.dart' show NotaItem;
import '../../pages/home/model.dart';

class SimpleTile extends StatelessWidget {
  final NotaItem item;
  final HomeViewModel model;
  const SimpleTile({super.key, required this.item, required this.model});

  @override
  Widget build(BuildContext context) {
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
  }
}

class ExtendedTile extends StatelessWidget {
  final NotaItem item;
  final HomeViewModel model;
  const ExtendedTile({super.key, required this.item, required this.model});

  @override
  Widget build(BuildContext context) {
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
      subtitle: Text(item.content ?? ""),
      trailing: IconButton(
        visualDensity: VisualDensity.compact,
        onPressed: () => model.toggleCompleted(item),
        icon: Icon(Icons.check_rounded),
      ),
    );
  }
}
