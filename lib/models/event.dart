/// @Created on: 4/11/25
/// @Author: Finley Conway

enum EventRepeatType {
  never,
  daily,
  weekly,
  monthly,
  yearly
}

enum EventType {
  appointments,
  medications,
  routine
}

class Event {
  final String title;
  final String location;
  final EventRepeatType repeatType;
  final EventType eventType;
  final DateTime reminderTime;
  final String notes;
  final bool completed;

  Event({
    required this.title, 
    required this.location,
    required this.repeatType, 
    required this.eventType,
    required this.reminderTime,
    required this.notes,
    required this.completed
  });

  bool occursOn(DateTime day) {
    // strip date to ignore time
    final DateTime eventDate = DateTime(reminderTime.year, reminderTime.month, reminderTime.day);
    final DateTime targetDate = DateTime(day.year, day.month, day.day);

    if (eventDate == targetDate) return true;
    if (targetDate.isBefore(eventDate)) return false; // prevents setting events in the past

    switch (repeatType) {
      case EventRepeatType.daily: return true;
      case EventRepeatType.weekly: return targetDate.weekday == eventDate.weekday;
      case EventRepeatType.monthly: return targetDate.day == eventDate.day;
      case EventRepeatType.yearly: return targetDate.month == eventDate.month && targetDate.day == eventDate.day; 
      case EventRepeatType.never: return false;
    }
  }

  @override
  bool operator ==(covariant Event other) {
    return 
      title == other.title &&
      location == other.location &&
      notes == other.notes &&
      repeatType == other.repeatType &&
      reminderTime == other.reminderTime &&
      completed == other.completed;
  }

  @override
  int get hashCode => Object.hash(
    title,
    location,
    notes,
    repeatType,
    reminderTime,
    completed
  );
}