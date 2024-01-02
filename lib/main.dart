import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordle/game/game.dart';
import 'package:wordle/ui/game_screen.dart';

void main() {
  runApp(const WordleApp());
}

class WordleApp extends StatelessWidget {
  const WordleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowMaterialGrid: false,
      home: Scaffold(
        body: ChangeNotifierProvider<Game>(
          create: (_) => Game(),
          builder: (BuildContext context, Widget? child) {
            return const GameScreen();
          },
        ),
      ),
    );
  }
}
