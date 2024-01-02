import 'dart:async';
import 'dart:math' as math;

import 'package:characters/characters.dart';
import 'package:flutter/foundation.dart';
import 'package:wordle/extensions/string_extensions.dart';
import 'package:wordle/game/letter.dart';
import 'package:wordle/game/words.dart';

typedef WordMatchResult = List<Letter>;

enum GameState {
  inProgress,
  notEnoughLetters,
  noSuchWord,
  incorrectWord,
  lose,
  win,
}

class Game extends ChangeNotifier {
  late int _attempts;
  late int _currentAttempt;
  late String _secretWord;
  late List<WordMatchResult> _guesses;
  late String _currentWord;
  late Map<String, LetterMatch> _usedLetters;
  late GameState _state;

  int get attempts => _attempts;

  int get currentAttempt => _currentAttempt;

  String get currentWord => _currentWord;

  GameState get state => _state;

  Game() {
    restart();
    _randomizeSecretWord();
  }

  Game.withSecretWord(String secretWord) {
    restart();
    _setSecretWord(secretWord);
  }

  Letter letterAt(int i, int j) {
    if (i == _currentAttempt - 1) {
      String? character = _currentWord.characters.elementAtOrNull(j);
      return character == null ? const Letter.empty() : Letter.unmatched(character);
    }

    return _guesses.elementAtOrNull(i)?.elementAt(j) ?? const Letter.empty();
  }

  LetterMatch? matchForLetter(String letter) {
    return _usedLetters[letter];
  }

  void pushLetter(String letter) {
    if (_isFinished()) {
      return;
    }

    if (_currentWord.length == 5) {
      print("letter limit reached");
      return;
    }

    assert(letter.isNotEmpty);
    assert(letter.length == 1);
    assert(letter.contains(RegExp("\\w")));

    _currentWord += letter.toUpperCase();

    notifyListeners();
  }

  void pushLetters(String letters) {
    if (_isFinished()) {
      return;
    }

    for (var letter in letters.characters) {
      pushLetter(letter);
    }
  }

  void popLetter() {
    if (_isFinished()) {
      return;
    }

    _currentWord = _currentWord.substring(0, math.max(0, _currentWord.length - 1));
    notifyListeners();
  }

  void submit() {
    if (_isFinished()) {
      return;
    }

    // We need to call notifyListeners() function on all paths.
    scheduleMicrotask(() {
      notifyListeners();
    });

    // TODO: Is there a better way to do all these checks?
    if (_currentWord.length < 5) {
      _state = GameState.notEnoughLetters;
      return;
    }

    if (_currentWord == _secretWord) {
      _saveCurrentWord();
      _state = GameState.win;
      return;
    }

    if (_currentAttempt == _attempts) {
      print("Your word was \"$_secretWord\"");
      _state = GameState.lose;
      _saveCurrentWord();
      return;
    }

    if (!_isCurrentWordValid()) {
      _state = GameState.noSuchWord;
      return;
    }

    _state = GameState.incorrectWord;
    _saveCurrentWord();
  }

  void restart() {
    _attempts = 6;
    _currentAttempt = 1;
    _currentWord = "";
    _secretWord = "";
    _guesses = [];
    _usedLetters = {};
    _state = GameState.inProgress;
  }

  WordMatchResult? lastGuessLetterMatchResult() {
    return _guesses.lastOrNull;
  }

  bool _isCurrentWordValid() {
    return answers.contains(_currentWord.toLowerCase()) || acceptableWords.contains(_currentWord.toLowerCase());
  }

  void _saveCurrentWord() {
    WordMatchResult wordMatch = WordMatchResult.filled(5, const Letter.empty(), growable: false);
    String secretWord = _secretWord;

    for (int i = 0; i < secretWord.length; ++i) {
      String character = _currentWord[i];
      LetterMatch letterMatch = LetterMatch.noMatch;
      int? indexToMask;

      if (character == secretWord[i]) {
        letterMatch = LetterMatch.fullMatch;
        indexToMask = i;
      } else {
        final int index = secretWord.indexOf(character);
        if (index != -1) {
          letterMatch = LetterMatch.partialMatch;
          indexToMask = index;
        }
      }

      // Use this to mask already processed characters. This ensures that if, for example,
      // user guess has same letter twice (or more), but secret has it only once, we will flag it only
      // once as well.
      if (indexToMask != null) {
        secretWord = secretWord.replaceAt(indexToMask, "_");
      }

      wordMatch[i] = Letter(character, letterMatch);

      _usedLetters.update(character, (value) => letterMatch.index > value.index ? letterMatch : value,
          ifAbsent: () => letterMatch);
    }

    _guesses.add(wordMatch);
    _currentWord = "";
    _currentAttempt++;
  }

  void _setSecretWord(String word) {
    assert(word.length == 5);
    _secretWord = word.toUpperCase();
  }

  void _randomizeSecretWord() {
    _secretWord = answers.elementAt(math.Random().nextInt(answers.length)).toUpperCase();
  }

  bool _isFinished() {
    return _state == GameState.win || _state == GameState.lose;
  }
}
