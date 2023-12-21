import 'dart:math';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workee/constants/colors.dart';
import 'package:workee/constants/table_names.dart';
import 'package:workee/models/department_model.dart';
import 'package:workee/models/user_model.dart';
import 'package:workee/utils/utils.dart';

class DatabaseServices extends ChangeNotifier {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  UserModel? userModel;
  List<DepartmentModel> departmentList = [];
  int? employeeDepartmentId;

  String generatedRandomEmployeeId() {
    final random = Random();
    const allChars = 'workeeWORKEE1234567890';
    final randomString = List.generate(8, (index) => allChars[random.nextInt(allChars.length)]).join();
    return randomString;
  }

  //insert new user data
  Future<void> insertNewUserData({
    required String email,
    required String id,
  }) async {
    await _supabaseClient.from(TableNames.employeeTable).insert([
      {
        'id': id,
        'email': email,
        'name': '',
        'department': null,
        'employee_id': generatedRandomEmployeeId(),
      }
    ]);
  }

  // return user data
  Future<UserModel> getUserData() async {
    final response = await _supabaseClient
        .from(TableNames.employeeTable)
        .select()
        .eq('id', _supabaseClient.auth.currentUser!.id)
        .single();
    userModel = UserModel.fromMap(response);

    //since this function can be called multiple times, then will reset the department value
    // thats why we use condition to check if the department value is null or not
    employeeDepartmentId == null ? employeeDepartmentId = userModel!.department : null;
    return userModel!;
  }

  // get all department
  Future<void> getAllDepartment() async {
    final response = await _supabaseClient.from(TableNames.departmentTable).select();

    departmentList = response.map((department) => DepartmentModel.fromMap(department)).toList();
    notifyListeners();
  }

  // update user data
  Future<void> updateProfile({required String name, required BuildContext context}) async {
    await _supabaseClient.from(TableNames.employeeTable).update({
      'name': name,
      'department': employeeDepartmentId,
    }).eq('id', _supabaseClient.auth.currentUser!.id);

    Utils.showSnackBar(context, 'Profile updated', color: AppColors.thirdColor);
    notifyListeners();
  }
}
