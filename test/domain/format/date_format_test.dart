import 'package:fiado_facil/domain/format/date_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatDateRecife', () {
    test('02:00 UTC is still the previous day in Recife', () {
      expect(formatDateRecife(DateTime.utc(2026, 11, 18, 2, 0)), '17/11/2026');
    });

    test('03:00 UTC is midnight in Recife', () {
      expect(formatDateRecife(DateTime.utc(2026, 11, 18, 3, 0)), '18/11/2026');
    });

    test('zero-pads day and month', () {
      expect(formatDateRecife(DateTime.utc(2026, 3, 5, 12)), '05/03/2026');
    });

    test('a local DateTime gives the same result as its UTC equivalent', () {
      final utc = DateTime.utc(2026, 11, 18, 2, 30);
      final local = utc.toLocal();

      expect(local.isUtc, isFalse);
      expect(formatDateRecife(local), formatDateRecife(utc));
    });
  });

  group('formatDayMonthRecife', () {
    test('crosses back into the previous year before 03:00 UTC', () {
      expect(formatDayMonthRecife(DateTime.utc(2026, 1, 1, 2, 59)), '31/12');
    });

    test('zero-pads day and month', () {
      expect(formatDayMonthRecife(DateTime.utc(2026, 3, 5, 12)), '05/03');
    });

    test('a local DateTime gives the same result as its UTC equivalent', () {
      final utc = DateTime.utc(2026, 1, 1, 2, 59);

      expect(formatDayMonthRecife(utc.toLocal()), formatDayMonthRecife(utc));
    });
  });

  group('host time zone independence', () {
    final start = DateTime.utc(2026, 11, 17);
    final instants = <DateTime>[
      for (var minutes = 0; minutes < 48 * 60; minutes += 30)
        start.add(Duration(minutes: minutes)),
    ];

    test('every half hour across two days, local equals UTC', () {
      for (final utc in instants) {
        final local = utc.toLocal();
        expect(
          formatDateRecife(local),
          formatDateRecife(utc),
          reason: 'formatDateRecife at $utc',
        );
        expect(
          formatDayMonthRecife(local),
          formatDayMonthRecife(utc),
          reason: 'formatDayMonthRecife at $utc',
        );
      }
    });
  });
}
