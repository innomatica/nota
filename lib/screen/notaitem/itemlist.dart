import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/notalogic.dart';
import 'instruction.dart';
import 'itemdetails.dart';

class ItemList extends StatefulWidget {
  const ItemList({super.key});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    final logic = context.watch<NotaLogic>();
    final items = logic.items;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return items.isEmpty && logic.currentTagId == null
        ? const ItemInstruction()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              itemCount: items.length,
              itemBuilder: (context, index) {
                // debugPrint('home.item: ${items[index]}');
                bool completed = items[index].completed;
                final textStyle = completed
                    ? titleStyle?.copyWith(
                        color: titleStyle.color?.withAlpha(50))
                    : titleStyle;
                final iconColor = completed
                    ? Theme.of(context).colorScheme.tertiary.withAlpha(50)
                    : Theme.of(context).colorScheme.tertiary;

                return ListTile(
                  visualDensity: const VisualDensity(vertical: -4),
                  onTap: () => items[index].completed
                      ? null
                      : Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ItemDetailsPage(item: items[index]))),
                  onLongPress: () => logic.deleteNotaItem(items[index]),
                  //
                  // Item Title
                  //
                  title: Row(
                    children: [
                      // Title
                      Text(items[index].title, style: textStyle),
                      const SizedBox(width: 6),
                      // Alarm badge
                      items[index].alarm.isEnabled
                          ? Icon(
                              Icons.alarm,
                              size: 16,
                              color: Theme.of(context).colorScheme.error,
                              // color: iconColor,
                            )
                          : const SizedBox(width: 0),
                    ],
                  ),
                  //
                  // check icon
                  //
                  trailing: IconButton(
                    onPressed: () {
                      // items[index].completed = !items[index].completed;
                      logic.completeNotaItem(items[index]);
                    },
                    icon: Icon(
                      Icons.check_rounded,
                      color: iconColor,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) =>
                  Divider(color: Theme.of(context).colorScheme.secondary),
            ),
          );
  }
}
