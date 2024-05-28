// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************



Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
      name: json['name'] as String,
      age: (json['age'] as num).toInt(),
      position: json['position'] as String,
      skills:
          (json['skills'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
      'name': instance.name,
      'age': instance.age,
      'position': instance.position,
      'skills': instance.skills,
    };
