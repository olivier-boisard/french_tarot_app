import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/app/cards/face_down_card.dart';
import 'package:french_tarot/app/cards/face_up_card.dart';
import 'package:french_tarot/app/french_tarot_app.dart';
import 'package:french_tarot/app/game_page.dart';
import 'package:french_tarot/app/played_cards_area.dart';
import 'package:french_tarot/app/player_area/face_down_player_area.dart';
import 'package:french_tarot/app/player_area/face_up_player_area.dart';
import 'package:french_tarot/engine/core/suits.dart';
import 'package:french_tarot/engine/core/tarot_card.dart';

void main() {
  final card = TarotCard.coloredCard(Suit.spades, 1);
  final faceDownPlayerArea = FaceDownPlayerArea(
    nCards: 1,
    faceDownCardFactory: () => FaceDownCard(),
  );
  final gamePageAcceptingAnyCard = GamePage(
    visibleHand: [FaceUpCard(card: card)],
    isCardAllowed: (card) => true,
    faceDownPlayerArea: faceDownPlayerArea,
  );

  testWidgets('Hand cards are visible', (tester) async {
    await _prepareApp(tester, gamePageAcceptingAnyCard);
    expect(find.byType(FaceUpCard), findsOneWidget);
  });
  final playedCardFinder = find.descendant(
    of: find.byType(PlayedCardsArea),
    matching: find.byType(FaceUpCard),
  );
  final cardInHandFinder = find.descendant(
    of: find.byType(FaceUpPlayerArea),
    matching: find.byType(FaceUpCard),
  );

  testWidgets('Play card', (tester) async {
    await _prepareApp(tester, gamePageAcceptingAnyCard);
    expect(cardInHandFinder, findsOneWidget);
    expect(playedCardFinder, findsNothing);

    await dragCardToPlay(tester);
    expect(cardInHandFinder, findsNothing);
    expect(playedCardFinder, findsOneWidget);
  });

  testWidgets('Reject played card', (tester) async {
    final gamePageRejectingAnyCard = GamePage(
      visibleHand: [FaceUpCard(card: card)],
      isCardAllowed: (card) => false,
      faceDownPlayerArea: faceDownPlayerArea,
    );
    await _prepareApp(tester, gamePageRejectingAnyCard);

    expect(cardInHandFinder, findsOneWidget);
    expect(playedCardFinder, findsNothing);

    await dragCardToPlay(tester);
    expect(cardInHandFinder, findsOneWidget);
    expect(playedCardFinder, findsNothing);
  });
}

Future dragCardToPlay(WidgetTester tester) async {
  final playedCard = find.byType(FaceUpCard);
  final playedCardCenter = tester.getCenter(playedCard);
  const dragTargetKey = Key('AbstractTarotCardDragTarget');
  final dragTargetCenter = tester.getCenter(find.byKey(dragTargetKey));
  await tester.drag(playedCard, dragTargetCenter - playedCardCenter);
  await tester.pumpAndSettle();
}

Future _prepareApp(WidgetTester tester, GamePage gamePage) async {
  await tester.pumpWidget(FrenchTarotApp(gameWidget: gamePage));
}
