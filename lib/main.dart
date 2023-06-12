import 'package:employee_app/cubits/employee_cubit.dart';
import 'package:employee_app/models/employee.dart';
import 'package:employee_app/views/add_employee.dart';
import 'package:employee_app/views/edit_employee.dart';
import 'package:employee_app/views/employee_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(EmployeeAdapter());
  await Hive.openBox<Employee>('employees');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final EmployeeCubit employeeCubit =
      EmployeeCubit(Hive.box<Employee>('employees'));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Employee App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/home': (context) => 
                  BlocProvider<EmployeeCubit>.value(
                    value: employeeCubit,
                     child: EmployeeListScreen(),
                  ),
                
          '/add': (context) => 
                  BlocProvider<EmployeeCubit>.value(
                    value: employeeCubit,
                     child: AddEmployeeScreen(),
                  ),
                
                
              
        },
        initialRoute: '/home',);
  }
}
