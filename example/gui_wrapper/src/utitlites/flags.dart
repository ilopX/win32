class Flags {
  Flags({
    required int initFlags
  }) : _flags = initFlags;

  int _flags;
  int get flags => _flags;

  // ignore: avoid_positional_boolean_parameters
  void addOrRemoveFlagIf(int newFlag, bool expression) {
    if (expression) {
      _flags |= newFlag;
    } else {
      _flags ^= newFlag;
    }
  }

  void addOrRemoveFlags(Map<int, bool> flagsExpressionMap) {
    for(final entry in flagsExpressionMap.entries)  {
      addOrRemoveFlagIf(entry.key, entry.value);
    }
  }
}
