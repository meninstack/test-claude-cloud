/// Returns the current time. Injected so tests can control the date.
typedef Clock = DateTime Function();

/// Calendar day in local time, formatted as `yyyy-MM-dd`.
///
/// Progress is stored against this key, so a new key means a new day and a
/// fresh board.
String dateKey(DateTime time) {
  final y = time.year.toString().padLeft(4, '0');
  final m = time.month.toString().padLeft(2, '0');
  final d = time.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}
