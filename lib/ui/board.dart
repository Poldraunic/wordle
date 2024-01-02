import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:wordle/game/game.dart';
import 'package:wordle/ui/common.dart';
import 'package:wordle/ui/word_row.dart';

class Board extends StatefulWidget {
  const Board({super.key, required this.game, required this.onTap});

  final Game game;
  final KeyboardCallback onTap;

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
        focusNode: focusNode,
        autofocus: true,
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent) {
            widget.onTap(event.logicalKey);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [for (int i = 0; i < 6; ++i) WordRow(rowIndex: i, game: widget.game)],
        ));
  }
}
