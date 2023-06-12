import 'package:employee_app/models/employee.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';


part 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final Box<Employee> _employeeBox;

  EmployeeCubit(this._employeeBox) : super(EmployeeInitial());

  Future<void> loadEmployees() async {
    emit(EmployeeLoading());
    try {
      final employees = _employeeBox.values.toList();
      emit(EmployeeLoaded(employees));
    } catch (e) {
      emit(EmployeeError('Failed to load employees'));
    }
  }

  Future<void> addEmployee(Employee employee) async {
    emit(EmployeeLoading());
    try {
      await _employeeBox.add(employee);
      final employees = _employeeBox.values.toList();
      emit(EmployeeLoaded(employees));
    } catch (e) {
      emit(EmployeeError('Failed to add employee'));
    }
  }

  Future<void> updateEmployee(int index, Employee updatedEmployee) async {
    emit(EmployeeLoading());
    try {
      await _employeeBox.putAt(index, updatedEmployee);
      final employees = _employeeBox.values.toList();
      emit(EmployeeLoaded(employees));
    } catch (e) {
      emit(EmployeeError('Failed to update employee'));
    }
  }

  

  Future<void> deleteEmployee(int index) async {
    emit(EmployeeLoading());
    try {
      await _employeeBox.deleteAt(index);
      final employees = _employeeBox.values.toList();
      emit(EmployeeLoaded(employees));
    } catch (e) {
      emit(EmployeeError('Failed to delete employee'));
    }
  }
}
