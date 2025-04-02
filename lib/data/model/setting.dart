import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant_notification.dart';

class Setting {
  final bool isDarkModeEnabled;
  final DailyReminder dailyReminder;

  const Setting({
    this.isDarkModeEnabled = false,
    this.dailyReminder = const DailyReminder(),
  });

  factory Setting.fromJson(Map<String, dynamic> json) {
    return Setting(
      isDarkModeEnabled: json["isDarkModeEnabled"],
      dailyReminder: DailyReminder.fromJson(json["dailyReminder"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "isDarkModeEnabled": isDarkModeEnabled,
      "dailyReminder": dailyReminder.toJson(),
    };
  }

  Setting copyWith({
    final bool? isDarkModeEnabled,
    final DailyReminder? dailyReminder,
  }) {
    return Setting(
      isDarkModeEnabled: isDarkModeEnabled ?? this.isDarkModeEnabled,
      dailyReminder: dailyReminder ?? this.dailyReminder,
    );
  }
}

class DailyReminder {
  final bool isEnabled;
  final TimeOfDay time;
  final bool isRandomRecommendation;
  final RestaurantNotification content;

  const DailyReminder(
      {this.isEnabled = false,
      this.time = const TimeOfDay(hour: 11, minute: 00),
      this.isRandomRecommendation = false,
      this.content = const RestaurantNotification(
        title: "Daily Reminder",
        body: "Jangan lupa makan ya! Kesehatan nomor satu.",
        payload: "",
      )});

  factory DailyReminder.fromJson(Map<String, dynamic> json) {
    final hour = json["time"]["hour"];
    final minute = json["time"]["minute"];
    final time = TimeOfDay(hour: hour, minute: minute);

    return DailyReminder(
      isEnabled: json["isEnabled"],
      isRandomRecommendation: json["isRandomRecommendation"],
      time: time,
      content: RestaurantNotification.fromJson(json["content"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "isEnabled": isEnabled,
        "time": {
          "hour": time.hour,
          "minute": time.minute,
        },
        "isRandomRecommendation": isRandomRecommendation,
        "content": content.toJson(),
      };

  DailyReminder copyWith({
    final bool? isEnabled,
    final int? notificationId,
    final TimeOfDay? time,
    final bool? isRandomRecommendation,
    final RestaurantNotification? content,
  }) {
    return DailyReminder(
      isEnabled: isEnabled ?? this.isEnabled,
      time: time ?? this.time,
      isRandomRecommendation:
          isRandomRecommendation ?? this.isRandomRecommendation,
      content: content ?? this.content,
    );
  }
}
