import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workee/constants/colors.dart';
import 'package:workee/pages/home_page.dart';
import 'package:workee/services/database_services.dart';
import 'package:workee/utils/utils.dart';

class AuthServices extends ChangeNotifier {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final DatabaseServices _databaseServices = DatabaseServices();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // register employee
  Future<void> registerEmployee({
    required String email,
    required String password,
    // required String name,
    required BuildContext context,
  }) async {
    try {
      setIsLoading = true;
      if (email.isEmpty || password.isEmpty) {
        setIsLoading = false;

        throw ('Please fill all fields');
      }

      final AuthResponse registerResponse = await _supabaseClient.auth.signUp(email: email, password: password);

      if (registerResponse.user != null) {
        await _databaseServices.insertNewUserData(id: registerResponse.user!.id, email: email);
        Utils.showSnackBar(context, 'Success registering new account! Enjoy your first day!',
            color: AppColors.textColorDark);
        await loginEmployee(email: email, password: password, context: context);
        Navigator.pop(context);
      }
    } catch (e) {
      Utils.showSnackBar(context, e.toString(), color: AppColors.errorColor);
      setIsLoading = false;
    }
  }

  // login employee
  Future<void> loginEmployee({required String email, required String password, required BuildContext context}) async {
    try {
      setIsLoading = true;
      if (email.isEmpty || password.isEmpty) {
        setIsLoading = false;

        throw ('Please fill all fields');
      }

      final AuthResponse loginResponse =
          await _supabaseClient.auth.signInWithPassword(email: email, password: password);

      if (loginResponse.user != null) {
        Utils.showSnackBar(context, 'Success login! Welcome back.', color: AppColors.textColorDark);
      }

      // go to home page\
      setIsLoading = false;
    } catch (e) {
      Utils.showSnackBar(context, e.toString(), color: AppColors.errorColor);
      setIsLoading = false;
    }
  }

  //signout user
  Future<void> signOutEmployee({required BuildContext context}) async {
    try {
      await _supabaseClient.auth.signOut();

      Utils.showSnackBar(context, 'Success logout! See you next time.', color: AppColors.textColorDark);
      notifyListeners();
    } catch (e) {
      Utils.showSnackBar(context, e.toString(), color: AppColors.errorColor);
      setIsLoading = false;
    }
  }

  User? get currentUser => _supabaseClient.auth.currentUser;
}
