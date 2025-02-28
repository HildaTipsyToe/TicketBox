import 'package:flutter/material.dart';

import 'base_button.dart';

class TBOutlineButton extends StatefulWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final double? roundBorder;
  final Color borderColor;
  Color? textColor;
  final EdgeInsets? padding;

  TBOutlineButton({super.key,
    this.text,
    this.icon,
    this.textColor,
    required this.onPressed,
    this.width,
    this.height,
    this.roundBorder,
    this.padding,
    required this.borderColor
  });

  @override
  State<StatefulWidget> createState() => _TBOutlineButton();
}

class _TBOutlineButton extends State<TBOutlineButton> {
  Color color = Colors.white;
  @override
  Widget build(BuildContext context) {
    widget.textColor ??= Colors.black;

    return MouseRegion(
      onHover: onHover,
      onExit: onExit,
      child: BaseButton(
        color: color,
        borderColor: widget.borderColor,
        onPressed: widget.onPressed,
        width: widget.width,
        text: widget.text,
        height: widget.height,
        textColor: widget.textColor,
        icon: widget.icon,
        roundBorder: widget.roundBorder,
      )

    );
  }

  void onHover(PointerEvent details) {
    setState(() {
      color = const Color(0xffeeeeee);
    });
  }

  void onExit(PointerEvent details) {
    setState(() {
      color = Colors.white;
    });
  }
}
