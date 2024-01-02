import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wordle/game/game.dart';
import 'package:wordle/ui/letter_tile.dart';

class WordRow extends StatefulWidget {
  const WordRow({super.key, required this.rowIndex});

  final int rowIndex;

  @override
  State<WordRow> createState() => _WordRowState();
}

class _WordRowState extends State<WordRow> with TickerProviderStateMixin {
  late final AnimationController animationController = AnimationController(
    value: 0,
    duration: const Duration(milliseconds: 50),
    lowerBound: -10,
    upperBound: 10,
    vsync: this,
  );

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget? widget) {
          return Transform.translate(
            offset: Offset(animationController.value, 0),
            child: widget,
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 5; ++i)
              Padding(
                  padding: const EdgeInsets.all(4),
                  child: Consumer<Game>(builder: (BuildContext context, Game value, Widget? child) {
                    runAnimationIfNeeded(value);
                    return LetterTile(row: widget.rowIndex, column: i);
                  }))
          ],
        ));
  }

  void runAnimationIfNeeded(Game game) async {
    const List<GameState> animatableGameStates = [GameState.noSuchWord, GameState.notEnoughLetters];
    if (animatableGameStates.contains(game.state) && game.currentRow == widget.rowIndex) {
      for (int i = 0; i < 3; ++i) {
        await animationController.forward();
        await animationController.reverse();
      }
      await animationController.animateTo(0);
    }
  }
}
