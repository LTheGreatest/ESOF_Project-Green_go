import 'package:flutter/material.dart';

class ProblemWidget extends StatelessWidget{
  final String text;
  const ProblemWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    //standard widget for displaying problems
    return  Center(
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}
