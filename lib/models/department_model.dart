// ignore_for_file: public_member_api_docs, sort_constructors_first
class DepartmentModel {
  final int id;
  final String title;
  DepartmentModel({
    required this.id,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
    };
  }

  factory DepartmentModel.fromMap(Map<String, dynamic> map) {
    return DepartmentModel(
      id: map['id'] as int,
      title: map['title'] as String,
    );
  }
}
