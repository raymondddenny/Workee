import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:workee/constants/colors.dart';
import 'package:workee/pages/attendance_page.dart';
import 'package:workee/pages/calendar_page.dart';
import 'package:workee/pages/profile_page.dart';
import 'package:workee/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<IconData> navigationIcons = [
    FontAwesomeIcons.solidCalendarDays,
    FontAwesomeIcons.check,
    FontAwesomeIcons.solidUser,
  ];

  int currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          CalendarPage(),
          AttendancePage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.only(left: 12, bottom: 24, right: 12),
        decoration: BoxDecoration(
          color: AppColors.secondaryColor,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondaryColor.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: navigationIcons
              .map((bottomNavIcon) => Expanded(
                      child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = navigationIcons.indexOf(bottomNavIcon);
                      });
                    },
                    child: Center(
                      child: FaIcon(
                        bottomNavIcon,
                        color: currentIndex == navigationIcons.indexOf(bottomNavIcon)
                            ? AppColors.thirdColor
                            : AppColors.primaryColor,
                        size: currentIndex == navigationIcons.indexOf(bottomNavIcon) ? 30 : 25,
                      ),
                    ),
                  )))
              .toList(),
        ),
      ),
    );
  }
}
