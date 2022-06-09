import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jukeboxprism/main.dart';

import 'Data/Box.dart';
import 'Data/Sound.dart';
import 'dart:math' as math;

// Page essentiellement similaire à celle des thèmes, mais les boutons doivent jouer des sons

class BoxForm extends StatefulWidget {

  const BoxForm({Key? key}) : super(key: key);

  @override
  State<BoxForm> createState() => _BoxFormState();
}

class _BoxFormState extends State<BoxForm> {
  TextEditingController nameController = TextEditingController();
  bool isNameValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter une box"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              TextField(
                decoration: InputDecoration(labelText: "Nom"),
                controller: nameController,
                maxLength: 20,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                onChanged: (val) {
                  setState(() {
                    isNameValid = val.isNotEmpty;
                  });
                },
              ),
              ElevatedButton(
                onPressed: !isNameValid ? null : () {
                if(nameController.text.isNotEmpty) {
                  int color = (math.Random().nextDouble() * 0xFFFFFF).toInt();
                  setState(() {
                    MyApp.boxes.add(Box(nameController.text, <Sound>[],color));
                  });
                }
                Navigator.pop(context);
              }, child: const Text("Ajouter")),
            ],
          ),
        ),
      ),
    );
  }
}