import 'package:collection/collection.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:jukeboxprism/BoxForm.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'dart:math' as math;
import 'package:jukeboxprism/SoundPage.dart';
import 'package:jukeboxprism/main.dart';

// Page des différents thèmes, affiche un tableau 2D de bouton qui permettent d'accéder aux différents thème
// Doit avoir un bouton + en bas à droite pour ajouter un thème

class ThemePage extends StatefulWidget {
  const ThemePage({Key? key}) : super(key: key);
  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  var colorbck = Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  var myMenuItems = <String>["A propos", 'Utilisation de l\'application'];
  void onSelect(item) {
    switch (item) {
      case 'Utilisation de l\'application':
        print('Notice clicked');
        showDialog(
            context: context,
            builder: ((context) => _buildPopupDialog(context)));
        break;
      case 'A propos':
        print('hello clicked');
        showDialog(
            context: context,
            builder: ((context) => _buildPopupPropos(context)));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Jukebox';
    const iconjukebox = '';
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: colorbck,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(
              image: new AssetImage("assets/jukebox.png"),
              width: 32,
              height: 32,
              color: null,
            ),
          ),
          title: const Text(title),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: PopupMenuButton<String>(
                  onSelected: onSelect,
                  icon: Icon(Icons.more_horiz),
                  itemBuilder: (BuildContext context) {
                    return myMenuItems.map((String choice) {
                      return PopupMenuItem<String>(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(choice),
                        ),
                        value: choice,
                      );
                    }).toList();
                  }),
            )
          ],
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 10.0),
          child: _buildGridList(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: colorbck,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BoxForm()),
            ).then((value) => {
                  // setState to force refresh list
                  setState(() => {})
                });
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildGridList() {
    return ResponsiveGridList(
        rowMainAxisAlignment: MainAxisAlignment.center,
        desiredItemWidth: 100,
        minSpacing: 10,
        children: MyApp.boxes.mapIndexed((i, box) {
          return ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 100, height: 100),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(box.color).withOpacity(1.0),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SoundPage(title: box.name, boxIndex: i)),
                  ).then((value) => {
                        // setState to force refresh list
                        setState(() => {})
                      });
                },
                onLongPress: () async {
                  if (await confirm(context,
                      content: Row(
                        children: const [
                          Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          Text("Supprimer ?"),
                        ],
                      ),
                      textCancel: Text("Non"),
                      textOK: Text("Oui"))) {
                    // Supprimer quand oui
                    setState(() {
                      MyApp.boxes.removeAt(i);
                    });
                  }
                  // Faire rien quand non
                },
                child: Text(box.name),
              ));
        }).toList());
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: Center(child: const Text("Notice de l'application")),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
              "Vous êtes actuellement sur la page des thèmes, vous avez la possibilité de créer un nouveau thème avec le bouton '+' en bas à droite de votre écran. Lorsque vous cliquez sur un des thèmes vous avez la possibilité de rajouter n'importe quelle musique de votre répertoire en cliquant sur le bouton '🎵'. Puis vous pouvez jouer votre musique en cliquant dessus dans la page de votre thème choisi. "),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Fermer'),
        ),
      ],
    );
  }

  Widget _buildPopupPropos(BuildContext context) {
    return AlertDialog(
      title: Center(child: const Text("A propos")),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
              "JukeboxPrism créer par : Jacques Clery, Diego Da Silva Marques, Hippolythe Ledogar, Tom Woodall, Nicolas Sénéchal. IUT D'Orsay, Licence PRO : PRISM. Flutter projet. Merci à Mr Bochet pour ce module. "),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Fermer'),
        ),
      ],
    );
  }
}
