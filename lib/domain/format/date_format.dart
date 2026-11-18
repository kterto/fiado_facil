const Duration _recifeUtcOffset = Duration(hours: 3);

String formatDateRecife(DateTime instant) {
  return '${formatDayMonthRecife(instant)}/${_recifeWallTime(instant).year}';
}

String formatDayMonthRecife(DateTime instant) {
  final wall = _recifeWallTime(instant);
  return '${_twoDigits(wall.day)}/${_twoDigits(wall.month)}';
}

DateTime _recifeWallTime(DateTime instant) =>
    instant.toUtc().subtract(_recifeUtcOffset);

String _twoDigits(int value) => value.toString().padLeft(2, '0');
