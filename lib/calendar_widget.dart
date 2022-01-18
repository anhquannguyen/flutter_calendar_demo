import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'calendar_model.dart';
import 'calendar_util.dart';
import 'const.dart';

class CalendarWidget extends StatefulWidget {
  final Function(DateTime) onChange;

  const CalendarWidget({
    Key? key,
    required this.onChange,
  });

  @override
  State<StatefulWidget> createState() => CalendarWidgetState();
}

class CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _currentDateTime;
  late DateTime _selectedDateTime;
  final List<CalendarModel> _sequentialDates = [];
  final weekDays = WEEKDAYS_SUN_START;
  final monthNames = MONTHS;

  @override
  void initState() {
    super.initState();

    final date = DateTime.now();
    _currentDateTime = DateTime(date.year, date.month);
    _selectedDateTime = DateTime(date.year, date.month, date.day);
    _getCalendar();
  }

  void _getCalendar() {
    if (_sequentialDates.isNotEmpty) _sequentialDates.clear();
    _sequentialDates.addAll(CalendarUtil().getMonthCalendar(
        month: _currentDateTime.month,
        year: _currentDateTime.year,
        startWeekDay: StartWeekDay.sunday));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        color: Colors.white,
        child: _mainView(),
      ),
    );
  }

  Widget _mainView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          padding: const EdgeInsets.fromLTRB(1, 5, 1, 5),
          child: Row(
            children: <Widget>[
              _buttonNext(false),
              _calendarTitle(),
              _buttonNext(true),
            ],
          ),
        ),
        Row(
          children: _weekDayTitles(),
        ),
        _dateTitles(),
      ],
    );
  }

  Widget _calendarTitle() {
    return Expanded(
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: calendarTitleTap,
        child: Center(
          child: Text(
            '${monthNames[_currentDateTime.month - 1]} ${_currentDateTime.year}',
            style: TextStyle(
                color: Colors.black,
                fontSize: calendarFontSize,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buttonNext(bool isNext) {
    return Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          onTap: () {
            setState(() {
              isNext ? _getNextMonth() : _getPrevMonth();
            });
          },
          child: Icon(
            (isNext) ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
            size: 15,
            color: Colors.black,
          ),
        ));
  }

  List<Widget> _weekDayTitles() {
    List<Widget> _weekDayTitles = [];
    for (var weekDay in weekDays) {
      _weekDayTitles.add(_weekDayTitle(weekDay));
    }
    return _weekDayTitles;
  }

  Widget _weekDayTitle(String weekDay) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
        alignment: Alignment.center,
        child: Text(
          weekDay,
          style: const TextStyle(
              color: Colors.black,
              fontSize: weekdaysFontSize,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _dateTitles() {
    if (_sequentialDates.isEmpty) return Container();
    return Container(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _sequentialDates.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: weekDays.length,
        ),
        itemBuilder: (context, index) {
          if (_sequentialDates[index].date == _selectedDateTime)
            return _dateTitle(_sequentialDates[index], true);
          return _dateTitle(_sequentialDates[index], false);
        },
      ),
    );
  }

  Widget _dateTitle(CalendarModel calendarDate, bool shouldSelected) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => _onDateSelected(calendarDate),
      child: Container(
        child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: shouldSelected ? primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              '${calendarDate.date.day}',
              style: TextStyle(
                fontSize: weekdaysFontSize,
                color: shouldSelected
                    ? Colors.white
                    : (calendarDate.thisMonth)
                        ? (calendarDate.date.weekday == DateTime.sunday)
                            ? Colors.red
                            : Colors.black
                        : (calendarDate.date.weekday == DateTime.sunday)
                            ? Colors.red.withOpacity(0.5)
                            : Colors.black.withOpacity(0.5),
              ),
            )),
      ),
    );
  }

  void calendarTitleTap() {
    final snackBar = SnackBar(
      content: Text(
          '${monthNames[_currentDateTime.month - 1]} ${_currentDateTime.year}'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _onDateSelected(CalendarModel calendarDate) {
    if (_selectedDateTime == calendarDate.date) return;
    if (calendarDate.nextMonth) {
      _getNextMonth();
    } else if (calendarDate.prevMonth) {
      _getPrevMonth();
    }
    setState(() => _selectedDateTime = calendarDate.date);

    widget.onChange(_selectedDateTime);
  }

  void _getNextMonth() {
    if (_currentDateTime.month == 12) {
      _currentDateTime = DateTime(_currentDateTime.year + 1, 1);
    } else {
      _currentDateTime =
          DateTime(_currentDateTime.year, _currentDateTime.month + 1);
    }
    _getCalendar();
  }

  void _getPrevMonth() {
    if (_currentDateTime.month == 1) {
      _currentDateTime = DateTime(_currentDateTime.year - 1, 12);
    } else {
      _currentDateTime =
          DateTime(_currentDateTime.year, _currentDateTime.month - 1);
    }
    _getCalendar();
  }
}
