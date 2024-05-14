import 'package:flutter/material.dart';
import 'models.dart';
import 'flip_card.dart'; // Assuming you've saved the FlipCard widget in a separate file

void main() => runApp(FlashcardApp());

class FlashcardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey,
      ),
      home: DeckListScreen(),
    );
  }
}

class DeckListScreen extends StatefulWidget {
  @override
  _DeckListScreenState createState() => _DeckListScreenState();
}

class _DeckListScreenState extends State<DeckListScreen> {
  final List<Deck> decks = [
    Deck(id: '1', name: 'Sample Deck', cards: [])
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Decks'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Add Deck'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewDeckScreen(
                      addNewDeck: addNewDeck,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: decks.length,
        itemBuilder: (context, index) {
          final deck = decks[index];
          return ListTile(
            title: Text(deck.name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CardListScreen(deck: deck, addNewCard: addNewCard),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewDeckScreen(
                addNewDeck: addNewDeck,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void addNewDeck(String deckName) {
    setState(() {
      decks.add(Deck(id: UniqueKey().toString(), name: deckName, cards: []));
    });
  }

  void addNewCard(Deck deck, FlashCard card) {
    setState(() {
      final index = decks.indexWhere((element) => element.id == deck.id);
      if (index != -1) {
        decks[index].cards.add(card);
      }
    });
  }
}

class NewDeckScreen extends StatelessWidget {
  final Function(String) addNewDeck;

  NewDeckScreen({required this.addNewDeck});

  final TextEditingController _deckNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Deck'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _deckNameController,
              decoration: InputDecoration(labelText: 'Deck Name'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                addNewDeck(_deckNameController.text);
                Navigator.pop(context); // Close the screen after adding deck
              },
              child: Text('Add Deck'),
            ),
          ],
        ),
      ),
    );
  }
}

class CardListScreen extends StatelessWidget {
  final Deck deck;
  final Function(Deck, FlashCard) addNewCard;

  CardListScreen({required this.deck, required this.addNewCard});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(deck.name),
      ),
      body: ListView.builder(
        itemCount: deck.cards.length,
        itemBuilder: (context, index) {
          final card = deck.cards[index];
          return ListTile(
            title: Text(card.question),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CardDetailScreen(card: card),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewCardScreen(deck: deck, addNewCard: addNewCard),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}



class CardDetailScreen extends StatelessWidget {
  final FlashCard card;

  CardDetailScreen({required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FlipCard(
              question: card.question,
              answer: card.answer,
            ),
            SizedBox(height: 8.0),
            // You can add other buttons or UI elements here for additional functionality
          ],
        ),
      ),
    );
  }
}


class NewCardScreen extends StatelessWidget {
  final Deck deck;
  final Function(Deck, FlashCard) addNewCard;

  NewCardScreen({required this.deck, required this.addNewCard});

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
                Navigator.pop(context); // Close the screen after adding card
              },
              child: Text('Add Card'),
            ),
          ],
        ),
      ),
    );
  }
}
