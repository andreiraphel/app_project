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
  DateTime nextReviewDate;
  int correctCount;
  int incorrectCount;

  FlashCard({
    required this.id,
    required this.question,
    required this.answer,
    required this.nextReviewDate,
    this.correctCount = 0,
    this.incorrectCount = 0,
  });
}

class ReviewSettings {
  int initialInterval;
  double intervalMultiplier;
  int sessionDuration;

  ReviewSettings({
    required this.initialInterval,
    required this.intervalMultiplier,
    required this.sessionDuration,
  });
}
