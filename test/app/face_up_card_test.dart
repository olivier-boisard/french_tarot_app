import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/app/cards/face_up_card.dart';
import 'package:french_tarot/app/french_tarot_app.dart';
import 'package:french_tarot/app/game_page.dart';
import 'package:french_tarot/app/played_cards_area.dart';
import 'package:french_tarot/app/player_area/face_up_player_area.dart';
import 'package:french_tarot/engine/core/abstract_tarot_card.dart';
import 'package:french_tarot/engine/core/suited_playable.dart';
import 'package:french_tarot/engine/core/tarot_card.dart';

void main() {
  final card = TarotCard.coloredCard(Suit.spades, 1);

  testWidgets('Hand cards are visible', (tester) async {
    await _prepareApp(tester, card);
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
    await _prepareApp(tester, card);
    expect(cardInHandFinder, findsOneWidget);
    expect(playedCardFinder, findsNothing);

    await dragCardToPlay(tester);
    expect(cardInHandFinder, findsNothing);
    expect(playedCardFinder, findsOneWidget);
  });

  testWidgets('Try to play wrong card', (tester) async {
    await _prepareApp(tester, card);

    expect(cardInHandFinder, findsOneWidget);
    expect(playedCardFinder, findsNothing);

    await dragCardToPlay(tester);
    expect(cardInHandFinder, findsOneWidget);
    expect(playedCardFinder, findsNothing);
  });

  //TODO test opponents play cards
}

Future dragCardToPlay(WidgetTester tester) async {
  final playedCard = find.byType(FaceUpCard);
  final playedCardCenter = tester.getCenter(playedCard);
  const dragTargetKey = Key('AbstractTarotCardDragTarget');
  final dragTargetCenter = tester.getCenter(find.byKey(dragTargetKey));
  await tester.drag(playedCard, dragTargetCenter - playedCardCenter);
  await tester.pumpAndSettle();
}

Future _prepareApp(WidgetTester tester, AbstractTarotCard cardToPlay) async {
  final gamePage = GamePage(visibleHand: [FaceUpCard(card: cardToPlay)]);
  await tester.pumpWidget(FrenchTarotApp(gameWidget: gamePage));
}
