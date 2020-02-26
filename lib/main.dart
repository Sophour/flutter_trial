import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_tz/redux/actions.dart';
import 'package:flutter_tz/videobox.dart';
import 'package:video_player/video_player.dart';
import 'redux/reducers.dart';
import 'package:redux/redux.dart';
import 'package:webview_flutter/webview_flutter.dart';


void main() {
  final _store = new Store<bool>(soundModeReducer, initialState: true);
  runApp(MyApp(store: _store));

}

class MyApp extends StatelessWidget {

  final Store<bool> store;

  MyApp({Key key, this.store}) : super(key:key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
        store: store,
      child: new MaterialApp(
      title: 'ClipCarousel',
      theme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.redAccent,
        bottomAppBarColor: Colors.black87,

      ),
      //debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Clip Carousel', store: store,),

    ));

  }


}

class MyHomePage extends StatefulWidget {
  final Store<bool> store;
  MyHomePage({Key key, this.title, this.store}) : super(key: key);


  final String title;



  @override
  _MyHomePageState createState() => _MyHomePageState(store);
}

class _MyHomePageState extends State<MyHomePage> {

  final Store<bool> store;

  _MyHomePageState(this.store);

  int _foremostVideo = 1;
  VoidCallback listener;
  bool soundIsOn = true;
 List<String> videoSources = [
    //"https://r3---sn-8ph2xajvh-n8ve.googlevideo.com/videoplayback?expire=1580741727&ei=_983XtHTKJCl7QSKurnQAg&ip=194.186.188.80&id=o-AGDkwyGLuZfWYhMneAcd1x8I_cekb5JjAT13kvSnHD3g&itag=18&source=youtube&requiressl=yes&mm=31%2C26&mn=sn-8ph2xajvh-n8ve%2Csn-axq7sn7l&ms=au%2Conr&mv=m&mvi=2&pcm2cms=yes&pl=24&nh=%2CIgpwcjAzLmxlZDAzKgkxMjcuMC4wLjE&initcwndbps=535000&vprv=1&mime=video%2Fmp4&gir=yes&clen=14185297&ratebypass=yes&dur=232.129&lmt=1574998691119643&mt=1580720023&fvip=10&fexp=23842630%2C23860862&txp=5531432&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cvprv%2Cmime%2Cgir%2Cclen%2Cratebypass%2Cdur%2Clmt&lsparams=mm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpcm2cms%2Cpl%2Cnh%2Cinitcwndbps&lsig=AHylml4wRQIgfmCYkjedkIY7htxn3a5zP9d056tHNrLcqjY8Ftjjt3gCIQC2mnBA7kiZy35ycdNkvvb6LOtXc-B0SDJOX835dsKnJw%3D%3D",
   "https://www.videvo.net/videvo_files/converted/2014_08/preview/Fuego_de_Refineria.mp416312.webm",
   "https://www.videvo.net/videvo_files/converted/2013_11/preview/FireBackground1Videvo.mov68542.webm",
   "https://www.videvo.net/videvo_files/converted/2015_10/preview/Code_flythough_loop_01_Videvo.mov92538.webm",
   "https://www.videvo.net/videvo_files/converted/2016_03/preview/Confetti_Falling_2.mp418233.webm",
   "https://cdn.videvo.net/videvo_files/video/free/2012-07/small_watermarked/Globe%20Rotate%201%20Matte_preview.webm"];
 List<VideoBox> videoBoxes = new List<VideoBox>();

 int previousCarouselPage= 0;




  @override
  void initState() {
    listener = (){
      setState(() {} );
    };
    for(var i=0; i<5; i++)
    videoBoxes.add( new VideoBox( i, 'https://www.twitch.tv/twitch/v/106400740'
        /*"assets/videos/rage.mp4"*/ /*videoSources[i-1]*/
        , 0 , store.state ? 0.5 : 0.0 , listener ) );

    super.initState();

  }

//  void showAlert(String msg) {
//    showDialog(
//      context: context,
//      builder: (context) => new AlertDialog(
//        content: new Text(msg),
//        actions: <Widget>[
//          new FlatButton(
//            child: new Text('DISMISS'),
//            onPressed: () => Navigator.of(context).pop(),
//          )
//        ],
//      ),
//    );
//  }

  @override
  void deactivate() {
    videoBoxes.forEach((vb){
      vb.playerController.removeListener(listener);
    vb.playerController.setVolume(0.0);});
    videoBoxes.clear();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child:   new StoreConnector<bool,OnSoundChangedCallback>(
      converter: (store)=>(_){ store.dispatch(SoundButtonToggleAction(videoBoxes));},
      builder: (context, callback) =>
        new Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

          new CarouselSlider(
              height: 200.0,
              enlargeCenterPage: true,
              onPageChanged: (index){
                setState(() {
                  videoBoxes[index].playerController.play();
                  videoBoxes[previousCarouselPage].playerController.pause();

                  _foremostVideo = index+1;
                  previousCarouselPage = index;
                });
              },
              items: videoBoxes.map((vb){
                return Builder(
                  builder: ( BuildContext context ) {
                    return Container(
                      width: MediaQuery
                          .of( context )
                          .size
                          .width,
                      margin: EdgeInsets.symmetric( horizontal: 5.0 ),

                      decoration: BoxDecoration(
                        color: Colors.black,

                      ),
                      child: vb.createVideo(store.state).setVideoBox( ),

                    );
                  },
                );
              } ).toList( ),
          ),
            //Text("Num of videoboxes is ${videoBoxes.length}"),

       new Container(
            padding: EdgeInsets.all(16.0),
            child: FloatingActionButton(

          onPressed: () {
          callback(videoBoxes);

      },
        tooltip: 'Sound switch',
        child: store.state ?  Icon(Icons.volume_off) : Icon(Icons.volume_up),
      ), // This trailing comma makes auto-formatting nicer for build methods.
          ),

      ],
        )),
    )

    );
  }


}

typedef OnSoundChangedCallback = Function(List<VideoBox> videoboxes);
