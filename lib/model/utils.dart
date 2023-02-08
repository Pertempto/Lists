/// Util:
///   - a static class that provides
///     various utilities
class Utils {
  static Iterable<U> mapIndexed<T, U>(
      Iterable<T> iterable, U Function(int, T) toElement) sync* {
    int index = 0;
    for (final element in iterable) {
      yield toElement(index++, element);
    }
  }
}
