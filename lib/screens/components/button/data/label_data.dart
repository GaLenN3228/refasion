import 'package:flutter/material.dart';

enum RBContentAnimation { fade, size, typing }

class RBLabelData {
  final Color color;

  final String title;
  final String initialTitle;
  final String caption;
  final bool uppercase;

  final RBContentAnimation titleAnimation;
  final RBContentAnimation captionAnimation;

  final bool Function() titleAnimationCondition;
  final bool Function() captionAnimationCondition;

  const RBLabelData({
    this.titleAnimationCondition,
    this.captionAnimationCondition,
    this.captionAnimation,
    this.titleAnimation,
    this.initialTitle,
    this.color,
    this.title,
    this.caption,
    this.uppercase: true,
  });

  factory RBLabelData.ofTitle(
    String title, {
    String caption,
    Color color,
    RBContentAnimation titleAnimation,
    String initialTitle,
    bool Function() titleAnimationCondition,
    bool Function() captionAnimationCondition,
    RBContentAnimation captionAnimation,
  }) {
    if (title == null) return null;

    return RBLabelData(
      title: title,
      caption: caption,
      color: color,
      titleAnimation: titleAnimation,
      initialTitle: initialTitle,
      titleAnimationCondition: titleAnimationCondition ?? () => true,
      captionAnimation: captionAnimation,
      captionAnimationCondition: captionAnimationCondition ?? () => true,
    );
  }
}
