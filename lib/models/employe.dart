import 'package:json_annotation/json_annotation.dart';

part 'employe.g.dart';

@JsonSerializable()
class Employee {
  String name;
  int age;
  String position;
  List<String> skills;

  Employee({
    required this.name,
    required this.age,
    required this.position,
    required this.skills,
  });

  void update(String name, String position, int age) {
    this.name = name;
    this.position = position;
    this.age = age;
  }

  factory Employee.fromJson(Map<String, dynamic> json) => _$EmployeeFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}
