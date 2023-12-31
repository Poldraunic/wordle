import 'package:test/test.dart';
import 'package:wordle/game/game.dart';
import 'package:wordle/game/letter.dart';

void main() {
  test('Submit with less letters than required', () {
    var game = Game();

    game.pushLetters('XXXX');
    game.submit();
    expect(game.state, GameState.notEnoughLetters);

    game.pushLetter('X');
    game.submit();
    expect(game.state, isNot(GameState.notEnoughLetters));
  });

  test('Submit with incorrect word', () {
    var game = Game.withSecretWord("hello");
    game.pushLetters("color");
    game.submit();
    expect(game.state, GameState.incorrectWord);
  });

  test('Exhaust all attempts', () {
    var game = Game.withSecretWord("hello");
    for (int i = game.currentAttempt; i < game.attempts; ++i) {
      game.pushLetters("color");
      expect(game.currentAttempt, i);
      game.submit();
      expect(game.state, GameState.incorrectWord);
    }
    game.pushLetters("color");
    expect(game.currentAttempt, game.attempts);
    game.submit();
    expect(game.state, GameState.lose);
  });

  test('Clean-up current word after submit', () {
    var game = Game.withSecretWord("hello");
    game.pushLetters("color");
    game.submit();
    expect(game.state, GameState.incorrectWord);
    expect(game.currentWord, isEmpty);
    game.submit();
    expect(game.state, GameState.notEnoughLetters);
  });

  test('Pop letters', () {
    var game = Game.withSecretWord("hello");
    expect(game.currentWord, isEmpty);

    game.pushLetters("color");
    expect(game.currentWord, "COLOR");

    game.popLetter();
    expect(game.currentWord, "COLO");

    game.popLetter();
    expect(game.currentWord, "COL");

    game.popLetter();
    expect(game.currentWord, "CO");

    game.popLetter();
    expect(game.currentWord, "C");

    game.popLetter();
    expect(game.currentWord, isEmpty);
  });

  test('Word match', () {
    var game = Game.withSecretWord("HELLO");

    expect(game.lastGuessLetterMatchResult(), isNull);

    game.pushLetters("POLAR");
    game.submit();
    expect(game.state, GameState.incorrectWord);

    WordMatchResult? matchResult = game.lastGuessLetterMatchResult();
    expect(matchResult, isNotNull);

    expect(matchResult![0].matchResult, LetterMatch.noMatch);
    expect(matchResult[1].matchResult, LetterMatch.partialMatch);
    expect(matchResult[2].matchResult, LetterMatch.fullMatch);
    expect(matchResult[3].matchResult, LetterMatch.noMatch);
    expect(matchResult[4].matchResult, LetterMatch.noMatch);
  });

  test("Word match with repeating letters", () {
    // This case features only 1 letter 'A' in a secret.
    var game = Game.withSecretWord("AFTER");

    // For the first attempt, only first 'A' should be counted as a full match,
    // and the second one should have no match.
    game.pushLetters("AWARE");
    game.submit();
    WordMatchResult? match = game.lastGuessLetterMatchResult();
    expect(match, isNotNull);
    expect(match![0].matchResult, LetterMatch.fullMatch);
    expect(match[2].matchResult, LetterMatch.noMatch);

    game.pushLetters("MAFIA");
    game.submit();
    match = game.lastGuessLetterMatchResult();
    expect(match, isNotNull);
    expect(match![1].matchResult, LetterMatch.partialMatch);
    expect(match[4].matchResult, LetterMatch.noMatch);
  });
}
