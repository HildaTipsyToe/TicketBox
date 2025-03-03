import 'package:flutter/material.dart';

class TBIconButton extends StatefulWidget {
  final VoidCallback onPressed;
  final double? iconSize;
  final IconData icon;
  final Color? color;
  final double? size;

  const TBIconButton({super.key, this.iconSize, required this.onPressed, required this.icon, this.color, this.size});

  @override
  State<StatefulWidget> createState() => _TBIconButton();
}

class _TBIconButton extends State<TBIconButton> {
  Color hoverColor = const Color.fromARGB(255, 241, 241, 241);


  @override
  Widget build(BuildContext context) {
    Color color = widget.color ?? Colors.white;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (_) => {
        setState(() {
          color = hoverColor;
        })
      },
      onExit: (_) => {
        setState(() {
          color = Colors.white;
        })
      },
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: widget.size ?? 50,
          height: widget.size ?? 50,
          decoration: BoxDecoration(
            color: color,
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 161, 160, 160),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 4),
              ),
            ],
            borderRadius: BorderRadius.all(
              Radius.circular(widget.size == null ? 25 : widget.size!/2),
            ),
            border: Border.all(color: Colors.black),
          ),
          child: Icon(
            widget.icon,
            size: widget.iconSize,
          ),
        ),
      ),
    );
  }
}
