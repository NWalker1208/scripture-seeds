import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../progress/provider.dart';
import 'service.dart';

const _reminderChannel = NotificationChannel(
  'reminders',
  'Reminders',
  'Daily reminders to study topics',
);

class RemindersProxy {
  RemindersProxy(this.service, this.progress) {
    updateReminders();
  }

  factory RemindersProxy.fromContext(BuildContext context) => RemindersProxy(
        Provider.of<NotificationService>(context),
        Provider.of<ProgressProvider>(context),
      );

  final NotificationService service;
  final ProgressProvider progress;

  void updateReminders() {
    print('Updating reminders');
    if (!progress.isLoaded) return;
    print('Showing notification');
    final count = progress.names.length;
    service.show(NotificationData(0, 'test', '$count topics', '/'),
        _reminderChannel);
  }
}
