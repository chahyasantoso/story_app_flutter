import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app/data/model/restaurant_notification.dart';
import 'package:restaurant_app/data/services/local_notification_service.dart';

class LocalNotificationProvider extends ChangeNotifier {
  final LocalNotificationService service;

  LocalNotificationProvider(this.service);

  int _notificationId = 0;

  String _message = "";
  String get message => _message;

  bool? _permission = false;
  bool? get permission => _permission;

  List<PendingNotificationRequest> pendingNotificationRequests = [];

  Future<void> requestPermissions() async {
    _permission = await service.requestPermissions();
    notifyListeners();
  }

  Future<void> checkPendingNotificationRequests() async {
    pendingNotificationRequests = await service.pendingNotificationRequests();
    notifyListeners();
  }

  Future<void> scheduleDailyNotification(
    TimeOfDay tod,
    RestaurantNotification notification,
  ) async {
    try {
      _notificationId += 1;
      await service.scheduleDailyNotification(
        id: _notificationId,
        title: notification.title,
        body: notification.body,
        payload: notification.payload,
        time: tod,
      );
      _message = "Using LocalNotification, sheduled daily at ";
      _message += "${tod.hour}:${tod.minute} ";
      _message += tod.period == DayPeriod.am ? "AM" : "PM";
    } on Exception {
      _message = "Can't schedule Local notification";
    }
  }

  Future<void> cancelAll() async {
    await service.cancelAll();
    _notificationId = 0;
  }

  StreamController<String?> get payloadStream => notificationPayloadStream;

  void configurePayloadStreamListener(Function(String? payload) listener) {
    payloadStream.stream.listen(listener);
  }
}
