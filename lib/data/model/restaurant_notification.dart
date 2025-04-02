class RestaurantNotification {
  final String title;
  final String body;
  final String payload;

  const RestaurantNotification({
    required this.title,
    required this.body,
    required this.payload,
  });

  factory RestaurantNotification.fromJson(Map<String, dynamic> json) {
    return RestaurantNotification(
      title: json["title"],
      body: json["body"],
      payload: json["payload"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "body": body,
      "payload": payload,
    };
  }

  RestaurantNotification copyWith({
    String? title,
    String? body,
    String? payload,
  }) {
    return RestaurantNotification(
      title: title ?? this.title,
      body: body ?? this.body,
      payload: payload ?? this.payload,
    );
  }
}
