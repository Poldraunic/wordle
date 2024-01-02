import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:wordle/game/game.dart';
import 'package:wordle/game/letter.dart';

typedef KeyboardCallback = Function(LogicalKeyboardKey);

class Keyboard extends StatelessWidget {
  const Keyboard({super.key, required this.game, required this.onTap});

  final Game game;
  final KeyboardCallback onTap;

  @override
  Widget build(BuildContext context) {
    const topRow = [
      LogicalKeyboardKey.keyQ,
      LogicalKeyboardKey.keyW,
      LogicalKeyboardKey.keyE,
      LogicalKeyboardKey.keyR,
      LogicalKeyboardKey.keyT,
      LogicalKeyboardKey.keyY,
      LogicalKeyboardKey.keyU,
      LogicalKeyboardKey.keyI,
      LogicalKeyboardKey.keyO,
      LogicalKeyboardKey.keyP,
    ];

    const middleRow = [
      LogicalKeyboardKey.keyA,
      LogicalKeyboardKey.keyS,
      LogicalKeyboardKey.keyD,
      LogicalKeyboardKey.keyF,
      LogicalKeyboardKey.keyG,
      LogicalKeyboardKey.keyH,
      LogicalKeyboardKey.keyJ,
      LogicalKeyboardKey.keyK,
      LogicalKeyboardKey.keyL,
    ];

    const bottomRow = [
      LogicalKeyboardKey.backspace,
      LogicalKeyboardKey.keyZ,
      LogicalKeyboardKey.keyX,
      LogicalKeyboardKey.keyC,
      LogicalKeyboardKey.keyV,
      LogicalKeyboardKey.keyB,
      LogicalKeyboardKey.keyN,
      LogicalKeyboardKey.keyM,
      LogicalKeyboardKey.enter
    ];

    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (final logicalKey in topRow)
            Padding(
              padding: const EdgeInsets.all(2),
              child: KeyWidget(
                logicalKey: logicalKey,
                letterMatch: game.matchForLetter(logicalKey.keyLabel),
                onTap: onTap,
              ),
            )
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (final logicalKey in middleRow)
            Padding(
              padding: const EdgeInsets.all(2),
              child: KeyWidget(
                logicalKey: logicalKey,
                letterMatch: game.matchForLetter(logicalKey.keyLabel),
                onTap: onTap,
              ),
            )
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (final logicalKey in bottomRow)
            Padding(
              padding: const EdgeInsets.all(2),
              child: KeyWidget(
                logicalKey: logicalKey,
                letterMatch: game.matchForLetter(logicalKey.keyLabel),
                onTap: onTap,
              ),
            )
        ]),
      ],
    );
  }
}

class KeyWidget extends StatelessWidget {
  const KeyWidget({super.key, required this.logicalKey, required this.letterMatch, required this.onTap});

  final LetterMatch? letterMatch;
  final LogicalKeyboardKey logicalKey;
  final KeyboardCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(logicalKey);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        constraints: const BoxConstraints(minWidth: 46, minHeight: 36),
        child: Text(
          logicalKey.keyLabel,
          style: const TextStyle(fontSize: 24, color: Color(0xffffffff)),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Color get backgroundColor {
    switch (letterMatch) {
      case LetterMatch.noMatch:
        return const Color(0xff3a3a3c);
      case LetterMatch.partialMatch:
        return const Color(0xffb59f3b);
      case LetterMatch.fullMatch:
        return const Color(0xff538d4e);
      default:
        return const Color(0xff818384);
    }
  }
}
