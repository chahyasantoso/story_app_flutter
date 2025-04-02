import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant_notification.dart';
import 'package:restaurant_app/data/services/workmanager_service.dart';

class WorkmanagerProvider extends ChangeNotifier {
  final WorkmanagerService _service;
  WorkmanagerProvider(this._service);

  String _message = "";
  String get message => _message;

  Future<void> startPeriodicNotification(
    TimeOfDay tod,
    RestaurantNotification notification,
  ) async {
    try {
      /// chain oneOffTask
      await _service.runOneOffTaskWithTime(
        time: tod,
        inputData: notification.toJson(),
      );

      final duration = _service.calculateNextDuration(tod);
      _message = "Using Workmanager, will start in ";
      _message += "${duration.inHours}:";
      _message += "${duration.inMinutes.remainder(60)}:";
      _message += "${duration.inSeconds.remainder(60)}";
    } catch (e) {
      _message = "Can't start workmanager task";
    }
  }

  Future<void> cancelAllTask() async {
    await _service.cancelAllTask();
  }
}
