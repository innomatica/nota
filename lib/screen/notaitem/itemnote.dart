import 'package:flutter/material.dart';

import '../../model/notaitem.dart';

class ItemNote extends StatefulWidget {
  final NotaItem item;
  const ItemNote({required this.item, super.key});

  @override
  State<ItemNote> createState() => _ItemNoteState();
}

class _ItemNoteState extends State<ItemNote> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) => widget.item.content = value,
      decoration: const InputDecoration(hintText: 'note'),
      initialValue: widget.item.content,
      maxLines: 5,
    );
  }
}
