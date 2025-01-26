import 'package:flutter/material.dart';

class ThreeDotLoader extends StatefulWidget {
  const ThreeDotLoader({super.key});

  @override
  _ThreeDotLoaderState createState() => _ThreeDotLoaderState();
}

class _ThreeDotLoaderState extends State<ThreeDotLoader> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < 3; i++)
          AnimatedDot(
            animation: Tween(begin: 0.2, end: 1.0).animate(
              CurvedAnimation(
                parent: _controller,
                curve: Interval(i * 0.2, 1.0, curve: Curves.easeInOut),
              ),
            ),
          ),
      ],
    );
  }
}

class AnimatedDot extends AnimatedWidget {
  const AnimatedDot({Key? key, required Animation<double> animation}) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      width: 8.0,
      height: 8.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.withOpacity(animation.value),
      ),
    );
  }
}
