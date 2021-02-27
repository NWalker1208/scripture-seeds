import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../service.dart';

@immutable
class NotificationData {
  const NotificationData(this.id, this.title, this.body, [this.payload]);

  final int id;
  final String title;
  final String body;
  final String payload;
}

@immutable
class NotificationChannel {
  const NotificationChannel(this.id, this.name, [this.description = '']);

  static const other = NotificationChannel('other', 'Other');

  final String id;
  final String name;
  final String description;

  NotificationDetails get details => NotificationDetails(
        android: AndroidNotificationDetails(id, name, description),
      );
}

class NotificationService
    extends CustomService<FlutterLocalNotificationsPlugin> {
  NotificationService();

  final _receiveController = StreamController<NotificationData>.broadcast();
  final _selectController = StreamController<String>.broadcast();

  /// Emits events when a notification is shown while the app is open.
  /// Only applies on some devices.
  Stream<NotificationData> get receive => _receiveController.stream;

  /// Emits events when a notification is selected.
  Stream<String> get select => _selectController.stream;

  /// Shows a notification immediately
  Future<void> show(
    NotificationData notification, [
    NotificationChannel channel = NotificationChannel.other,
  ]) async {
    final plugin = await data;
    await plugin.show(
      notification.id,
      notification.title,
      notification.body,
      channel.details,
      payload: notification.payload,
    );
  }

  @override
  Future<FlutterLocalNotificationsPlugin> open() {
    final settings = InitializationSettings(
      android: AndroidInitializationSettings('app_icon'),
      iOS: IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) async =>
            _receiveController.add(NotificationData(id, title, body, payload)),
      ),
      macOS: MacOSInitializationSettings(),
    );
    final plugin = FlutterLocalNotificationsPlugin();
    return plugin
        .initialize(
      settings,
      onSelectNotification: (payload) async => _selectController.add(payload),
    )
        .then((success) {
      if (!success) throw Exception('Failed to initialize notifications.');
      return plugin;
    });
  }

  @override
  Future<void> close() async {
    await _receiveController.close();
    await _selectController.close();
    await super.close();
  }
}
