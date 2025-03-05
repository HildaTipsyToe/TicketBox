import 'package:flutter/material.dart';

class TBCircularProgressIndicator extends StatelessWidget {
  const TBCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height - 75,
        width: MediaQuery.of(context).size.width,
        child: const Center(child: CircularProgressIndicator())
    );
  }
}
