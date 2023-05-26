import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class FadeInAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  const FadeInAnimation({Key? key, this.delay = 2, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tween = MovieTween()
      ..tween(_AniProps.opacity, 0.0.tweenTo(1.0),
          duration: const Duration(milliseconds: 500), curve: Curves.easeIn)
      ..tween(_AniProps.translateX, 130.0.tweenTo(0.0),
          duration: const Duration(milliseconds: 500), curve: Curves.easeOut);

    return CustomAnimationBuilder(
      delay: (300 * delay).round().milliseconds,
      duration: 500.milliseconds,
      tween: tween,
      child: child,
      builder: (BuildContext context, Movie value, Widget? child) {
        return Opacity(
          opacity: value.get(_AniProps.opacity),
          child: Transform.translate(
              offset: Offset(value.get(_AniProps.translateX), 0.0),
              child: child),
        );
      },
    );
  }
}

enum _AniProps { opacity, translateX }
