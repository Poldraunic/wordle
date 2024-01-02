import 'package:test/test.dart';
import 'package:wordle/game/game.dart';
import 'package:wordle/game/letter.dart';

void main() {
  test('Submit with less letters than required', () {
    var vm = Game();

    vm.pushLetters('XXXX');
    expect(vm.submit(), SubmitResult.notEnoughLetters);

    vm.pushLetter('X');
    expect(vm.submit(), isNot(SubmitResult.notEnoughLetters));
  });

  test('Submit with incorrect word', () {
    var vm = Game.withSecretWord("hello");
    vm.pushLetters("color");
    expect(vm.submit(), SubmitResult.incorrectWord);
  });

  test('Exhaust all attempts', () {
    var vm = Game.withSecretWord("hello");
    for (int i = vm.currentAttempt; i < vm.attempts; ++i) {
      vm.pushLetters("color");
      expect(vm.currentAttempt, i);
      expect(vm.submit(), SubmitResult.incorrectWord);
    }
    vm.pushLetters("color");
    expect(vm.currentAttempt, vm.attempts);
    expect(vm.submit(), SubmitResult.lose);
  });

  test('Clean-up current word after submit', () {
    var vm = Game.withSecretWord("hello");
    vm.pushLetters("color");
    expect(vm.submit(), SubmitResult.incorrectWord);
    expect(vm.currentWord, isEmpty);
    expect(vm.submit(), SubmitResult.notEnoughLetters);
  });

  test('Pop letters', () {
    var vm = Game.withSecretWord("hello");
    expect(vm.currentWord, isEmpty);

    vm.pushLetters("color");
    expect(vm.currentWord, "COLOR");

    vm.popLetter();
    expect(vm.currentWord, "COLO");

    vm.popLetter();
    expect(vm.currentWord, "COL");

    vm.popLetter();
    expect(vm.currentWord, "CO");

    vm.popLetter();
    expect(vm.currentWord, "C");

    vm.popLetter();
    expect(vm.currentWord, isEmpty);
  });

  test('Letter guess matrix', () {
    var vm = Game.withSecretWord("HELLO");

    expect(vm.lastGuessLetterMatchResult(), isNull);

    vm.pushLetters("COLOR");
    expect(vm.submit(), SubmitResult.incorrectWord);

    WordMatchResult? matchResult = vm.lastGuessLetterMatchResult();
    expect(matchResult, isNotNull);

    expect(matchResult![0].matchResult, LetterMatch.noMatch);
    expect(matchResult[1].matchResult, LetterMatch.partialMatch);
    expect(matchResult[2].matchResult, LetterMatch.fullMatch);
    expect(matchResult[3].matchResult, LetterMatch.partialMatch);
    expect(matchResult[4].matchResult, LetterMatch.noMatch);
  });
}
