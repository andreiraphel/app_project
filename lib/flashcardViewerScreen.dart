import 'package:flutter/material.dart';
import 'models.dart';

class FlashcardViewerScreen extends StatefulWidget {
  final Deck deck;
  final ReviewSettings reviewSettings;

  FlashcardViewerScreen({required this.deck, required this.reviewSettings});

  @override
  _FlashcardViewerScreenState createState() => _FlashcardViewerScreenState();
}

class _FlashcardViewerScreenState extends State<FlashcardViewerScreen> {
  PageController _pageController = PageController();
  bool _showAnswer = false;

  void _flipCard() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  void _markCardCorrect(FlashCard card) {
    setState(() {
      card.correctCount += 1;
      card.nextReviewDate = DateTime.now().add(Duration(
        days: (widget.reviewSettings.initialInterval *
                widget.reviewSettings.intervalMultiplier)
            .toInt(),
      ));
    });
  }

  void _markCardIncorrect(FlashCard card) {
    setState(() {
      card.incorrectCount += 1;
      card.nextReviewDate = DateTime.now().add(Duration(
        days: widget.reviewSettings.initialInterval,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final reviewCards = widget.deck.cards
        .where((card) => card.nextReviewDate.isBefore(DateTime.now()))
        .toList();

    if (reviewCards.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.deck.name),
        ),
        body: Center(
          child: Text('No cards to review.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deck.name),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: reviewCards.length,
        itemBuilder: (context, index) {
          final card = reviewCards[index];
          return GestureDetector(
            onTap: _flipCard,
            child: Card(
              margin: EdgeInsets.all(16.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _showAnswer ? card.answer : card.question,
                      style: TextStyle(fontSize: 24.0),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.0),
                    if (_showAnswer) ...[
                      ElevatedButton(
                        onPressed: () {
                          _markCardCorrect(card);
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Text('Correct'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _markCardIncorrect(card);
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Text('Incorrect'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
        onPageChanged: (index) {
          setState(() {
            _showAnswer = false;
          });
        },
      ),
    );
  }
}
