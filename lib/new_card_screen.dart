import 'package:flutter/material.dart';
import 'models.dart';

class NewCardScreen extends StatelessWidget {
  final Deck deck;
  final Function(Deck, FlashCard) addNewCard;
  final VoidCallback? onCardAdded;

  NewCardScreen(
      {required this.deck, required this.addNewCard, this.onCardAdded});

  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Card'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: 'Question'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(labelText: 'Answer'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final newCard = FlashCard(
                  id: UniqueKey().toString(),
                  question: _questionController.text,
                  answer: _answerController.text,
                );
                addNewCard(deck, newCard);
                Navigator.pop(context);
              },
              child: Text('Add Card'),
            ),
          ],
        ),
      ),
    );
  }
}
