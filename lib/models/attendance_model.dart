class AttendanceModel {
  final int id;
  final String date;
  final String clockIn;
  final String? clockOut;
  final DateTime createdAt;
  final Map? checkInLocation;
  final Map? checkOutLocation;

  AttendanceModel({
    required this.id,
    required this.date,
    required this.clockIn,
    this.clockOut,
    required this.createdAt,
    required this.checkInLocation,
    required this.checkOutLocation,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date,
      'clock_in': clockIn,
      'clock_out': clockOut,
      'created_at': createdAt.toIso8601String(),
      'check_in_location': checkInLocation,
      'check_out_location': checkOutLocation,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
        id: map['id'] as int,
        date: map['date'] as String,
        clockIn: map['clock_in'] as String,
        clockOut: map['clock_out'] != null ? map['clock_out'] as String : null,
        createdAt: DateTime.parse(map['created_at'] as String),
        checkInLocation: map['clock_in_location'],
        checkOutLocation: map['clock_out_location']);
  }
}
