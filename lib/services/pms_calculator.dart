import 'package:claymore/models/trg_event.dart';
import 'package:claymore/models/user.dart';

bool pmsCurrent(User user, List<TrgEvent> trgEvents) {
  final events = trgEvents
      .where((te) => te.trgJtacID == user.id)
      .where(
        (te) =>
            te.trgDetails.contains('PMS Course') ||
            te.trgDetails.contains('6 point drop') ||
            te.trgDetails.contains('12 point drop'),
      )
      .toList()
    ..sort((a, b) => a.trgDate.compareTo(b.trgDate));

  if (events.isEmpty) return false;

  final now = DateTime.now();

  String expectedNext = 'PMS Course';
  DateTime? deadline;

  for (final event in events) {
    if (deadline != null && event.trgDate.isAfter(deadline)) {
      return false;
    }

    if (!event.trgDetails.contains(expectedNext)) {
      continue;
    }

    deadline = DateTime(
      event.trgDate.year,
      event.trgDate.month + 6,
      event.trgDate.day,
    );

    expectedNext = switch (expectedNext) {
      'PMS Course' => '6 point drop',
      '6 point drop' => '12 point drop',
      '12 point drop' => '6 point drop',
      _ => 'PMS Course',
    };
  }

  if (deadline == null) return false;

  return now.isBefore(deadline) || now.isAtSameMomentAs(deadline);
}