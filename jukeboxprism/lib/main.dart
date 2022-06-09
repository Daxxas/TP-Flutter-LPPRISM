import 'dart:async';

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:jukeboxprism/BoxForm.dart';
// ignore: unused_import
import 'package:jukeboxprism/SoundForm.dart';
import 'package:jukeboxprism/ThemePage.dart';
import 'package:jukeboxprism/Data/Sound.dart';
import 'package:just_audio/just_audio.dart';
import 'Data/Box.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({Key? key}) : super(key: key);
  static List<Box> boxes = <Box>[
    Box("Voix", <Sound>[],((0xb00041).toInt())),
    Box("Nature", <Sound>[],((0xFF00CBC).toInt())),
    Box("Techno", <Sound>[],((0xFF00E0B2).toInt()))
  ];

  static late AudioPlayer player;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    MyApp.player = AudioPlayer();
  }

  @override
  void dispose() {
    MyApp.player.dispose();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const ThemePage(),
      home: const ThemePage(),
    );
  }
}

