import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/notalogic.dart';
import '../../model/notaitem.dart';

class ItemTags extends StatefulWidget {
  final NotaItem item;
  const ItemTags({required this.item, super.key});

  @override
  State<ItemTags> createState() => _ItemTagsState();
}

class _ItemTagsState extends State<ItemTags> {
  @override
  Widget build(BuildContext context) {
    final tags = context.watch<NotaLogic>().tags;
    return Wrap(
      children: tags
          .map((e) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: FilterChip(
                  label: Text(e.title, style: TextStyle(color: Color(e.color))),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                  elevation: 4.0,
                  selectedShadowColor: Color(e.color),
                  surfaceTintColor: Color(e.color),
                  selected: widget.item.tagIds.contains(e.id),
                  onSelected: (value) {
                    if (value) {
                      widget.item.tagIds.add(e.id!);
                    } else if (e.id != null) {
                      widget.item.tagIds.remove(e.id);
                    }
                    setState(() {});
                  },
                ),
              ))
          .toList(),
    );
  }
}
