import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wordle/game/game.dart';
import 'package:wordle/ui/board.dart';
import 'package:wordle/ui/keyboard.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  void handleKey(LogicalKeyboardKey key) {
    switch (key) {
      case LogicalKeyboardKey.backspace:
        context.read<Game>().popLetter();
      case LogicalKeyboardKey.enter || LogicalKeyboardKey.numpadEnter:
        context.read<Game>().submit();
      default:
        String letter = key.keyLabel;
        if (letter.length == 1 && letter.contains(RegExp("[a-zA-Z]"))) {
          context.read<Game>().pushLetter(letter);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xff121213),
        child: Column(children: [
          Expanded(
            child: Board(onTap: handleKey),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Keyboard(onTap: handleKey),
          ),
        ]));
  }
}
