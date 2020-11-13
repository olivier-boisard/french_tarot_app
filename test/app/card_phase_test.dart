import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/app/cards/face_down_card.dart';
import 'package:french_tarot/app/cards/face_up_card.dart';
import 'package:french_tarot/app/french_tarot_app.dart';
import 'package:french_tarot/app/game_page.dart';
import 'package:french_tarot/app/played_cards_area.dart';
import 'package:french_tarot/app/player_area/face_up_player_area.dart';
import 'package:french_tarot/engine/core/suited_playable.dart';
import 'package:french_tarot/engine/core/tarot_card.dart';

void main() {
  final card = TarotCard.coloredCard(Suit.spades, 1);
  final gamePageAcceptingAnyCard = GamePage(
    visibleHand: [FaceUpCard(card: card)],
    isCardAllowed: (card) => true,
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

  final topPlayerHand = find.descendant(
    of: find.byKey(topFaceDownAreaKey),
    matching: find.byType(FaceDownCard),
  );
  final leftPlayerHand = find.descendant(
    of: find.byKey(leftFaceDownArea),
    matching: find.byType(FaceDownCard),
  );
  final rightPlayerHand = find.descendant(
    of: find.byKey(rightFaceDownAreaKey),
    matching: find.byType(FaceDownCard),
  );

  testWidgets('Play card', (tester) async {
    await _prepareApp(tester, gamePageAcceptingAnyCard);
    expect(cardInHandFinder, findsOneWidget);
    expect(playedCardFinder, findsNothing);
    expect(topPlayerHand, findsOneWidget);
    expect(leftPlayerHand, findsOneWidget);
    expect(rightPlayerHand, findsOneWidget);

    await dragCardToPlay(tester);
    expect(cardInHandFinder, findsNothing);
    expect(playedCardFinder, findsOneWidget);
    expect(topPlayerHand, findsNothing);
    expect(leftPlayerHand, findsNothing);
    expect(rightPlayerHand, findsNothing);
  });

  testWidgets('Reject played card', (tester) async {
    final gamePageRejectingAnyCard = GamePage(
      visibleHand: [FaceUpCard(card: card)],
      isCardAllowed: (card) => false,
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
  final finder = find.byKey(abstractTarotCardDragTargetKey);
  final dragTargetCenter = tester.getCenter(finder);
  await tester.drag(playedCard, dragTargetCenter - playedCardCenter);
  await tester.pumpAndSettle();
}

Future _prepareApp(WidgetTester tester, GamePage gamePage) async {
  await tester.pumpWidget(FrenchTarotApp(gameWidget: gamePage));
}
