import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workee/constants/table_names.dart';
import 'package:workee/models/attendance_model.dart';
import 'package:workee/services/location_service.dart';
import 'package:workee/utils/utils.dart';

class AttendanceServices extends ChangeNotifier {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  AttendanceModel? attendanceModel;

  String todayDate = DateFormat('dd MMMM yyyy').format(DateTime.now());

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // to get attendance history
  String _attendanceHistoryMonth = DateFormat('MMMM yyyy').format(DateTime.now());

  String get attendanceHistoryMonth => _attendanceHistoryMonth;

  set setAttendanceHistoryMonth(String value) {
    _attendanceHistoryMonth = value;
    notifyListeners();
  }

  // get today attendace
  Future<void> getTodayAttendance() async {
    final List attendanceResults = await _supabaseClient
        .from(TableNames.attendanceTable)
        .select()
        .eq('employee_id', _supabaseClient.auth.currentUser!.id)
        .eq('date', todayDate);

    if (attendanceResults.isNotEmpty) {
      attendanceModel = AttendanceModel.fromMap(attendanceResults.first);
    }
    notifyListeners();
  }

  // clock in attendance
  Future<void> markAttendance(BuildContext context) async {
    // only allow mark attendance if get location permission
    Map? getLocation = await LocationService().initializeAndGetLocation(context);

    if (getLocation == null) {
      return;
    }

    if (attendanceModel?.clockIn == null) {
      await _supabaseClient.from(TableNames.attendanceTable).insert([
        {
          'employee_id': _supabaseClient.auth.currentUser!.id,
          'date': todayDate,
          'clock_in': DateFormat('HH:mm').format(DateTime.now()),
          'clock_in_location': getLocation,
        }
      ]);
    } else if (attendanceModel?.clockOut == null) {
      await _supabaseClient
          .from(TableNames.attendanceTable)
          .update({
            'clock_out': DateFormat('HH:mm').format(DateTime.now()),
            'clock_out_location': getLocation,
          })
          .eq('employee_id', _supabaseClient.auth.currentUser!.id)
          .eq('date', todayDate);
    } else {
      Utils.showSnackBar(context, 'You have clocked in and out today!');
    }

    // update today attendance data
    await getTodayAttendance();
  }

  // get attendance history
  Future<List<AttendanceModel>> getAttendanceHistory() async {
    final List<AttendanceModel> attendanceHistory = [];
    final List attendanceResults = await _supabaseClient
        .from(TableNames.attendanceTable)
        .select()
        .eq('employee_id', _supabaseClient.auth.currentUser!.id)
        .ilike('date', '%$_attendanceHistoryMonth%')
        .order('created_at', ascending: false);

    for (final attendance in attendanceResults) {
      attendanceHistory.add(AttendanceModel.fromMap(attendance));
    }

    return attendanceHistory;
  }
}
