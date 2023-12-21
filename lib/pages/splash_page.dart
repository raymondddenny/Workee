import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workee/pages/home_page.dart';
import 'package:workee/pages/login_page.dart';
import 'package:workee/services/auth_service.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthServices>(builder: (context, authProvider, child) {
      return authProvider.currentUser == null ? const LoginPage() : const HomePage();
    });
  }
}
