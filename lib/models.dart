class Deck {
  String id;
  String name;
  List<FlashCard> cards;

  Deck({required this.id, required this.name, required this.cards});
}

class FlashCard {
  String id;
  String question;
  String answer;

  FlashCard({required this.id, required this.question, required this.answer});
}
