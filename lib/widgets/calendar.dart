import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarController _calendarController;
  Map<DateTime, List<dynamic>> _events;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _events = {};
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
        events: _events,
        initialCalendarFormat: CalendarFormat.week,
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarStyle: CalendarStyle(
            todayColor: Colors.green[700],
            selectedColor: Colors.orange[200],
        ),
        headerStyle: HeaderStyle(
            centerHeaderTitle: true,
            formatButtonShowsNext: false,
            formatButtonDecoration: BoxDecoration(
                color: Colors.green[700],
                borderRadius: BorderRadius.circular(10)
            )
        ),
        onDaySelected: (date, events, holidays) {

        },
        calendarController: _calendarController);
  }
}
