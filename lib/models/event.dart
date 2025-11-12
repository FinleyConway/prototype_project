/// @Created on: 4/11/25
/// @Author: Finley Conway

enum EventRepeatType {
  never,
  daily,
  weekly,
  monthly,
  yearly
}

class Event {
  final String title;
  final String message;
  final bool isAllDay;
  final EventRepeatType repeatType;
  final DateTime reminderTime;

  Event({
    required this.title, 
    required this.message, 
    required this.isAllDay, 
    required this.repeatType, 
    required this.reminderTime
  });

  bool occursOn(DateTime day) {
    if (reminderTime.isAtSameMomentAs(day)) return true;
    if (day.isBefore(reminderTime)) return false; // prevents setting events in the past

    switch (repeatType) {
      case EventRepeatType.daily: return true;
      case EventRepeatType.weekly: return day.weekday == reminderTime.weekday;
      case EventRepeatType.monthly: return day.day == reminderTime.day;
      case EventRepeatType.yearly: return day.month == reminderTime.month && day.day == reminderTime.day; 
      case EventRepeatType.never: return false;
    }
  }

  @override
  bool operator ==(covariant Event other) {
    return 
      title == other.title &&
      message == other.message &&
      isAllDay == other.isAllDay &&
      repeatType == other.repeatType &&
      reminderTime == other.reminderTime;
  }

  @override
  int get hashCode => Object.hash(
    title,
    message,
    isAllDay,
    repeatType,
    reminderTime,
  );
}