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

class _WordRowState extends State<WordRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < 5; ++i)
          Padding(
              padding: const EdgeInsets.all(4),
              child: Consumer<Game>(builder: (BuildContext context, Game value, Widget? child) {
                return LetterTile(letter: value.letterAt(widget.rowIndex, i));
              }))
      ],
    );
  }
}
