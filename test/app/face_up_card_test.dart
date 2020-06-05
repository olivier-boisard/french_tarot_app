import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/app/cards/face_up_card.dart';
import 'package:french_tarot/app/core/dimensions.dart';
import 'package:french_tarot/app/french_tarot_app.dart';
import 'package:french_tarot/app/game_page.dart';
import 'package:french_tarot/app/played_cards_area.dart';
import 'package:french_tarot/app/player_area/face_down_player_area.dart';
import 'package:french_tarot/app/player_area/face_up_player_area.dart';
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
    const playerHandKey = Key('playerHand');

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
      playerHandKey: playerHandKey,
    );

    expect(
      find.descendant(
        of: find.byKey(playerHandKey),
        matching: find.byKey(cardToPlayKey),
      ),
      findsOneWidget,
    );

    final playedCard = find.byKey(cardToPlayKey);
    final playedCardCenter = tester.getCenter(playedCard);
    final dragTargetCenter = tester.getCenter(find.byKey(cardToPlayTargetKey));
    await tester.drag(playedCard, dragTargetCenter - playedCardCenter);
    await tester.pumpAndSettle();

    //TODO avoid using hard coded texts here and below
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
    expect(
      find.descendant(
        of: find.byKey(playerHandKey),
        matching: find.byKey(cardToPlayKey),
      ),
      findsNothing,
    );
  });

  //TODO test play unallowed card
}

//TODO refactor and reuse script's main function
Future _prepareApp(WidgetTester tester, AbstractTarotCard cardPlayedByUser,
    Key cardToPlayKey, {List<AbstractTarotCard> cardPlayedByOthers,
      Key cardToPlayTargetKey,
      Key playerHandKey}) async {
  const nCards = 18;

  final playedCards = LinkedHashMap<PlayerLocation, Widget>();
  final gamePage = GamePage(
    playerAreas: <Widget>[
      FaceUpPlayerArea(
        key: playerHandKey,
        cards: [cardPlayedByUser],
        cardWidgetKeys: [cardToPlayKey],
      ),
      FaceDownPlayerArea(nCards: nCards),
      FaceDownPlayerArea(nCards: nCards),
      FaceDownPlayerArea(nCards: nCards),
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
