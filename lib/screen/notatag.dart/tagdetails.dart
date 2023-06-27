import 'package:flutter/material.dart';
import 'package:notaapp/screen/notatag.dart/alarmsetting.dart';
import 'package:provider/provider.dart';

import '../../logic/notalogic.dart';
import '../../model/notatag.dart';

class TagDetailsPage extends StatefulWidget {
  final NotaTag tag;
  const TagDetailsPage({required this.tag, super.key});

  @override
  State<TagDetailsPage> createState() => _TagDetailsPageState();
}

class _TagDetailsPageState extends State<TagDetailsPage> {
  bool _titleError = false;
  bool _alarmError = false;

  Widget _buildTitleError() => _titleError
      ? Text('Please enter title or delete this tag',
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
        _alarmError = logic.validateAlarm(widget.tag) != null;
        _titleError = widget.tag.title.isEmpty;
        if (_titleError || _alarmError) {
          setState(() {});
        } else {
          // update tag
          await logic.updateNotaTag(widget.tag);
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  //
  // AppBar Action Buttons
  //
  Widget _buildActionButtons(NotaLogic logic) {
    return TextButton.icon(
      onPressed: () {
        logic.deleteNotaTag(widget.tag);
        Navigator.of(context).pop();
      },
      label: const Text('delete'),
      icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
    );
  }

  //
  // Title
  //
  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: widget.tag.title,
        decoration: const InputDecoration(
          labelText: 'Title',
          hintText: 'Grocery',
        ),
        onChanged: (value) => widget.tag.title = value,
      ),
    );
  }

  //
  // Color
  //
  Widget _buildColor() {
    final textStyle = Theme.of(context).textTheme.labelLarge;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Tag color',
          style: textStyle,
        ),
        DropdownButton<int>(
          value: widget.tag.color,
          underline: const SizedBox(width: 0),
          icon: const SizedBox(width: 20),
          items: NotaTag.tagColors
              .map<DropdownMenuItem<int>>((e) => DropdownMenuItem<int>(
                    value: e,
                    child: Icon(Icons.label, color: Color(e)),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              widget.tag.color = value;
              setState(() {});
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final logic = context.read<NotaLogic>();
    logic.clearExpiredAlarm(widget.tag);

    return Scaffold(
      appBar: AppBar(
        leading: _buildLeadingButton(logic),
        title: Text(widget.tag.title.isEmpty ? '(New Tag)' : widget.tag.title),
        actions: [_buildActionButtons(logic)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: [
              // Title
              _buildTitle(),
              _buildTitleError(),
              // Color
              _buildColor(),
              // Alarm
              AlarmSetting(object: widget.tag),
              _buildAlarmError(),
            ],
          ),
        ),
      ),
    );
  }
}
