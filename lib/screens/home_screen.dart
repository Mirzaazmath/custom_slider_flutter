import 'package:flutter/material.dart';

import 'custom_slider.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CustomSliderWidget(),
      ),
    );
  }
}
