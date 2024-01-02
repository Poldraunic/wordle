enum LetterMatch {
  noMatch,
  partialMatch,
  fullMatch,
}

class Letter {
  const Letter.empty()
      : _character = "",
        _matchResult = null;

  const Letter.unmatched(String character)
      : _character = character,
        _matchResult = null;

  const Letter(String character, LetterMatch matchResult)
      : _character = character,
        _matchResult = matchResult;

  final String _character;
  final LetterMatch? _matchResult;

  String get character => _character;

  LetterMatch? get matchResult => _matchResult;

  bool get isEmpty => _character.isEmpty;

  bool get isNotEmpty => _character.isNotEmpty;
}
