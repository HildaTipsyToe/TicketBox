import 'package:flutter/material.dart';

class TBCard extends StatelessWidget {
  final Color? backgroundColor;
  final VoidCallback? onPressed;
  final EdgeInsets padding;
  final double? width;
  final double? height;
  final double maxWidth;
  final EdgeInsets margin;
  final Widget? child;
  final Color? shadowColor;
  final double? roundedConers;

  const TBCard({
    super.key,
    this.width,
    this.height,
    this.backgroundColor,
    this.shadowColor,
    this.onPressed,
    this.padding = const EdgeInsets.all(0.0),
    this.child,
    this.maxWidth = double.infinity,
    this.margin = const EdgeInsets.all(0.0),
    this.roundedConers = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Padding(
        padding: padding,
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(roundedConers!),
            boxShadow: [
              BoxShadow(
                color: shadowColor ??
                    (backgroundColor != null
                        ? backgroundColor!.withOpacity(0.3)
                        : const Color.fromARGB(255, 233, 233, 233).withOpacity(0.2)),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 4), // changes position of shadow
              ),
            ],
          ),
          child: Material(
            borderRadius: BorderRadius.circular(roundedConers!),
            color: Colors.white,
            child: InkWell(
              onTap: onPressed,
              child: SizedBox(
                width: width,
                height: height,
                child: Padding(
                  padding: padding,
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
