import 'package:collection/collection.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:jukeboxprism/Data/Sound.dart';
import 'package:jukeboxprism/SoundForm.dart';
import 'package:responsive_grid/responsive_grid.dart';
//import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'Data/Box.dart';
import 'main.dart';
import 'dart:math' as math;
//import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'AudioManager.dart';
// Page essentiellement similaire à celle des thèmes, mais les boutons doivent jouer des sons

class SoundPage extends StatefulWidget {
  const SoundPage({Key? key, required this.title, required this.boxIndex})
      : super(key: key);

  final String title;
  final int boxIndex;

  @override
  State<SoundPage> createState() => _SoundPageState();
}

class _SoundPageState extends State<SoundPage> {
  bool click = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    seekbarinit();
  }

  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );

  //late Stream<Duration> PositionMusic = MyApp.player.positionStream;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color(MyApp.boxes[widget.boxIndex].color).withOpacity(1.0),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(MyApp.boxes[widget.boxIndex].color).withOpacity(1.0),
          child: const Icon(
            Icons.music_note,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SoundForm(boxIndex: widget.boxIndex))).then((value) => {
                  print(value),
                  // setState to force refresh list
                  setState(() => {})
                });
          }),
      body: Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: _buildGridList(),
      ),
      bottomNavigationBar: _buildFoot(),
    );
  }

  seekbarinit() {
    MyApp.player.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
    MyApp.player.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });
    MyApp.player.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  Widget _buildFoot() {
    if (MyApp.boxes[widget.boxIndex].sounds.isEmpty) {
      return const BottomAppBar();
    } else {
      return BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ValueListenableBuilder<ProgressBarState>(
              valueListenable: progressNotifier,
              builder: (_, value, __) {
                return ProgressBar(
                  progress: value.current,
                  buffered: value.buffered,
                  total: value.total,
                  onSeek: null,
                );
              },
            ),
            Center(
              child: Icon(
                (click == false) ? Icons.play_arrow : Icons.pause,
                size: 40,
              ),
            ),
          ]),
        ),
      );
    }
  }

  Widget _buildGridList() {
    return ResponsiveGridList(
        rowMainAxisAlignment: MainAxisAlignment.center,
        desiredItemWidth: 100,
        minSpacing: 10,
        children: MyApp.boxes[widget.boxIndex].sounds.mapIndexed((i, sound) {
          return ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 100, height: 100),
              child: Container(
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ElevatedButton(
                  //Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0)
                  style: ElevatedButton.styleFrom(
                    primary: Color(sound.color).withOpacity(1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  onPressed: () async {
                    // Jouer le son ici

                    print("sound name: " + sound.name);
                    print("sound path: " + sound.path);


                    await MyApp.player.setFilePath(sound.path).then((value) =>  {
                      setState(() {
                        play();
                      })
                    });
                    //play();
                    //print(MyApp.player.positionStream);
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
                        MyApp.boxes[widget.boxIndex].sounds.removeAt(i);
                      });
                    }
                    // Faire rien quand non
                  },
                  child: Container(
/*                     decoration: new BoxDecoration(
                      color: Colors.green,
                    ), */
                    child: Center(
                      child: Text(sound.name),
                    ),
                  ),
                ),
              ));
        }).toList());
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

Future<void> play() async {
  if(MyApp.player.playing) {
    await MyApp.player.stop();
    MyApp.player.play();
  }
  else {
    MyApp.player.play();
  }
}

void pause() {
  MyApp.player.pause();
}

void seek(Duration position) {
  MyApp.player.seek(position);
}
