class DiagnosticEvent {
  const DiagnosticEvent({
    required this.at,
    required this.level,
    required this.message,
  });

  final DateTime at;
  final String level;
  final String message;

  String get timeLabel {
    final String h = at.hour.toString().padLeft(2, '0');
    final String m = at.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
