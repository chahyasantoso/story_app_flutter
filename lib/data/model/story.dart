class Story {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final DateTime createdAt;
  final double? lat;
  final double? lon;

  Story({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    this.lat,
    this.lon,
  });

  factory Story.fromJson(Map<String, dynamic> json) => Story(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    photoUrl: json["photoUrl"],
    createdAt: DateTime.parse(json["createdAt"]),
    lat: json["lat"]?.toDouble(),
    lon: json["lon"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "photoUrl": photoUrl,
    "createdAt": createdAt.toIso8601String(),
    "lat": lat,
    "lon": lon,
  };

  Story copyWith({
    String? id,
    String? name,
    String? description,
    String? photoUrl,
    DateTime? createdAt,
    double? lat,
    double? lon,
  }) => Story(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    photoUrl: photoUrl ?? this.photoUrl,
    createdAt: createdAt ?? this.createdAt,
    lat: lat ?? this.lat,
    lon: lon ?? this.lon,
  );
}
