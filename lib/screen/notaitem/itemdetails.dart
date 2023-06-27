import 'package:flutter/material.dart';
import 'package:notaapp/screen/notaitem/itemnote.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../logic/notalogic.dart';
import '../../model/notaitem.dart';

import '../notatag.dart/alarmsetting.dart';
import 'itemtags.dart';
import 'itemtitle.dart';

class ItemDetailsPage extends StatefulWidget {
  final NotaItem item;
  const ItemDetailsPage({required this.item, super.key});

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  bool _titleError = false;
  bool _alarmError = false;

  Widget _buildTitleError() => _titleError
      ? Text('Please enter title or delete this item',
          style: TextStyle(color: Theme.of(context).colorScheme.error))
      : const SizedBox(height: 0);
  Widget _buildAlarmError() => _alarmError
      ? Text('Please check alarm time or disable alarm',
          style: TextStyle(color: Theme.of(context).colorScheme.error))
      : const SizedBox(height: 0);

  //
  // AppBar Back Button
  //
  Widget _buildLeadingButton(NotaLogic logic) {
    return IconButton(
      onPressed: () async {
        _alarmError = logic.validateAlarm(widget.item) != null;
        _titleError = widget.item.title.isEmpty;
        if (_alarmError || _titleError) {
          setState(() {});
        } else {
          await logic.updateNotaItem(widget.item);
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      icon: const Icon(Icons.arrow_back_rounded),
    );
  }

  //
  // AppBar Action Buttons
  //
  Widget _buildActionButtons(NotaLogic logic) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Share Button
        IconButton(
          onPressed: () {
            Share.share(widget.item.content ?? ' ', subject: widget.item.title);
          },
          icon: const Icon(Icons.share_rounded),
        ),
        // Delete Button
        TextButton.icon(
          onPressed: () async {
            await logic.deleteNotaItem(widget.item);
            if (mounted) {
              Navigator.of(context).pop();
            }
          },
          icon: Icon(
            Icons.delete_forever_rounded,
            color: Theme.of(context).colorScheme.error,
          ),
          label: const Text('delete'),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final logic = context.read<NotaLogic>();
    logic.clearExpiredAlarm(widget.item);

    return Scaffold(
      appBar: AppBar(
        leading: _buildLeadingButton(logic),
        title: const Text('Nota Item'),
        actions: [_buildActionButtons(logic)],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ItemTitle(item: widget.item),
              _buildTitleError(),
              ItemTags(item: widget.item),
              AlarmSetting(object: widget.item),
              _buildAlarmError(),
              ItemNote(item: widget.item)
            ],
          ),
        ),
      ),
    );
  }
}
