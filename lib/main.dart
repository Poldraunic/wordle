import 'package:flutter/material.dart';
import 'package:wordle/ui/game_screen.dart';

void main() {
  runApp(const WordleApp());
}

class WordleApp extends StatelessWidget {
  const WordleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowMaterialGrid: false,
      home: Material(child: GameScreen()),
    );
  }
}
