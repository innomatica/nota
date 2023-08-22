import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

import '../../model/notaobject.dart';
import '../../model/notatag.dart';
import '../../service/notification.dart';
import '../../shared/settings.dart';

class AlarmSetting extends StatefulWidget {
  final NotaObject object;
  const AlarmSetting({required this.object, super.key});

  @override
  State<AlarmSetting> createState() => _AlarmSettingState();
}

class _AlarmSettingState extends State<AlarmSetting> {
  final _notification = NotificationService();

  //
  // Ensure that the (starting) alarm time is set to the future
  //
  void _fixAlarmDate(NotaObject object) {
    final now = DateTime.now();
    if (object.alarm.when != null && object.alarm.when!.isBefore(now)) {
      if (object.alarm.match != null) {
        switch (object.alarm.match!) {
          case DateTimeComponents.time:
            // one day to the future
            object.alarm.when = DateTime(now.year, now.month, now.day + 1,
                object.alarm.when!.hour, object.alarm.when!.minute);
            break;
          case DateTimeComponents.dayOfWeekAndTime:
            // one week to the future
            object.alarm.when = DateTime(now.year, now.month, now.day + 7,
                object.alarm.when!.hour, object.alarm.when!.minute);
            break;
          case DateTimeComponents.dayOfMonthAndTime:
            // one month to the future
            object.alarm.when = DateTime(now.year, now.month + 1,
                object.alarm.when!.hour, object.alarm.when!.minute);
            break;
          default:
            break;
        }
      } else {
        // one day to the future
        object.alarm.when = DateTime(now.year, now.month, now.day + 1,
            object.alarm.when!.hour, object.alarm.when!.minute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('MMMMd');
    final timeFormatter = DateFormat('Hm');
    bool alarmEnabled = widget.object.alarm.isEnabled;

    final buttonColor =
        alarmEnabled ? Theme.of(context).colorScheme.primary : Colors.grey;
    Color? textColor = alarmEnabled ? null : Colors.grey;
    final buttonStyle =
        Theme.of(context).textTheme.labelLarge?.copyWith(color: buttonColor);
    final textStyle =
        Theme.of(context).textTheme.labelLarge?.copyWith(color: textColor);
    return Column(
      children: [
        Row(
          children: [
            //
            // alarm icon button
            //
            IconButton(
              onPressed: () async {
                // set dirty flag
                widget.object.alarm.isUpdated = true;

                if (alarmEnabled == false) {
                  // disable => enable
                  final status = await _notification.checkPermission();
                  if (!mounted) return;
                  if (status == false) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(
                          'Notification Blocked',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        content: OutlinedButton(
                          onPressed: () {
                            AppSettings.openAppSettings(
                                type: AppSettingsType.notification);
                            Navigator.of(context).pop();
                          },
                          child: const Text('Open App Settings'),
                        ),
                      ),
                    );
                  } else {
                    widget.object.alarm.isEnabled = true;
                  }
                } else {
                  // enable => disable
                  widget.object.alarm.isEnabled = false;
                  // cancel notification if exists : this is unnecessary now
                  // _notification.cancelNotification(widget.object.alarm.alarmId);
                }
                setState(() {});
              },
              icon: Icon(Icons.alarm, color: buttonColor),
            ),
            //
            // data picker
            //
            TextButton(
              onPressed: alarmEnabled
                  ? () {
                      widget.object.alarm.isUpdated = true;
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 120)),
                      ).then((value) {
                        if (value != null) {
                          // existing data
                          if (widget.object.alarm.when != null) {
                            // update date part only
                            widget.object.alarm.when = DateTime(
                              value.year,
                              value.month,
                              value.day,
                              widget.object.alarm.when!.hour,
                              widget.object.alarm.when!.minute,
                            );
                          } else {
                            // set date and time (12:00)
                            widget.object.alarm.when = value;
                          }
                          setState(() {});
                        }
                      });
                    }
                  : null,
              child: Text(
                dateFormatter.format(widget.object.alarm.when == null
                    ? DateTime.now() // today
                    : widget.object.alarm.when!), // object alarm date
              ),
            ),
            //
            // time picker
            //
            TextButton(
              onPressed: alarmEnabled
                  ? () {
                      widget.object.alarm.isUpdated = true;
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                          DateTime.now().add(const Duration(minutes: 5)),
                        ),
                      ).then(
                        (value) {
                          if (value != null) {
                            if (widget.object.alarm.when != null) {
                              // has previous alarm data
                              _fixAlarmDate(widget.object);
                              // update only time part
                              widget.object.alarm.when = DateTime(
                                widget.object.alarm.when!.year,
                                widget.object.alarm.when!.month,
                                widget.object.alarm.when!.day,
                                value.hour,
                                value.minute,
                              );
                            } else {
                              // set date to today
                              widget.object.alarm.when = DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                value.hour,
                                value.minute,
                              );
                            }
                            setState(() {});
                          }
                        },
                      );
                    }
                  : null,
              child: Text(
                timeFormatter.format(widget.object.alarm.when == null
                    ? DateTime.now()
                        .add(const Duration(minutes: 5)) // 5 min to thefuture
                    : widget.object.alarm.when!), // object alarm time
              ),
            ),
            const SizedBox(width: 8),
            //
            // duration picker
            //
            PopupMenuButton<Duration>(
              enabled: alarmEnabled,
              onSelected: (value) {
                widget.object.alarm.isUpdated = true;
                widget.object.alarm.when = DateTime.now().add(value);
                setState(() {});
              },
              itemBuilder: (context) {
                return laterTimes.keys
                    .map((e) => PopupMenuItem<Duration>(
                        value: laterTimes[e], child: Text(e)))
                    .toList();
              },
              child: Text('sometime later', style: buttonStyle),
            )
          ],
        ),
        //
        // Repeat
        //
        (widget.object is NotaTag)
            ? Row(
                children: [
                  Text('Repeat', style: textStyle),
                  //
                  // daily
                  //
                  Radio<DateTimeComponents>(
                    value: DateTimeComponents.time,
                    onChanged: alarmEnabled
                        ? (value) {
                            widget.object.alarm.isUpdated = true;
                            widget.object.alarm.match = value;
                            setState(() {});
                          }
                        : null,
                    groupValue: widget.object.alarm.match,
                    toggleable: true,
                  ),
                  Text('daily', style: buttonStyle),
                  //
                  // weekly
                  //
                  Radio<DateTimeComponents>(
                    value: DateTimeComponents.dayOfWeekAndTime,
                    onChanged: alarmEnabled
                        ? (value) {
                            widget.object.alarm.isUpdated = true;
                            widget.object.alarm.match = value;
                            setState(() {});
                          }
                        : null,
                    groupValue: widget.object.alarm.match,
                    toggleable: true,
                  ),
                  Text('weekly', style: buttonStyle),
                  //
                  // monthly
                  //
                  Radio<DateTimeComponents>(
                    value: DateTimeComponents.dayOfMonthAndTime,
                    onChanged: alarmEnabled
                        ? (value) {
                            widget.object.alarm.isUpdated = true;
                            widget.object.alarm.match = value;
                            setState(() {});
                          }
                        : null,
                    groupValue: widget.object.alarm.match,
                    toggleable: true,
                  ),
                  Text('monthly', style: buttonStyle)
                ],
              )
            : Container(),
      ],
    );
  }
}
