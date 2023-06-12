import 'dart:developer';

import 'package:employee_app/cubits/employee_cubit.dart';
import 'package:employee_app/models/employee.dart';
import 'package:employee_app/views/widgets/custom_date_picker.dart';
import 'package:employee_app/views/widgets/role_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddEmployeeScreen extends StatefulWidget {
  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  DateTime? _selectedJoiningDate;
  DateTime? _selectedExitDate;

  @override
  void initState() {
    super.initState();

    _selectedJoiningDate = DateTime.now();
    _selectedExitDate = DateTime(3000);
  }

  void _selectJoiningDate(DateTime selectedDate) {
    setState(() {
      _selectedJoiningDate = selectedDate;
    });
  }

  void _selectExitDate(DateTime selectedDate) {
    setState(() {
      _selectedExitDate = selectedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final employeeCubit = context.read<EmployeeCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Employee Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.0),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Employee name'),
                ),
                SizedBox(height: 12.0),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      builder: (BuildContext builder) {
                        return RoleSelectionBottomSheet(
                          roleController: _roleController,
                        );
                      },
                    );
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _roleController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Select role',
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Colors.blue,
                        ),
                        suffixIcon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.blue,
                        ),
                      ),
                      readOnly: true,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      child: CustomDatePicker(
                        selectedDate: _selectedJoiningDate,
                        onDateSelected: _selectJoiningDate,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.forward, color: Colors.blue),
                    SizedBox(width: 10),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      child: CustomDatePicker(
                        isExit: true,
                        selectedDate: _selectedExitDate,
                        onDateSelected: _selectExitDate,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: Text('Cancel', style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please fill name'),
                        ),
                      );
                    } else if (_roleController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please fill role'),
                        ),
                      );
                    } else if (_selectedJoiningDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select joining date'),
                        ),
                      );
                    } else if (_nameController.text.isNotEmpty &&
                        _roleController.text.isNotEmpty &&
                        _selectedJoiningDate != null &&
                        _selectedExitDate != null) {
                      final employee = Employee(
                        name: _nameController.text,
                        role: _roleController.text,
                        dateOfJoining: _selectedJoiningDate!,
                        exitDate: _selectedExitDate!,
                      );
                      employeeCubit.addEmployee(employee);
                      Navigator.pop(
                          context); // Navigate back to EmployeeListScreen
                    } else if (_nameController.text.isNotEmpty &&
                        _roleController.text.isNotEmpty &&
                        _selectedJoiningDate != null) {
                      final employee = Employee(
                        name: _nameController.text,
                        role: _roleController.text,
                        dateOfJoining: _selectedJoiningDate!,
                      );
                      employeeCubit.addEmployee(employee);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please fill necessary details'),
                        ),
                      );
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
