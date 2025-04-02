import 'dart:math';
import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/data/model/restaurant_notification.dart';
import 'package:restaurant_app/data/services/api_services.dart';
import 'package:restaurant_app/data/services/local_notification_service.dart';
import 'package:restaurant_app/data/services/shared_preferences_service.dart';
import 'package:restaurant_app/static/restaurant_workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Future<Restaurant> fetchRandomRestaurant() async {
    final apiService = ApiServices();
    final response = await apiService.getRestaurantList();
    final restaurantList = response.restaurants;
    final randomIndex = Random().nextInt(restaurantList.length);
    return restaurantList[randomIndex];
  }

  Future<String> fetchAndSaveRestaurantPicture(String pictureId) async {
    final apiService = ApiServices();
    return await apiService.downloadAndSaveRestaurantPicture(pictureId);
  }

  Future<void> showRestaurantNotification(
    RestaurantNotification notification,
    String? picturePath,
  ) async {
    final notificationService = LocalNotificationService();
    await notificationService.init();
    await notificationService.configureLocalTimeZone();
    if (picturePath != null) {
      return notificationService.showBigPictureNotification(
        id: 0,
        title: notification.title,
        body: notification.body,
        payload: notification.payload,
        bigPicturePath: picturePath,
        largeIconPath: picturePath,
      );
    }
    notificationService.showNotification(
      id: 0,
      title: notification.title,
      body: notification.body,
      payload: notification.payload,
    );
  }

  Future<void> scheduleAnotherOneOffNotification(
    RestaurantNotification notification,
  ) async {
    final workmanagerService = WorkmanagerService();
    await workmanagerService.init();

    final prefs = await SharedPreferences.getInstance();
    final prefService = SharedPreferencesService(prefs);
    final setting = prefService.getSettingValue();
    final tod = setting.dailyReminder.time;

    await workmanagerService.runOneOffTaskWithTime(
      time: tod,
      inputData: notification.toJson(),
    );
  }

  Workmanager().executeTask(
    (String task, Map<String, dynamic>? inputData) async {
      try {
        if (task == RestaurantWorkmanager.oneOff.taskName ||
            task == RestaurantWorkmanager.periodic.taskName) {
          if (inputData != null) {
            final restaurant = await fetchRandomRestaurant();
            final picturePath = await fetchAndSaveRestaurantPicture(
              restaurant.pictureId,
            );
            final notification = RestaurantNotification.fromJson(inputData);
            if (task == RestaurantWorkmanager.oneOff.taskName) {
              await scheduleAnotherOneOffNotification(notification);
            }
            final restaurantNotification = notification.copyWith(
              body: "${notification.body}<br>Rekomendasi: ${restaurant.name}",
              payload: restaurant.id,
            );
            await showRestaurantNotification(
              restaurantNotification,
              picturePath,
            );
          }
        }
        return Future.value(true);
      } catch (e) {
        debugPrint(e.toString());
        return Future.error(e);
      }
    },
  );
}

class WorkmanagerService {
  final Workmanager _workmanager;

  WorkmanagerService([Workmanager? workmanager])
      : _workmanager = workmanager ??= Workmanager();

  Future<void> init() async {
    await _workmanager.initialize(callbackDispatcher, isInDebugMode: true);
  }

  Future<String> runOneOffTask({
    Duration initialDelay = Duration.zero,
    Map<String, dynamic>? inputData,
  }) async {
    final uuid = Uuid();
    final uniqueId = uuid.v4();
    await _workmanager.registerOneOffTask(
      uniqueId,
      RestaurantWorkmanager.oneOff.taskName,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      initialDelay: initialDelay,
      inputData: inputData,
    );
    return uniqueId;
  }

  Duration calculateNextDuration(TimeOfDay tod) {
    final now = DateTime.now();
    final scheduledTime =
        DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final duration = scheduledTime.isBefore(now)
        ? scheduledTime.add(Duration(days: 1)).difference(now)
        : scheduledTime.difference(now);

    return duration;
  }

  Future<String> runOneOffTaskWithTime({
    required TimeOfDay time,
    Map<String, dynamic>? inputData,
  }) async {
    final uuid = Uuid();
    final uniqueId = uuid.v4();
    await _workmanager.registerOneOffTask(
      uniqueId,
      RestaurantWorkmanager.oneOff.taskName,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      initialDelay: calculateNextDuration(time),
      inputData: inputData,
    );
    return uniqueId;
  }

  Future<String> runPeriodicTask({
    Duration? frequency,
    Duration initialDelay = Duration.zero,
    Map<String, dynamic>? inputData,
  }) async {
    final uuid = Uuid();
    final uniqueId = uuid.v4();
    await _workmanager.registerPeriodicTask(
      uniqueId,
      RestaurantWorkmanager.periodic.taskName,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      frequency: frequency,
      initialDelay: initialDelay,
      inputData: inputData,
    );
    return uniqueId;
  }

  Future<void> cancelAllTask() async {
    await _workmanager.cancelAll();
  }
}
