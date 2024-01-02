import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wordle/game/game.dart';
import 'package:wordle/game/letter.dart';
import 'package:wordle/ui/flip_widget.dart';

class LetterTile extends StatefulWidget {
  const LetterTile({super.key, required this.row, required this.column});

  final int row;
  final int column;

  @override
  State<LetterTile> createState() => _LetterTileState();
}

class _LetterTileState extends State<LetterTile> with TickerProviderStateMixin {
  late final AnimationController flipAnimationController = AnimationController(
    duration: animationDuration,
    vsync: this,
  );

  static const Duration animationDuration = Duration(milliseconds: 600);

  @override
  Widget build(BuildContext context) {
    var game = context.watch<Game>();
    runFlipAnimationIfNeeded(game);

    var letter = game.letterAt(widget.row, widget.column);
    return FlipWidget(
      front: _OutlinedLetterTile(letter: letter),
      back: _FilledLetterTile(letter: letter),
      animationController: flipAnimationController,
    );
  }

  void runFlipAnimationIfNeeded(Game game) async {
    const List<GameState> animatableGameStates = [GameState.incorrectWord, GameState.win, GameState.lose];

    // By the time game advanced to any of these states, `currentRow` is already incremented.
    if (animatableGameStates.contains(game.state) && widget.row == game.currentRow - 1) {
      await Future.delayed(
        Duration(milliseconds: animationDuration.inMilliseconds ~/ 2) * widget.column,
        () => flipAnimationController.forward(),
      );
    }
  }
}

abstract class _BaseLetterTile extends StatelessWidget {
  const _BaseLetterTile({required this.letter});

  final Letter letter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor(letter),
        border: Border.all(width: 2, color: borderColor(letter)),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          style: const TextStyle(fontSize: 24, color: Color(0xffffffff)),
          textAlign: TextAlign.center,
          letter.character,
        ),
      ),
    );
  }

  Color borderColor(Letter letter);

  Color backgroundColor(Letter letter);
}

class _OutlinedLetterTile extends _BaseLetterTile {
  const _OutlinedLetterTile({required super.letter});

  @override
  Color borderColor(Letter letter) {
    if (letter.isEmpty) return const Color(0xff3a3a3c);
    return const Color(0xff565758);
  }

  @override
  Color backgroundColor(Letter letter) {
    return const Color(0x00000000);
  }
}

class _FilledLetterTile extends _BaseLetterTile {
  const _FilledLetterTile({required super.letter});

  @override
  Color borderColor(Letter letter) {
    assert(letter.matchResult != null);
    return const Color(0x00000000);
  }

  @override
  Color backgroundColor(Letter letter) {
    assert(letter.matchResult != null);
    switch (letter.matchResult!) {
      case LetterMatch.noMatch:
        return const Color(0xff3a3a3c);
      case LetterMatch.partialMatch:
        return const Color(0xffb59f3b);
      case LetterMatch.fullMatch:
        return const Color(0xff538d4e);
    }
  }
}
