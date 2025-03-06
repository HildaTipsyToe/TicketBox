import 'package:flutter/material.dart';

class TBDropdownButton<T> extends StatefulWidget {
  final List<T> data;
  final Function(dynamic name) callback;
  final Widget Function(T value) itemsLayout;
  final Widget Function({dynamic value}) hint;
  const TBDropdownButton({
    super.key,
    required this.data,
    required this.callback,
    required this.hint,
    required this.itemsLayout,
  });

  @override
  State<TBDropdownButton> createState() => _TBDropdownButton();
}

class _TBDropdownButton<T> extends State<TBDropdownButton<T>> {
  late T? dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = null;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      hint: widget.hint(value: widget.data),
      isExpanded: true,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.blue,
      ),
      onChanged: (T? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value as T;
          widget.callback(value);
        });
      },
      items: widget.data.map<DropdownMenuItem<T>>((value) {
        return DropdownMenuItem<T>(
          value: value,
          child: widget.itemsLayout(value),
        );
      }).toList(),
    );
  }
}
