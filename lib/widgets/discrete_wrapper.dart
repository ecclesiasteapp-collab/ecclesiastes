import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/app_settings.dart';

class DiscreteWrapper extends StatelessWidget {
  final Widget child;
  final double blurSigma;

  const DiscreteWrapper({super.key, required this.child, this.blurSigma = 6.0});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<AppSettings>('settings_box').listenable(),
      builder: (context, Box<AppSettings> box, _) {
        final settings = box.get('current', defaultValue: AppSettings());
        final isDiscrete = settings?.isDiscreteMode ?? false;

        if (!isDiscrete) return child;

        return ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: child,
        );
      },
    );
  }
}
