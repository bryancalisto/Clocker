import 'package:flutter/material.dart';

class PulseAnimation extends StatefulWidget {
  const PulseAnimation({Key? key}) : super(key: key);

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 5), value: 1, vsync: this)..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: (BuildContext _, Widget? __) {
        return ClipPath(
          clipper: WaveClipper(),
          child: Opacity(
            opacity: _animation.value,
            child: Container(
              color: Colors.black,
              width: double.infinity,
              height: 7,
            ),
          ),
        );
      },
      animation: _animation,
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    var x = 0.0;
    var numberOfWaves = 30;
    var increment = size.width / numberOfWaves;
    bool startFromTop = false;

    while (x < size.width) {
      if (startFromTop) {
        path.lineTo(x, 0);
        path.cubicTo(x + increment / 2, 0, x + increment / 2, size.height, x + increment, size.height);
      } else {
        path.lineTo(x, size.height);
        path.cubicTo(x + increment / 2, size.height, x + increment / 2, 0, x + increment, 0);
      }
      x += increment;
      startFromTop = !startFromTop;
    }

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
  }
}
