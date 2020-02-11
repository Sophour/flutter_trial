

import 'package:flutter_tz/videobox.dart';
import 'package:video_player/video_player.dart';

class MuteSoundAction{
  final bool _muted;

  MuteSoundAction(this._muted);
}

class SoundOnAction{
  final bool _soundIsOn;

  SoundOnAction(this._soundIsOn);
}

class SoundButtonToggleAction{
  final List<VideoBox> videoBoxes;
  SoundButtonToggleAction(this.videoBoxes);
}