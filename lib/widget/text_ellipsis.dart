import 'package:flutter/material.dart';

class TextEllipsis extends Text {
  const TextEllipsis(super.data, {super.key, super.style, super.maxLines = 1})
      : super(overflow: TextOverflow.ellipsis);
}
