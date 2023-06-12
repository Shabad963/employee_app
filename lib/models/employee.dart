import 'package:hive/hive.dart';

part 'employee.g.dart';


@HiveType(typeId: 0)
class Employee extends HiveObject {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String role;

  @HiveField(3)
  final DateTime dateOfJoining;

  @HiveField(4)
  final DateTime? exitDate;

  Employee({
     this.id,
    required this.name,
    required this.role,
    required this.dateOfJoining,
     this.exitDate,
  });
}