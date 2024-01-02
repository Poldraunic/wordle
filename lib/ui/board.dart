import 'package:flutter/widgets.dart';
import 'package:wordle/game/game.dart';
import 'package:wordle/ui/letter_tile.dart';

class Board extends StatelessWidget {
  const Board({super.key, required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < 6; ++i)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int j = 0; j < 5; ++j)
                Padding(
                    padding: const EdgeInsets.all(4),
                    child: LetterTile(
                      letter: game.letterAt(i, j),
                    ))
            ],
          )
      ],
    );
  }
}
