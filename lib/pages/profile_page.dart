import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workee/constants/colors.dart';
import 'package:workee/services/auth_service.dart';
import 'package:workee/services/database_services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DatabaseServices>(context);
    dbService.departmentList.isEmpty ? dbService.getAllDepartment() : null;
    _nameController.text.isEmpty ? _nameController.text = dbService.userModel?.name ?? '' : null;
    return Scaffold(
      body: dbService.userModel == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 100,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  Text(
                    dbService.userModel!.email,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'employee id: ${dbService.userModel!.employeeId}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Divider(),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Employee Name',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Department',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: DropdownButtonFormField(
                      value: dbService.employeeDepartmentId ?? dbService.departmentList.first.id,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        dbService.employeeDepartmentId = value;
                      },
                      items: dbService.departmentList
                          .map(
                            (department) => DropdownMenuItem(
                              value: department.id,
                              child: Text(department.title),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        backgroundColor: AppColors.secondaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      onPressed: () async {
                        await dbService.updateProfile(
                          name: _nameController.text.trim(),
                          context: context,
                        );
                      },
                      child:
                          const Text('Update Profile', style: TextStyle(fontSize: 20, color: AppColors.textColorDark)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Consumer<AuthServices>(builder: (context, authService, child) {
                    return TextButton(
                        onPressed: () async {
                          await authService.signOutEmployee(context: context);
                        },
                        child: const Text('Logout', style: TextStyle(fontSize: 16, color: AppColors.thirdColor)));
                  })
                ],
              ),
            ),
    );
  }
}
