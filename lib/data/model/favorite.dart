import 'package:restaurant_app/data/model/restaurant.dart';

class Favorite {
  final int? id;
  final String restaurantId;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;

  Favorite({
    this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory Favorite.fromRestaurant(Restaurant restaurant) {
    final restaurantJson = restaurant.toJson();
    return Favorite(
      restaurantId: restaurantJson["id"],
      name: restaurantJson["name"],
      description: restaurantJson["description"],
      pictureId: restaurantJson["pictureId"],
      city: restaurantJson["city"],
      rating: restaurantJson["rating"]?.toDouble(),
    );
  }

  Restaurant toRestaurant() => Restaurant.fromJson({
        'id': restaurantId,
        'name': name,
        'description': description,
        'pictureId': pictureId,
        "city": city,
        "rating": rating,
      });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json["id"],
      restaurantId: json["restaurantId"],
      name: json["name"],
      description: json["description"],
      pictureId: json["pictureId"],
      city: json["city"],
      rating: json["rating"]?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'restaurantId': restaurantId,
        'name': name,
        'description': description,
        'pictureId': pictureId,
        "city": city,
        "rating": rating,
      };

  Favorite copyWith({
    int? id,
    String? restaurantId,
    String? name,
    String? description,
    String? pictureId,
    String? city,
    double? rating,
  }) =>
      Favorite(
        id: id,
        restaurantId: restaurantId ?? this.restaurantId,
        name: name ?? this.name,
        description: description ?? this.description,
        pictureId: pictureId ?? this.pictureId,
        city: city ?? this.city,
        rating: rating ?? this.rating,
      );
}
