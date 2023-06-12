import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final bool? isExit;

  const CustomDatePicker({
    required this.selectedDate,
    required this.onDateSelected,
    this.isExit = false,
  });

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
  }

  int selectedButton = -1;

  void onSelectButton(int index) {
    setState(() {
      selectedButton = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  contentPadding: EdgeInsets.all(12),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widget.isExit == false
                          ? Row(
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      onSelectButton(0);
                                      final today = DateTime.now();
                                      setState(() {
                                        _selectedDate = today;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: selectedButton == 0
                                            ? Colors.blue
                                            : Color.fromARGB(255, 186, 230, 250)),
                                    child: Text('Today'),
                                  ),
                                ),
                                SizedBox(width: 15),
                                SizedBox(
                                  width: 120,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      onSelectButton(1);
                                      final nextMonday =
                                          _getNextWeekday(DateTime.monday);
                                      setState(() {
                                        _selectedDate = nextMonday;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: selectedButton == 1
                                            ? Colors.blue
                                            : Color.fromARGB(255, 186, 230, 250)),
                                    child: Text('Next Monday'),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(),
                      widget.isExit == false
                          ? Row(
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      onSelectButton(2);
                                      final nextTuesday =
                                          _getNextWeekday(DateTime.tuesday);
                                      setState(() {
                                        _selectedDate = nextTuesday;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: selectedButton == 2
                                            ? Colors.blue
                                            : Color.fromARGB(255, 186, 230, 250)),
                                    child: Text('Next Tuesday'),
                                  ),
                                ),
                                SizedBox(width: 15),
                                SizedBox(
                                  width: 120,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      onSelectButton(3);
                                      final nextWeek =
                                          DateTime.now().add(Duration(days: 7));
                                      setState(() {
                                        _selectedDate = nextWeek;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: selectedButton == 3
                                            ? Colors.blue
                                            : Color.fromARGB(255, 186, 230, 250)),
                                    child: Text('After 1 Week'),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(),
                      widget.isExit == true
                          ? Row(
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      onSelectButton(4);
                                      final today = DateTime(3000);
                                      setState(() {
                                        _selectedDate = today;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: selectedButton == 4
                                            ? Colors.blue
                                            : Color.fromARGB(255, 186, 230, 250)),
                                    child: Text('No date'),
                                  ),
                                ),
                                SizedBox(width: 15),
                                SizedBox(
                                  width: 120,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      onSelectButton(0);
                                      final today = DateTime.now();
                                      setState(() {
                                        _selectedDate = today;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: selectedButton == 0
                                            ? Colors.blue
                                            : Color.fromARGB(255, 186, 230, 250)),
                                    child: Text('Today'),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(),
                      SizedBox(height: 8.0),
                      SfDateRangePicker(
                        headerStyle: DateRangePickerHeaderStyle(
                          textAlign: TextAlign.center,
                        ),
                        monthViewSettings:
                            DateRangePickerMonthViewSettings(dayFormat: 'EEE'),
                        showNavigationArrow: true,
                        initialSelectedDate: _selectedDate,
                        onSelectionChanged:
                            (DateRangePickerSelectionChangedArgs args) {
                          setState(() {
                            _selectedDate = (args.value as DateTime).toLocal();
                          });
                        },
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                               Icon(Icons.calendar_today, size: 13, color: Colors.blue),
                               SizedBox(width: 10),
                              Text(
                                _selectedDate == DateTime(3000)
                                    ? "No date"
                                    :DateFormat("dd MMM,yyyy ")
                                                  .format(_selectedDate).toString(),
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                               ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                             
                            },
                            style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white
                                ),
                            child: Text('Cancel',style: TextStyle(color: Colors.black)),
                          ),
                          SizedBox(width: 10),
                              ElevatedButton(
                                
                                onPressed: () {
                                  Navigator.pop(context, _selectedDate);
                                  widget.onDateSelected(_selectedDate);
                                },
                                child: Text('Save'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
      child: Row(
        children: [
          Icon(Icons.calendar_today, size: 13, color: Colors.blue),
          SizedBox(width: 10),
          Text(
            _selectedDate == DateTime(3000)
                ? "No date"
                : _selectedDate == DateTime.now()
                    ? "Today"
                    : DateFormat("dd MMM,yyyy ")
                                                  .format(_selectedDate).toString(),
            style: TextStyle(fontSize: 14.0),
          ),
        ],
      ),
    );
  }

  DateTime _getNextWeekday(int weekday) {
    DateTime date = DateTime.now();
    while (date.weekday != weekday) {
      date = date.add(Duration(days: 1));
    }
    return date;
  }
}
