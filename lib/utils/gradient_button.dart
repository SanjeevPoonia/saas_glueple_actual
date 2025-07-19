import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_theme.dart';

class GradientButton extends StatelessWidget{
  final String text;
  final VoidCallback onTap;
  final double height;
  final double borderRadius;
  final double margin;
  final TextStyle? textStyle;

  const GradientButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.height = 50,
    this.borderRadius = 12,
    this.textStyle,
    this.margin=15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        margin: EdgeInsets.symmetric(horizontal: margin),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.themeGreenColor,AppTheme.themeBlueColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: textStyle ??
              const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

}
class GradientButtonCircular extends StatelessWidget{
  final String text;
  final VoidCallback onTap;
  final double height;
  final double borderRadius;
  final double margin;
  final TextStyle? textStyle;

  const GradientButtonCircular({
    Key? key,
    required this.text,
    required this.onTap,
    this.height = 50,
    this.borderRadius = 12,
    this.textStyle,
    this.margin=15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        margin: EdgeInsets.symmetric(horizontal: margin),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.themeGreenColor,AppTheme.themeBlueColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: textStyle ??
              const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

}