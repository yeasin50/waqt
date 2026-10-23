class UserPreference {
  const UserPreference({required this.enableDoubleTapLock});

  final bool enableDoubleTapLock;

  static const UserPreference empty = UserPreference(
    enableDoubleTapLock: false,
  );

  UserPreference copyWith({bool? enableDoubleTapLock}) {
    return UserPreference(
      enableDoubleTapLock: enableDoubleTapLock ?? this.enableDoubleTapLock,
    );
  }

  @override
  String toString() {
    return "UserPreference(enableDoubleTapLock:$enableDoubleTapLock)";
  }
}
