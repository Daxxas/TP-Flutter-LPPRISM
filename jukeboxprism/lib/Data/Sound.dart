import 'package:file_picker/file_picker.dart';

class Sound {
  late PlatformFile file;
  late String path;
  late String name = "";
  late int color;
  Sound(this.file, this.name, this.path,this.color);

  Sound.Debug(String name) {
    this.name = name;
    // file = PlatformFile(name: "test", size: 0);
  }

  Sound.EmptySound();
}