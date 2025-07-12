import 'package:flutter/material.dart';

class CustomPlacholder extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Widget? child;
  final BoxShape shape;
  final double borderwidth;
  final Color borderColor;

  const CustomPlacholder({
    super.key,
    this.width = 100.0,
    this.height = 100.0,
    this.color = Colors.grey,
    this.child,
    this.shape = BoxShape.rectangle,
    this.borderwidth = 0.0,
    this.borderColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle ? BorderRadius.circular(12) : null, // Adjust radius for rectangle
        border: Border.all(
          color: borderColor,
          width: borderwidth,
        ),
      ),
      child: child,
    );
  }
}