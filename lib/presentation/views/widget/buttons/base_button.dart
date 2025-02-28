import 'package:flutter/material.dart';

class BaseButton extends StatefulWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback onPressed;
  final double? width;
  final Color? textColor;
  final Color color;
  final Color? borderColor;
  final double? height;
  final double? roundBorder;

  const BaseButton({
    super.key,
    this.text,
    this.icon,
    this.width,
    this.height,
    this.roundBorder,
    this.textColor,
    required this.color,
    required this.onPressed,
    required this.borderColor,
  });

  @override
  State<StatefulWidget> createState() => _BaseButton();
}

class _BaseButton extends State<BaseButton> {


  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        overlayColor:
        WidgetStateColor.resolveWith((states) => Colors.transparent),
      ),
      onPressed: widget.onPressed,
      child: Container(
        width: widget.width ?? MediaQuery
            .of(context)
            .size
            .width - 32,
        height: widget.height ?? 65,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.roundBorder ?? 5.0),
            border: widget.borderColor != null ? Border.all(width: 2, color: widget.borderColor!) : null,
            color: widget.color),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.icon != null
                ? Icon(
              widget.icon,
              color: widget.textColor ?? Colors.white,
            )
                : Container(),
            Text(
              widget.text != null ? widget.text! : "",
              style: TextStyle(
                color: widget.textColor ?? Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
