import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class VideoBox{


  int id;
  String videoUrl;
  int timePaused;
  double volume;
  VideoPlayerController playerController;
  VoidCallback listener;

  VideoBox(this.id, this.videoUrl, this.timePaused, this.volume, this.listener);

  AspectRatio setVideoBox(){
    return AspectRatio(
      aspectRatio: 16/9,
      child: Container(
          child: (playerController != null) ?
          VideoPlayer(playerController) : Container()

      ),
    );
  }

  VideoBox createVideo(bool soundIsOn){
    if (playerController == null){
      playerController = VideoPlayerController.asset(videoUrl)
        ..addListener(listener)
        ..setLooping(true)
        ..setVolume(soundIsOn? 0.5 : 0.0)
        ..initialize();
      if(this.id==0 )
        this.playerController.play();
    }
//    else{
//      if(playerController.value.isPlaying){
//        playerController.pause();
//      }
//      else{
//        playerController.initialize();
//        playerController.play();
//      }
//    }
  return this;
  }

//  void play(){
//    createVideo();
//    playerController.play();
//  }



}