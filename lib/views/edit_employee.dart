import 'package:employee_app/cubits/employee_cubit.dart';
import 'package:employee_app/models/employee.dart';
import 'package:employee_app/views/widgets/custom_date_picker.dart';
import 'package:employee_app/views/widgets/role_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditEmployeeScreen extends StatefulWidget {
  final Employee employee;
  final int index;

  EditEmployeeScreen({required this.employee, required this.index});

  @override
  _EditEmployeeScreenState createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  late DateTime _selectedJoiningDate;
  late DateTime _selectedExitDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee.name);
    _roleController = TextEditingController(text: widget.employee.role);
    _selectedJoiningDate = widget.employee.dateOfJoining;
    widget.employee.exitDate == null
        ? {_selectedExitDate = DateTime(3000)}
        : _selectedExitDate = widget.employee.exitDate!;
  }

  // void _selectJoiningDate(BuildContext context) {
  //   showDatePicker(
  //     context: context,
  //     initialDate: _selectedJoiningDate,
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime.now(),
  //   ).then((value) {
  //     if (value != null) {
  //       setState(() {
  //         _selectedJoiningDate = value;
  //       });
  //     }
  //   });
  // }

  // void _selectExitDate(BuildContext context) {
  //   showDatePicker(
  //     context: context,
  //     initialDate: _selectedExitDate,
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime.now(),
  //   ).then((value) {
  //     if (value != null) {
  //       setState(() {
  //         _selectedExitDate = value;
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final employeeCubit = context.read<EmployeeCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Employee'),
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
                        onDateSelected: (date) {
                          setState(() {
                            _selectedJoiningDate = date;
                          });
                        },
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
                        onDateSelected: (date) {
                          setState(() {
                            _selectedExitDate = date;
                          });
                        },
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
                     style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white
                                    ),
                                child: Text('Cancel',style: TextStyle(color: Colors.black)),
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
                        } else {
                          final editedEmployee = Employee(
                            id: widget.employee.id,
                            name: _nameController.text,
                            role: _roleController.text,
                            dateOfJoining: _selectedJoiningDate,
                            exitDate: _selectedExitDate,
                          );
                          employeeCubit.updateEmployee(
                              widget.index, editedEmployee);
                          Navigator.pop(context);
                        } // Navigate back to EmployeeListScreen
                      },
                      child: Text('Save'),
                    ),
                  ],
                )
          ],
        ),
      ),
    );
  }
}
