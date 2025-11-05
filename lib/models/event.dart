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