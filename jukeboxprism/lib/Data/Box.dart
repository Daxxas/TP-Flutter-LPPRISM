import 'package:jukeboxprism/Data/Sound.dart';

class Box {
  String name;
  List<Sound> sounds;
  int color;

  Box(this.name, this.sounds,this.color);

  void addSound(Sound sound) {
    sounds.add(sound);
  }
}