import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/app/cards/face_down_card.dart';
import 'package:french_tarot/app/cards/face_up_card.dart';
import 'package:french_tarot/app/french_tarot_app.dart';
import 'package:french_tarot/app/game_page.dart';
import 'package:french_tarot/app/player_area.dart';
import 'package:french_tarot/engine/core/suited_playable.dart';
import 'package:french_tarot/engine/core/tarot_card.dart';

void main() {
  testWidgets('Hand cards are visible', (tester) async {
    final visibleCards = <FaceUpCard>[
      FaceUpCard(card: TarotCard.coloredCard(Suit.spades, 1)),
    ];

    final faceDownCards = <FaceDownCard>[];
    const nCards = 18;
    for (var i = 0; i < nCards; i++) {
      faceDownCards.add(FaceDownCard());
    }

    final gamePage = GamePage(
      playerAreas: <Widget>[
        PlayerArea(cards: visibleCards),
        PlayerArea(cards: faceDownCards),
        PlayerArea(cards: faceDownCards),
        PlayerArea(cards: faceDownCards),
      ],
    );
    await tester.pumpWidget(FrenchTarotApp(gameWidget: gamePage));

    expect(find.text('1\n♠'), findsWidgets);
    //TODO expect(find.text('1♠'), findsOneWidget);
  });
}
