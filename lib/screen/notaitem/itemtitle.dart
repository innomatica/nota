import 'package:flutter/material.dart';

import '../../model/notaitem.dart';

class ItemTitle extends StatefulWidget {
  final NotaItem item;
  final bool showCheckButton;
  const ItemTitle({
    required this.item,
    this.showCheckButton = false,
    super.key,
  });

  @override
  State<ItemTitle> createState() => _ItemTitleState();
}

class _ItemTitleState extends State<ItemTitle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        autofocus: true,
        initialValue: widget.item.title,
        onChanged: (value) => widget.item.title = value,
        decoration: InputDecoration(
          labelText: 'title',
          hintText: 'broccoli, carrots, onions',
          suffixIcon: widget.showCheckButton
              ? IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.check),
                )
              : const SizedBox(width: 0, height: 0),
        ),
      ),
    );
  }
}
