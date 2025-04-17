class BottomNavRoute {
  List<int> _indexStack = [0];
  List<int> get indexStack => _indexStack;
  int get currentIndex => _indexStack.last;

  final int _maxIndexLength = 5;
  void push(int index) {
    if (currentIndex != index) {
      final lastNItems =
          _indexStack.reversed.take(_maxIndexLength - 1).toList().reversed;
      _indexStack = [...lastNItems, index];
    }
  }

  bool pop() {
    if (_indexStack.length > 1) {
      _indexStack = [..._indexStack..removeLast()];
      return true;
    }
    return false;
  }

  void reset() {
    _indexStack = [0];
  }
}
