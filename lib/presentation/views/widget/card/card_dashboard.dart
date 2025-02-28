import 'package:flutter/material.dart';

import 'card.dart';

class TBCards extends StatefulWidget {
  final double width;
  final double height;
  final Widget child;
  final VoidCallback? onPressed;

  const TBCards(
      {super.key, required this.width,
      required this.height,
      required this.child,
      this.onPressed});

  @override
  State<StatefulWidget> createState() => _TBCards();
}

class _TBCards extends State<TBCards> {
  bool hover = false;
  Color cols = Colors.black;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      // color: i % 2 == 0 ? Colors.blue : Colors.green,
      child: TBCard(
        shadowColor: hover ? Colors.grey[350] : null,
        child: GestureDetector(
          onTap: widget.onPressed,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onHover: (e) {
              setState(() {
                hover = true;
              });
            },
            onExit: (e) {
              setState(() {
                hover = false;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 25),
                  child: widget.child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
