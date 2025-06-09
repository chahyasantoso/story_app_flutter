import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:story_app/domain/entities/story_entity.dart';

part 'story.freezed.dart';
part 'story.g.dart';

@freezed
abstract class Story with _$Story {
  const factory Story({
    required String id,
    required String name,
    required String description,
    required String photoUrl,
    required DateTime createdAt,
    double? lat,
    double? lon,
  }) = _Story;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
  factory Story.fromEntity(StoryEntity entity) => Story(
    id: entity.id,
    name: entity.name,
    description: entity.description,
    photoUrl: entity.photoUrl,
    createdAt: entity.createdAt,
    lat: entity.lat,
    lon: entity.lon,
  );
}

extension StoryEntityMapper on Story {
  StoryEntity toEntity() => StoryEntity(
    id: id,
    name: name,
    description: description,
    photoUrl: photoUrl,
    createdAt: createdAt,
  );
}
