import 'package:flutter/material.dart';

class FlipCard extends StatefulWidget {
  final String question;
  final String answer;

  FlipCard({required this.question, required this.answer});

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> {
  bool _showAnswer = false;

  void _flipCard() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: Card(
        margin: EdgeInsets.all(16.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              _showAnswer ? widget.answer : widget.question,
              style: TextStyle(fontSize: 24.0),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
