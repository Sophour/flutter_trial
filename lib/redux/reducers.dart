
import 'actions.dart';

bool soundModeReducer(bool soundIsOn, dynamic action){
  if(action is SoundButtonToggleAction)
    return switchSound(soundIsOn, action);

  return true;
}


bool switchSound(bool soundIsOn, SoundButtonToggleAction action){
  if(soundIsOn){
    action.videoBoxes.forEach((vb) => vb.playerController != null?
    vb.playerController.setVolume(0):null);
    return false;
  }
  else {
    action.videoBoxes.forEach ( ( vb ) => vb.playerController != null?
    vb.playerController.setVolume(50):null );
     return true;
  }
//bool switchSound(bool soundIsOn, SoundButtonToggleAction action){
//  if(soundIsOn){
//    action.videoBoxes.forEach((vb) => vb._controller != null?
//    vb.playerController.setVolume(0.0):null);
//    return false;
//  }
//  else {
//    action.videoBoxes.forEach ( ( vb ) => vb.playerController != null?
//    vb.playerController.setVolume(0.5):null );
//     return true;
//  }
}

