import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final double? width;
  final double? height;
  final VoidCallback? onPressed;
  final String? buttonText;
  final Color? backgroundColor;
  final Color foregroundColor;
  final Color? disabledBackgroundColor;
  final BorderSide? side;

  const CustomTextButton({
    super.key,
    this.width,
    this.height,
    required this.onPressed,
    this.buttonText = "button",
    this.backgroundColor,
    this.foregroundColor = Colors.black,
    this.disabledBackgroundColor,
    this.side,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton.icon(
        onPressed: onPressed,
        label: Text(
          "$buttonText",
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.bold
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: backgroundColor,
          disabledForegroundColor: foregroundColor,
          side: side,
        ),
      ),
    );
  }
}
