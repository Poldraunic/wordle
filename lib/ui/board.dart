import 'package:flutter/widgets.dart';
import 'package:wordle/game/game.dart';
import 'package:wordle/ui/word_row.dart';

class Board extends StatelessWidget {
  const Board({super.key, required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [for (int i = 0; i < 6; ++i) WordRow(rowIndex: i, game: game)],
    );
  }
}
