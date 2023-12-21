import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workee/constants/colors.dart';
import 'package:workee/pages/register_page.dart';
import 'package:workee/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const SizedBox(height: 60),
          const Icon(Icons.assignment_returned_sharp, size: 100, color: AppColors.thirdColor),
          const SizedBox(height: 20),
          const Text(
            'Workee',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColors.textColorDark,
            ),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    hintText: 'Email Employee ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text('Forgot Password?', style: TextStyle(color: AppColors.textColorDark)),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Consumer<AuthServices>(builder: (context, authServicesProvider, _) {
                  return SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: authServicesProvider.isLoading
                        ? const Center(
                            child: CircularProgressIndicator.adaptive(
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondaryColor)))
                        : ElevatedButton(
                            onPressed: () {
                              authServicesProvider.loginEmployee(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                                context: context,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.thirdColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('Login', style: TextStyle(fontSize: 20, color: AppColors.textColorLight)),
                          ),
                  );
                }),
                const SizedBox(height: 30),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('New Employee?', style: TextStyle(color: AppColors.textColorDark)),
                        SizedBox(width: 2),
                        Text('please register here', style: TextStyle(color: AppColors.linkColor)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
