import 'package:flutter/cupertino.dart';

class GradientWidget extends StatelessWidget {
  final Widget child;
  final AlignmentGeometry end;
  final AlignmentGeometry start;
  final List<Color> colors;
  const GradientWidget(
      {super.key,
      required this.child,
      this.end = Alignment.topLeft,
      this.start = Alignment.bottomRight,
      required this.colors});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: colors,
          begin: start,
          end: end,
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcATop,
      child: child,
    );
  }
}
