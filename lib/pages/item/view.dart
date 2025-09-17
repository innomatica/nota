import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/notatag.dart';
import 'model.dart';

class ItemView extends StatefulWidget {
  final ItemViewModel model;
  final int itemId;
  const ItemView({super.key, required this.model, required this.itemId});

  @override
  State<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.model.load(widget.itemId);
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _contentController.dispose();
  }

  Future _showTagEditor(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        final labelStyle = TextStyle(
          color: Theme.of(context).colorScheme.secondary,
        );
        return AlertDialog(
          contentPadding: EdgeInsets.only(
            left: 24,
            top: 24,
            bottom: 24,
            right: 8,
          ),
          title: Text('Tag Settings'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  spacing: 16.0,
                  children: [
                    ...widget.model.tags.map((t) {
                      return Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                // title
                                TextFormField(
                                  initialValue: t.title,
                                  decoration: InputDecoration(
                                    labelText: "title",
                                    labelStyle: labelStyle,
                                  ),
                                  onChanged: (value) => t.title = value,
                                ),
                                Row(
                                  spacing: 8,
                                  children: [
                                    // color
                                    Text('color', style: labelStyle),
                                    DropdownButton<int>(
                                      value: t.color,
                                      icon: SizedBox(),
                                      underline: SizedBox(),
                                      items: NotaTag.tagColors.map((c) {
                                        return DropdownMenuItem<int>(
                                          value: c,
                                          child: Icon(
                                            Icons.label_rounded,
                                            color: Color(c),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        if (value != null) t.color = value;
                                        setState(() {});
                                      },
                                    ),
                                    Expanded(child: SizedBox()),
                                    // layout
                                    Text('layout', style: labelStyle),
                                    DropdownButton(
                                      value: t.layout,
                                      items: ItemLayout.values.map((e) {
                                        return DropdownMenuItem(
                                          value: e,
                                          child: Text(e.name),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        if (value != null) t.layout = value;
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // delete
                          IconButton(
                            icon: Icon(
                              Icons.delete_rounded,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              widget.model.deleteTag(t.id!);
                              setState(() {});
                            },
                          ),
                        ],
                      );
                    }),
                    // add new tag
                    Row(
                      children: [
                        Expanded(child: SizedBox(width: 300)),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () async {
                            await widget.model.createTag();
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    ).then((value) async {
      await widget.model.updateTags();
    });
    widget.model.load(widget.model.item!.id);
  }

  Widget _buildBody(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.model,
      builder: (context, _) {
        _titleController.text = widget.model.item?.title ?? '';
        _contentController.text = widget.model.item?.content ?? '';
        return widget.model.item != null
            ? Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 8.0,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // title
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Title',
                            hintText: 'broccoli, carrots, onions',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.close_rounded),
                              onPressed: () {
                                _titleController.text = "";
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter title";
                            }
                            widget.model.item!.title = value;
                            return null;
                          },
                        ),
                        // content
                        TextFormField(
                          controller: _contentController,
                          onChanged: (value) =>
                              widget.model.item!.content = value,
                          decoration: const InputDecoration(labelText: 'Note'),
                          maxLines: 10,
                        ),
                        // alarm
                        // tags
                        Wrap(
                          spacing: 8.0,
                          children: [
                            ...widget.model.tags.map((e) {
                              return FilterChip(
                                label: Text(
                                  e.title,
                                  style: TextStyle(color: Color(e.color)),
                                ),
                                selected: widget.model.item!.tagIds.contains(
                                  e.id,
                                ),
                                onSelected: (value) {
                                  value
                                      ? widget.model.addTagToItem(e.id!)
                                      : widget.model.removeTagFromItem(e.id!);
                                  setState(() {});
                                },
                              );
                            }),
                            IconButton(
                              icon: Icon(Icons.settings),
                              onPressed: () async {
                                await _showTagEditor(context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                ),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left_rounded),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              widget.model.item!.title = _titleController.text;
              widget.model.item!.content = _contentController.text;
              await widget.model.updateItem();
              if (context.mounted) context.pop();
            }
          },
        ),
        title: Text('Item Details'),
        actions: [
          TextButton.icon(
            label: Text('delete'),
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.error,
            ),
            onPressed: () async {
              await widget.model.deleteItem();
              if (context.mounted) context.pop();
            },
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }
}
