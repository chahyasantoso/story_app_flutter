class Restaurant {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;
  final String? address;
  final List<Category>? categories;
  final Menus? menus;
  final List<CustomerReview>? customerReviews;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    this.address,
    this.categories,
    this.menus,
    this.customerReviews,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      pictureId: json["pictureId"],
      city: json["city"],
      rating: json["rating"]?.toDouble(),
      address: json["address"],
      categories: json["categories"] != null
          ? List<Category>.from(
              json["categories"].map((x) => Category.fromJson(x)),
            )
          : null,
      menus: json["menus"] != null ? Menus.fromJson(json["menus"]) : null,
      customerReviews: json["customerReviews"] != null
          ? List<CustomerReview>.from(
              json["customerReviews"].map((x) => CustomerReview.fromJson(x)),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'pictureId': pictureId,
        "city": city,
        "rating": rating,
        "address": address,
        "categories": categories?.map((category) => category.toJson()),
        "menus": menus?.toJson(),
        "customerReviews": customerReviews?.map((review) => review.toJson()),
      };
}

class Category {
  final String name;

  Category({
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}

class CustomerReview {
  final String name;
  final String review;
  final String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
        name: json["name"],
        review: json["review"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "review": review,
        "date": date,
      };
}

class Menus {
  final List<Food> foods;
  final List<Drink> drinks;

  Menus({
    required this.foods,
    required this.drinks,
  });

  Menus.empty()
      : foods = [],
        drinks = [];

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
        foods: List<Food>.from(
          json["foods"].map((x) => Food.fromJson(x)),
        ),
        drinks: List<Drink>.from(
          json["drinks"].map((x) => Drink.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        'foods': foods.map((food) => food.toJson()),
        'drinks': drinks.map((drink) => drink.toJson()),
      };
}

class Food {
  final String name;

  Food({required this.name});

  factory Food.fromJson(Map<String, dynamic> json) => Food(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}

class Drink {
  final String name;

  Drink({required this.name});

  factory Drink.fromJson(Map<String, dynamic> json) => Drink(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
