import 'package:flutter/widgets.dart';
import 'package:wordle/game/game.dart';
import 'package:wordle/ui/letter_tile.dart';

class WordRow extends StatefulWidget {
  const WordRow({super.key, required this.rowIndex, required this.game});

  final int rowIndex;
  final Game game;

  @override
  State<WordRow> createState() => _WordRowState();
}

class _WordRowState extends State<WordRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int j = 0; j < 5; ++j)
          Padding(
              padding: const EdgeInsets.all(4),
              child: LetterTile(
                letter: widget.game.letterAt(widget.rowIndex, j),
              ))
      ],
    );
  }
}
