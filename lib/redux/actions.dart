

class MuteSoundAction{
  final bool _muted;

  MuteSoundAction(this._muted);
}

class SoundOnAction{
  final bool _soundIsOn;

  SoundOnAction(this._soundIsOn);
}

class SoundButtonToggleAction{
  final bool soundIsOn;
  SoundButtonToggleAction(this.soundIsOn);
}