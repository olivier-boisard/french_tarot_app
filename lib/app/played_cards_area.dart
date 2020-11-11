import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../engine/core/abstract_tarot_card.dart';
import '../engine/core/function_interfaces.dart';
import 'cards/face_up_card.dart';
import 'player_area/screen_sized.dart';

const abstractTarotCardDragTargetKey = Key('AbstractTarotCardDragTarget');

class PlayedCardsArea extends StatefulWidget {
  final Map<PlayerLocation, Widget> playedCards;
  final Transformer<bool, AbstractTarotCard> cardIsAllowed;
  final Consumer<AbstractTarotCard> playCard;

  const PlayedCardsArea({
    Key key,
    @required this.playedCards,
    @required this.cardIsAllowed,
    @required this.playCard,
  }) : super(key: key);

  @override
  _PlayerCardsAreaState createState() {
    return _PlayerCardsAreaState(
      playedCards,
      cardIsAllowed,
      playCard,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Map<PlayerLocation, Widget>>(
        'playedCards',
        playedCards,
      ))
      ..add(ObjectFlagProperty<Transformer<bool, AbstractTarotCard>>.has(
        'cardIsAllowed',
        cardIsAllowed,
      ))
      ..add(ObjectFlagProperty<Consumer<AbstractTarotCard>>.has(
        'playCard',
        playCard,
      ));
  }
}

enum PlayerLocation { top, left, right, bottom }

class _PlayerCardsAreaState extends State<PlayedCardsArea> with ScreenSized {
  final Map<PlayerLocation, Widget> playedCards;
  final DragTargetWillAccept<AbstractTarotCard> cardIsAllowed;
  final Consumer<AbstractTarotCard> playCard;

  _PlayerCardsAreaState(
    this.playedCards,
    this.cardIsAllowed,
    this.playCard,
  );

  @override
  Widget build(BuildContext context) {
    final cardPlaceHolder = Container(
      width: dimensions.width,
      height: dimensions.height,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: playedCards[PlayerLocation.top] ?? cardPlaceHolder,
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Container(
                child: playedCards[PlayerLocation.left] ?? cardPlaceHolder,
              ),
              Container(
                child: playedCards[PlayerLocation.right] ?? cardPlaceHolder,
              ),
              Expanded(
                flex: 1,
                child: Container(),
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.topCenter,
            child: playedCards[PlayerLocation.bottom] ??
                _buildPlayedCardDraggableTarget(),
          ),
        )
      ],
    );
  }

  DragTarget<AbstractTarotCard> _buildPlayedCardDraggableTarget() {
    return DragTarget<AbstractTarotCard>(
      key: abstractTarotCardDragTargetKey,
      onWillAccept: cardIsAllowed,
      onAccept: (cardToPlay) {
        setState(() {
          playCard(cardToPlay);
        });
      },
      builder: (context, candidates, rejects) {
        return candidates.isNotEmpty && cardIsAllowed(candidates.first)
            ? FaceUpCard(card: candidates.first)
            : Container();
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Map<PlayerLocation, Widget>>(
        'playedCards',
        playedCards,
      ))
      ..add(ObjectFlagProperty<Transformer<bool, AbstractTarotCard>>.has(
        'cardIsAllowed',
        cardIsAllowed,
      ))
      ..add(ObjectFlagProperty<Consumer<AbstractTarotCard>>.has(
        'playCard',
        playCard,
      ));
  }
}
