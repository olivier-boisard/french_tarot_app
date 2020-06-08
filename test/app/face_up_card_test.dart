import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/app/cards/face_up_card.dart';
import 'package:french_tarot/app/french_tarot_app.dart';
import 'package:french_tarot/app/game_page.dart';
import 'package:french_tarot/app/played_cards_area.dart';
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

    expect(playedCardFinder, findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(playerHandKey),
        matching: find.byKey(cardToPlayKey),
      ),
      findsNothing,
    );
  });

  //TODO test play unallowed card
  //TODO test opponents play cards
}

//TODO refactor and reuse script's main function
Future _prepareApp(WidgetTester tester, AbstractTarotCard cardPlayedByUser,
    Key cardToPlayKey, {Key cardToPlayTargetKey,
      Key playerHandKey}) async {
  final gamePage = GamePage(
    visibleHand: [cardPlayedByUser],
    visibleCardKeys: [cardToPlayKey],
    cardDraggableTargetKey: cardToPlayTargetKey,
    playerHandKey: playerHandKey,
  );
  await tester.pumpWidget(FrenchTarotApp(gameWidget: gamePage));
}
