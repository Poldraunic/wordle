import 'dart:math' as math;

import 'package:characters/characters.dart';
import 'package:flutter/foundation.dart';
import 'package:wordle/game/letter.dart';
import 'package:wordle/game/words.dart';

typedef WordMatchResult = List<Letter>;

enum SubmitResult {
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
  bool _finished = false;

  int get attempts => _attempts;

  int get currentAttempt => _currentAttempt;

  String get currentWord => _currentWord;

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
    if (_finished) {
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

    print("push: $letter");
    notifyListeners();
  }

  void pushLetters(String letters) {
    if (_finished) {
      return;
    }

    for (var letter in letters.characters) {
      pushLetter(letter);
    }
  }

  void popLetter() {
    if (_finished) {
      return;
    }

    _currentWord = _currentWord.substring(0, math.max(0, _currentWord.length - 1));
    print("(pop)");
    notifyListeners();
  }

  SubmitResult submit() {
    if (_finished) {
      return SubmitResult.win;
    }

    if (_currentWord.length < 5) {
      return SubmitResult.notEnoughLetters;
    }

    if (_currentWord == _secretWord) {
      _finished = true;
      _saveCurrentWord();
      notifyListeners();
      return SubmitResult.win;
    }

    if (_currentAttempt == _attempts) {
      print("Your word was $_secretWord");

      _finished = true;
      _saveCurrentWord();
      notifyListeners();
      return SubmitResult.lose;
    }

    if (!_isCurrentWordValid()) {
      notifyListeners();
      return SubmitResult.noSuchWord;
    }

    _saveCurrentWord();
    notifyListeners();
    return SubmitResult.incorrectWord;
  }

  void restart() {
    _attempts = 6;
    _currentAttempt = 1;
    _currentWord = "";
    _secretWord = "";
    _guesses = [];
    _finished = false;
    _usedLetters = {};
  }

  WordMatchResult? lastGuessLetterMatchResult() {
    return _guesses.lastOrNull;
  }

  bool _isCurrentWordValid() {
    return answers.contains(_currentWord.toLowerCase()) || acceptableWords.contains(_currentWord.toLowerCase());
  }

  void _saveCurrentWord() {
    WordMatchResult wordMatch = WordMatchResult.filled(5, const Letter.empty(), growable: false);

    for (int i = 0; i < 5; ++i) {
      String character = _currentWord[i];
      LetterMatch letterMatch = LetterMatch.noMatch;

      if (character == _secretWord[i]) {
        letterMatch = LetterMatch.fullMatch;
      } else if (_secretWord.contains(character)) {
        letterMatch = LetterMatch.partialMatch;
      }

      wordMatch[i] = Letter(character, letterMatch);
      _usedLetters[character] = letterMatch;
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
}
