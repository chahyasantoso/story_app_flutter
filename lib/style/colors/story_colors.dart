import 'package:flutter/material.dart';

enum StoryColors {
  orange("Orange", Color.fromARGB(255, 224, 83, 40)),
  green("Green", Color.fromARGB(255, 0, 104, 89)),
  yellow("Yellow", Color.fromARGB(255, 244, 151, 22));

  const StoryColors(this.name, this.color);

  final String name;
  final Color color;
}
