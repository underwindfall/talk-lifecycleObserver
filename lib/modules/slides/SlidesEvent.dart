import 'package:flutter/material.dart';

enum SlidesEvent { previous, forward, goto }

class SlidesAction {
  final SlidesEvent event;
  final int slide;

  const SlidesAction({@required this.event, this.slide});
}
