import 'package:flutter/widgets.dart';
import 'package:wordle/game/letter.dart';

class LetterTile extends StatelessWidget {
  const LetterTile({super.key, required this.letter});

  final Letter letter;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(width: 2, color: borderColor),
        ),
        child: Align(
            alignment: Alignment.center,
            child: Text(
                style: const TextStyle(fontSize: 24, color: Color(0xffffffff)),
                textAlign: TextAlign.center,
                letter.character)));
  }

  Color get borderColor {
    if (letter.matchResult != null) {
      return const Color(0x00000000);
    }

    if (letter.isEmpty) return const Color(0xff3a3a3c);
    return const Color(0xff565758);
  }

  Color get backgroundColor {
    switch (letter.matchResult) {
      case LetterMatch.noMatch:
        return const Color(0xff3a3a3c);
      case LetterMatch.partialMatch:
        return const Color(0xffb59f3b);
      case LetterMatch.fullMatch:
        return const Color(0xff538d4e);
      default:
        return const Color(0x00000000);
    }
  }
}
