import 'dart:async';
import 'dart:js';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Partie 1',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Calendar());
  }
}

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime selectedDate = DateTime.now();
  bool dateHaveBeenSelected = false;
  String dateDisplay = "";

  Timer? timer;

  void switchScene(context) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
      return CalendarDiff();
    }));
  }

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => updateDate());
    updateDate(); // Premier appel de fonction ici sinon le texte commence à s'afficher seulement une seconde après le chargement de la page
    super.initState();
  }

  void updateDate() {
    if(dateHaveBeenSelected) {
      setState(() {
        dateDisplay = DateCalculator.getDiffYMD(selectedDate, DateTime.now());
      });
    }
    else {
      setState(() {
        dateDisplay = "0 ans, 0 mois, 0 jours, 0 heures, 0 minutes, 0 secondes";
      });
    }
  }

  selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: new DateTime(1900),
        lastDate: DateTime.now()
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        dateHaveBeenSelected = true;
      });
      updateDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Calcul Age"),
          actions: [
            IconButton(
              onPressed: () {
                switchScene(context);
              },
              icon: const Icon(Icons.list),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                  onPressed: () {
                    selectDate(context);
                  },
                  child: Icon(Icons.calendar_month)),
              Text("Tu as " + dateDisplay)
            ],
          ),
        ));
  }
}


class CalendarDiff extends StatefulWidget {
  const CalendarDiff({Key? key}) : super(key: key);

  @override
  State<CalendarDiff> createState() => _CalendarDiffState();
}

class _CalendarDiffState extends State<CalendarDiff> {

  DateTime selectedFirstDate = DateTime.now();
  DateTime selectedSecondDate = DateTime.now();

  bool firstDateSelected = false;
  bool secondDateSelected = false;

  String dateDisplay = "";

  selectFirstDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: selectedFirstDate,
        firstDate: new DateTime(1900),
        lastDate: DateTime.now(),
    );
    if (selected != null && selected != selectedFirstDate) {
      setState(() {
        selectedFirstDate = selected;
        firstDateSelected = true;
      });
      updateDisplayDate();
    }
  }

  selectSecondDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: selectedSecondDate,
        firstDate: new DateTime(1900),
        lastDate: DateTime.now()
    );
    if (selected != null && selected != selectedSecondDate) {
      setState(() {
        selectedSecondDate = selected;
        secondDateSelected = true;
      });
      updateDisplayDate();
    }
  }

  updateDisplayDate() {
    if(firstDateSelected && secondDateSelected) {
      setState(() {
        dateDisplay = DateCalculator.getDiffYMD(selectedFirstDate, selectedSecondDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Calcul Partie 2"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Date 1 : "),
                  TextButton(
                      onPressed: () {
                        selectFirstDate(context);
                      },
                      child: Icon(Icons.calendar_month)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Date 2 : "),
                  TextButton(
                      onPressed: () {
                        selectSecondDate(context);
                      },
                      child: Icon(Icons.calendar_month)),
                ],
              ),
              Text(dateDisplay)
            ],
          ),
        )
    );
  }
}

// Class pour éviter d'avoir à copier/coller getDiffYMD à travers plusieurs class
class DateCalculator {
  static String getDiffYMD(DateTime then, DateTime now) {
    int years = now.year - then.year;
    int months = now.month - then.month;
    int days = now.day - then.day;
    int hours = now.hour - then.hour;
    int minutes = now.minute - then.minute;
    int seconds = now.second - then.second;

    if (minutes < 0) {
      minutes += 60;
      hours--;
    }

    if (hours < 0) {
      hours += 24;
      days--;
    }

    if (days < 0) {
      days += DateTime(then.year, then.month, 0)
          .day; // Permet d'avoir le nombre de jours dans le mois courant
      months--;
    }

    if (months < 0) {
      months += 12;
      years--;
    }

    return "$years ans, $months mois, $days jours, $hours heures, $minutes minutes, $seconds secondes";
  }
}