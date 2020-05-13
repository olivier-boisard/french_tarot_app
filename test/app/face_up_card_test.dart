import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/app/cards/face_down_card.dart';
import 'package:french_tarot/app/cards/face_up_card.dart';
import 'package:french_tarot/app/core/dimensions.dart';
import 'package:french_tarot/app/french_tarot_app.dart';
import 'package:french_tarot/app/game_page.dart';
import 'package:french_tarot/app/played_cards_area.dart';
import 'package:french_tarot/app/player_area.dart';
import 'package:french_tarot/engine/core/abstract_tarot_card.dart';
import 'package:french_tarot/engine/core/suited_playable.dart';
import 'package:french_tarot/engine/core/tarot_card.dart';

//TODO strip this unit test from useless elements
void main() {
  const playedCardWidgetText = '1♠';
  testWidgets('Hand cards are visible', (tester) async {
    await _prepareApp(tester);

    expect(find.text('1\n♠'), findsWidgets);
    expect(find.text(playedCardWidgetText), findsOneWidget);
  });

  testWidgets('Play card', (tester) async {
    const cardToPlayKey = Key('cardToPlay');
    const cardToPlayTargetKey = Key('cardToPlayTarget');

    await _prepareApp(
      tester,
      cardToPlayKey: cardToPlayKey,
      cardToPlayTargetKey: cardToPlayTargetKey,
    );
    final playedCard = find.byKey(cardToPlayKey);
    final dragTarget = find.byKey(cardToPlayTargetKey);

    final playedCardCenter = tester.getCenter(playedCard);
    final dragTargetCenter = tester.getCenter(dragTarget);
    await tester.drag(playedCard, dragTargetCenter - playedCardCenter);

    final playedCardFinder = find.descendant(
      of: find.byType(PlayedCardsArea),
      matching: find.widgetWithText(FaceUpCard, playedCardWidgetText),
    );

    expect(playedCardFinder, findsOneWidget);
  });
}

Future _prepareApp(WidgetTester tester,
    {Key cardToPlayKey, Key cardToPlayTargetKey}) async {
  final card = TarotCard.coloredCard(Suit.spades, 1);
  final dimensions = Dimensions.fromScreen();
  final visibleCards = <Draggable<AbstractTarotCard>>[
    Draggable<AbstractTarotCard>(
      key: cardToPlayKey,
      data: card,
      feedback: FaceUpCard(card: card, dimensions: dimensions),
      child: FaceUpCard(card: card, dimensions: dimensions),
    ),
  ];

  final faceDownCards = <FaceDownCard>[];
  const nCards = 18;
  for (var i = 0; i < nCards; i++) {
    faceDownCards.add(FaceDownCard(dimensions: Dimensions.fromScreen()));
  }

  final playedCards = LinkedHashMap<PlayerLocation, Widget>();
  final gamePage = GamePage(
    playerAreas: <Widget>[
      PlayerArea(cards: visibleCards),
      PlayerArea(cards: faceDownCards),
      PlayerArea(cards: faceDownCards),
      PlayerArea(cards: faceDownCards),
    ],
    playedCardsArea: PlayedCardsArea(
      playedCards: playedCards,
      cardIsAllowed: (card) => true,
      playCard: (card) {
        playedCards[PlayerLocation.bottom] = FaceUpCard(
          card: card,
          dimensions: Dimensions.fromScreen(),
        );
      },
      cardDraggableTargetKey: cardToPlayTargetKey,
    ),
  );
  await tester.pumpWidget(FrenchTarotApp(gameWidget: gamePage));
}
