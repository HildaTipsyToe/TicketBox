
import 'package:flutter/material.dart';

import '../../../shared/constants/app_colors.dart';
import 'base_button.dart';

class TBFilledButton extends StatefulWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback onPressed;
  final double? width;
  final Color? color;
  final Color? hoverColor;
  final double? height;
  final Color? borderColor;
  final Color? textColor;
  final double? roundBorder;
  TextDirection? textDirection = TextDirection.ltr;

  TBFilledButton({
    super.key,
    this.textDirection,
    this.textColor,
    this.hoverColor,
    this.text,
    this.color,
    this.borderColor,
    required this.onPressed,
    this.icon,
    this.width,
    this.height,
    this.roundBorder,
  });

  @override
  State<StatefulWidget> createState() => _TBFilledButton();
}

class _TBFilledButton extends State<TBFilledButton> {
  late Color colors;

  @override
  void initState(){
    super.initState();
    colors = widget.color ?? AppColors.tbPrimary;
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10) ,
        child: MouseRegion(
          onEnter: onEnter,
          onExit: onExit,
          child: BaseButton(
            onPressed: widget.onPressed,
            borderColor: widget.borderColor,
            color: colors,
            textColor: widget.textColor,
            roundBorder: widget.roundBorder,
            icon: widget.icon,
            text: widget.text,
            width: widget.width,
            height: widget.height,
          )
        )
    );
  }

  void onEnter(PointerEvent details) {
    setState(() {
        colors = widget.hoverColor ?? AppColors.tbPrimaryHover;
    });
  }

  void onExit(PointerEvent details) {
    setState(
      () {
        colors = widget.color ?? AppColors.tbPrimary;
      },
    );
  }
}
