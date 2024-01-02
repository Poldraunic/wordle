import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordle/game/game.dart';
import 'package:wordle/ui/board.dart';
import 'package:wordle/ui/keyboard.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Game game;

  void handleKey(LogicalKeyboardKey key) {
    switch (key) {
      case LogicalKeyboardKey.backspace:
        game.popLetter();
      case LogicalKeyboardKey.enter || LogicalKeyboardKey.numpadEnter:
        game.submit();
      default:
        String letter = key.keyLabel;
        if (letter.length == 1 && letter.contains(RegExp("[a-zA-Z]"))) {
          game.pushLetter(letter);
        }
    }
  }

  @override
  void initState() {
    super.initState();

    game = Game();
    game.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    game.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xff121213),
        child: Column(children: [
          Expanded(
            child: Board(game: game, onTap: handleKey),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Keyboard(game: game, onTap: handleKey),
          ),
        ]));
  }
}
