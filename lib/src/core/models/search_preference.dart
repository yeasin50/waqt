part of 'user_preference.dart';

class SearchConfigs {
  const SearchConfigs({
    this.showSearch = true,
    this.quickSearch = false,
    this.autoShowKeyboard = false,
    this.searchOrder = 'alphabet',
    this.searchAtBottom = true,
  });

  final bool showSearch;

  /// Automatically opens a single matching result.
  final bool quickSearch;
  final bool autoShowKeyboard;

  /// alphabet, reverseAlpha, lastLaunch
  final String searchOrder;
  final bool searchAtBottom;

  SearchConfigs copyWith({
    bool? showSearch,
    bool? quickSearch,
    bool? autoShowKeyboard,
    String? searchOrder,
    bool? searchAtBottom,
  }) {
    return SearchConfigs(
      showSearch: showSearch ?? this.showSearch,
      quickSearch: quickSearch ?? this.quickSearch,
      autoShowKeyboard: autoShowKeyboard ?? this.autoShowKeyboard,
      searchOrder: searchOrder ?? this.searchOrder,
      searchAtBottom: searchAtBottom ?? this.searchAtBottom,
    );
  }

  @override
  String toString() {
    return 'SearchConfigs(showSearch: $showSearch, quickSearch: $quickSearch, autoShowKeyboard: $autoShowKeyboard, searchOrder: $searchOrder, searchAtBottom: $searchAtBottom)';
  }
}
