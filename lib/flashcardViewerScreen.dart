import 'package:flutter/material.dart';
import 'models.dart';

class FlashcardViewerScreen extends StatefulWidget {
  final Deck deck;

  FlashcardViewerScreen({required this.deck});

  @override
  _FlashcardViewerScreenState createState() => _FlashcardViewerScreenState();
}

class _FlashcardViewerScreenState extends State<FlashcardViewerScreen> {
  int _currentIndex = 0;
  bool _showAnswer = false;

  void _nextCard() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.deck.cards.length;
      _showAnswer = false;
    });
  }

  void _flipCard() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.deck.cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.deck.name),
        ),
        body: Center(
          child: Text('No cards in this deck.'),
        ),
      );
    }

    final currentCard = widget.deck.cards[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deck.name),
      ),
      body: Center(
        child: GestureDetector(
          onTap: _flipCard,
          child: Card(
            margin: EdgeInsets.all(16.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  _showAnswer ? currentCard.answer : currentCard.question,
                  style: TextStyle(fontSize: 24.0),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _nextCard,
        child: Icon(Icons.navigate_next),
      ),
    );
  }
}
