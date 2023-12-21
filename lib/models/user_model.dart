// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String id;
  final String email;
  final String name;
  final int? department;
  final String employeeId;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.department,
    required this.employeeId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'department': department,
      'employee_id': employeeId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      department: map['department'] != null ? map['department'] as int : null,
      employeeId: map['employee_id'] as String,
    );
  }
}
