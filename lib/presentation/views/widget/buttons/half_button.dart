import 'package:flutter/material.dart';

class TBHalfButton extends StatefulWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback onPressed;
  final double? roundBorder;
  TextDirection? textDirection = TextDirection.ltr;

  TBHalfButton({super.key,
    this.text,
    this.icon,
    required this.onPressed,
    this.roundBorder,
    this.textDirection,
  });

  @override
  State<StatefulWidget> createState() => _TBHalfButton();
}

class _TBHalfButton extends State<TBHalfButton> {
  Color color = const Color.fromARGB(33, 0, 0, 0);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onExit: bkOnExit,
      onHover: bkOnHover,
      child: TextButton(
        style: ButtonStyle(
          overlayColor:
              WidgetStateColor.resolveWith((states) => Colors.transparent),
        ),
        onPressed: widget.onPressed,
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 65,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(widget.roundBorder ?? 5.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: widget.textDirection,
            children: [
              widget.icon != null
                  ? Icon(
                widget.icon,
                color: Colors.black,
              )
                  : Container(),
              Text(
                widget.text != null ? widget.text! : "",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void bkOnHover(PointerEvent details) {
    setState(() {
      color = Colors.grey;
    });
  }

  void bkOnExit(PointerEvent details) {
    setState(() {
      color = const Color.fromARGB(33, 0, 0, 0);
    });
  }
}
