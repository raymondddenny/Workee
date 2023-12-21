import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_month_year_picker/simple_month_year_picker.dart';
import 'package:workee/constants/colors.dart';
import 'package:workee/models/attendance_model.dart';
import 'package:workee/services/attendance_service.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 60, left: 20, bottom: 10),
            child: const Text(
              'My Attendances',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Consumer<AttendanceServices>(builder: (context, attendanceServices, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  attendanceServices.attendanceHistoryMonth,
                  style: const TextStyle(fontSize: 24),
                ),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.thirdColor),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    onPressed: () async {
                      // disableFurure: true to disable future month or year
                      final selectedDate = await SimpleMonthYearPicker.showMonthYearPickerDialog(
                        context: context,
                        disableFuture: true,
                        selectionColor: AppColors.thirdColor,
                        titleTextStyle: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      );

                      String pickedMonth = DateFormat('MMMM yyyy').format(selectedDate);
                      attendanceServices.setAttendanceHistoryMonth = pickedMonth;

                      // get attendance history
                      // await attendanceServices.getAttendanceHistory();
                    },
                    child: const Text('Pick a month', style: TextStyle(fontSize: 18, color: AppColors.thirdColor)))
              ],
            );
          }),
          Expanded(child: Consumer<AttendanceServices>(builder: (context, attendanceServices, child) {
            return FutureBuilder(
                future: attendanceServices.getAttendanceHistory(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return const Center(child: Text('No attendance history'));
                    }

                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final AttendanceModel attendanceModel = snapshot.data![index];
                          return Container(
                            margin: const EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 10),
                            height: 150,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.secondaryColor.withOpacity(0.5),
                                  blurRadius: 10,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Container(
                                  margin: const EdgeInsets.only(),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.thirdColor.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      DateFormat('EE \n dd').format(attendanceModel.createdAt),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: AppColors.textColorLight,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Clock In',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors.textColorDark,
                                      ),
                                    ),
                                    Text(
                                      attendanceModel.clockIn ?? '--/--',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        color: AppColors.textColorDark,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Clock Out',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors.textColorDark,
                                      ),
                                    ),
                                    Text(
                                      attendanceModel.clockOut ?? '--/--',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        color: AppColors.textColorDark,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          );
                        });
                  }

                  return const LinearProgressIndicator();
                });
          }))
        ],
      ),
    );
  }
}
