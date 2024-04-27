import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String text;
  const TitleWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    //standard title
    return Text(text,
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold
      ),
    );
  }
}
