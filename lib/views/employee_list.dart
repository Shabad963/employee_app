import 'dart:developer';

import 'package:employee_app/cubits/employee_cubit.dart';
import 'package:employee_app/models/employee.dart';
import 'package:employee_app/views/add_employee.dart';
import 'package:employee_app/views/edit_employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class EmployeeListScreen extends StatefulWidget {
  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EmployeeCubit>().loadEmployees();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    final employeeCubit = context.read<EmployeeCubit>();

    return Scaffold(
       backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Employee List'),
      ),
      body: BlocBuilder<EmployeeCubit, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is EmployeeLoaded) {
            if (state.employees.isEmpty) {
              return Center(
                  child: Container(child: Image.asset("assets/images/no_employees.png",width: 180)));
            } else {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width:double .infinity,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      color: Color(0xffF2F2F2),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Current employees",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      height: height / 3,
                      child: ListView.separated(
                        itemCount: state.employees.length,
                        itemBuilder: (context, index) {
                          final employee = state.employees[index];
                          if (employee.exitDate != DateTime(3000)) {
                            return SizedBox();
                          } else
                           {
                            return InkWell(
                              child: Slidable(
                                endActionPane: ActionPane(
                                    extentRatio: 0.2,
                                    motion: ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        onPressed: (context) {
                                          final deletedEmployee = employee;
                                          employeeCubit
                                              .deleteEmployee(index);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text('Employee data deleted'),
                                              action: SnackBarAction(
                                                label: 'Undo',
                                                onPressed: () {
                                                  employeeCubit.addEmployee(
                                                      deletedEmployee);
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icons.delete,
                                      )
                                    ]),
                                child: ListTile(
                                
                                  title: Text(employee.name,style : TextStyle(height: 1.5)),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(employee.role,style : TextStyle(height: 1.5)),
                                      Text(
                                         "From ${DateFormat("dd MMM,yyyy ")
                                                  .format(employee.dateOfJoining)}",style : TextStyle(height: 1.5)
                                                 
                                      ),
                                      
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BlocProvider<EmployeeCubit>.value(
                                          value: employeeCubit,
                                          child: EditEmployeeScreen(
                                            index: index,
                                            employee: employee,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                        }, separatorBuilder: (BuildContext context, int index) { 
                          return state.employees[index].exitDate != null ? SizedBox() :Divider();
                         },
                      ),
                    ),
                      Container(
                      width:double .infinity,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      color: Color(0xffF2F2F2),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Previous employees",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      height: height / 2.7,
                      child: ListView.separated(
                        itemCount: state.employees.length,
                        itemBuilder: (context, index) {
                          final employee = state.employees[index];
                          if (employee.exitDate == DateTime(3000)) {
                            return SizedBox();
                          } else {
                            return InkWell(
                              child: Slidable(
                                endActionPane: ActionPane(
                                    extentRatio: 0.2,
                                    motion: ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        onPressed: (context){
                                           final deletedEmployee = employee;
                                          employeeCubit
                                              .deleteEmployee(index);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text('Employee data deleted'),
                                              action: SnackBarAction(
                                                label: 'Undo',
                                                onPressed: () {
                                                  employeeCubit.addEmployee(
                                                      deletedEmployee);
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icons.delete,
                                      )
                                    ]),
                                child: employee.exitDate == null
                                          ? SizedBox()
                                          :employee.exitDate == DateTime(3000) ? SizedBox() :  ListTile(
                                  title: Text(employee.name,style : TextStyle(height: 1.5)),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        
                                        employee.role,style : TextStyle(height: 1.5)),
                                      Row(
                                        children: [
                                          Text(
                                             DateFormat("dd MMM,yyyy ")
                                                      .format(employee.dateOfJoining!)
                                                      .toString(),style : TextStyle(height: 1.5)
                                            ),
                                            Text("-"),
                                            Text(
                                          DateFormat("dd MMM,yyyy ")
                                                  .format(employee.exitDate!)
                                                  .toString(),style : TextStyle(height: 1.5)
                                         ),
                                        ],
                                      ),
                                      
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BlocProvider<EmployeeCubit>.value(
                                          value: employeeCubit,
                                          child: EditEmployeeScreen(
                                            index: index,
                                            employee: employee,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                        }, separatorBuilder: (BuildContext context, int index) {
                          return SizedBox();
                          },
                      ),
                    ),
                      Container(
                      width:double .infinity,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      color: Color(0xffF2F2F2),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Swipe to delete"),
                      ),
                    ),
                  ],
                ),
              );
            }
          } else if (state is EmployeeError) {
            return Center(child: Text(state.errorMessage));
          } else {
            return Center(child: Container(child: Text("Some error occured")));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
