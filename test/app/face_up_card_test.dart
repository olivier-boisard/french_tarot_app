import 'dart:collection';

import 'package:flutter/cupertino.dart';
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

void main() {
  const cardToPlayKey = Key('cardToPlay');
  final card = TarotCard.coloredCard(Suit.spades, 1);
  testWidgets('Hand cards are visible', (tester) async {
    await _prepareApp(tester, card, cardToPlayKey);

    expect(find.byKey(cardToPlayKey), findsOneWidget);
  });

  testWidgets('Play card', (tester) async {
    const cardToPlayTargetKey = Key('cardToPlayTarget');

    await _prepareApp(
      tester,
      card,
      cardToPlayKey,
      cardPlayedByOthers: <AbstractTarotCard>[
        TarotCard.coloredCard(Suit.spades, 2),
        TarotCard.coloredCard(Suit.spades, 3),
        TarotCard.coloredCard(Suit.spades, 4),
      ],
      cardToPlayTargetKey: cardToPlayTargetKey,
    );

    final playedCard = find.byKey(cardToPlayKey);
    final playedCardCenter = tester.getCenter(playedCard);
    final dragTargetCenter = tester.getCenter(find.byKey(cardToPlayTargetKey));
    await tester.drag(playedCard, dragTargetCenter - playedCardCenter);
    await tester.pumpAndSettle();

    final playedCardFinder = find.descendant(
      of: find.byType(PlayedCardsArea),
      matching: find.widgetWithText(FaceUpCard, '1♠'),
    );

    final secondOfSpades = find.descendant(
      of: find.byType(PlayedCardsArea),
      matching: find.widgetWithText(FaceUpCard, '2♠'),
    );
    final thirdOfSpades = find.descendant(
      of: find.byType(PlayedCardsArea),
      matching: find.widgetWithText(FaceUpCard, '3♠'),
    );
    final fourthOfSpades = find.descendant(
      of: find.byType(PlayedCardsArea),
      matching: find.widgetWithText(FaceUpCard, '4♠'),
    );

    expect(playedCardFinder, findsOneWidget);
    expect(secondOfSpades, findsOneWidget);
    expect(thirdOfSpades, findsOneWidget);
    expect(fourthOfSpades, findsOneWidget);

    //TODO test played card not in hand anymore
  });
}

//TODO refactor
Future _prepareApp(WidgetTester tester, AbstractTarotCard cardPlayedByUser,
    Key cardToPlayKey, {List<AbstractTarotCard> cardPlayedByOthers,
      Key cardToPlayTargetKey}) async {
  final dimensions = Dimensions.fromScreen();
  final visibleCards = <Draggable<AbstractTarotCard>>[
    Draggable<AbstractTarotCard>(
      key: cardToPlayKey,
      data: cardPlayedByUser,
      feedback: FaceUpCard(card: cardPlayedByUser, dimensions: dimensions),
      child: FaceUpCard(card: cardPlayedByUser, dimensions: dimensions),
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
        // Display card that was played by user
        final cardDimensions = Dimensions.fromScreen();
        playedCards[PlayerLocation.bottom] = FaceUpCard(
          card: card,
          dimensions: cardDimensions,
        );

        // Display other cards
        playedCards[PlayerLocation.left] = FaceUpCard(
          card: cardPlayedByOthers[0],
          dimensions: cardDimensions,
        );
        playedCards[PlayerLocation.top] = FaceUpCard(
          card: cardPlayedByOthers[1],
          dimensions: cardDimensions,
        );
        playedCards[PlayerLocation.right] = FaceUpCard(
          card: cardPlayedByOthers[2],
          dimensions: cardDimensions,
        );
      },
      cardDraggableTargetKey: cardToPlayTargetKey,
    ),
  );
  await tester.pumpWidget(FrenchTarotApp(gameWidget: gamePage));
}
