import 'package:json_annotation/json_annotation.dart';
import 'package:uyishi/models/employe.dart';
import 'package:uyishi/models/product.dart';

part 'company.g.dart';

@JsonSerializable()
class Company {
  final String company;
  final String location;
  final List<Employee> employees;
  final List<Product> products;

  Company({
    required this.company,
    required this.location,
    required this.employees,
    required this.products,
  });

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}
