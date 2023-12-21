import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:workee/constants/colors.dart';
import 'package:workee/models/user_model.dart';
import 'package:workee/services/attendance_service.dart';
import 'package:workee/services/database_services.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final GlobalKey<SlideActionState> _slideActionKey = GlobalKey<SlideActionState>();

  @override
  void initState() {
    Provider.of<AttendanceServices>(context, listen: false).getTodayAttendance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 32),
              child: const Text(
                "Welcome",
                style: TextStyle(color: AppColors.textColorDark, fontSize: 30),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Consumer<DatabaseServices>(builder: (context, databaseServices, child) {
                return FutureBuilder<UserModel>(
                    future: databaseServices.getUserData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final userData = snapshot.data!;

                        return Text(
                          userData.name != '' ? userData.name : '#${userData.employeeId}',
                          style: const TextStyle(color: AppColors.textColorDark, fontSize: 24),
                        );
                      }

                      return const SizedBox(
                        width: 60,
                        child: LinearProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    });
              }),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 32),
              child: const Text(
                "Today's Status",
                style: TextStyle(color: AppColors.textColorDark, fontSize: 20),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 32),
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38.withOpacity(0.3),
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
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Clock In",
                        style: TextStyle(color: AppColors.textColorDark, fontSize: 20),
                      ),
                      const SizedBox(width: 80, child: Divider()),
                      Consumer<AttendanceServices>(builder: (context, attendanceServices, child) {
                        return Text(
                          attendanceServices.attendanceModel?.clockIn ?? "--:--",
                          style: const TextStyle(color: AppColors.textColorDark, fontSize: 24),
                        );
                      }),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Clock out",
                        style: TextStyle(color: AppColors.textColorDark, fontSize: 20),
                      ),
                      const SizedBox(width: 80, child: Divider()),
                      Consumer<AttendanceServices>(builder: (context, attendanceServices, child) {
                        return Text(
                          attendanceServices.attendanceModel?.clockOut ?? "--:--",
                          style: const TextStyle(color: AppColors.textColorDark, fontSize: 24),
                        );
                      }),
                    ],
                  ))
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                DateFormat('dd MMMM yyyy').format(DateTime.now()),
                style: const TextStyle(color: Colors.black38, fontSize: 14),
              ),
            ),
            StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DateFormat('kk:mm:ss a').format(DateTime.now()),
                      style: const TextStyle(color: AppColors.textColorDark, fontSize: 14),
                    ),
                  );
                }),
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: Builder(
                  builder: (context) => Consumer<AttendanceServices>(builder: (context, attendanceServices, child) {
                        return SlideAction(
                          key: _slideActionKey,
                          text: attendanceServices.attendanceModel?.clockIn == null
                              ? 'Slide to Clock In'
                              : 'Slide to Clock Out',
                          textStyle: const TextStyle(
                            color: AppColors.textColorDark,
                            fontSize: 20,
                          ),
                          outerColor: AppColors.primaryColor,
                          innerColor: AppColors.thirdColor,
                          onSubmit: () async {
                            await attendanceServices.markAttendance(context);
                            _slideActionKey.currentState!.reset();

                            return null;
                          },
                        );
                      })),
            )
          ],
        ),
      ),
    );
  }
}
