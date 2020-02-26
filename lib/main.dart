import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_tz/redux/actions.dart';
import 'package:flutter_tz/ui_elements/videobox.dart';
import 'package:video_player/video_player.dart';
import 'redux/reducers.dart';
import 'package:redux/redux.dart';
import 'resources.dart';

//TODO make this mess more object-oriented
void main() {
  final _store = new Store<bool>(soundModeReducer, initialState: true);
  runApp(MyApp(store: _store));
}

class MyApp extends StatelessWidget {
  final Store<bool> store;

  MyApp({Key key, this.store}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
        store: store,
        child: new MaterialApp(
          title: 'Clip Carousel',
          theme: ThemeData(
            brightness: Brightness.dark,
            accentColor: Colors.redAccent,
            bottomAppBarColor: Colors.black87,
          ),
          //debugShowCheckedModeBanner: false,
          home: MyHomePage(
            title: 'Clip Carousel',
            store: store,
          ),
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

  int _foremostVideo = 0;

  VoidCallback listener;
  //bool soundIsOn = true;

  List<VideoBox> videoBoxes = new List<VideoBox>();

  int previousCarouselPage = 0;

  @override
  void initState() {
    listener = () {
      setState(() {});
    };
    for (var i = 0; i < 5; i++)
      videoBoxes.add(new VideoBox(
          i,
          "assets/videos/rage.mp4" /*videoSources[i-1]*/,
          0,
          store.state ? 0.5 : 0.0,
          listener));

    super.initState();
  }

  @override
  void deactivate() {
    videoBoxes.forEach((vb) {
      vb.playerController.removeListener(listener);
      vb.playerController.setVolume(0.0);
    });
    videoBoxes.clear();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: new StoreConnector<bool, OnSoundChangedCallback>(
              converter: (store) => (_) {
                    store.dispatch(SoundButtonToggleAction(videoBoxes));
                  },
              builder: (context, callback) => new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new CarouselSlider(
                        height: 200.0,
                        enlargeCenterPage: true,
                        onPageChanged: (index) {
                          setState(() {
                            videoBoxes[index].playerController.play();
                            videoBoxes[previousCarouselPage]
                                .playerController
                                .pause();

                            _foremostVideo = index + 1;
                            previousCarouselPage = index;
                          });
                        },
                        items: videoBoxes.map((vb) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                ),
                                child:
                                    vb.createVideo(store.state).setVideoBox(),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      //Text("Num of videoboxes is ${videoBoxes.length}"),

                      new Container(
                        padding: EdgeInsets.all(16.0),
                        child: FloatingActionButton(
                          onPressed: () {
                            callback(videoBoxes);
                          },
                          tooltip: 'Sound switch',
                          child: store.state
                              ? Icon(Icons.volume_off)
                              : Icon(Icons.volume_up),
                        ),
                      ),
                    ],
                  )),
        ));
  }
}

typedef OnSoundChangedCallback = Function(List<VideoBox> videoboxes);

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
