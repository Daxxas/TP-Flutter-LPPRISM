import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'Data/Box.dart';
import 'Data/Sound.dart';
import 'main.dart';
import 'dart:math' as math;


// Page essentiellement similaire à celle des thèmes, mais les boutons doivent jouer des sons

class SoundForm extends StatefulWidget {
  final int boxIndex;

  const SoundForm({Key? key, required this.boxIndex}) : super(key: key);

  @override
  State<SoundForm> createState() => _SoundFormState();
}

class _SoundFormState extends State<SoundForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController fileController = TextEditingController();
  bool isFileValid = false;
  bool isNameValid = false;
  late PlatformFile currentFile;

  @override
  Widget build(BuildContext context) {
    // Sound currentSound = Sound.EmptySound();
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un son"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              TextField(
                decoration: InputDecoration(labelText: "Nom du son"),
                controller: nameController,
                maxLength: 20,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                onChanged: (val) {
                  setState(() {
                    isNameValid = val.isNotEmpty;
                  });
                },
              ),
              TextField(
                enabled: false,
                decoration: InputDecoration(labelText: "Fichier"),
                controller: fileController,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
              ),
              SizedBox(height: 10),
              ElevatedButton(onPressed: () async {
                FilePickerResult? result = (await FilePicker.platform.pickFiles(
                type: FileType.audio,
                allowMultiple: false,
                onFileLoading: (FilePickerStatus status) => print(status),
                ));

                setState(() {
                  isFileValid = result != null;
                  if(result != null) {
                    PlatformFile file = result.files.first;
                    print("result not null : " + file.name);
                    fileController.text = file.name;

                    // Ajouter à la box le son
                    if(widget.boxIndex < 0 || widget.boxIndex > MyApp.boxes.length-1) {
                      print("Le box index rentrée n'est pas dans le tableau des boxes");
                    }
                    print("Current file initialized ?");
                    currentFile = file;
                    print(currentFile.path);
                  }
                });
              }, child: const Text("Ajouter...")),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: (!(isFileValid && isNameValid)) ? null : () {
                  int color = (math.Random().nextDouble() * 0xFFFFFF).toInt();
                  Sound newSound = Sound(currentFile, nameController.text, currentFile.path!,color);
                  // currentSound.name = nameController.text;
                  MyApp.boxes[widget.boxIndex].sounds.add(newSound);
                  Navigator.pop(context);
              }, child: const Text("Créer")),
            ],
          ),
        ),
      ),
    );
  }
}