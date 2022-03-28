import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Proposition placeholder1 = Proposition("EntreprisePH", "1000 BRUT", "10000 NET", "STATUS", ["SENTIMENT #1", "SENTIMENT #2"]);
  var propositions = <Proposition>[];

  // Function to open proposition form
  void switchScene(context) {

    Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (context) => PropositionForm(passedPropositions: propositions))
    ).then((value) {
      setState(() {

      });
    },);
  }

  // Items in propositions list
  Widget _buildRow(Proposition proposition) {

    var propositionTexts = <Widget>[
      Text("Entreprise : " + proposition.entreprise),
      Text("Salaire brut annuel : " + proposition.salaireBrut),
      Text("Salaire net mensuel : " + proposition.salaireNet),
      Text("Statut proposé : " + proposition.status),
      proposition.sentiments.isNotEmpty ? Text("Sentiments :") : Text("")
    ];

    // proposition.sentiments.forEach((element) {propositionTexts.add(Text("- " + element));});

    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: propositionTexts
        ),
    );
  }

  // List of propositions
  @override
  Widget build(BuildContext context) {
    print("build !");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              switchScene(context);
            }, icon: const Icon(Icons.add),
          )
        ],
      ),
      body:  ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: propositions.length,
        itemBuilder: (context, i) {
          return _buildRow(propositions[i]);
        },
      )
    );
  }
}

class PropositionForm extends StatefulWidget {
  final List<Proposition> passedPropositions;

  const PropositionForm({Key? key, required this.passedPropositions}) : super(key: key);

  @override
  State<PropositionForm> createState() => _PropositionFormState();
}

class _PropositionFormState extends State<PropositionForm> {
  Proposition currentProposition = Proposition.emptyProposition();

  // Variable contenant les widgets des champs sentiments
  var sentimentInputs = <SentimentInput> [];
  var infos = <TextFormField> [];

  // Controller permettant de récupérer le contenu des champs de sentiments
  TextEditingController returnController(String controllerName) {
    final controllerName = TextEditingController();
    return controllerName;
  }
  TextEditingController entrepriseController = TextEditingController();
  TextEditingController brutController = TextEditingController();
  TextEditingController netController = TextEditingController();
  String selectedStatus = "Cadre";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajout d'une proposition"),
      ),
      body: Column(
        children: <Widget> [
          TextFormField(
            controller: entrepriseController,
            decoration: const InputDecoration(
                labelText: "Entreprise"
            ),
          ),
          TextFormField(
            controller: brutController,
            decoration: const InputDecoration(
                labelText: "Salaire brut par mois"
            ),
            onChanged: (value) {
              netController.text = (int.parse(value) * 12).toString();
            },
          ),
          TextFormField(
            controller: netController,
            decoration: const InputDecoration(
                labelText: "Salaire net par an"
            ),
            onChanged: (value) {
              brutController.text = (int.parse(value) / 12).toString();
            },
          ),
          ListTile(
              title: const Text("Cadre"),
              leading: Radio<String>(
                value: "Cadre", groupValue: selectedStatus, onChanged: (String? value) { setState(() {
                  selectedStatus = value!;
                });},
              )
          ),
          ListTile(
              title: const Text("Non cadre"),
              leading: Radio<String>(
                value: "Non Cadre", groupValue: selectedStatus, onChanged: (String? value) { setState(() {
                  selectedStatus = value!;
                }); },
              )
          ),
          Row(
            children: [
              TextButton(onPressed: () {
                //Ajout d'un input de sentiment lorsqu'on clique sur le bouton +
                setState(() {if(sentimentInputs.length > 0) {
                            sentimentInputs.removeAt(sentimentInputs.length - 1);
                          }
                        });
              }, child: const Text("-")),
              TextButton(onPressed: () {
                //Ajout d'un input de sentiment lorsqu'on clique sur le bouton +
                setState(() {
                  sentimentInputs.add(SentimentInput(
                    fieldName: 'Sentiment #${sentimentInputs.length + 1}',
                    controller: returnController(
                        "sentiment ${sentimentInputs.length + 1}"
                    ),
                    index: sentimentInputs.length,
                  ));
                });
              }, child: const Text("+"))
            ],
          ),

        ]
        + sentimentInputs
        + [
            TextButton(onPressed: (){

              Navigator.pop(context);
              var listOfSentimentEntries = sentimentInputs.map((i)=>i.controller.text.trim()).toList();
              var proposition = Proposition(entrepriseController.text, brutController.text, netController.text, selectedStatus, listOfSentimentEntries);

              setState(() {
                widget.passedPropositions.add(proposition);
              });

            }, child: const Text("Valider"))
          ], // Les champs de sentiments sont ajouté à la fin du formulaire ici
      ),
    );
  }
}

// Champs d'un sentiment, ajouter dynamiquement dans la page avec le bouton + dans le formulaire
class SentimentInput extends StatelessWidget {
  final String fieldName;
  final int index;
  final TextEditingController controller;

  const SentimentInput({Key? key, this.fieldName = '', required this.controller, required this.index })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, bottom: 10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: fieldName,
        ),

      ),
    );
  }
}



class Proposition {
  String entreprise = "";
  String salaireBrut = "";
  String salaireNet = "";
  String status = "";
  var sentiments = [];

  Proposition(this.entreprise, this.salaireBrut, this.salaireNet, this.status,
      this.sentiments);
  Proposition.emptyProposition();
}


////////////////////////////////////////////////////////////////////////////////


class DynamicTextFieldPage extends StatefulWidget {
  const DynamicTextFieldPage({Key? key}) : super(key: key);

  @override
  _DynamicTextFieldPageState createState() => _DynamicTextFieldPageState();
}

class _DynamicTextFieldPageState extends State<DynamicTextFieldPage>
    with SingleTickerProviderStateMixin {
  final List<Phone> _phoneWidgets = <Phone>[];
  List<String> listOfTextEntries = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dynamic Fields "),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Text(
          '+',
          style: TextStyle(fontSize: 20.0),
        ),
        shape: RoundedRectangleBorder(
            side: const BorderSide(
                color: Colors.black26, width: 1.0, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(10.0)),
        onPressed: () {
          setState(() {
            //add Phone objects dynamically here while setting up a controller in there.
            _phoneWidgets.add(Phone(
              fieldName: 'Phone Number ${_phoneWidgets.length + 1}',
              controller: returnController(
                  "phoneController ${_phoneWidgets.length + 1}"),
            ));
          });
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView(
                  shrinkWrap: true,
                  children: List.generate(_phoneWidgets.length, (i) {
                    return _phoneWidgets[i];
                  }),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      child: const Text('Submit'),
                      onPressed: () {
                        showTextFieldEntries();
                      },
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  TextEditingController returnController(String controllerName) {
    final controllerName = TextEditingController();
    return controllerName;
  }

  //You can see the list of text entries from here.
  void showTextFieldEntries() {
    //listOfTextEntries = _phoneWidgets.map((i)=>i.controller.text.trim()).toList();
    _phoneWidgets.map((i) {
      //i.controller.text.trim();
      print("these are the listOfTextEntries ${i.controller.text.trim()}");
    }).toList();

    //print("these are ${listOfTextEntries[0]}");
  }
}

class Phone extends StatelessWidget {
  final String fieldName;
  final TextEditingController controller;

  const Phone({Key? key, this.fieldName = '', required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, bottom: 10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(color: Colors.white, width: 0.1),
          ),
          filled: true,
          icon: const Icon(
            Icons.phone,
            color: Colors.black,
            size: 20.0,
          ),
          labelText: fieldName,
          labelStyle: const TextStyle(
              fontSize: 15.0,
              height: 1.5,
              color: Color.fromRGBO(61, 61, 61, 1)),
          fillColor: const Color(0xffD2E8E6),
        ),
        maxLines: 1,
      ),
    );
  }
}