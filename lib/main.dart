import 'package:flutter/material.dart';
import 'models.dart';
import 'flip_card.dart';
import 'flashcardViewerScreen.dart';

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
  final List<Deck> decks = []; // Start with an empty list
  final ReviewSettings reviewSettings = ReviewSettings(
    initialInterval: 1,
    intervalMultiplier: 2.0,
    sessionDuration: 30,
  );

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
      body: decks.isEmpty
          ? Center(child: Text('No decks available. Add a new deck.'))
          : ListView.builder(
              itemCount: decks.length,
              itemBuilder: (context, index) {
                final deck = decks[index];
                return ListTile(
                  title: Text(deck.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.play_arrow),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FlashcardViewerScreen(
                                deck: deck,
                                reviewSettings: reviewSettings,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewCardScreen(
                                deck: deck,
                                addNewCard: addNewCard,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
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
                Navigator.pop(context);
              },
              child: Text('Add Deck'),
            ),
          ],
        ),
      ),
    );
  }
}

class CardListScreen extends StatefulWidget {
  final Deck deck;
  final Function(Deck, FlashCard) addNewCard;

  CardListScreen({required this.deck, required this.addNewCard});

  @override
  _CardListScreenState createState() => _CardListScreenState();
}

class _CardListScreenState extends State<CardListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deck.name),
      ),
      body: ListView.builder(
        itemCount: widget.deck.cards.length,
        itemBuilder: (context, index) {
          final card = widget.deck.cards[index];
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
              builder: (context) => NewCardScreen(
                deck: widget.deck,
                addNewCard: widget.addNewCard,
                onCardAdded: () {
                  setState(() {});
                },
              ),
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
          ],
        ),
      ),
    );
  }
}

class NewCardScreen extends StatelessWidget {
  final Deck deck;
  final Function(Deck, FlashCard) addNewCard;
  final VoidCallback? onCardAdded;

  NewCardScreen({
    required this.deck,
    required this.addNewCard,
    this.onCardAdded,
  });

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
                  nextReviewDate: DateTime.now(),
                );
                addNewCard(deck, newCard);
                Navigator.pop(context);
                if (onCardAdded != null) {
                  onCardAdded!();
                }
              },
              child: Text('Add Card'),
            ),
          ],
        ),
      ),
    );
  }
}
