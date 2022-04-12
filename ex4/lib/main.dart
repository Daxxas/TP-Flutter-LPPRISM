import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Centralize every controller & callback here so we can easily control every controller & callback
  TextEditingController horaireBrut = TextEditingController(text: "0.00");
  TextEditingController mensuelBrut = TextEditingController(text: "0.00");
  TextEditingController annuelBrut = TextEditingController(text: "0.00");
  TextEditingController horaireNet = TextEditingController(text: "0.00");
  TextEditingController mensuelNet = TextEditingController(text: "0.00");
  TextEditingController annuelNet = TextEditingController(text: "0.00");

  TextEditingController mensuelNetFinal = TextEditingController(text: "0.00");
  TextEditingController annuelNetFinal = TextEditingController(text: "0.00");

  double workTimeValue = 1;
  double prelevementSourceValue = 0;

  int statusGroupValue = 22;
  int primeGroupValue = 12;

  void horaireBrutCallback(String value) {
    if(value != "") {
      double workTimeRatio = workTimeValue * 7.25;

      double hbrut = double.parse(value);
      double mbrut = hbrut * workTimeRatio * 21;
      double abrut = mbrut * 12;

      double hnet = hbrut * (1 - (statusGroupValue/100));
      double mnet = hnet * workTimeRatio * 21;
      double anet = mnet * 12;

      mensuelBrut.text = mbrut.toStringAsFixed(2);
      annuelBrut.text = abrut.toStringAsFixed(2);

      horaireNet.text = hnet.toStringAsFixed(2);
      mensuelNet.text = mnet.toStringAsFixed(2);
      annuelNet.text = anet.toStringAsFixed(2);
    }
  }
  void mensuelBrutCallback(String value) {
    if(value != "") {
      double workTimeRatio = workTimeValue * 7.25;

      double mbrut = double.parse(value);
      double hbrut = mbrut / (workTimeRatio * 21);
      double abrut = mbrut * 12;

      double hnet = hbrut * (1 - (statusGroupValue/100));
      double mnet = hnet * workTimeRatio * 21;
      double anet = mnet * 12;

      horaireBrut.text = hbrut.toStringAsFixed(2);
      annuelBrut.text = abrut.toStringAsFixed(2);

      horaireNet.text = hnet.toStringAsFixed(2);
      mensuelNet.text = mnet.toStringAsFixed(2);
      annuelNet.text = anet.toStringAsFixed(2);
    }
  }
  void anneeBrutCallback(String value) {
    if(value != "") {
      double workTimeRatio = workTimeValue * 7.25;

      double abrut = double.parse(value);
      double mbrut = abrut / 12;
      double hbrut = mbrut / (workTimeRatio * 21);

      double hnet = hbrut * (1 - (statusGroupValue/100));
      double mnet = hnet * workTimeRatio * 21;
      double anet = mnet * 12;

      horaireBrut.text = hbrut.toStringAsFixed(2);
      mensuelBrut.text = mbrut.toStringAsFixed(2);

      horaireNet.text = hnet.toStringAsFixed(2);
      mensuelNet.text = mnet.toStringAsFixed(2);
      annuelNet.text = anet.toStringAsFixed(2);
    }
  }
  void horaireNetCallback(String value) {
    if(value != "") {
      double workTimeRatio = workTimeValue * 7.25;

      double hnet = double.parse(value);
      double mnet = hnet * workTimeRatio * 21;
      double anet = mnet * 12;

      double hbrut = hnet / (1 - (statusGroupValue/100));
      double mbrut = hbrut * workTimeRatio * 21;
      double abrut = mbrut * 12;

      horaireBrut.text = hbrut.toStringAsFixed(2);
      mensuelBrut.text = mbrut.toStringAsFixed(2);
      annuelBrut.text = abrut.toStringAsFixed(2);

      mensuelNet.text = mnet.toStringAsFixed(2);
      annuelNet.text = anet.toStringAsFixed(2);
    }
  }
  void mensuelNetCallback(String value) {
    if(value != "") {
      double workTimeRatio = workTimeValue * 7.25;
      double mnet = double.parse(value);
      double hnet = mnet / (workTimeRatio * 21);

      double hbrut = hnet / (1 - (statusGroupValue/100));
      double mbrut = hbrut * workTimeRatio * 21;
      double abrut = mbrut * 12;

      double anet = mnet * 12;

      horaireBrut.text = hbrut.toStringAsFixed(2);
      mensuelBrut.text = mbrut.toStringAsFixed(2);
      annuelBrut.text = abrut.toStringAsFixed(2);

      horaireNet.text = hnet.toStringAsFixed(2);
      annuelNet.text = anet.toStringAsFixed(2);
    }
  }
  void annuelNetCallback(String value) {
    if(value != "") {
      double workTimeRatio = workTimeValue * 7.25;
      double anet = double.parse(value);
      double mnet = anet / 12;
      double hnet = mnet / (workTimeRatio * 21);

      double hbrut = hnet / (1 - (statusGroupValue/100));
      double mbrut = hbrut * workTimeRatio * 21;
      double abrut = mbrut * 12;


      horaireBrut.text = hbrut.toStringAsFixed(2);
      mensuelBrut.text = mbrut.toStringAsFixed(2);
      annuelBrut.text = abrut.toStringAsFixed(2);

      horaireNet.text = hnet.toStringAsFixed(2);
      mensuelNet.text = mnet.toStringAsFixed(2);
    }
  }

  void primeCallback(int? value) {
    setState(() {
      primeGroupValue = value!;
    });
  }

  void statusCallback(int? value) {
    setState(() {
      statusGroupValue = value!;
      horaireBrutCallback(horaireBrut.text);
    });
  }

  void prelevementSourceCallback(double value) {
    setState(() {
      prelevementSourceValue = value;
    });
  }
  void workTimeCallback(double value) {
    horaireBrutCallback(horaireBrut.text);

    setState(() {
      workTimeValue = value;
      horaireBrutCallback(horaireBrut.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Wrap(runSpacing: 30, children: [
              Container(
                width: 500,
                child: Column(
                  children: [
                    Row(children: [BrutInfo(horaireBrut: horaireBrut, mensuelBrut: mensuelBrut, annuelBrut: annuelBrut, horaireBrutCallback: horaireBrutCallback, mensuelBrutCallback: mensuelBrutCallback, annuelBrutCallback: anneeBrutCallback), NetInfo(annuelNet: annuelNet, annuelNetCallback: annuelNetCallback, horaireNet: horaireNet, horaireNetCallback: horaireNetCallback, mensuelNet: mensuelNet, mensuelNetCallback: mensuelNetCallback)]),
                    Text("Sélectionnez votre temps de travail : " + (workTimeValue * 100).round().toString() + " %"),
                    Slider(value: workTimeValue, onChanged: workTimeCallback),
                    StatusSelection(statusCallback: statusCallback, statusGroupValue: statusGroupValue,),
                    Text("Sélectionnez le taux de prélèvement à la source : " + (prelevementSourceValue * 100).round().toString() + " %"),
                    Slider(value: prelevementSourceValue, onChanged: prelevementSourceCallback
                    ),
                    PrimeSelection(primeCallback: primeCallback, primeGroupValue: primeGroupValue,),
                    Text("Estimation de votre salaire net après le prélèvement à la source"),
                    TextField(
                      decoration: const InputDecoration(labelText: "Mensuel net après impôts"),
                      controller: mensuelNetFinal,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: "Annuel net après impôts"),
                      controller: annuelNetFinal,
                    ),
                  ],
                ),
              ),
    ])));
  }
}

class BrutInfo extends StatefulWidget {
  final TextEditingController horaireBrut;
  final TextEditingController mensuelBrut;
  final TextEditingController annuelBrut;
  final Function(String) horaireBrutCallback;
  final Function(String) mensuelBrutCallback;
  final Function(String) annuelBrutCallback;

  const BrutInfo({Key? key, required this.horaireBrut, required this.mensuelBrut, required this.annuelBrut, required this.horaireBrutCallback, required this.mensuelBrutCallback, required this.annuelBrutCallback}) : super(key: key);

  @override
  State<BrutInfo> createState() => _BrutInfoState();
}

class _BrutInfoState extends State<BrutInfo> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: <Widget>[
            Text("Indiquez votre salaire brut"),
            TextField(
              decoration: const InputDecoration(labelText: "Horaire brut"),
              controller: widget.horaireBrut,
              onChanged: widget.horaireBrutCallback,

            ),
            TextField(
              decoration: const InputDecoration(labelText: "Mensuel Brut"),
              controller: widget.mensuelBrut,
              onChanged: widget.mensuelBrutCallback,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Annuel brut"),
              controller: widget.annuelBrut,
              onChanged: widget.annuelBrutCallback,
            )
          ],
        ),
      ),
    );
  }
}

class NetInfo extends StatefulWidget {
  final TextEditingController horaireNet;
  final TextEditingController mensuelNet;
  final TextEditingController annuelNet;
  final Function(String) horaireNetCallback;
  final Function(String) mensuelNetCallback;
  final Function(String) annuelNetCallback;

  const NetInfo({Key? key, required this.horaireNet, required this.mensuelNet, required this.annuelNet, required this.horaireNetCallback, required this.mensuelNetCallback, required this.annuelNetCallback}) : super(key: key);

  @override
  State<NetInfo> createState() => _NetInfoState();
}

class _NetInfoState extends State<NetInfo> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: <Widget>[
            Text("Indiquez votre salaire net"),
            TextField(
              decoration: const InputDecoration(labelText: "Horaire net"),
              controller: widget.horaireNet,
              onChanged: widget.horaireNetCallback,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Mensuel net"),
              controller: widget.mensuelNet,
              onChanged: widget.mensuelNetCallback,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Annuel net"),
              controller: widget.annuelNet,
              onChanged: widget.annuelNetCallback,
            )
          ],
        ),
      ),
    );
  }
}

class StatusSelection extends StatefulWidget {
  final Function(int?) statusCallback;
  final int statusGroupValue;

  const StatusSelection({Key? key, required this.statusCallback, required this.statusGroupValue}) : super(key: key);

  @override
  State<StatusSelection> createState() => _StatusSelectionState();
}

class _StatusSelectionState extends State<StatusSelection> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        child: Column(children: [
          Text("Sélectionnez votre statut :"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Radio<int>(
                    groupValue: widget.statusGroupValue,
                    value: 22,
                    onChanged: widget.statusCallback,
                  ),
                  const Text(
                    "Salarié non-cadre",
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
              Column(
                children: [
                  Radio<int>(
                    groupValue: widget.statusGroupValue,
                    value: 25,
                    onChanged: widget.statusCallback,
                  ),
                  const Text(
                    "Salarié cadre",
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
              Column(
                children: [
                  Radio<int>(
                    groupValue: widget.statusGroupValue,
                    value: 15,
                    onChanged: widget.statusCallback,
                  ),
                  const Text(
                    "Fonction publique",
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
              Column(
                children: [
                  Radio<int>(
                    groupValue: widget.statusGroupValue,
                    value: 45,
                    onChanged: widget.statusCallback,
                  ),
                  const Text(
                    "Profession libérale",
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
              Column(
                children: [
                  Radio<int>(
                    groupValue: widget.statusGroupValue,
                    value: 51,
                    onChanged: widget.statusCallback,
                  ),
                  const Text(
                    "Portage salarial",
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ],
          )
        ]));
  }
}


class PrimeSelection extends StatefulWidget {
  final Function(int?) primeCallback;
  final int primeGroupValue;
  const PrimeSelection({Key? key, required this.primeCallback, required this.primeGroupValue}) : super(key: key);

  @override
  State<PrimeSelection> createState() => _PrimeSelectionState();
}

class _PrimeSelectionState extends State<PrimeSelection> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        child: Column(children: [
          const Text("Sélectionnez le nombre de mois de prime conventionnelle :"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Radio<int>(
                    groupValue: widget.primeGroupValue,
                    value: 12,
                    onChanged: widget.primeCallback,
                  ),
                  const Text(
                    "12 mois",
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
              Column(
                children: [
                  Radio<int>(
                    groupValue: widget.primeGroupValue,
                    value: 13,
                    onChanged: widget.primeCallback,
                  ),
                  const Text(
                    "13 mois",
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
              Column(
                children: [
                  Radio<int>(
                    groupValue: widget.primeGroupValue,
                    value: 14,
                    onChanged: widget.primeCallback,
                  ),
                  const Text(
                    "14 mois",
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
              Column(
                children: [
                  Radio<int>(
                    groupValue: widget.primeGroupValue,
                    value: 15,
                    onChanged: widget.primeCallback,
                  ),
                  const Text(
                    "15 mois",
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
              Column(
                children: [
                  Radio<int>(
                    groupValue: widget.primeGroupValue,
                    value: 16,
                    onChanged: widget.primeCallback,
                  ),
                  const Text(
                    "16 mois",
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ],
          ),
        ],
      )
    );
  }
}
